all: ../output/Teleworkable_BNJDopinion.dta

include ../../generic.make

../output/Teleworkable_BNJDopinion.dta: ../input/Teleworkable_BNJDopinion.csv | ../output
	stata-se -e load.do
