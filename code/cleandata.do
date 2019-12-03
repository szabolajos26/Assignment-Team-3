*Data from here:
*https://www.dropbox.com/sh/53tn729we5u8nwr/AACnifmIxqPo-_TcPP5vSP-Sa?dl=0


*** 1. Merge datasets within year ***

* create temp and derived folder if they don't exist
cap mkdir data/temp
cap mkdir data/derived

forvalues i = 1999/2007 {
	use "data/raw/SchoolData`i'.dta", clear
	merge 1:1 schoolcode using "data/raw/SchoolCensusData`i'.dta", generate(merge_census)
	if `i'!=2000 {
		merge 1:1 schoolcode using "data/raw/RestaurantData`i'.dta", generate(merge_restaurant)
	}

	save "data/temp/merged_`i'.dta", replace
}



*** 2. Create panel ***
use "data/temp/merged_1999.dta", clear
forvalues i = 2000/2007 {
	append using "data/temp/merged_`i'.dta"
}

*** 3. Labels ***
label variable ffood "fast food restaurant availability"
label variable afood "any restaurant availability"
label define ffood_label 1 "fast food restaurant within 0.1 miles"	2 "fast food restaurant 0.10-0.25 miles"	3 "fast food restaurant 0.25-0.50 miles"
label define afood_label 1 "any restaurant within 0.1 miles"		2 "any restaurant 0.10-0.25 miles"			3 "any restaurant 0.25-0.50 miles"
foreach var of varlist ffood afood {
	destring `var', replace
	label values `var' `var'_label
}

save "data/derived/obesitydata.dta", replace






