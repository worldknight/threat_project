//Testing Group Threat Through Hate Crime & Presidential Campaigns (OBAMA)
//PI: Ashley V. Reichelmann
//Researcher: Jonathan A. LLoyd
//Last Updated: February 22, 2022
//Code Written for STATA 17.0

//Dataset: Hate Crime Statistics, 1991-2020
//Notes: Dataset was modified in Excel using the "Date" function so that incident_date reads numerically rather than by string. For example, 31-Aug-91 becomes 08/31/91. This was to make data importation easier in STATA. This is the only change made.
//Notes: Consulted week-number.net for week of year.

//Data Importation and Time Setup
import delimited "F:\Research\Projects\Threat\datesupdatedhate_crime_FBI website.csv"
generate date = date(incident_date, "MDY")
format %tdMon_DD,_CCYY date
label variable date "incident date formatted"

*week in year
gen week = week(date)
gen year = year(date)
*year and week in year
gen weekyear = yw(year,w)
format weekyear %tw
*month in year
gen month = month(date)
gen monyear=ym(year,month)
format monyear %tm

*generating offense times overall
gen hatecrime = 1 if incident_id !=0
bys date: egen hcperday = sum(hatecrime)
bys weekyear: egen hcperweek = sum(hatecrime)
bys monyear: egen hcpermon = sum(hatecrime)


*Obama Dates
**Announcement: Feb 10, 2007, Week Six of 2007
di date("10feb2007", "DMY")
**Generates: 17207
gen afterobamaann = 1 if (date >= 17207)
replace afterobamaann = 0 if (date < 17207)
label variable afterobamaann "Obama Announcement"
label define afterobamaann 0 "No" 1 "Yes"
label values afterobamaann afterobamaann
**Weekly
gen weekafterobamaann = 1 if weekyear >= tw(2007w6)
replace weekafterobamaann = 0 if weekyear < tw(2007w6)
label values weekafterobamaann afterobamaann
**Monthly
gen monthafterobamaann = 1 if monyear >= tm(2007m2)
replace monthafterobamaann = 0 if monyear < tm(2007m2)
label values monthafterobamaann afterobamaann

**Presumptive Nominee: June 3, 2008, Week 23 of 2008
di date("03june2008", "DMY")
**Generates: 17686
gen afterobamapres = 1 if (date >= 17686)
replace afterobamapres = 0 if (date < 17686)
label variable afterobamapres "Obama Presumptive Nominee"
label define afterobamapres 0 "No" 1 "Yes"
label values afterobamapres afterobamapres
**Weekly
gen weekafterobamapres = 1 if weekyear >= tw(2008w23)
replace weekafterobamapres = 0 if weekyear < tw(2008w23)
label values weekafterobamapres afterobamapres
**Monthly
gen monthafterobamapres = 1 if monyear >= tm(2008m6)
replace monthafterobamapres = 0 if monyear < tm(2008m6)
label values monthafterobamapres afterobamapres


**Nominated: August 27, 2008, Week 35 of 2008
di date("27aug2008", "DMY")
**Generates: 17771
gen afterobamanom = 1 if (date >= 17771)
replace afterobamanom = 0 if (date < 17771)
label variable afterobamanom "Obama Nominated"
label define afterobamanom 0 "No" 1 "Yes"
label values afterobamanom afterobamanom
**Weekly
gen weekafterobamanom = 1 if weekyear >= tw(2008w35)
replace weekafterobamanom = 0 if weekyear < tw(2008w35)
label values weekafterobamanom afterobamanom
**Monthly
gen monthafterobamanom = 1 if monyear >= tm(2008m8)
replace monthafterobamanom = 0 if monyear < tm(2008m8)
label values monthafterobamanom afterobamanom

