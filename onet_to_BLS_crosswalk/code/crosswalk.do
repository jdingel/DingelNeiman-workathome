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

use "../input/onet_teleworkable.dta", clear
merge 1:1 onetsoccode using `tf_onet_soc', assert(using match) keep(match) keepusing(SOC_2010) nogen
bys SOC_2010: egen total = total(1)
by  SOC_2010: egen stddev_telew = sd(telew)
list onetsoccode title SOC_2010 teleworkable if total!=1 & stddev_telew!=0 //Taking survey-respondent-weighted averages to get to SOC_2010
collapse (mean) telew [w=n], by(SOC_2010)
merge 1:m SOC_2010 using `tf_soc_bls', keep(using match)
assert strpos(OES_TITLE,"All Other")!=0|OES_TITLE=="Legislators"|strpos(OES_TITLE,"Miscellaneous")==1 if _merge==2
drop if _merge==2
drop _merge
bys OES_2018: egen total = total(1)
by  OES_2018: egen stddev_telew = sd(telew)
list OES_2018 SOC_2010 telew if total!=1 & stddev_telew!=0 //Taking simple averages (employment reported by OES_2018, not SOC_2010)
collapse (mean) telew (firstnm) OES_TITLE, by(OES_2018)
clonevar OCC_CODE = OES_2018

save "../output/onet_teleworkable_blscodes.dta", replace
export delimited OCC_CODE OES_TITLE telew using "../output/onet_teleworkable_blscodes.csv", replace
