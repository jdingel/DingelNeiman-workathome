//Produce table of highest and lowest cities; statement of range; only among 100 largest MSAs (by employment)

use "../input/MSA_2018_teleworkable_onet.dta", clear
tempvar tv0
egen `tv0' = rank(MSA_totalemployment), field
keep if inrange(`tv0',1,100)

tempvar tv1 tv2
egen `tv1' = rank(teleworkable_emp), field
egen `tv2' = rank(teleworkable_emp), track

keep if inrange(`tv1',1,5) | inrange(`tv2',1,5)
gen row = (`tv1')*inrange(`tv1',1,5) + (11-`tv2')*inrange(`tv2',1,5)
sort row
list AREA_NAME teleworkable_emp teleworkable_wage row
gen str tele_emp_str = string(teleworkable_emp,"%3.2f")
gen str tele_wage_str = string(teleworkable_wage,"%3.2f")

sort row
qui summarize teleworkable_emp if row==1
local top_num = string(100*`r(mean)',"%3.0f")
local top_msa = AREA_NAME[1]
qui summarize teleworkable_emp if row==10
local bot_num = string(100*`r(mean)',"%3.0f")
local bot_msa = AREA_NAME[10]
shell echo -n "from `bot_num' percent in `bot_msa' to `top_num' percent in `top_msa'%" > ../output/MSA_range.tex

gen msa_name = AREA_NAME
replace msa_name = "top5" + AREA_NAME if row==1
replace msa_name = "bot5" + AREA_NAME if row==6

listtex msa_name tele_emp_str tele_wage_str using "../output/MSA_telework_top5bottom5_table.tex", replace ///
rstyle(tabular) head("\begin{tabular}{lcc} \toprule" "& Unweighted & Weighted by wage\\" "\midrule") foot("\bottomrule \end{tabular}")

shell sed -i.bak 's/^top5/\\underline{\\textit{Top five}}\\\\/' ../output/MSA_telework_top5bottom5_table.tex
shell sed -i.bak 's/^bot5/\\\\ \\underline{\\textit{Bottom five}}\\\\/' ../output/MSA_telework_top5bottom5_table.tex
rm ../output/MSA_telework_top5bottom5_table.tex.bak
