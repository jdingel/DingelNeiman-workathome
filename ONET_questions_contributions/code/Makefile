all: ../output/ONET_questions_contributions.tex ../output/ONET_solequestion_empshare.tex

include ../../generic.make

../output/ONET_questions_contributions.tex ../output/ONET_solequestion_empshare.tex: blscodes_characteristics_explore.do ../input/2010_to_SOC_Crosswalk.xlsx ../input/oes_2019_hybrid_structure.xlsx ../input/national_M2018_dl.xlsx ../input/onet_teleworkable_detail.dta | ../output
	stata-se -e $<

../input/2010_to_SOC_Crosswalk.xlsx ../input/oes_2019_hybrid_structure.xlsx ../input/national_M2018_dl.xlsx: ../input/%: ../../downloaddata/output/% | ../input
	ln -s $< $@
../input/onet_teleworkable_detail.dta: ../../occ_onet_scores/output/onet_teleworkable_detail.dta | ../input
	ln -s $< $@
