all: ../output/CBSA_characteristics_5yr.dta

#Folder recipes
../input ../output:
	mkdir $@
../input/B19013_5yr.csv ../input/B15003_5yr.csv ../input/B25003_5yr.csv ../input/B02001_5yr.csv: | ../input
	if [ -e ../../downloaddata/output/$(@F) ] ; then ln -s ../../downloaddata/output/$(@F) $@ ; else exit 1; fi
../output/CBSA_characteristics_5yr.dta: MSA_traits_5yearACS.do ../input/B19013_5yr.csv ../input/B15003_5yr.csv ../input/B25003_5yr.csv ../input/B02001_5yr.csv | ../output
	stata-se -e $<
