## Definitions
FOLDERS = ../input ../output slurmlogs
INPUTS_DATA = 	../input/ONET_Work_Context.txt ../input/ONET_Work_Context_Categories.txt ../input/ONET_Occupation_Data.txt ../input/ONET_Work_Activities.txt

## Recipes
all: ../output/onet_teleworkable.dta

#Folders recipes
$(FOLDERS):
	mkdir $@
#Inputs recipes
../input/ONET_Work_Context.txt ../input/ONET_Work_Context_Categories.txt ../input/ONET_Occupation_Data.txt ../input/ONET_Work_Activities.txt: | ../input
	if [ -e ../../downloaddata/output/$(@F) ] ; then ln -s ../../downloaddata/output/$(@F) $@ ; else exit 1; fi
#Outputs recipes
../output/onet_teleworkable.dta: onet_characteristics.do $(INPUTS_DATA) | ../output
	stata-se -e $<