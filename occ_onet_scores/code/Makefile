all: ../output/onet_teleworkable.dta ../output/occupations_workathome.csv

include ../../generic.make

../output/onet_teleworkable.dta ../output/occupations_workathome.csv: onet_characteristics.do $(shell grep -o '../input/[A-Za-z0-9_]*.txt' onet_characteristics.do) | ../output
	stata-se -e $<

../input/ONET%.txt: ../../downloaddata/output/ONET%.txt | ../input
	ln -s $< $@