**Won Election: Nov. 4, 2008, Week 45 of 2008
di date("04nov2008", "DMY")
**Generates: 17840
gen afterobamaelec = 1 if (date >=17840)
replace afterobamaelec = 0 if (date < 17840)
label variable afterobamaelec "Obama Won Election"
label define afterobamaelec 0 "No" 1 "Yes"
label values afterobamaelec afterobamaelec
**Weekly
gen weekafterobamaelec = 1 if weekyear >= tw(2008w45)
replace weekafterobamaelec = 0 if weekyear < tw(2008w45)
label values weekafterobamaelec afterobamaelec
**Monthly
gen monthafterobamaelec = 1 if monyear >= tm(2008m11)
replace monthafterobamaelec = 0 if monyear < tm(2008m11)
label values monthafterobamaelec afterobamaelec

**Inaguration: Jan. 20, 2009, Week 4 of 2009
di date("20jan2009", "DMY")
**Generates: 17917
gen afterobamainag = 1 if (date >= 17917)
replace afterobamainag = 0 if (date < 17917)
label variable afterobamainag "Obama Inaugurated"
label define afterobamainag 0 "No" 1 "Yes"
label values afterobamainag afterobamainag
**Weekly
gen weekafterobamainag = 1 if weekyear >= tw(2009w4)
replace weekafterobamainag = 0 if weekyear < tw(2009w4)
label values weekafterobamainag afterobamainag
**Monthly
gen monthafterobamainag = 1 if monyear >= tm(2009m1)
replace monthafterobamainag = 0 if monyear < tm(2009m1)
label values monthafterobamainag afterobamainag

//Recoding Offense Types
encode bias_desc, gen(bias)
numlabel, add
labelbook bias

*Anti-Black or African-American
gen antiblack = 0
replace antiblack = 1 if (bias >=3) & (bias <=4)
replace antiblack = 1 if (bias >=12) & (bias <=16)
replace antiblack = 1 if (bias >=31) & (bias <=39)
replace antiblack = 1 if (bias == 56)
replace antiblack = 1 if (bias >=62) & (bias <=118)
replace antiblack = . if (bias == 279)
label variable antiblack "anti-black or african-american incident"
label define antiblack 0 "Other Bias" 1 "Anti-Black or African-American"
label values antiblack antiblack

** Converting incident level data to crimes per week
bys date: egen numblackdate = sum(antiblack)
bys weekyear: egen numblackweek = sum(antiblack)
bys monyear: egen numblackmon = sum(antiblack)

*Anti-Islamic
gen antiislam = 0
replace antiislam = 1 if (bias ==6)
replace antiislam = 1 if (bias ==16)
replace antiislam = 1 if (bias ==19)
replace antiislam = 1 if (bias >=21) & (bias <=24)
replace antiislam = 1 if (bias ==37)
replace antiislam = 1 if (bias ==45)
replace antiislam = 1 if (bias >=72) & (bias <=73)
replace antiislam = 1 if (bias ==84)
replace antiislam = 1 if (bias >=88) & (bias<=90)
replace antiislam = 1 if (bias == 150)
replace antiislam = 1 if (bias == 174)
replace antiislam = 1 if (bias ==179)
replace antiislam = 1 if (bias ==182)
replace antiislam = 1 if (bias >=195) & (bias <=203)
replace antiislam = . if (bias == 279)
label variable antiislam "anti-Islamic (Muslim)"
label define antiislam 0 "Other Bias" 1 "Anti-Islamic (Muslim)"
label values antiislam antiislam

** Converting incident level data to crimes per week
bys date: egen numislamdate = sum(antiislam)
bys weekyear: egen numislamweek = sum(antiislam)
bys monyear: egen numislammon = sum(antiislam)

