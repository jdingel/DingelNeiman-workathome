## Definitions
FOLDERS = ../input ../output
INPUTS_DATA = ../input/country_isco08_telework.dta ../input/WEO_Data.xls
OUTPUTS = ../output/telework_vs_GDPPC.eps ../output/country_workathome.csv

## Recipes
all: $(OUTPUTS)

#Folders recipes
$(FOLDERS):
	mkdir $@
#Inputs recipes
../input/country_isco08_telework.dta: | ../input
	if [ -e ../../country_measures/output/$(@F) ] ; then ln -s ../../country_measures/output/$(@F) $@ ; else exit 1; fi
../input/WEO_Data.xls: | ../input
	if [ -e ../../downloaddata/output/$(@F) ] ; then ln -s ../../downloaddata/output/$(@F) $@ ; else exit 1; fi

#Outputs recipes
$(OUTPUTS): correlates.do $(INPUTS_DATA) | ../output
	stata-se -e $<
