
all: ../output/occupation_WFH_wage_plot.eps ../output/occupation_WFH_wage_plot_largetext.eps

include ../../generic.make

../output/occupation_WFH_wage_plot.eps ../output/occupation_WFH_wage_plot_largetext.eps: plot.do ../input/national_M2018_dl.xlsx ../input/onet_teleworkable_blscodes.dta | ../output
	stata-se -e $<

../input/onet_teleworkable_blscodes.dta: ../../onet_to_BLS_crosswalk/output/onet_teleworkable_blscodes.dta  | ../input
	ln -s $< $@
../input/national_M2018_dl.xlsx: ../../downloaddata/output/national_M2018_dl.xlsx | ../input
	ln -s $< $@
