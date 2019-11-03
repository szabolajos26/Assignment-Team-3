*Data from here:
*https://www.dropbox.com/sh/53tn729we5u8nwr/AACnifmIxqPo-_TcPP5vSP-Sa?dl=0

* run this code from obesity/data


*** Merge datasets ***

* create temp and derived folder if they don't exist
cap mkdir temp
cap mkdir derived

* School data
use "raw/SchoolData1999.dta", clear
forval i = 2000/2007 {
	merge 1:1 schoolcode using "raw/SchoolData`i'.dta"
	rename _merge merge_school_`i'
}
save "temp/SchoolData.dta", replace

* Restaurant data
use "raw/RestaurantData1999", clear
forval i = 2001/2007 {
	merge 1:1 schoolcode using "raw/RestaurantData`i'.dta"
	rename _merge merge_restaurant_`i'
}
save "temp/RestaurantData.dta", replace

* School census
use "raw/SchoolCensusData1999.dta", clear
forval i = 2000/2007 {
	merge 1:1 schoolcode using "raw/SchoolCensusData`i'.dta"
	rename _merge merge_census_`i'
}
save "temp/SchoolCensusData.dta", replace



* Merge the 3 datasets
	/* Note: schoolcode is unique each year so we can merge only on schoolcode */
merge 1:1 schoolcode using "temp/RestaurantData.dta"
rename _merge merge_census_restaurant
merge 1:1 schoolcode using "temp/SchoolData.dta"
rename _merge merge_final




*** Labels ***

label variable ffood "fast food restaurant availability"
label variable afood "any restaurant availability"
label define ffood_label 1 "fast food restaurant within 0.1 miles"	2 "fast food restaurant 0.10-0.25 miles"	3 "fast food restaurant 0.25-0.50 miles"
label define afood_label 1 "any restaurant within 0.1 miles"		2 "any restaurant 0.10-0.25 miles"			3 "any restaurant 0.25-0.50 miles"
label values ffood ffood_label
label values afood afood_label

save "derived/obesitydata.dta", replace




