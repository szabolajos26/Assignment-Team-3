* Table 1A

tempfile temp
local n 0

* generate descriptives as a dataset, with collapse and append
foreach sample in "" "keep if inlist(ffoodlag,1,2,3)" "keep if inlist(ffoodlag,1,2)" "keep if inlist(ffoodlag,1)" {

	local ++n

	use "data/derived/obesitydata.dta", clear

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

* store table in a matrix
sort sample
mkmat schoolcode-fit9Obes, matrix(B)
matrix B=B'
matrix separator = J(2,4,.)
matrix B=B[1..2,1...] \ separator \ B[3..16,1...] \ separator \ B[17..23,1...] \ separator \ B[24..49,1...] \ separator \ B[50,1...]

* export the matrix into latex
frmttable using "output/table1a", statmat(B)	///
sdec(0\2 \0\0 \3\3\3\3\3\3\3\3\3\3\3\3\3\3 \0\0 \3\3\3\3\3\3\3 \0\0 \0\0\2\2\2\0\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3 \0\0 \3) ///
ctitles("All","$ < $ 0.5 miles FF","$ < $ 0.25 miles FF","$ < $ 0.1 miles FF") ///
rtitles("Number of school-year observations" \ 	"Number of students in ninth grade" \ "" \	"School characteristics" \ 	"School qualified for Title I funding" \ 	"Number of students" \ 	"Student teacher ratio " \ 	"Share black students" \ 	"Share Asian students" \ 	"Share Hispanic students" \ 	"Share Native American students" \ 	"Share immigrant students" \ 	"Share female students" \ 	"Share eligible for free lunch" \ 	"Share eligible for subsidised lunch" \ 	"FTE teachers per student" \ 	"Average test scores for ninth grade " \ 	"Test score information missing" \ 	"" \ "School district characteristics" \ 	"Student teacher ratio " \ 	"Share immigrant students" \ 	"Share non-English speaking (LEP/ELL) students" \ 	"Share IEP students" \ 	"Staff student ratio" \ 	"Share diploma recipients" \ 	"Share diploma recipients missing" \ "" \	"2000 Census Demographics of nearest block" \ 	"Median household income " \ 	"Median earnings " \ 	"Average household size" \ 	"Median contract rent for rental units" \ 	"Median gross rent for rentals units" \ 	"Median value for owner-occupied housing" \ 	"Share white" \ 	"Share black" \ 	"Share Asian" \ 	"Share male" \ 	"Share never married" \ 	"Share married" \ 	"Share divorced" \ 	"Share high school degree only" \ 	"Share some college" \ 	"Share Associate degree" \ 	"Share Bachelor’s degree" \ 	"Share graduate degree" \ 	"Share in labor force" \ 	"Share unemployed" \ 	"Share with household income $ < $ S10K" \ 	"Share with household income $ > $ S200K" \ 	"Share with wage or salary income" \ 	"Share of housing units occupied" \ 	"Share in owner-occupied units" \ 	"Share urban" \ "" \	"Outcome" \ 	"Percent obese students ") ///
tex replace