*Anti-Jewish
gen antijewish = .
replace antijewish = 1 if (bias ==4)
replace antijewish = 1 if (bias == 15)
replace antijewish = 1 if (bias ==22)
replace antijewish = 1 if (bias ==25)
replace antijewish = 1 if (bias ==42)
replace antijewish = 1 if (bias ==46)
replace antijewish = 1 if (bias ==60)
replace antijewish = 1 if (bias == 70)
replace antijewish = 1 if (bias >=73) & (bias <=75)
replace antijewish = 1 if (bias ==81)
replace antijewish = 1 if (bias ==85)
replace antijewish = 1 if (bias ==89)
replace antijewish = 1 if (bias >=91) & (bias <=98)
replace antijewish = 1 if (bias ==123)
replace antijewish = 1 if (bias == 131)
replace antijewish = 1 if (bias >=151) & (bias <=154)
replace antijewish = 1 if (bias ==168)
replace antijewish = 1 if (bias ==183)
replace antijewish = 1 if (bias >=196) & (bias <=197)
replace antijewish = 1 if (bias >=206) & (bias <=223)
replace antijewish = . if (bias == 279)
label variable antijewish "anti-jewish"
label define antijewish 0 "Other Bias" 1 "Anti-Jewish"
label values antijewish antijewish

** Converting incident level data to crimes per week
bys date: egen numjewishdate = sum(antijewish)
bys weekyear: egen numjewishweek = sum(antijewish)
bys monyear: egen numjewishmon = sum(antijewish)


*Anti-Hispanic or Latino
gen antihispanic = .
replace antihispanic = 1 if (bias >=4) & (bias <=5)
replace antihispanic = 1 if (bias >=14) & (bias <=15)
replace antihispanic = 1 if (bias >=18) & (bias <=20)
replace antihispanic = 1 if (bias ==32)
replace antihispanic = 1 if (bias ==36)
replace antihispanic = 1 if (bias ==44)
replace antihispanic = 1 if (bias >=69) & (bias <=71)
replace antihispanic = 1 if (bias >=83) & (bias <=87)
replace antihispanic = 1 if (bias ==122)
replace antihispanic = 1 if (bias == 132)
replace antihispanic = 1 if (bias >=148) & (bias <=149)
replace antihispanic = 1 if (bias >=181) & (bias <=194)
replace antihispanic = . if (bias == 279)
label variable antihispanic "anti-hispanic or latino"
label define antihispanic 0 "Other Bias" 1 "Anti-hispanic or latino"
label values antihispanic antihispanic

** Converting incident level data to crimes per week
bys date: egen numhispanicdate = sum(antihispanic)
bys weekyear: egen numhispanicweek = sum(antihispanic)
bys monyear: egen numhispanicmon = sum(antihispanic)


//Tests: Obama
//2006-2011

*Duplicate Deletes
//Note: Only run by time period, clear, and then run again.
//e.g. drop duplicates for monyear, run monthly HC analyses, clear STATA, and reload before dropping for weekyear, and then repeat
//If I find a way to loop STATA commands, I'll rewrite this section -JL

duplicates drop monyear, force

duplicates drop weekyear, force

duplicates drop date, force

*Line Tests
**NOTE: Ignoring for the moment
line numblackmon hcpermon monyear if monyear > = tm(2006m1) & monyear <tm(2011m1)
line numblackmon hcpermon monyear if monyear > = tm(2007m1) & monyear <tm(2009m3)

line numblackweek hcperweek weekyear if weekyear > = tw(2006w1) & weekyear <tw(2011w1)
line numblackweek hcperweek weekyear if weekyear > = tw(2007w1) & weekyear <tw(2009w12)

line numblackdate date if date > = 16802 & date <18628
line numblackdate date if date > = 17100 & date <18000

line numislammon hcpermon monyear if monyear > = tm(2006m1) & monyear <tm(2011m1)
line numislammon hcpermon monyear if monyear > = tm(2007m1) & monyear <tm(2009m3)

line numislamweek hcperweek weekyear if weekyear > = tw(2006w1) & weekyear <tw(2011w1)
line numislamweek hcperweek weekyear if weekyear > = tw(2007w1) & weekyear <tw(2009w12)

line numislamdate date if date > = 16802 & date <18628
line numislamdate date if date > = 17100 & date <18000

line numjewishmon hcpermon monyear if monyear > = tm(2006m1) & monyear <tm(2011m1)
line numjewishmon hcpermon monyear if monyear > = tm(2007m1) & monyear <tm(2009m3)

line numjewishweek hcperweek weekyear if weekyear > = tw(2006w1) & weekyear <tw(2011w1)
line numjewishweek hcperweek weekyear if weekyear > = tw(2007w1) & weekyear <tw(2009w12)

