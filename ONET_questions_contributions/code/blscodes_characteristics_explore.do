
local jobs_chars_vars = "violentpeople_atleastweekly repair_elecequip minorhurt_atleastweekly repair_mechequip outdoors_everyday disease_atleastweekly operate_equipment physical_activities handlingobjects control_machines walking_majority email_lessthanmonthly dealwithpublic inspect_equip safetyequip_majority"

//The next 40 lines mimic the content of onet_to_BLS_crosswalk/code/crosswalk.do, now applied to ../input/onet_teleworkable_detail.dta

//MAP O*NET TELEWORK SCORE to BLS's 6-digit SOC categories

tempfile tf_onet_soc tf_soc_bls tf_bls_telework

import excel using "../input/2010_to_SOC_Crosswalk.xlsx", firstrow cellrange(A4:D1114) clear
rename ONETSOC2010Code onetsoccode
rename SOCCode SOC_2010
rename SOCTitle SOC_TITLE
save `tf_onet_soc'

import excel using "../input/oes_2019_hybrid_structure.xlsx", sheet(OES2019 Hybrid) cellrange(A6:H874) clear firstrow
rename (OES2018EstimatesCode OES2018EstimatesTitle) (OES_2018 OES_TITLE)
rename (G H) (SOC_2010 SOC_TITLE)
keep OES_2018 OES_TITLE SOC_2010 SOC_TITLE
replace OES_TITLE = trim(OES_TITLE)
duplicates drop
save `tf_soc_bls'

use "../input/onet_teleworkable_detail.dta", clear
merge 1:1 onetsoccode using `tf_onet_soc', assert(using match) keep(match) keepusing(SOC_2010) nogen
bys SOC_2010: egen total = total(1)
by  SOC_2010: egen stddev_telew = sd(telew)
list onetsoccode title SOC_2010 teleworkable if total!=1 & stddev_telew!=0 //Taking survey-respondent-weighted averages to get to SOC_2010
collapse (mean) teleworkable `jobs_chars_vars' [w=n], by(SOC_2010)
merge 1:m SOC_2010 using `tf_soc_bls', keep(using match)
assert strpos(OES_TITLE,"All Other")!=0|OES_TITLE=="Legislators"|strpos(OES_TITLE,"Miscellaneous")==1 if _merge==2
drop if _merge==2
drop _merge
bys OES_2018: egen total = total(1)
by  OES_2018: egen stddev_telew = sd(telew)
list OES_2018 SOC_2010 telew if total!=1 & stddev_telew!=0 //Taking simple averages (employment reported by OES_2018, not SOC_2010)
collapse (mean) teleworkable `jobs_chars_vars' (firstnm) OES_TITLE, by(OES_2018)
clonevar OCC_CODE = OES_2018
tempfile bls_explore
save `bls_explore', replace

*************************************************************************
****BLS Codes Characteristics Explore************************************
*************************************************************************
//Load national SOC data
import excel using "../input/national_M2018_dl.xlsx", clear firstrow
keep if OCC_GROUP=="detailed"
//Merge with ONET-based coding of teleworkability and other vars; fill in "miscellaneous" categories using 4-digit means
merge 1:1 OCC_CODE using `bls_explore'
gen str OCC_CODE_4digit = substr(OCC_CODE,1,10)
foreach var of varlist teleworkable `jobs_chars_vars' { 
local name = substr("`var'",1,25)
bys OCC_CODE_4digit: egen numer_`name' = total(`var'*TOT_EMP)
bys OCC_CODE_4digit: egen denom_`name' = total(TOT_EMP)
gen `name'_4digit = numer_`name' / denom_`name'
replace `var' = `name'_4digit if missing(`var')==1 & (substr(OCC_CODE,-1,1)=="9"|substr(OCC_CODE,-2,2)=="90"|OCC_CODE=="11-1031") & (strpos(OCC_TITLE,"All Other")!=0|strpos(OCC_TITLE,"Miscellaneous")!=0|OCC_TITLE=="Legislators") //
assert missing(`var')==0
}
drop _merge numer* denom* *_4digit

//Generate employment-weighted and wage-weighted means and report them
replace H_MEAN = "100" if H_MEAN=="#"
destring H_MEAN, replace ig(*)

foreach var of varlist `jobs_chars_vars' {
	assert missing(`var')==0
}
gen byte cannotworkfromhome = (email_lessthanmonthly!=0|outdoors_everyday!=0|violentpeople_atleastweekly!=0|safetyequip_majority!=0|minorhurt_atleastweekly!=0|physical_activities!=0|handlingobjects!=0|control_machines!=0|operate_equipment!=0|dealwithpublic!=0|repair_mechequip!=0|repair_elecequip!=0|inspect_equip!=0|disease_atleastweekly!=0|walking_majority!=0)
gen int cannotworkfromhome_sum = (email_lessthanmonthly!=0) + (outdoors_everyday!=0) + (violentpeople_atleastweekly!=0) + (safetyequip_majority!=0) + (minorhurt_atleastweekly!=0) + (physical_activities!=0) + (handlingobjects!=0) + (control_machines!=0) + (operate_equipment!=0) + (dealwithpublic!=0) + (repair_mechequip!=0) + (repair_elecequip!=0) + (inspect_equip!=0) + (disease_atleastweekly!=0) + (walking_majority!=0)
foreach var of varlist `jobs_chars_vars' {
	count if inlist(`var',0,1)==0 & cannotworkfromhome_sum==1
}
quietly count if cannotworkfromhome_sum == 1
local obs_singlecondition = `r(N)'
display "There are `r(N)' observations in which only one survey response causes the occupation to be classified as unable to be performed at home."

