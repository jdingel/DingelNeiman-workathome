
use "../input/MSA_2018_teleworkable_onet.dta", clear
clonevar cbsa2013 = AREA
recode cbsa2013 (70900=12700) (71650=14460) (78100=44140) (79600 = 49340) (70750 = 12620) (71950 = 14860) (72400 = 15540) (73450 = 25540) (75700 = 35300) (76450 = 35980) (76750 = 38860) (77200 = 39300) //Recode NECTAs to work with CBSA 2013 maptile
maptile teleworkable_emp, geo(cbsa2013) ndfcolor(white) rangecolor(red*0.2 red*2.5) propcolor
//graph export "../output/MSA_teleworkable_emp.png", replace
graph export "../output/MSA_teleworkable_emp.eps", replace
maptile teleworkable_wage, geo(cbsa2013) ndfcolor(white) rangecolor(red*0.2 red*2.5) propcolor
//graph export "../output/MSA_teleworkable_wage.png", replace
graph export "../output/MSA_teleworkable_wage.eps", replace
