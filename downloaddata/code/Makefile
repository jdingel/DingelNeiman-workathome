#Definitions
FOLDERS   = ../output

#Recipes
all: 	../output/MSA_M2018_dl.xlsx ../output/national_M2018_dl.xlsx \
		../output/ONET_Work_Context.txt ../output/ONET_Work_Context_Categories.txt ../output/ONET_Occupation_Data.txt ../output/ONET_Work_Activities.txt \
 		../output/natsector_M2018_dl.xlsx ../output/nat3d_M2018_dl.xlsx \
		../output/oes_2019_hybrid_structure.xlsx ../output/2010_to_SOC_Crosswalk.xlsx

../output:
	mkdir $@

#Occupational Employment Statistics
../output/oesm18nat.zip: | ../output
	curl https://www.bls.gov/oes/special.requests/oesm18nat.zip > $@
../output/oesm18ma.zip: | ../output
	curl https://www.bls.gov/oes/special.requests/oesm18ma.zip > $@
../output/oesm18in4.zip: | ../output
	curl https://www.bls.gov/oes/special.requests/oesm18in4.zip > $@
../output/national_M2018_dl.xlsx: | ../output/oesm18nat.zip
	unzip ../output/oesm18nat.zip -d ../output
	mv -v ../output/oesm18nat/* ../output/
	rm -r ../output/oesm18nat
../output/MSA_M2018_dl.xlsx: | ../output/oesm18ma.zip
	unzip ../output/oesm18ma.zip -d ../output
	mv -v ../output/oesm18ma/* ../output/
	rm -r ../output/oesm18ma
../output/natsector_M2018_dl.xlsx ../output/nat3d_M2018_dl.xlsx: | ../output/oesm18in4.zip
	unzip ../output/oesm18in4.zip oesm18in4/natsector_M2018_dl.xlsx oesm18in4/nat3d_M2018_dl.xlsx -d ../output
	mv -v ../output/oesm18in4/* ../output/
	rm -r ../output/oesm18in4
#O*NET occupational characteristics
../output/ONET_Work_Context.txt: | ../output
	curl https://www.onetcenter.org/dl_files/database/db_24_2_text/Work%20Context.txt > $@
../output/ONET_Work_Context_Categories.txt: | ../output
	curl https://www.onetcenter.org/dl_files/database/db_24_2_text/Work%20Context%20Categories.txt	> $@
../output/ONET_Occupation_Data.txt: | ../output
	curl https://www.onetcenter.org/dl_files/database/db_24_2_text/Occupation%20Data.txt > $@
../output/ONET_Work_Activities.txt: | ../output
	curl https://www.onetcenter.org/dl_files/database/db_24_2_text/Work%20Activities.txt > $@
#Crosswalks
../output/oes_2019_hybrid_structure.xlsx: | ../output
	curl https://www.bls.gov/oes/$(@F) > $@
../output/2010_to_SOC_Crosswalk.xlsx: | ../output
	curl https://www.onetcenter.org/taxonomy/2010/soc/2010_to_SOC_Crosswalk.xlsx?fmt=xlsx  > $@