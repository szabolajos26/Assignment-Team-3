

* Table 1A
tempfile temp
local n 0

foreach sample in "" "keep if inlist(ffoodlag,1,2,3)" "keep if inlist(ffoodlag,1,2)" "keep if inlist(ffoodlag,1)" {

local ++n

use "derived/obesitydata.dta", clear

destring ffoodlag, replace
`sample'

collapse (count) ///
schoolcode ///
(mean) ///
no9Obes ///
rttitlei ///
rtnostud ///
rtpupiltc /// 
rtblack /// 
rtasian /// 
rthispanic /// 
rtindian /// 
rtmigrant /// 
rtfemale /// 
rtfreelcelig /// 
rtreducedlc /// 
rtfteteachers ///
rttestsc9 /// 
rtdmtestsc9 ///
rtpupiltcds ///
rtmigrantds ///
rtlepellds ///    
rtiepds ///     
rtstaffds ///
rtdiplomarecds ///
rtdmdiplomarecds ///
medhhinc ///
medearn	///
avghhsize ///
medcontrent	///
medgrossrent ///
medvalue ///
pctwhite ///
pctblack ///
pctasian ///
pctmale ///
pctnevermarried ///
pctmarried ///
pctdivorced	///
pctHSdiponly ///
pctsomecollege ///
pctassociate ///
pctbachelors ///
pctgraddegree ///
pctinlaborforce ///
pctunemployed ///
pctincunder10k ///
pctincover200k ///
pcthhwithwages ///
pctoccupied	///
pctpopownerocc ///
pcturban ///
fit9Obes	

gen sample=`n'
if `n'>=2 {
append using `temp'
}
save `temp', replace
}

sort sample
drop sample
xpose, clear varname
order _varname

label variable v1 "All"
label variable v2 "< 0.5 miles FF"
label variable v3 "< 0.25 miles FF"
label variable v4 "< 0.1 miles FF"

cap mkdir ../output
export excel using "../output/tables.xlsx", sheetmodify sheet("table_1a") firstrow(varlabels) keepcellfmt
   
