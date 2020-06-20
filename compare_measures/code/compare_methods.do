
//Load national SOC data
tempfile tf_national_soc6 tf_national_soc5 tf_national_soc2
import excel using "../input/national_M2018_dl.xlsx", clear firstrow
keep if OCC_GROUP=="detailed"
save `tf_national_soc6', replace
import excel using "../input/national_M2018_dl.xlsx", clear firstrow
keep if OCC_GROUP=="broad"
save `tf_national_soc5', replace
import excel using "../input/national_M2018_dl.xlsx", clear firstrow
keep if substr(OCC_CODE,-4,4)=="0000" & substr(OCC_CODE,1,2)!="00" //equivalent to keep if OCC_GROUP=="major"
gen soc2 = real(substr(OCC_CODE,1,2))
keep soc2 OCC_CODE OCC_TITLE 
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
tempfile tf_merged_onet
save `tf_merged_onet'

//Merge two methods
use "../input/Teleworkable_BNJDopinion.dta", clear
gen str soc5 = substr(BroadGroupCode,1,6)
rename Teleworkable Tele_BNJD
tempfile tf0
save `tf0'
use `tf_merged_onet', clear
merge m:1 OCC_CODE using `tf_national_soc6', keepusing(OCC_TITLE OCC_GROUP TOT_EMP) assert(master match) keep(match) nogen
gen str soc5 = substr(OCC_CODE,1,6)
collapse (mean) teleworkable [w=TOT_EMP], by(soc5)
merge 1:1 soc5 using `tf0' 
list if _merge!=3
drop _merge
tempfile tf_merged
save `tf_merged'

//Produce table with 2-digit SOC for both measures
use `tf_merged', clear
clonevar OCC_CODE = BroadGroupCode
merge 1:1 OCC_CODE using `tf_national_soc5', keepusing(OCC_TITLE OCC_GROUP TOT_EMP) assert(master match) keep(match) nogen
gen soc2 = real(substr(OCC_CODE,1,2))
collapse (mean) teleworkable Tele_BNJD [w=TOT_EMP], by(soc2)
merge 1:1 soc2 using `tf_national_soc2', assert(master match) keepusing(OCC_TITLE) nogen
gen str tele_bnjd_str = string(Tele_BNJD,"%3.2f")
gen str teleworkable_str = string(teleworkable,"%3.2f")
gsort -teleworkable soc2
listtex soc2 OCC_TITLE teleworkable_str tele_bnjd_str using "../output/soc2_summary.tex", replace ///
rstyle(tabular) head("\begin{tabular}{llcc} \toprule" "&&O*NET-derived & Manual\\" "\multicolumn{2}{c}{Occupation} & baseline & assignment\\" "\midrule") foot("\bottomrule \end{tabular}")

//Report where two methods disagree for 5-digit SOC codes
use `tf_merged', clear
keep if (Tele_BNJD==0 & inrange(teleworkable,0.8,.)) | (Tele_BNJD==1 & inrange(teleworkable,0.0,0.2))
gen str tele_bnjd_str = string(Tele_BNJD,"%2.0f")
gen str teleworkable_str = string(teleworkable,"%3.2f")
sort teleworkable Tele_BNJD soc5
listtex soc5 BroadGroup teleworkable_str tele_bnjd_str using "../output/methods_disagree.tex", replace ///
rstyle(tabular) head("\begin{tabular}{llcc} \toprule" "&&O*NET-derived & Manual\\" "\multicolumn{2}{c}{Occupation} & baseline & assignment\\" "\midrule") foot("\bottomrule \end{tabular}")
