clear all

foreach package in blindschemes {
    capture which `package'
    if _rc==111 ssc install `package'
}
set scheme plotplainblind

//Load country-level GDP per capita, PPP
import delim using "../input/WEO_Data.xls", rowrange(1:194) clear
rename iso country_code
forvalues i = 7/46 {
	local yr = 1973 + `i'
	rename v`i' gdppc_ppp`yr'
}
assert (missing(gdppc_ppp2019)==0 & gdppc_ppp2019!="n/a")|missing(estimatesstartafter)==1|(gdppc_ppp2011=="n/a" & gdppc_ppp2012=="n/a" & gdppc_ppp2013=="n/a" & gdppc_ppp2014=="n/a" & gdppc_ppp2015=="n/a" & gdppc_ppp2016=="n/a" & gdppc_ppp2017=="n/a" & gdppc_ppp2018=="n/a" & gdppc_ppp2019=="n/a") //If GDP is reported after 2011, it's available in 2019
keep country country_code gdppc_ppp2019
drop if gdppc_ppp2019=="n/a"|missing(gdppc_ppp2019)==1
destring(gdppc_ppp2019), ignore(",") replace
tempfile country_level_gdp
save `country_level_gdp'

//Merge country-level telework scores with GDP per capita
use "../input/country_isco08_telework.dta", clear
collapse (mean) telework* (first) country unallocated_employment_share [w=employment], by(country_code year)
merge 1:1 country_code using `country_level_gdp', keep(match) nogen
tempfile tf_merged
save `tf_merged'

//Export CSV of scatterplot observations
keep if inrange(unallocated_employment_share,0,0.05)==1
sort country_code
rename year year_ilo
export delimited country_code country year_ilo teleworkable gdppc_ppp2019 if inrange(gdppc_ppp2019,0,.) using "../output/country_workathome.csv", replace

//Compare to Saltiel results
list if inlist(country_code,"ARM","BOL","CHN","COL","GEO")|inlist(country_code,"GHA","KEN","LAO","MKD","VNM")==1

//Scatterplot
graph twoway scatter teleworkable gdppc_ppp2019 if inrange(gdppc_ppp2019,0,.), xlabel(0(15000)120000) ylabel(0(0.1)0.5) graphregion(color(white)) ///
ytitle("Share of jobs that can be done at home") ylabel( , labsize(small))  ///
xtitle("GDP per capita (purchasing power parity)") xlabel( , labsize(small)) ///
mlabel(country_code) msym(none) mlabposition(0) mlabsize(vsmall) mlabcolor(black)
graph export "../output/telework_vs_GDPPC.eps", as(eps) replace
