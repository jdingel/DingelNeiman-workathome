## Definitions
FOLDERS = ../input ../output
INPUTS_DATA = ../input/ilostat-2020-04-10.csv ../input/ISCO_SOC_Crosswalk.xls ../input/national_M2018_dl.xlsx ../input/oes_2019_hybrid_structure.xlsx ../input/onet_teleworkable_blscodes.dta ../input/WEO_Data.xls
OUTPUTS = ../output/country_isco08_telework.dta

## Recipes
all: ../output/country_isco08_telework.dta

#Folders recipes
$(FOLDERS):
	mkdir $@
#Inputs recipes

../input/national_M2018_dl.xlsx ../input/oes_2019_hybrid_structure.xlsx ../input/ilostat-2020-04-10.csv: | ../input
	if [ -e ../../downloaddata/output/$(@F) ] ; then ln -s ../../downloaddata/output/$(@F) $@ ; else exit 1; fi
../input/ISCO_SOC_Crosswalk.xls ../input/WEO_Data.xls: | ../input
	if [ -e ../../downloaddata/output/$(@F) ] ; then ln -s ../../downloaddata/output/$(@F) $@ ; else exit 1; fi
../input/onet_teleworkable_blscodes.dta: | ../input
	if [ -e ../../onet_to_BLS_crosswalk/output/$(@F) ] ; then ln -s ../../onet_to_BLS_crosswalk/output/$(@F) $@ ; else exit 1; fi

#Outputs recipes
../output/country_isco08_telework.dta: country_level_measures.do $(INPUTS_DATA) | ../output
	stata-se -e $<
