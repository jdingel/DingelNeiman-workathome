clear all

foreach package in blindschemes {
    capture which `package'
    if _rc==111 ssc install `package'
}
set scheme plotplainblind

import delimited using "../input/EF_telework.csv", clear
assert yes==total
drop total
rename yes covid_caused_telework
assert inrange(covid_caused_telework,1.0,100.0)
replace covid_caused_telework = covid_caused_telework / 100
assert inrange(covid_caused_telework,0,1)
label variable covid_caused_telework "Share who started to work from home due to COVID-19"
gen byte low_reliability = substr(country,-1,1)=="*"
label variable low_reliability "Eurofound notes country estimate as 'low reliability'"
replace country = subinstr(country,"*","",1) if low_reliability==1
drop if country=="Total (EU27)"
tempfile tf_EF
save `tf_EF'

import delimited using "../input/country_workathome.csv", clear
label variable teleworkable "Share of jobs that can be performed at home (Dingel-Neiman estimate)"
merge 1:1 country using `tf_EF', assert(master match) keep(match) nogen
twoway 	(scatter covid_caused_telework teleworkable if low_reliability==0, mlabel(country_code) msym(none) mlabposition(0) mlabsize(vsmall) mlabcolor(black)) ///
		(scatter covid_caused_telework teleworkable if low_reliability==1, mlabel(country_code) msym(none) mlabposition(0) mlabsize(vsmall) mlabcolor(red)) ///
		, legend(off)

		regress covid_caused_telework teleworkable
local slope = string(_b[teleworkable],"%3.2f")
local intercept = string(_b[_cons],"%3.2f")
local Rsquared = string(e(r2),"%3.2f")
twoway (scatter covid_caused_telework teleworkable, mlabel(country_code) msym(none) mlabposition(0) mlabsize(vsmall) mlabcolor(black)) ///
	, note("A linear regression yields a slope of `slope', intercept of `intercept', and R{sup:2} of `Rsquared'.", size(small))

twoway (scatter covid_caused_telework teleworkable, mlabel(country_code) msym(none) mlabposition(0) mlabsize(vsmall) mlabcolor(black))
graph export "../output/countries_crisisoutcomes.eps", replace
graph export "../output/countries_crisisoutcomes.png", replace
