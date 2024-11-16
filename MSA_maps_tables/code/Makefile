all: ../output/MSA_range.tex ../output/MSA_teleworkable_emp.eps ../output/MSA_teleworkable_wage.eps ../output/MSA_telework_top10bottom10_table_char.tex

include ../../generic.make

../output/MSA_%.tex: table.do $(shell grep -o '../input/[A-Za-z0-9_]*.dta' table.do) | ../output
	stata-se -e $<
../output/MSA_teleworkable_emp.eps ../output/MSA_teleworkable_wage.eps: maps.do ../input/MSA_2018_teleworkable_onet.dta | ../output
	stata-se -e $<

../input/MSA_2018_teleworkable_onet.dta: ../../MSA_measures/output/MSA_2018_teleworkable_onet.dta | ../input
	ln -s $< $@
../input/CBSA_characteristics_5yr.dta: ../../MSA_traits/output/CBSA_characteristics_5yr.dta | ../input
	ln -s $< $@
