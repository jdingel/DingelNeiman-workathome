all: $(addprefix ../output/, \
	MSA_M2018_dl.xlsx national_M2018_dl.xlsx \
	ONET_Work_Context.txt ONET_Work_Context_Categories.txt ONET_Occupation_Data.txt ONET_Work_Activities.txt \
 	natsector_M2018_dl.xlsx nat3d_M2018_dl.xlsx \
	oes_2019_hybrid_structure.xlsx 2010_to_SOC_Crosswalk.xlsx \
	ISCO_SOC_Crosswalk.xls WEO_Data.xls ilostat-2020-04-10.csv \
	B19013_5yr.csv B15003_5yr.csv B25003_5yr.csv B02001_5yr.csv \
	EF_telework.csv)

include ../../generic.make

#Occupational Employment Statistics
../temp/oesm18nat.zip ../temp/oesm18ma.zip ../temp/oesm18in4.zip: | ../temp
	wget --user-agent="youraddress@domain.edu" https://www.bls.gov/oes/special.requests/$(@F) -O $@
../output/national_M2018_dl.xlsx: | ../temp/oesm18nat.zip
	unzip -j $| oesm18nat/$(@F) -d ../output
../output/MSA_M2018_dl.xlsx: | ../temp/oesm18ma.zip
	unzip -j $| oesm18ma/$(@F) -d ../output
../output/natsector_M2018_dl.xlsx ../output/nat3d_M2018_dl.xlsx: | ../temp/oesm18in4.zip
	unzip -j $| oesm18in4/$(@F) -d ../output
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
	wget --user-agent="youraddress@domain.edu" https://www.bls.gov/oes/oes_2019_hybrid_structure.xlsx -O $@
../output/2010_to_SOC_Crosswalk.xlsx: | ../output
	$(error This is committed to the repo because ONET removed from https://www.onetcenter.org/taxonomy/2010/soc/2010_to_SOC_Crosswalk.xlsx?fmt=xlsx)
	#curl https://www.onetcenter.org/taxonomy/2010/soc/2010_to_SOC_Crosswalk.xlsx?fmt=xlsx  > $@
#International data 
# ilostat-2020-04-10.csv.zip would have to be manually downloaded from "https://www.ilo.org/shinyapps/bulkexplorer16/?lang=en&segment=indicator&id=EMP_TEMP_SEX_OC2_NB_A". Select sex==total and years>=2015.
../output/ilostat-2020-04-10.csv: ../input/ilostat-2020-04-10.csv.zip | ../output
	unzip ../input/ilostat-2020-04-10.csv.zip -d ../output/
	touch ../output/ilostat-2020-04-10.csv
../output/WEO_Data.xls: | ../output
	$(error This is committed to the repo because the IMF website is not stable.)
	#curl "https://www.imf.org/external/pubs/ft/weo/2017/02/weodata/weoreptc.aspx?sy=1980&ey=2019&scsm=1&ssd=1&sic=1&sort=country&ds=.&br=1&pr1.x=65&pr1.y=13&c=512%2C946%2C914%2C137%2C612%2C546%2C614%2C962%2C311%2C674%2C213%2C676%2C911%2C548%2C193%2C556%2C122%2C678%2C912%2C181%2C313%2C867%2C419%2C682%2C513%2C684%2C316%2C273%2C913%2C868%2C124%2C921%2C339%2C948%2C638%2C943%2C514%2C686%2C218%2C688%2C963%2C518%2C616%2C728%2C223%2C836%2C516%2C558%2C918%2C138%2C748%2C196%2C618%2C278%2C624%2C692%2C522%2C694%2C622%2C142%2C156%2C449%2C626%2C564%2C628%2C565%2C228%2C283%2C924%2C853%2C233%2C288%2C632%2C293%2C636%2C566%2C634%2C964%2C238%2C182%2C662%2C359%2C960%2C453%2C423%2C968%2C935%2C922%2C128%2C714%2C611%2C862%2C321%2C135%2C243%2C716%2C248%2C456%2C469%2C722%2C253%2C942%2C642%2C718%2C643%2C724%2C939%2C576%2C644%2C936%2C819%2C961%2C172%2C813%2C132%2C726%2C646%2C199%2C648%2C733%2C915%2C184%2C134%2C524%2C652%2C361%2C174%2C362%2C328%2C364%2C258%2C732%2C656%2C366%2C654%2C734%2C336%2C144%2C263%2C146%2C268%2C463%2C532%2C528%2C944%2C923%2C176%2C738%2C534%2C578%2C536%2C537%2C429%2C742%2C433%2C866%2C178%2C369%2C436%2C744%2C136%2C186%2C343%2C925%2C158%2C869%2C439%2C746%2C916%2C926%2C664%2C466%2C826%2C112%2C542%2C111%2C967%2C298%2C443%2C927%2C917%2C846%2C544%2C299%2C941%2C582%2C446%2C474%2C666%2C754%2C668%2C698%2C672&s=PPPPC&grp=0&a=" > $@
../output/ISCO_SOC_Crosswalk.xls: | ../output
	wget --user-agent="youraddress@domain.edu" https://www.bls.gov/soc/ISCO_SOC_Crosswalk.xls -O $@
# 2018 American Community Survey (5-year) CBSA characteristics
../output/B19013_5yr.csv: | ../output
	wget "https://api.census.gov/data/2018/acs/acs5?get=NAME,group(B19013)&for=metropolitan%20statistical%20area/micropolitan%20statistical%20area" -O $@
../output/B15003_5yr.csv: | ../output
	wget "https://api.census.gov/data/2018/acs/acs5?get=NAME,group(B15003)&for=metropolitan%20statistical%20area/micropolitan%20statistical%20area" -O $@
../output/B25003_5yr.csv: | ../output
	wget "https://api.census.gov/data/2018/acs/acs5?get=NAME,group(B25003)&for=metropolitan%20statistical%20area/micropolitan%20statistical%20area" -O $@
../output/B02001_5yr.csv: | ../output
	wget "https://api.census.gov/data/2018/acs/acs5?get=NAME,group(B02001)&for=metropolitan%20statistical%20area/micropolitan%20statistical%20area" -O $@
# eurofound survey on working from home downloaded from https://www.eurofound.europa.eu/data/covid-19/working-teleworking?var=D007_01&cat_sel=Yes
../output/EF_telework.csv: ../input/EF_data.csv
	sed -n '4,31p' $< > $@