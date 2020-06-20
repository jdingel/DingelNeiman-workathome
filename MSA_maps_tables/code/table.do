//Compute correlations with MSA traits
//Produce table of highest and lowest cities; statement of range; only among 100 largest MSAs (by employment)

local keepnum = 10
local keepnumstr = "ten"

use "../input/MSA_2018_teleworkable_onet.dta", clear
clonevar cbsa = AREA
recode cbsa (70900=12700) (71650=14460) (78100=44140) (79600 = 49340) (70750 = 12620) (71950 = 14860) (72400 = 15540) (73450 = 25540) (75700 = 35300) (76450 = 35980) (76750 = 38860) (77200 = 39300) (74650=30340) (74950=31700) (76600=38340) //Recode NECTAs to work with CBSA codes in ACS 2018 characteristics file
drop if inlist(AREA,72850,73050,74500,75550,76900,78700) //NECTAs that do not appear in ACS CBSA geography
merge 1:1 cbsa using "../input/CBSA_characteristics_5yr.dta", assert(using match) // keep(match) nogen

//Report correlations with MSA traits
correlate teleworkable_emp frac_ba
assert inrange(r(rho),0.5,1.0)
local rho_ba = string(r(rho),"%3.2f")
correlate teleworkable_emp median_income
assert inrange(r(rho),0.5,1.0)
local rho_income = string(r(rho),"%3.2f")
correlate teleworkable_emp frac_own
assert inrange(r(rho),-1.0,0.0)
local rho_own = string(r(rho),"%3.2f") 
correlate teleworkable_emp frac_white
assert inrange(r(rho),-1.0,0.0)
local rho_white = string(r(rho),"%3.2f")
shell echo "Across all metropolitan areas, the share of jobs that can be performed at home is strongly positively correlated with median household income (`rho_income') and its share of residents who attained a college degree (`rho_ba') and negatively correlated with its home ownership rate (`rho_own') and its share of residents who are white (`rho_white').%" > ../output/MSA_correlates.tex

//Restrict attention to 100 largest MSAs (by employment) to produce top & bottom table
tempvar tv0
egen `tv0' = rank(MSA_totalemployment), field
keep if inrange(`tv0',1,100)

tempvar tv1 tv2
egen `tv1' = rank(teleworkable_emp), field
egen `tv2' = rank(teleworkable_emp), track

keep if inrange(`tv1',1,`keepnum') | inrange(`tv2',1,`keepnum')
gen row = (`tv1')*inrange(`tv1',1,`keepnum') + (2*`keepnum'+1-`tv2')*inrange(`tv2',1,`keepnum')

//Format numbers suitable for table output
gen str tele_emp_str = string(teleworkable_emp,"%3.2f")
gen str tele_wage_str = string(teleworkable_wage,"%3.2f")
foreach var of varlist frac_ba frac_own frac_white{
	gen str `var'_str = string(`var',"%3.2f")
}
gen str median_income_thousands = string(median_income/1000,"%3.0f")


sort row
qui summarize teleworkable_emp if row==1
local top_num = string(100*`r(mean)',"%3.0f")
local top_msa = AREA_NAME[1]
qui summarize teleworkable_emp if row==2*`keepnum'
local bot_num = string(100*`r(mean)',"%3.0f")
local bot_msa = AREA_NAME[2*`keepnum']
shell echo -n "from `bot_num' percent in `bot_msa' to `top_num' percent in `top_msa'%" > ../output/MSA_range.tex

gen msa_name = AREA_NAME
replace msa_name = "topnum" + AREA_NAME if row==1
replace msa_name = "botnum" + AREA_NAME if row==(1+`keepnum')

listtex msa_name tele_emp_str tele_wage_str frac_ba_str median_income_thousands frac_white_str frac_own_str using "../output/MSA_telework_top`keepnum'bottom`keepnum'_table_char.tex", replace ///
rstyle(tabular) head("\begin{tabular}{lcc|cccc} \toprule" " & \multicolumn{2}{c}{Share of jobs} & \multicolumn{4}{c}{Metropolitan characteristics} \\" " && Weighted & BA & Median & White & Owner \\" "& Unweighted & by wage & share & income & share & share \\" "\midrule") foot("\bottomrule \end{tabular}")

shell sed -i.bak 's/^topnum/\\underline{\\textit{Top `keepnumstr'}}\\\\/' ../output/MSA_telework_top`keepnum'bottom`keepnum'_table_char.tex
shell sed -i.bak 's/^botnum/\\\\ \\underline{\\textit{Bottom `keepnumstr'}}\\\\/' ../output/MSA_telework_top`keepnum'bottom`keepnum'_table_char.tex
rm ../output/MSA_telework_top`keepnum'bottom`keepnum'_table_char.tex.bak
