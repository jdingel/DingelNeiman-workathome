
all: ../output/countries_crisisoutcomes.eps

../input ../output:
		mkdir $@

../input/country_workathome.csv: | ../input
	if [ -e ../../country_correlates/output/$(@F) ] ; then ln -s ../../country_correlates/output/$(@F) $@ ; else exit 1; fi
../input/EF_telework.csv: | ../input
	if [ -e ../../downloaddata/output/$(@F) ] ; then ln -s ../../downloaddata/output/$(@F) $@ ; else exit 1; fi
../output/countries_crisisoutcomes.eps: countries_crisisoutcomes.do ../input/country_workathome.csv ../input/EF_telework.csv | ../output
	stata-se -e $<