line numjewishdate date if date > = 16802 & date <18628
line numjewishdate date if date > = 17100 & date <18000

*Overall Hate Crime (Monthly)
regress hcpermon monthafterobamaann  if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
regress hcpermon monthafterobamapres  if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
regress hcpermon monthafterobamanom  if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
regress hcpermon monthafterobamaelec  if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
regress hcpermon monthafterobamainag  if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

*Overall Hate Crime (Weekly)
regress hcperweek weekafterobamaann  if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
regress hcperweek weekafterobamapres  if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
regress hcperweek weekafterobamanom  if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
regress hcperweek weekafterobamaelec  if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
regress hcperweek weekafterobamainag  if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

*Overall Hate Crime (Daily)
regress hcperday afterobamaann  if date > = 16802 & date <18628, vce(robust)
regress hcperday afterobamapres  if date > = 16802 & date <18628, vce(robust)
regress hcperday afterobamanom  if date > = 16802 & date <18628, vce(robust)
regress hcperday afterobamaelec  if date > = 16802 & date <18628, vce(robust)
regress hcperday afterobamainag  if date > = 16802 & date <18628, vce(robust)

*Anti-Black Hate Crime (Monthly)
reg numblackmon monthafterobamaann hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numblackmon monthafterobamaann##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numblackmon monthafterobamapres hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numblackmon monthafterobamapres##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numblackmon monthafterobamanom hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numblackmon monthafterobamanom##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numblackmon monthafterobamaelec hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numblackmon monthafterobamaelec##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numblackmon monthafterobamainag hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numblackmon monthafterobamainag##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)


*Anti-Black Hate Crime (Weekly)
reg numblackweek weekafterobamaann hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numblackweek weekafterobamaann##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numblackweek weekafterobamapres hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numblackweek weekafterobamapres##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numblackweek weekafterobamanom hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numblackweek weekafterobamanom##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numblackweek weekafterobamaelec hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numblackweek weekafterobamaelec##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numblackweek weekafterobamainag hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numblackweek weekafterobamainag##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

*Anti-Black Hate Crime (Daily)
reg numblackdate afterobamaann hcperday if date > = 16802 & date <18628, vce(robust)
reg numblackdate afterobamaann##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numblackdate afterobamapres hcperday if date > = 16802 & date <18628, vce(robust)
reg numblackdate afterobamapres##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numblackdate afterobamanom hcperday if date > = 16802 & date <18628, vce(robust)
reg numblackdate afterobamanom##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numblackdate afterobamaelec hcperday if date > = 16802 & date <18628, vce(robust)
reg numblackdate afterobamaelec##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numblackdate afterobamainag hcperday if date > = 16802 & date <18628, vce(robust)
reg numblackdate afterobamainag##c.hcperday if date > = 16802 & date <18628, vce(robust)

**Anti-Islam Hate Crime (Monthly)
reg numislammon monthafterobamaann hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numislammon monthafterobamaann##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numislammon monthafterobamapres hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numislammon monthafterobamapres##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numislammon monthafterobamanom hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numislammon monthafterobamanom##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numislammon monthafterobamaelec hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numislammon monthafterobamaelec##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numislammon monthafterobamainag hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numislammon monthafterobamainag##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)



**Anti-Islam Hate Crime (Weekly)
reg numislamweek weekafterobamaann hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numislamweek weekafterobamaann##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numislamweek weekafterobamapres hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numislamweek weekafterobamapres##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numislamweek weekafterobamanom hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numislamweek weekafterobamanom##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numislamweek weekafterobamaelec hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numislamweek weekafterobamaelec##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numislamweek weekafterobamainag hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numislamweek weekafterobamainag##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

