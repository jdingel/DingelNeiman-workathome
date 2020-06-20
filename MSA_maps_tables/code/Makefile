#Recipes
all: ../output/MSA_range.tex ../output/MSA_teleworkable_emp.eps ../output/MSA_teleworkable_wage.eps ../output/MSA_telework_top10bottom10_table_char.tex
#Folders recipes
../input ../output:
	mkdir $@
#Inputs recipes
../input/MSA_2018_teleworkable_manual.dta ../input/MSA_2018_teleworkable_onet.dta: | ../input
	if [ -e ../../MSA_measures/output/$(@F) ] ; then ln -s ../../MSA_measures/output/$(@F) $@ ; else exit 1; fi
../input/CBSA_characteristics_5yr.dta: | ../input
	if [ -e ../../MSA_traits/output/$(@F) ] ; then ln -s ../../MSA_traits/output/$(@F) $@ ; else exit 1; fi
#Outputs recipes
../output/MSA_range.tex ../output/MSA_telework_top5bottom5_table.tex: table.do ../input/MSA_2018_teleworkable_manual.dta ../input/MSA_2018_teleworkable_onet.dta | ../output
	stata-se -e $<
../output/MSA_teleworkable_emp.eps ../output/MSA_teleworkable_wage.eps: maps.do ../input/MSA_2018_teleworkable_manual.dta ../input/MSA_2018_teleworkable_onet.dta | ../output
	stata-se -e $<
../output/MSA_telework_top10bottom10_table_char.tex ../output/MSA_correlates.tex: table.do ../input/MSA_2018_teleworkable_manual.dta ../input/MSA_2018_teleworkable_onet.dta ../input/CBSA_characteristics_5yr.dta | ../output
	stata-se -e $<
