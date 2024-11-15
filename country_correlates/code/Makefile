all: ../output/telework_vs_GDPPC.eps ../output/country_workathome.csv
include ../../generic.make

../output/telework_vs_GDPPC.eps ../output/country_workathome.csv: correlates.do ../input/country_isco08_telework.dta ../input/WEO_Data.xls | ../output
	stata-se -e $<

../input/country_isco08_telework.dta: ../../country_measures/output/country_isco08_telework.dta | ../input
	ln -s $< $@
../input/WEO_Data.xls: ../../downloaddata/output/WEO_Data.xls | ../input
	ln -s $< $@
