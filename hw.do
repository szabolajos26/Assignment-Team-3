*Data from here:
*https://www.aeaweb.org/articles?id=10.1257/pol.2.3.32

cd "C:\Irattár\ceu\2019ősz\Empirical_Research\obesity\data\raw\"

*foreach x in 200	{
forvalues i=1999/1999{
import delimited  "PE data `i'.txt", clear
*import delimited  PE_data_`i'.txt, clear
save SchoolData`i'.dta

}

forvalues i=2001/2006{
import delimited  "PE data `i'.txt", clear
*import delimited  PE_data_`i'.txt, clear
save SchoolData`i'.dta

}


foreach i in  2001	{
use  SchoolData`i'.dta
*This helps to make a panel later on
rename * *`i'
rename schoolcode`i' schoolcode
save SchoolData`i'.dta, replace
destring schoolcode, replace force


merge m:1 schoolcode using  revisedrestaurant_newJun08.dta
drop if _merge==2
drop _merge

merge m:1 schoolcode using restCensusContr2006.dta
drop if _merge==2
drop _merge

merge m:m schoolcode using SchoolData1999.dta
drop if _merge==2
drop _merge


label var ffood`i' "This is the label for ffood"

label var afood`i' "This is the label for afood"


save SchoolData`i'.dta, replace
}

*Merging:

use SchoolData1999.dta

forvalues i=2001/2006{
merge m:m schoolcode using SchoolData`i'.dta
drop if _merge==1
drop _merge
}


reshape long countyname	districtname	schoolname	reporttype	reportnumber ///
tabletype	linenumberintable	countycode	districtcode	school	linetext ///
grade5numberstudents	grade5percenthfz	grade5percentnonhfz	grade7numberstudents ///
grade7percenthfz	grade7percentnonhfz	grade9percenthfz	grade9numberstudents ///
grade9percenthfz	grade9percentnonhfz, i(schoolcode) j(year)




*Because the file is too big and we don't want to use it:
keep in 1/50000



}
*forvalues i=2001/2001{
*append using SchoolData`i'.dta
*}

