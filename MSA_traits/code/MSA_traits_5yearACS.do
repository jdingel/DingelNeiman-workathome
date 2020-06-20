clear all

// median household income
import delimited "../input/B19013_5yr.csv", varn(1) clear
destring b19013_001e, replace ignore("null")
assert substr(metropolitanstatisticalareamicro,1,5)==substr(geo_id,-5,5)
keep geo_id v5 b19013_001e
rename (v5 b19013_001e) (geo_name median_income)
tempfile df_income
save `df_income'

// fraction of population with a bachelor's degree or higher educational attainment
import delimited "../input/B15003_5yr.csv", varn(1) clear
gen frac_ba = (b15003_022e + b15003_023e + b15003_024e + b15003_025e)/b15003_001e
assert substr(metropolitanstatisticalareamicro,1,5)==substr(geo_id,-5,5)
keep geo_id v53 frac_ba
rename v53 geo_name
tempfile df_edu
save `df_edu'

// fraction home owners (as opposed to renters)
import delimited "../input/B25003_5yr.csv", varn(1) clear
gen frac_own = b25003_002e/b25003_001e
assert substr(metropolitanstatisticalareamicro,1,5)==substr(geo_id,-5,5)
keep geo_id v9 frac_own
rename v9 geo_name
tempfile df_tenure
save `df_tenure'

// fraction of residential population whose race is white
import delimited "../input/B02001_5yr.csv", varn(1) clear
gen frac_white = b02001_002e/b02001_001e
assert substr(metropolitanstatisticalareamicro,1,5)==substr(geo_id,-5,5)
keep geo_id v23 frac_white
rename v23 geo_name

// merge data
merge 1:1 geo_id using `df_income', assert(match) nogen
merge 1:1 geo_id using `df_edu', assert(match) nogen
merge 1:1 geo_id using `df_tenure', assert(match) nogen
gen cbsa = real(substr(geo_id,-5,5))
save "../output/CBSA_characteristics_5yr.dta",replace

