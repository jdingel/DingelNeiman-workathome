all: ../output/Teleworkable_BNJDopinion.dta

../output/Teleworkable_BNJDopinion.dta: ../input/Teleworkable_BNJDopinion.csv | ../output
	stata-se -e load.do
../output:
	mkdir $@