egen emp_denom  = total(TOT_EMP)
egen emp_denom_sole = total(TOT_EMP) if cannotworkfromhome_sum==1
egen wage_denom = total(H_MEAN*TOT_EMP*(missing(H_MEAN)==0))
egen wage_denom_sole = total(H_MEAN*TOT_EMP*(missing(H_MEAN)==0)) if cannotworkfromhome_sum==1

foreach var of varlist `jobs_chars_vars' {
quietly {
	egen en_`var'  = total(`var'*TOT_EMP)
	egen ens_`var'  = total(`var'*TOT_EMP) if cannotworkfromhome_sum==1
	egen wn_`var' = total(`var'*H_MEAN*TOT_EMP*(missing(H_MEAN)==0))
	egen wns_`var' = total(`var'*H_MEAN*TOT_EMP*(missing(H_MEAN)==0)) if cannotworkfromhome_sum==1
}
}

collapse (firstnm) emp_denom emp_denom_sole wage_denom wage_denom_sole en_* ens_* wn_* wns_*
gen i = _n
reshape long en_ ens_ wn_ wns_, i(i) j(trait) string
gen str mean_emp       = string(en_ / emp_denom,"%3.2f")
gen str mean_emp_sole  = string(ens_ / emp_denom_sole,"%3.2f")
gen str mean_wage      = string(wn_ / wage_denom,"%3.2f")
gen str mean_wage_sole = string(wns_ / wage_denom_sole,"%3.2f")
gen str mean_emp_sole_fulldenom  = string(ens_ / emp_denom,"%4.3f")
gen mean_emp_sole_fulldenom_num = ens_ / emp_denom
gen str mean_wage_sole_fulldenom = string(wns_ / wage_denom,"%4.3f")
keep trait mean_*

gen str trait_label = trait  //GWA labels are "is very important", WC are "average respondent says..."
replace trait_label = subinstr(trait_label,"repair_elecequip","GWA23: Repairing and Maintaining Electronic Equipment",1)
replace trait_label = subinstr(trait_label,"violentpeople_atleastweekly","WC14: Deal with violent people weekly",1)
replace trait_label = subinstr(trait_label,"repair_mechequip","GWA22: Repairing and Maintaining Mechanical Equipment",1)
replace trait_label = subinstr(trait_label,"minorhurt_atleastweekly","WC33: Exposed to minor burns, cuts, bites, or stings weekly",1)
replace trait_label = subinstr(trait_label,"outdoors_everyday","WC17/18: Majority of respondents say outdoors every day",1)
replace trait_label = subinstr(trait_label,"control_machines","GWA18: Controlling Machines and Processes",1)
replace trait_label = subinstr(trait_label,"operate_equipment","GWA20: Operating Vehicles, Mechanized Devices, or Equipment",1)
replace trait_label = subinstr(trait_label,"disease_atleastweekly","WC29: Exposed to diseases or infection weekly",1)
replace trait_label = subinstr(trait_label,"handlingobjects","GWA17: Handling and Moving Objects",1)
replace trait_label = subinstr(trait_label,"physical_activities","GWA16: Performing General Physical Activities",1)
replace trait_label = subinstr(trait_label,"inspect_equip","GWA4: Inspecting Equipment, Structures, or Materials",1)
replace trait_label = subinstr(trait_label,"email_lessthanmonthly","WC4: Use email less than once per month",1)
replace trait_label = subinstr(trait_label,"dealwithpublic","GWA32: Performing for or Working Directly with the Public",1)
replace trait_label = subinstr(trait_label,"walking_majority","WC37: Majority of time walking or running",1)
replace trait_label = subinstr(trait_label,"safetyequip_majority","WC43/44: Majority of time wearing protective or safety equipment",1)

sort mean_emp
listtex trait_label mean_emp mean_wage mean_emp_sole_fulldenom mean_wage_sole_fulldenom using "../output/ONET_questions_contributions.tex", replace ///
rstyle(tabular) head("\begin{tabular}{lcccc} \toprule" "&\multicolumn{2}{c}{Cannot do at home} &\multicolumn{2}{c}{Sole condition} \\" "\cmidrule(lr){2-3} \cmidrule(lr){4-5}" "O*NET survey condition& Jobs & Wages & Jobs & Wages\\" "\midrule") foot("\bottomrule \end{tabular}")

summarize mean_emp_sole_fulldenom_num
local share_solecondition = string(100*r(sum),"%3.0f")
display "`share_solecondition'"
shell echo "`share_solecondition' percent of employment is in occupations that a single survey condition implies cannot be performed at home." > ../output/ONET_solequestion_empshare.tex

