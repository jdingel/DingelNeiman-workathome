all: ../output/onet_teleworkable_blscodes.dta

include ../../generic.make

../output/onet_teleworkable_blscodes.dta ../output/onet_teleworkable_blscodes.csv: crosswalk.do ../input/onet_teleworkable.dta ../input/2010_to_SOC_Crosswalk.xlsx ../input/oes_2019_hybrid_structure.xlsx ../input/national_M2018_dl.xlsx | ../output
	stata-se -e $<

../input/2010_to_SOC_Crosswalk.xlsx ../input/oes_2019_hybrid_structure.xlsx ../input/national_M2018_dl.xlsx: ../input/%:  ../../downloaddata/output/% | ../input
	ln -s $< $@
../input/onet_teleworkable.dta: ../../occ_onet_scores/output/onet_teleworkable.dta | ../input
	ln -s $< $@
