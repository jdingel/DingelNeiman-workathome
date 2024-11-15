all: $(addprefix ../output/state_, workfromhome.csv 2018_teleworkable_onet.dta 2018_teleworkable_manual.dta)

include ../../generic.make

$(addprefix ../output/state_, workfromhome.csv 2018_teleworkable_onet.dta 2018_teleworkable_manual.dta): produce_measures.do ../input/state_M2018_dl.xlsx ../input/national_M2018_dl.xlsx ../input/onet_teleworkable_blscodes.dta ../input/Teleworkable_BNJDopinion.dta | ../output
	stata-se -e $<

../input/state_M2018_dl.xlsx ../input/national_M2018_dl.xlsx: ../input/%: ../../downloaddata/output/% | ../input
	ln -s $< $@
../input/onet_teleworkable_blscodes.dta: ../../onet_to_BLS_crosswalk/output/onet_teleworkable_blscodes.dta  | ../input
	ln -s $< $@
../input/Teleworkable_BNJDopinion.dta: ../../occ_manual_scores/output/Teleworkable_BNJDopinion.dta | ../input
	ln -s $< $@