**Anti-Islam Hate Crime (Daily)
reg numislamdate afterobamaann hcperday if date > = 16802 & date <18628, vce(robust)
reg numislamdate afterobamaann##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numislamdate afterobamapres hcperday if date > = 16802 & date <18628, vce(robust)
reg numislamdate afterobamapres##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numislamdate afterobamanom hcperday if date > = 16802 & date <18628, vce(robust)
reg numislamdate afterobamanom##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numislamdate afterobamaelec hcperday if date > = 16802 & date <18628, vce(robust)
reg numislamdate afterobamaelec##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numislamdate afterobamainag hcperday if date > = 16802 & date <18628, vce(robust)
reg numislamdate afterobamainag##c.hcperday if date > = 16802 & date <18628, vce(robust)

**Anti-Jewish Hate Crime (Monthly)
reg numjewishmon monthafterobamaann hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numjewishmon monthafterobamaann##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numjewishmon monthafterobamapres hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numjewishmon monthafterobamapres##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numjewishmon monthafterobamanom hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numjewishmon monthafterobamanom##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numjewishmon monthafterobamaelec hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numjewishmon monthafterobamaelec##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numjewishmon monthafterobamainag hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numjewishmon monthafterobamainag##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)


**Anti-Jewish Hate Crime (Weekly)
reg numjewishweek weekafterobamaann hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numjewishweek weekafterobamaann##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numjewishweek weekafterobamapres hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numjewishweek weekafterobamapres##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numjewishweek weekafterobamanom hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numjewishweek weekafterobamanom##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numjewishweek weekafterobamaelec hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numjewishweek weekafterobamaelec##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numjewishweek weekafterobamainag hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numjewishweek weekafterobamainag##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

**Anti-Jewish Hate Crime (Daily)
reg numjewishdate afterobamaann hcperday if date > = 16802 & date <18628, vce(robust)
reg numjewishdate afterobamaann##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numjewishdate afterobamapres hcperday if date > = 16802 & date <18628, vce(robust)
reg numjewishdate afterobamapres##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numjewishdate afterobamanom hcperday if date > = 16802 & date <18628, vce(robust)
reg numjewishdate afterobamanom##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numjewishdate afterobamaelec hcperday if date > = 16802 & date <18628, vce(robust)
reg numjewishdate afterobamaelec##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numjewishdate afterobamainag hcperday if date > = 16802 & date <18628, vce(robust)
reg numjewishdate afterobamainag##c.hcperday if date > = 16802 & date <18628, vce(robust)

**Anti-Hispanic or Latino Hate Crime (Monthly)
reg numhispanicmon monthafterobamaann hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numhispanicmon monthafterobamaann##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numhispanicmon monthafterobamapres hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numhispanicmon monthafterobamapres##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numhispanicmon monthafterobamanom hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numhispanicmon monthafterobamanom##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numhispanicmon monthafterobamaelec hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numhispanicmon monthafterobamaelec##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numhispanicmon monthafterobamainag hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numhispanicmon monthafterobamainag##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)


**Anti-Hispanic or Latino Hate Crime (Weekly)
reg numhispanicweek weekafterobamaann hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numhispanicweek weekafterobamaann##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numhispanicweek weekafterobamapres hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numhispanicweek weekafterobamapres##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numhispanicweek weekafterobamanom hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numhispanicweek weekafterobamanom##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numhispanicweek weekafterobamaelec hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numhispanicweek weekafterobamaelec##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numhispanicweek weekafterobamainag hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numhispanicweek weekafterobamainag##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

**Anti-Hispanic or Latino Hate Crime (Daily)
reg numhispanicdate afterobamaann hcperday if date > = 16802 & date <18628, vce(robust)
reg numhispanicdate afterobamaann##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numhispanicdate afterobamapres hcperday if date > = 16802 & date <18628, vce(robust)
reg numhispanicdate afterobamapres##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numhispanicdate afterobamanom hcperday if date > = 16802 & date <18628, vce(robust)
reg numhispanicdate afterobamanom##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numhispanicdate afterobamaelec hcperday if date > = 16802 & date <18628, vce(robust)
reg numhispanicdate afterobamaelec##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numhispanicdate afterobamainag hcperday if date > = 16802 & date <18628, vce(robust)
reg numhispanicdate afterobamainag##c.hcperday if date > = 16802 & date <18628, vce(robust)
