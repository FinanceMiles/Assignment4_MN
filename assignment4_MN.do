ssc install reghdfe
ssc install ftools
clear all

use "C:\Users\mfn23a\Downloads\dataset_assignment_4.dta"

*a
reg y x1 x2 x3 x4 x5 x6 x7 x8 x9 x10

*b
reg y x1 x2 x3 x4 x5 x6 x7 x8 x9 x10, robust

*c
reghdfe y x1 x2 x3 x4 x5 x6 x7 x8 x9 x10, absorb(id t) vce(robust)
*https://scorreia.com/help/reghdfe.html

*d
macro drop _tuple*

local x_list x2 x3 x4 x5 x6 x7 x8

tuples `x_list', min(1) display
di `ntuples'

tempname output
postfile `output' str30 tuple beta1 beta2 using "output.dta", replace
forval i = 1/`ntuples' {
	qui reghdfe y x1 x2 `tuple`i'' , absorb(id t) vce(robust)
	post `output' ("`tuple`i''") (_b[x1]) (_b[x2])
}
postclose `output'



*e
*bysort id (t): gen time_trend = _n
***t is already time trend
reghdfe y x1 x2 x3 x6 x7 t, absorb(id) vce(robust)


*f
gen tsquared = t^2
reghdfe y x1 x2 x3 x6 x7 tsquared, absorb(id) vce(robust)


*d outputs
use "C:\Users\mfn23a\Downloads\output.dta"

gen b1_distance = abs(_b[x1] + 3)
gen b2_distance = abs(_b[x2] - 2)
minindex(b1_distance, 1, i, w)
minindex(b2_distance, 1, i, w)
