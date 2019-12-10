*** Table 2 ***

*cd "C:\Irattár\ceu\2019ősz\Empirical_Research\obesity\data\derived"

*use "finaldata.dta"

use "data/derived/obesitydata.dta", clear
cap mkdir "output/tables"
cap mkdir "output/figures"

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


* Regressions:
local schoolvar "rtnostud rtpupiltc rtpupiltcds rtblack rtindian rtasian rthispanic rtmigrant rtfemale rtfreelcelig rtreducedlc rtfteteachers rtmigrantds rtlepellds rtiepds rtstaffds rtdiplomarecds rttestsc9 rtdmdiplomarecds rtdmtestsc9"
local blockvar "medhhinc medearn avghhsize medcontrent medgrossrent medvalue pctwhite pctblack pctasian pctmale pctnevermarried pctmarried pctdivorced pctHSdiponly pctsomecollege pctassociate pctbachelors pctgraddegree pctinlaborforce pctunemployed pctincunder10k pctincover200k pcthhwithwages pcturban pctoccupied pctpopownerocc"

quietly eststo Equation1: reg fit9Obes ffood_01 afood_01 ffood_25 afood_25  ffood_50 afood_50 [aw=no9Obes], cluster(schoolcode)
quietly eststo Equation2: reg fit9Obes ffood_01 afood_01 ffood_25 afood_25  ffood_50 afood_50 `schoolvar' `blockvar' ///
  [aw=no9Obes], cluster(schoolcode)

*Two type of graphs:
  
 coefplot Equation1 Equation2, drop( afood_01 afood_25   afood_50  _cons `schoolvar' `blockvar') ///
  coeflabels(ffood_01="0.1" ffood_25="0.25" ffood_50="0.5") vertical  msymbol(d) mfcolor(white) levels(99.9 99 95)  ///
xtitle(Distance from fast food restaurant (in miles)) ytitle(Estimated change in % obesity among ninth graders) recast(connected) 
graph export "output/figures/figure1A.png", replace

 
coefplot (Equation1, drop(afood_01 afood_25   afood_50  _cons)) ///
(Equation2, drop( afood_01 afood_25   afood_50  _cons `schoolvar' `blockvar')), ///
  coeflabels(ffood_01="0.1" ffood_25="0.25" ffood_50="0.5") vertical ///
xtitle(Distance from fast food restaurant (in miles)) ytitle(Estimated change in % obesity among ninth graders) recast(connected)
graph export "output/figures/figure1A_b.png", replace


/*
coefplot, drop( afood_01 afood_25   afood_50  _cons) xline(2) coeflabels(ffood_01="0.1" ffood_25="0.25" ffood_50="0.5") vertical ///
xtitle(Distance from fast food restaurant (in miles)) ytitle(Estimated change in % obesity among ninth graders) recast(connected)








reg fit9Obes ffood_01 afood_01 ffood_25 afood_25 ffood_50 afood_50  [aw=no9Obes], cluster(schoolcode)
