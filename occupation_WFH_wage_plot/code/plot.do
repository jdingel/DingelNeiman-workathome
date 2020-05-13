clear all
graph set window fontface "Garamond"
graph set eps fontface "Times"

//Load national SOC data
tempfile tf_national_soc6 tf_national_soc2
import excel using "../input/national_M2018_dl.xlsx", clear firstrow
keep if OCC_GROUP=="detailed"
save `tf_national_soc6', replace
import excel using "../input/national_M2018_dl.xlsx", clear firstrow
keep if OCC_GROUP=="major" //equivalent to keep if substr(OCC_CODE,-4,4)=="0000" & substr(OCC_CODE,1,2)!="00"
gen soc2 = real(substr(OCC_CODE,1,2))
keep soc2 OCC_CODE OCC_TITLE H_MEAN A_MEAN H_MEDIAN A_MEDIAN
destring H_MEAN A_MEAN H_MEDIAN A_MEDIAN, replace
compress
save `tf_national_soc2'

//ONET-based coding of teleworkability; fill in "miscellaneous" categories using 4-digit employedment-weighted means
import excel using "../input/national_M2018_dl.xlsx", clear firstrow
keep if OCC_GROUP=="detailed"
merge 1:1 OCC_CODE using "../input/onet_teleworkable_blscodes.dta"
gen str OCC_CODE_4digit = substr(OCC_CODE,1,5)
bys OCC_CODE_4digit: egen numer = total(telew*TOT_EMP)
bys OCC_CODE_4digit: egen denom = total(TOT_EMP)
gen telew_4digit = numer / denom
replace teleworkable = telew_4digit if missing(teleworkable)==1 & (substr(OCC_CODE,-1,1)=="9"|substr(OCC_CODE,-2,2)=="90"|OCC_CODE=="11-1031") & (strpos(OCC_TITLE,"All Other")!=0|strpos(OCC_TITLE,"Miscellaneous")!=0|OCC_TITLE=="Legislators") //
assert missing(teleworkable)==0
keep OCC_CODE OCC_TITLE teleworkable

//Grab employment counts
merge m:1 OCC_CODE using `tf_national_soc6', keepusing(OCC_TITLE OCC_GROUP TOT_EMP) assert(master match) keep(match) nogen

//Produce table with 2-digit SOC for both measures
gen soc2 = real(substr(OCC_CODE,1,2))
collapse (mean) teleworkable [w=TOT_EMP], by(soc2)
merge 1:1 soc2 using `tf_national_soc2', assert(master match) keepusing(OCC_TITLE H_MEAN A_MEAN H_MEDIAN A_MEDIAN) nogen

//Brent's labels + scatterplot code
gen occ_short = "Computing/Mathematical (15)" if soc2==15
replace occ_short = "Education (25)" if soc==25
replace occ_short = "Legal (23)" if soc==23
replace occ_short = "Business/Finance (13)" if soc==13
replace occ_short = "Management (11)" if soc==11
replace occ_short = "Entertainment/Media (27)" if soc==27
replace occ_short = "Office/Administrative (43)" if soc==43
replace occ_short = "Architecture/Engineering (17)" if soc==17
replace occ_short = "Physical/Social Scientists (19)" if soc==19
replace occ_short = "Social Services (21)" if soc==21
replace occ_short = "Sales (41)" if soc==41
replace occ_short = "Personal Care (39)" if soc==39
replace occ_short = "Protective Service (33)" if soc==33
replace occ_short = "Healthcare Practitioners (29)" if soc==29
replace occ_short = "Transportation/Moving (53)" if soc==53
replace occ_short = "Healthcare Support (31)" if soc==31
replace occ_short = "Farming (45)" if soc==45
replace occ_short = "Production (51)" if soc==51
replace occ_short = "Maintenance (49)" if soc==49
replace occ_short = "Construction (47)" if soc==47
replace occ_short = "Food Preparation (35)" if soc==35
replace occ_short = "Building Cleaning (37)" if soc==37
keep occ_short teleworkable H_MEDIAN 
graph twoway scatter H_MEDIAN teleworkable, xsc(r(-0.1 1.1)) xlabel(0(0.25)1, labsize(small)) ylabel(0(15)60, labsize(small)) graphregion(color(white)) ///
xtitle("Share of jobs that can be done at home") xlabel( , labsize(small))  ytitle("Median hourly wage (USD)") mlabel(occ_short) msym(o) mlabposition(12) mlabsize(vsmall) mlabcolor(black) || ///
lfit H_MEDIAN teleworkable, legend(off)
graph export "../output/occupation_WFH_wage_plot.eps", as(eps) replace
