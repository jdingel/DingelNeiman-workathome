all: ../output/CBSA_characteristics_5yr.dta

include ../../generic.make

../output/CBSA_characteristics_5yr.dta: MSA_traits_5yearACS.do ../input/B19013_5yr.csv ../input/B15003_5yr.csv ../input/B25003_5yr.csv ../input/B02001_5yr.csv | ../output
	stata-se -e $<
../input/B19013_5yr.csv ../input/B15003_5yr.csv ../input/B25003_5yr.csv ../input/B02001_5yr.csv: ../input/%: ../../downloaddata/output/% | ../input
	ln -s $< $@
