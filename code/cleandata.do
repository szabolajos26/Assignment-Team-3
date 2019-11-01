*Data from here:
*https://www.dropbox.com/sh/53tn729we5u8nwr/AACnifmIxqPo-_TcPP5vSP-Sa?dl=0

* run this code from obesity/data


*** Merge datasets ***

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






* Create database
*forvalues i = 1999/1999 {
*import delimited "raw/PE data `i'.txt", clear
*save "derived/SchoolData`i'.dta", replace
*}

*forvalues i = 2001/2005 {
*import delimited  "raw/PE data `i'.txt", clear
*save "derived/SchoolData`i'.dta", replace
*}

*forvalues i = 2006/2006 {
*import delimited  "raw/PE Data `i'.txt", clear
*save "derived/SchoolData`i'.dta", replace
*}

*forvalues i = 2007/2007 {
*import delimited "raw/PE Data `i'.csv", clear
*save "derived/SchoolData`i'.dta", replace
*}



*forvalues i=2001/2007 {
*use  "derived/SchoolData`i'.dta", clear
*This helps to make a panel later on
*rename * *`i'
*rename schoolcode`i' schoolcode
*save "derived/SchoolData`i'.dta", replace
*destring schoolcode, replace force


*merge m:1 schoolcode using  "raw/revisedrestaurant_newJun08.dta", replace
*drop if _merge==2
*drop _merge

*merge m:1 schoolcode using "raw/restCensusContr2006.dta", replace
*drop if _merge==2
*drop _merge

*merge m:m schoolcode using "raw/SchoolData1999.dta", replace
*drop if _merge==2
*drop _merge


*label var ffood`i' "This is the label for ffood"

*label var afood`i' "This is the label for afood"


*save "derived/SchoolData`i'.dta", replace
*}


* Merging
*use "derived/SchoolData1999.dta", clear

*forvalues i=2001/2006{
*merge 1:1 id using "derived/SchoolData`i'.dta"
*drop if _merge==1
*drop _merge
 *}


*reshape long countyname	districtname	schoolname	reporttype	reportnumber ///
*tabletype	linenumberintable	countycode	districtcode	school	linetext ///
*grade5numberstudents	grade5percenthfz	grade5percentnonhfz	grade7numberstudents ///
*grade7percenthfz	grade7percentnonhfz	grade9percenthfz	grade9numberstudents ///
*grade9percenthfz	grade9percentnonhfz, i(schoolcode) j(year)




*Because the file is too big and we don't want to use it:
*keep in 1/50000





