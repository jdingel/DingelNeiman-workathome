all: ../output/headline_onet.tex ../output/headline_manual.tex ../output/NAICS_telework_top5bottom5_table.tex ../output/NAICS2_table.tex ../output/NAICS_workfromhome.csv ../output/NAICS3_workfromhome.csv

include ../../generic.make

../output/headline_onet.tex ../output/headline_manual.tex: headline_numbers.do ../input/national_M2018_dl.xlsx ../input/onet_teleworkable_blscodes.dta ../input/Teleworkable_BNJDopinion.dta | ../output
	stata-se -e $<
../output/NAICS_telework_top5bottom5_table.tex ../output/NAICS2_table.tex ../output/NAICS_workfromhome.csv: naics.do ../input/natsector_M2018_dl.xlsx ../input/onet_teleworkable_blscodes.dta ../input/Teleworkable_BNJDopinion.dta | ../output
	stata-se -e $<
../output/NAICS3_workfromhome.csv: naics_3digit.do ../input/nat3d_M2018_dl.xlsx ../input/onet_teleworkable_blscodes.dta ../input/Teleworkable_BNJDopinion.dta | ../output
	stata-se -e $<

../input/national_M2018_dl.xlsx ../input/natsector_M2018_dl.xlsx ../input/nat3d_M2018_dl.xlsx: ../input/%: ../../downloaddata/output/% | ../input
	ln -s $< $@
../input/onet_teleworkable_blscodes.dta: ../../onet_to_BLS_crosswalk/output/onet_teleworkable_blscodes.dta  | ../input
	ln -s $< $@
../input/Teleworkable_BNJDopinion.dta: ../../occ_manual_scores/output/Teleworkable_BNJDopinion.dta | ../input
	ln -s $< $@
