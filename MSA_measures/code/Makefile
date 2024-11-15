all: $(addprefix ../output/MSA_, workfromhome.csv 2018_teleworkable_onet.dta 2018_teleworkable_manual.dta)

include ../../generic.make

../output/MSA_%: produce_measures.do $(addprefix ../input/, MSA_M2018_dl.xlsx national_M2018_dl.xlsx onet_teleworkable_blscodes.dta Teleworkable_BNJDopinion.dta) | ../output
	stata-se -e $<

../input/MSA_M2018_dl.xlsx ../input/national_M2018_dl.xlsx: ../input/%: ../../downloaddata/output/% | ../input
	ln -s $< $@
../input/onet_teleworkable_blscodes.dta: ../../onet_to_BLS_crosswalk/output/onet_teleworkable_blscodes.dta  | ../input
	ln -s $< $@
../input/Teleworkable_BNJDopinion.dta: ../../occ_manual_scores/output/Teleworkable_BNJDopinion.dta | ../input
	ln -s $< $@
