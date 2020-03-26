//MAP O*NET TELEWORK SCORE to BLS's 6-digit SOC categories

tempfile tf_onet_soc tf_soc_bls tf_bls_telework

import excel using "../input/2010_to_SOC_Crosswalk.xlsx", firstrow cellrange(A4:D1114) clear
rename ONETSOC2010Code onetsoccode
rename SOCCode SOC_2010
rename SOCTitle SOC_TITLE
save `tf_onet_soc'

/*
bys onetsoccode: egen total_onet = total(1)
assert total_onet==1
bys SOC_2010: egen total_soc = total(1)
list if total_onet!=1|total_soc!=1
*/

import excel using "../input/oes_2019_hybrid_structure.xlsx", sheet(OES2019 Hybrid) cellrange(A6:H874) clear firstrow
rename (OES2018EstimatesCode OES2018EstimatesTitle) (OES_2018 OES_TITLE)
rename (G H) (SOC_2010 SOC_TITLE)
keep OES_2018 OES_TITLE SOC_2010 SOC_TITLE
replace OES_TITLE = trim(OES_TITLE)
duplicates drop
save `tf_soc_bls'
/*
bys SOC_2010: egen total = total(1)
//In data, will need to collapse employment counts for "25-3097	Teachers and Instructors, All Other, Except Substitute Teachers" & "25-3098	Substitute Teachers" down to "25-3099	Teachers and Instructors, All Other"
*/

use "../input/onet_teleworkable.dta", clear
merge 1:1 onetsoccode using `tf_onet_soc', assert(using match) keep(match) keepusing(SOC_2010) nogen
collapse (mean) telew [w=n], by(SOC_2010)
merge 1:m SOC_2010 using `tf_soc_bls', keep(match) nogen
collapse (mean) telew (firstnm) OES_TITLE, by(OES_2018)
clonevar OCC_CODE = OES_2018

save "../output/onet_teleworkable_blscodes.dta", replace
