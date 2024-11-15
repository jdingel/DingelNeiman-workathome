## Definitions
INPUTS_DATA = $(addprefix ../input/, national_M2018_dl.xlsx oes_2019_hybrid_structure.xlsx ilostat-2020-04-10.csv ISCO_SOC_Crosswalk.xls WEO_Data.xls)

## Recipes
all: ../output/country_isco08_telework.dta
include ../../generic.make

../output/country_isco08_telework.dta: country_level_measures.do $(shell grep -o '../input/[A-Za-z0-9_\-]*\.[a-z]*' country_level_measures.do) | ../output
	stata-se -e $<

$(INPUTS_DATA): ../input/%: ../../downloaddata/output/% | ../input
	ln -s $< $@
../input/onet_teleworkable_blscodes.dta: ../../onet_to_BLS_crosswalk/output/onet_teleworkable_blscodes.dta | ../input
	ln -s $< $@
