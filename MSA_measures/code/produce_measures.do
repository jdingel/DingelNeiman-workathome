//Load national SOC data
import excel using "../input/national_M2018_dl.xlsx", clear firstrow
keep if OCC_GROUP=="detailed"
//Merge with ONET-based coding of teleworkability; fill in "miscellaneous categories using 4-digit means
merge 1:1 OCC_CODE using "../input/onet_teleworkable_blscodes.dta"
gen str OCC_CODE_4digit = substr(OCC_CODE,1,5)
bys OCC_CODE_4digit: egen numer = total(telew*TOT_EMP)
bys OCC_CODE_4digit: egen denom = total(TOT_EMP)
gen telew_4digit = numer / denom
replace teleworkable = telew_4digit if missing(teleworkable)==1 & (substr(OCC_CODE,-1,1)=="9"|substr(OCC_CODE,-2,2)=="90"|OCC_CODE=="11-1031") & (strpos(OCC_TITLE,"All Other")!=0|strpos(OCC_TITLE,"Miscellaneous")!=0|OCC_TITLE=="Legislators") //
assert missing(teleworkable)==0
keep OCC_CODE OCC_TITLE teleworkable
tempfile tf_merged_onet
save `tf_merged_onet'

//Load MSA occupation counts
import excel using "../input/MSA_M2018_dl.xlsx", clear firstrow
destring AREA TOT_EMP, replace ig("*")
drop if OCC_CODE=="00-0000" | substr(OCC_CODE,-4,4)=="0000"
replace H_MEAN = "100" if H_MEAN=="#"
destring H_MEAN, replace ig(*)
tempfile tf_BLS_MSA_occ_data
save `tf_BLS_MSA_occ_data'

//Merge with BN-JD coding of teleworkability by collapsing to 5-digit level
gen BroadGroupCode = substr(OCC_CODE,1,6) + "0"
collapse (sum) TOT_EMP (mean) H_MEAN (firstnm) PRIM_STATE AREA_NAME , by(AREA BroadGroupCode)
merge m:1 BroadGroupCode using "../input/Teleworkable_BNJDopinion.dta", assert(using match) keep(match) nogen
rename Teleworkable teleworkable

//Generate employment-weighted and wage-weighted means
bys AREA: egen emp_denom  = total(TOT_EMP)
bys AREA: egen emp_numer  = total(teleworkable*TOT_EMP)
bys AREA: egen wage_denom = total(H_MEAN*TOT_EMP)
bys AREA: egen wage_numer = total(teleworkable*H_MEAN*TOT_EMP)
gen teleworkable_emp = emp_numer / emp_denom
gen teleworkable_wage = wage_numer / wage_denom
rename emp_denom MSA_totalemployment
keep AREA AREA_NAME teleworkable_emp teleworkable_wage MSA_totalemployment
duplicates drop
egen tag = tag(AREA)
assert tag==1
save "../output/MSA_2018_teleworkable_manual.dta", replace

//Merge with O*NET-derived coding of teleworkability
use `tf_BLS_MSA_occ_data', clear
merge m:1 OCC_CODE using `tf_merged_onet', assert(using match) keep(match) nogen

//Generate employment-weighted and wage-weighted means
bys AREA: egen emp_denom  = total(TOT_EMP)
bys AREA: egen emp_numer  = total(teleworkable*TOT_EMP)
bys AREA: egen wage_denom = total(H_MEAN*TOT_EMP)
bys AREA: egen wage_numer = total(teleworkable*H_MEAN*TOT_EMP)
gen teleworkable_emp = emp_numer / emp_denom
gen teleworkable_wage = wage_numer / wage_denom
rename emp_denom MSA_totalemployment
keep AREA AREA_NAME teleworkable_emp teleworkable_wage MSA_totalemployment
duplicates drop
egen tag = tag(AREA)
assert tag==1
save "../output/MSA_2018_teleworkable_onet.dta", replace

use AREA AREA_NAME teleworkable* using "../output/MSA_2018_teleworkable_manual.dta", clear
rename (teleworkable_emp teleworkable_wage) (teleworkable_manual_emp teleworkable_manual_wage )
merge 1:1 AREA using "../output/MSA_2018_teleworkable_onet.dta", update keepusing(teleworkable*) assert(match) nogen
keep AREA AREA_NAME teleworkable*
export delimited using "../output/MSA_workfromhome.csv", replace
