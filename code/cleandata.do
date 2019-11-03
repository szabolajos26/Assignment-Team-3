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

save "derived/obesitydata.dta", replace








