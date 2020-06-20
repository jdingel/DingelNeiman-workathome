## Recipes
all: ../output/ONET_questions_contributions.tex ../output/ONET_solequestion_empshare.tex

#Folders recipes
../input ../output:
	mkdir $@
#Inputs recipes
../input/2010_to_SOC_Crosswalk.xlsx ../input/oes_2019_hybrid_structure.xlsx ../input/national_M2018_dl.xlsx: | ../input
	if [ -e ../../downloaddata/output/$(@F) ] ; then ln -s ../../downloaddata/output/$(@F) $@ ; else exit 1; fi
../input/onet_teleworkable_detail.dta: | ../input
	if [ -e ../../occ_onet_scores/output/$(@F) ] ; then ln -s ../../occ_onet_scores/output/$(@F) $@ ; else exit 1; fi
#Outputs recipes
../output/ONET_questions_contributions.tex ../output/ONET_solequestion_empshare.tex: blscodes_characteristics_explore.do ../input/2010_to_SOC_Crosswalk.xlsx ../input/oes_2019_hybrid_structure.xlsx ../input/national_M2018_dl.xlsx ../input/onet_teleworkable_detail.dta | ../output
	stata-se -e $<
