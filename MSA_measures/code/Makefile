#Recipes
all: ../output/MSA_workfromhome.csv ../output/MSA_2018_teleworkable_onet.dta ../output/MSA_2018_teleworkable_manual.dta
#Folders recipes
../input ../output :
	mkdir $@
#Inputs recipes
../input/MSA_M2018_dl.xlsx ../input/national_M2018_dl.xlsx: | ../input
	if [ -e ../../downloaddata/output/$(@F) ] ; then ln -s ../../downloaddata/output/$(@F) $@ ; else exit 1; fi
../input/onet_teleworkable_blscodes.dta: | ../input
	if [ -e ../../onet_to_BLS_crosswalk/output/$(@F) ] ; then ln -s ../../onet_to_BLS_crosswalk/output/$(@F) $@ ; else exit 1; fi
../input/Teleworkable_BNJDopinion.dta: | ../input
	if [ -e ../../occ_manual_scores/output/$(@F) ] ; then ln -s ../../occ_manual_scores/output/$(@F) $@ ; else exit 1; fi
#Outputs recipes
../output/MSA_workfromhome.csv ../output/MSA_2018_teleworkable_onet.dta ../output/MSA_2018_teleworkable_manual.dta: produce_measures.do ../input/MSA_M2018_dl.xlsx ../input/national_M2018_dl.xlsx ../input/onet_teleworkable_blscodes.dta ../input/Teleworkable_BNJDopinion.dta | ../output
	stata-se -e $<
