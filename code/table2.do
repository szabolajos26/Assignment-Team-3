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


* Generate school controls and census block controls
local schoolvars rttitlei rtnostud rtpupiltc rtblack rtasian rthispanic rtindian rtmigrant rtfemale rtfreelcelig rtreducedlc rtfteteachers rttestsc9 rtdmtestsc9

local schooldistvars rtpupiltcds rtmigrantds rtlepellds rtiepds rtstaffds rtdiplomarecds rtdmdiplomarecds

local blockvars medhhinc medearn avghhsize medcontrent medgrossrent medvalue pctwhite pctblack pctasian pctmale pctnevermarried pctmarried pctdivorced pctHSdiponly pctsomecollege pctassociate pctbachelors pctgraddegree pctinlaborforce pctunemployed pctincunder10k pctincover200k pcthhwithwages pctoccupied pctpopownerocc pcturban


* Regressions

eststo clear
eststo: reg fit9Obes ffood_01 afood_01 ffood_25 afood_25 ffood_50 afood_50 [aw=no9Obes], cluster(schoolcode)
estadd local schoolfe "no"
estadd local yearfe "no"
estadd local schoolvars "no"
estadd local blockvars "no"
estadd scalar cumulative = _b[ffood_01] + _b[ffood_25] + _b[ffood_50]

eststo: reg fit9Obes ffood_01 afood_01 ffood_25 afood_25 ffood_50 afood_50 i.year `schoolvars' `blockvars' `schooldistvars' [aw=no9Obes], cluster(schoolcode)
estadd local schoolfe "no"
estadd local yearfe "yes"
estadd local schoolvars "yes"
estadd local blockvars "yes"
estadd scalar cumulative = _b[ffood_01] + _b[ffood_25] + _b[ffood_50]

eststo: areg fit9Obes ffood_01 afood_01 ffood_25 afood_25 ffood_50 afood_50 [aw=no9Obes], cluster(schoolcode) a(schoolcode)
estadd local schoolfe "yes"
estadd local yearfe "no"
estadd local schoolvars "no"
estadd local blockvars "no"
estadd scalar cumulative = _b[ffood_01] + _b[ffood_25] + _b[ffood_50]

eststo: areg fit9Obes ffood_01 afood_01 ffood_25 afood_25 ffood_50 afood_50 i.year `schoolvars' `blockvars' `schooldistvars' [aw=no9Obes], cluster(schoolcode) a(schoolcode)
estadd local schoolfe "yes"
estadd local yearfe "yes"
estadd local schoolvars "yes"
estadd local blockvars "yes"
estadd scalar cumulative = _b[ffood_01] + _b[ffood_25] + _b[ffood_50]

esttab using "output/tables/table2.tex", replace label s(schoolfe yearfe schoolvars blockvars cumulative N r2, label("School Fixed Effects" "Year fixed effects" "School controls" "Census block controls" "Implied cumulative effect of exposure to fast food restaurant within 0.1 miles" "N" "R-squared")) ar2 se noconstant star(* .10 ** .05 *** .01) b(a4) drop(*year `schoolvars' `blockvars' `schooldistvars')


