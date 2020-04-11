//BN-JD coding of teleworkability
//Load national SOC data
import excel using "../input/national_M2018_dl.xlsx", clear firstrow
keep if OCC_GROUP=="broad"

//Merge with BN-JD coding of teleworkability
clonevar BroadGroupCode = OCC_CODE
merge 1:1 BroadGroupCode using "../input/Teleworkable_BNJDopinion.dta", assert(using match) keep(match) nogen
rename Teleworkable teleworkable
tempfile tf_merged_manual
save `tf_merged_manual'
//Generate employment-weighted and wage-weighted means
egen emp_denom  = total(TOT_EMP)
egen emp_numer  = total(teleworkable*TOT_EMP)
replace H_MEAN = "100" if H_MEAN=="#"
destring H_MEAN, replace ig(*)
egen wage_denom = total(H_MEAN*TOT_EMP*(missing(H_MEAN)==0))
egen wage_numer = total(teleworkable*H_MEAN*TOT_EMP*(missing(H_MEAN)==0))
gen teleworkable_emp = emp_numer / emp_denom
gen teleworkable_wage = wage_numer / wage_denom
//Report
keep teleworkable_emp teleworkable_wage
duplicates drop
list
quietly summarize teleworkable_emp
local tele_emp = string(100*`r(mean)',"%3.0f")
quietly summarize teleworkable_wage
local tele_wage = string(100*`r(mean)',"%3.0f")
shell echo -n "Approximately `tele_emp' percent of all U.S. jobs, accounting for `tele_wage' percent of overall wages, can be performed almost entirely at home.%" > ../output/headline_manual.tex

//Report teachers caveat
use `tf_merged_manual', clear
gen byte teacher = (substr(OCC_CODE,1,2)=="25")
keep if teacher==1
gen emp_numer = teleworkable*TOT_EMP
collapse (sum) emp_numer emp_denom = TOT_EMP
gen teleworkable_emp = emp_numer / emp_denom
quietly summarize teleworkable_emp
local tele_emp = string(100*`r(mean)',"%3.0f")
quietly summarize emp_denom
local total_teachers = string(`r(mean)',"%10.0fc")
shell echo -n "Our scheme classifies `tele_emp' percent of `total_teachers' teachers as able to work from home." > ../output/teachers_caveat_manual.tex


//O*NET survey-derived coding of teleworkability


//Load national SOC data
import excel using "../input/national_M2018_dl.xlsx", clear firstrow
keep if OCC_GROUP=="detailed"
//Merge with ONET-based coding of teleworkability; fill in "miscellaneous" categories using 4-digit means
merge 1:1 OCC_CODE using "../input/onet_teleworkable_blscodes.dta"
gen str OCC_CODE_4digit = substr(OCC_CODE,1,5)
bys OCC_CODE_4digit: egen numer = total(telew*TOT_EMP)
bys OCC_CODE_4digit: egen denom = total(TOT_EMP)
gen telew_4digit = numer / denom
replace teleworkable = telew_4digit if missing(teleworkable)==1 & (substr(OCC_CODE,-1,1)=="9"|substr(OCC_CODE,-2,2)=="90"|OCC_CODE=="11-1031") & (strpos(OCC_TITLE,"All Other")!=0|strpos(OCC_TITLE,"Miscellaneous")!=0|OCC_TITLE=="Legislators") //
assert missing(teleworkable)==0
drop _merge OCC_CODE_4digit  numer denom telew_4digit
tempfile tf_merged_onet
save `tf_merged_onet'

//Generate employment-weighted and wage-weighted means
egen emp_denom  = total(TOT_EMP)
egen emp_numer  = total(teleworkable*TOT_EMP)
replace H_MEAN = "100" if H_MEAN=="#"
destring H_MEAN, replace ig(*)
egen wage_denom = total(H_MEAN*TOT_EMP*(missing(H_MEAN)==0))
egen wage_numer = total(teleworkable*H_MEAN*TOT_EMP*(missing(H_MEAN)==0))
gen teleworkable_emp = emp_numer / emp_denom
gen teleworkable_wage = wage_numer / wage_denom
//Report
keep teleworkable_emp teleworkable_wage
duplicates drop
list
quietly summarize teleworkable_emp
local tele_emp = string(100*`r(mean)',"%3.0f")
quietly summarize teleworkable_wage
local tele_wage = string(100*`r(mean)',"%3.0f")
shell echo -n "Our classification implies that `tele_emp' percent of U.S. jobs can plausibly be performed at home.%" > ../output/headline_topicsentence_onet.tex
shell echo -n "the `tele_emp' percent of U.S. jobs that can plausibly be performed at home account for `tele_wage' percent of all wages.%"  > ../output/headline_onet.tex

//Report teachers caveat
use `tf_merged_onet', clear
gen byte teacher = (substr(OCC_CODE,1,2)=="25")
keep if teacher==1
gen emp_numer = teleworkable*TOT_EMP
collapse (sum) emp_numer emp_denom = TOT_EMP
gen teleworkable_emp = emp_numer / emp_denom
quietly summarize teleworkable_emp
local tele_emp = string(100*`r(mean)',"%3.0f")
quietly summarize emp_denom
local total_teachers = string(`r(mean)'/1000000,"%3.1fc")
shell echo -n "Our scheme classifies `tele_emp' percent of `total_teachers' teachers as able to work from home." > ../output/teachers_caveat_onet.tex
shell echo -n "our classification codes `tele_emp' percent of the `total_teachers' million teachers in the U.S. as able to work from home,%" > ../output/teachers_caveat_fragment_onet.tex
