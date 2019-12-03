*** Table 2 ***

use "data/derived/obesitydata.dta", clear
cap mkdir "output/tables"

* Generate availability of restaurants variables 
foreach var in ffood afood {
	gen `var'_01 = `var' == 1
	gen `var'_25 = `var'_01 == 1 | `var' == 2
	gen `var'_50 = `var'_25 == 1 | `var' == 3	
}

lab var ffood_01 "Availability of fast food restaurant within 0.1 miles"
lab var ffood_25 "Availability of fast food restaurant within 0.25 miles"
lab var ffood_50 "Availability of fast food restaurant within 0.5 miles"
lab var afood_01 "Availability of any restaurant within 0.1 miles"
lab var afood_25 "Availability of any restaurant within 0.25 miles"
lab var afood_50 "Availability of any restaurant within 0.50 miles"


* Regressions
reg fit9Obes ffood_01 afood_01 ffood_25 afood_25 ffood_50 afood_50 [aw=no9Obes], cluster(schoolcode)
outreg2 using "output/tables/table2.tex", replace
