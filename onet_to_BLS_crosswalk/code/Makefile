## Recipes
all: ../output/onet_teleworkable_blscodes.dta

#Folders recipes
../input ../output:
	mkdir $@
#Inputs recipes
../input/2010_to_SOC_Crosswalk.xlsx ../input/oes_2019_hybrid_structure.xlsx ../input/national_M2018_dl.xlsx: | ../input
	if [ -e ../../downloaddata/output/$(@F) ] ; then ln -s ../../downloaddata/output/$(@F) $@ ; else exit 1; fi
../input/onet_teleworkable.dta: | ../input
	if [ -e ../../occ_onet_scores/output/$(@F) ] ; then ln -s ../../occ_onet_scores/output/$(@F) $@ ; else exit 1; fi
#Outputs recipes
../output/onet_teleworkable_blscodes.dta: crosswalk.do ../input/onet_teleworkable.dta ../input/2010_to_SOC_Crosswalk.xlsx ../input/oes_2019_hybrid_structure.xlsx ../input/national_M2018_dl.xlsx | ../output
	stata-se -e $<
