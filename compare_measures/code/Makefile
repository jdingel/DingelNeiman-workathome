#Definitions
FOLDERS = ../input ../output
INPUTS_DATA = ../input/gss.dta
#Recipes
all: ../output/soc2_summary.tex ../output/methods_disagree.tex

$(FOLDERS):
	mkdir $@
#Inputs recipes
../input/gss.dta: ../../MasPallaisGSS/output/gss.dta | ../input
	ln -s $< $@
../input/Teleworkable_BNJDopinion.dta: ../../occ_manual_scores/output/Teleworkable_BNJDopinion.dta | ../input
	ln -s $< $@
../input/onet_teleworkable_blscodes.dta: ../../onet_to_BLS_crosswalk/output/onet_teleworkable_blscodes.dta  | ../input
	ln -s $< $@
../input/national_M2018_dl.xlsx: | ../input
	if [ -e ../../downloaddata/output/$(@F) ] ; then ln -s ../../downloaddata/output/$(@F) $@ ; else exit 1; fi
../output/soc2_summary.tex ../output/methods_disagree.tex: compare_methods.do ../input/national_M2018_dl.xlsx ../input/Teleworkable_BNJDopinion.dta ../input/onet_teleworkable_blscodes.dta | ../output
	stata-se -e $<
