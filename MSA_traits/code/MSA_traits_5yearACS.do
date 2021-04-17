clear all

cap program drop cbsanamefix
program define cbsanamefix
	assert substr(metropolitanstatisticalareamicro,1,5)==substr(geo_id,-5,5)
	assert substr(name,1,2)==`"[""' & substr(name,-5,5)==`"Area""'
	replace name = substr(name,3,length(name)-3)  //Remove "[ from start and " from end of string
end

// median household income
import delimited "../input/B19013_5yr.csv", varn(1) clear
cbsanamefix
destring b19013_001e, gen(median_income) ignore("null")
keep geo_id name median_income
tempfile df_income
save `df_income'

// fraction of population with a bachelor's degree or higher educational attainment
import delimited "../input/B15003_5yr.csv", varn(1) clear
cbsanamefix
gen frac_ba = (b15003_022e + b15003_023e + b15003_024e + b15003_025e)/b15003_001e
keep geo_id name frac_ba
tempfile df_edu
save `df_edu'

// fraction home owners (as opposed to renters)
import delimited "../input/B25003_5yr.csv", varn(1) clear
cbsanamefix
gen frac_own = b25003_002e/b25003_001e
keep geo_id name frac_own
tempfile df_tenure
save `df_tenure'

// fraction of residential population whose race is white
import delimited "../input/B02001_5yr.csv", varn(1) clear
cbsanamefix
gen frac_white = b02001_002e/b02001_001e
keep geo_id name frac_white

// merge data
merge 1:1 geo_id using `df_income', assert(match) nogen
merge 1:1 geo_id using `df_edu', assert(match) nogen
merge 1:1 geo_id using `df_tenure', assert(match) nogen
rename name geo_name
gen cbsa = real(substr(geo_id,-5,5))
save "../output/CBSA_characteristics_5yr.dta",replace

