all: ../output/countries_crisisoutcomes.eps

include ../../generic.make 

../output/countries_crisisoutcomes.eps: countries_crisisoutcomes.do ../input/country_workathome.csv ../input/EF_telework.csv | ../output
	stata-se -e $<
../input/country_workathome.csv: ../../country_correlates/output/country_workathome.csv | ../input
	ln -s $< $@
../input/EF_telework.csv: ../../downloaddata/output/EF_telework.csv | ../input
	ln -s $< $@
