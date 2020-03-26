clear all
foreach package in listtex {
    capture which `package'
    if _rc==111 ssc install `package'
}


//BN-JD coding of teleworkability
//LOAD NAICS-SOC data
import excel using "../input/natsector_M2018_dl.xlsx", clear firstrow
keep if OCC_GROUP=="broad"
//Merge with BN-JD coding of teleworkability
clonevar BroadGroupCode = OCC_CODE
merge m:1 BroadGroupCode using "../input/Teleworkable_BNJDopinion.dta", assert(using match) keep(match) nogen
rename Teleworkable teleworkable
//Generate employment-weighted and wage-weighted means
destring TOT_EMP, replace ig(*)
bys NAICS: egen emp_denom  = total(TOT_EMP)
bys NAICS: egen emp_numer  = total(teleworkable*TOT_EMP)
replace H_MEAN = "100" if H_MEAN=="#"
destring H_MEAN, replace ig(*)
bys NAICS: egen wage_denom = total(H_MEAN*TOT_EMP*(missing(H_MEAN)==0))
bys NAICS: egen wage_numer = total(teleworkable*H_MEAN*TOT_EMP*(missing(H_MEAN)==0))
gen teleworkable_emp = emp_numer / emp_denom
gen teleworkable_wage = wage_numer / wage_denom
//Industry-level results
keep NAICS NAICS_TITLE teleworkable_emp teleworkable_wage
duplicates drop
//Report results in CSV 
tempfile tf_forcsv_manual
save `tf_forcsv_manual'

//Report results in statements and tables
tempvar tv1 tv2
egen `tv1' = rank(teleworkable_emp), field
egen `tv2' = rank(teleworkable_emp), track

keep if inrange(`tv1',1,5) | inrange(`tv2',1,5)
gen row = (`tv1')*inrange(`tv1',1,5) + (11-`tv2')*inrange(`tv2',1,5)
sort row
list NAICS_TITLE teleworkable_emp teleworkable_wage row
gen str tele_emp_str = string(teleworkable_emp,"%3.2f")
gen str tele_wage_str = string(teleworkable_wage,"%3.2f")


sort row
qui summarize teleworkable_emp if row==1
local top_num = string(100*`r(mean)',"%3.0f")
local top_ind = NAICS_TITLE[1]
qui summarize teleworkable_emp if row==10
local bot_num = string(100*`r(mean)',"%3.0f")
local bot_ind = NAICS_TITLE[10]
shell echo -n "from `bot_num' percent in `bot_ind' to `top_num' percent in `top_ind'%" > ../output/industry_range_manual.tex

gen ind_name = NAICS_TITLE
replace ind_name = "top5" + NAICS_TITLE if row==1
replace ind_name = "bot5" + NAICS_TITLE if row==6

sort row
listtex ind_name tele_emp_str tele_wage_str using "../output/NAICS_telework_manual_top5bottom5_table.tex", replace ///
rstyle(tabular) head("\begin{tabular}{lcc} \toprule" "& Unweighted & Weighted by wage\\" "\midrule") foot("\bottomrule \end{tabular}")

shell sed -i.bak 's/^top5/\\underline{\\textit{Top five}}\\\\/' ../output/NAICS_telework_manual_top5bottom5_table.tex
shell sed -i.bak 's/^bot5/\\\\ \\underline{\\textit{Bottom five}}\\\\/' ../output/NAICS_telework_manual_top5bottom5_table.tex
rm ../output/NAICS_telework_manual_top5bottom5_table.tex.bak

//O*NET-derived measure

//LOAD NAICS-SOC data
import excel using "../input/natsector_M2018_dl.xlsx", clear firstrow
keep if OCC_GROUP=="detailed"
//Merge with ONET-based coding of teleworkability; fill in "miscellaneous" categories using 4-digit means
merge m:1 OCC_CODE using "../input/onet_teleworkable_blscodes.dta", keep(master match)
destring TOT_EMP, replace ig(*)
gen str OCC_CODE_4digit = substr(OCC_CODE,1,5)
bys OCC_CODE_4digit: egen numer = total(telew*TOT_EMP)
bys OCC_CODE_4digit: egen denom = total(TOT_EMP)
gen telew_4digit = numer / denom
replace teleworkable = telew_4digit if missing(teleworkable)==1 & (substr(OCC_CODE,-1,1)=="9"|substr(OCC_CODE,-2,2)=="90"|OCC_CODE=="11-1031") & (strpos(OCC_TITLE,"All Other")!=0|strpos(OCC_TITLE,"Miscellaneous")!=0|OCC_TITLE=="Legislators") //
assert missing(teleworkable)==0
drop _merge OCC_CODE_4digit  numer denom telew_4digit
//Generate employment-weighted and wage-weighted means
bys NAICS: egen emp_denom  = total(TOT_EMP)
bys NAICS: egen emp_numer  = total(teleworkable*TOT_EMP)
replace H_MEAN = "100" if H_MEAN=="#"
destring H_MEAN, replace ig(*)
bys NAICS: egen wage_denom = total(H_MEAN*TOT_EMP*(missing(H_MEAN)==0))
bys NAICS: egen wage_numer = total(teleworkable*H_MEAN*TOT_EMP*(missing(H_MEAN)==0))
gen teleworkable_emp = emp_numer / emp_denom
gen teleworkable_wage = wage_numer / wage_denom
//Industry-level results
keep NAICS NAICS_TITLE teleworkable_emp teleworkable_wage
duplicates drop
//Report results in CSV 
tempfile tf_forcsv_baseline
save `tf_forcsv_baseline'


//Export both measures to CSV
use `tf_forcsv_manual', clear
rename (teleworkable_emp teleworkable_wage) (teleworkable_manual_emp teleworkable_manual_wage)
merge 1:1 NAICS using `tf_forcsv_baseline', assert(match) nogen
export delimited using "../output/NAICS_workfromhome.csv", replace

//Report results in statements and tables
use `tf_forcsv_baseline', clear

tempvar tv1 tv2
egen `tv1' = rank(teleworkable_emp), field
egen `tv2' = rank(teleworkable_emp), track

keep if inrange(`tv1',1,5) | inrange(`tv2',1,5)
gen row = (`tv1')*inrange(`tv1',1,5) + (11-`tv2')*inrange(`tv2',1,5)
sort row
list NAICS_TITLE teleworkable_emp teleworkable_wage row
gen str tele_emp_str = string(teleworkable_emp,"%3.2f")
gen str tele_wage_str = string(teleworkable_wage,"%3.2f")


sort row
qui summarize teleworkable_emp if row==1
local top_num = string(100*`r(mean)',"%3.0f")
local top_ind = NAICS_TITLE[1]
qui summarize teleworkable_emp if row==10
local bot_num = string(100*`r(mean)',"%3.0f")
local bot_ind = NAICS_TITLE[10]
shell echo -n "from `bot_num' percent in `bot_ind' to `top_num' percent in `top_ind'%" > ../output/industry_range.tex

gen ind_name = NAICS_TITLE
replace ind_name = "top5" + NAICS_TITLE if row==1
replace ind_name = "bot5" + NAICS_TITLE if row==6

sort row
listtex ind_name tele_emp_str tele_wage_str using "../output/NAICS_telework_top5bottom5_table.tex", replace ///
rstyle(tabular) head("\begin{tabular}{lcc} \toprule" "& Unweighted & Weighted by wage\\" "\midrule") foot("\bottomrule \end{tabular}")

shell sed -i.bak 's/^top5/\\underline{\\textit{Top five}}\\\\/' ../output/NAICS_telework_top5bottom5_table.tex
shell sed -i.bak 's/^bot5/\\\\ \\underline{\\textit{Bottom five}}\\\\/' ../output/NAICS_telework_top5bottom5_table.tex
rm ../output/NAICS_telework_top5bottom5_table.tex.bak
