## Definitions
FOLDERS = ../input ../output
INPUTS_DATA = ../input/national_M2018_dl.xlsx ../input/onet_teleworkable_blscodes.dta ../input/Teleworkable_BNJDopinion.dta \
				../input/natsector_M2018_dl.xlsx

## Recipes
all: ../output/headline_onet.tex ../output/headline_manual.tex ../output/NAICS_telework_top5bottom5_table.tex ../output/NAICS_workfromhome.csv

#Folders recipes
$(FOLDERS):
	mkdir $@
#Inputs recipes
../input/national_M2018_dl.xlsx ../input/natsector_M2018_dl.xlsx: | ../input
	if [ -e ../../downloaddata/output/$(@F) ] ; then ln -s ../../downloaddata/output/$(@F) $@ ; else exit 1; fi
../input/onet_teleworkable_blscodes.dta: | ../input
	if [ -e ../../onet_to_BLS_crosswalk/output/$(@F) ] ; then ln -s ../../onet_to_BLS_crosswalk/output/$(@F) $@ ; else exit 1; fi
../input/Teleworkable_BNJDopinion.dta: | ../input
	if [ -e ../../occ_manual_scores/output/$(@F) ] ; then ln -s ../../occ_manual_scores/output/$(@F) $@ ; else exit 1; fi
#Outputs recipes
../output/headline_onet.tex ../output/headline_manual.tex: headline_numbers.do ../input/national_M2018_dl.xlsx ../input/onet_teleworkable_blscodes.dta ../input/Teleworkable_BNJDopinion.dta | ../output
	stata-se -e $<
../output/NAICS_telework_top5bottom5_table.tex ../output/NAICS_workfromhome.csv: naics.do ../input/natsector_M2018_dl.xlsx ../input/onet_teleworkable_blscodes.dta ../input/Teleworkable_BNJDopinion.dta | ../output
	stata-se -e $<
