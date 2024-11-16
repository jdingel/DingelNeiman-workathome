all: ../output/soc2_summary.tex ../output/methods_disagree.tex

include ../../generic.make

../output/soc2_summary.tex ../output/methods_disagree.tex: compare_methods.do ../input/national_M2018_dl.xlsx ../input/Teleworkable_BNJDopinion.dta ../input/onet_teleworkable_blscodes.dta | ../output
	stata-se -e $<

#Inputs recipes
../input/Teleworkable_BNJDopinion.dta: ../../occ_manual_scores/output/Teleworkable_BNJDopinion.dta | ../input
	ln -s $< $@
../input/onet_teleworkable_blscodes.dta: ../../onet_to_BLS_crosswalk/output/onet_teleworkable_blscodes.dta  | ../input
	ln -s $< $@
../input/national_M2018_dl.xlsx: ../../downloaddata/output/national_M2018_dl.xlsx | ../input
	ln -s $< $@
