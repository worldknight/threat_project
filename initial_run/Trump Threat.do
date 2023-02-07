//Testing Group Threat Through Hate Crime & Presidential Campaigns (TRUMP)
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


*Trump Dates
**Announcement: June 16, 2015, Week 25 of 2015
di date("16june2015", "DMY")
**Generates: 20255
gen aftertrumpann = 1 if (date >= 20255)
replace aftertrumpann = 0 if (date < 20255)
label variable aftertrumpann "Trump Announcement"
label define aftertrumpann 0 "No" 1 "Yes"
label values aftertrumpann aftertrumpann
**Weekly
gen weekaftertrumpann = 1 if weekyear >= tw(2015w25)
replace weekaftertrumpann = 0 if weekyear < tw(2015w25)
label values weekaftertrumpann aftertrumpann
**Monthly
gen monthaftertrumpann = 1 if monyear >= tm(2015m6)
replace monthaftertrumpann = 0 if monyear < tm(2015m6)
label values monthaftertrumpann aftertrumpann

**Presumptive Nominee: May 4, 2016, Week 18 of 2016
di date("04may2016", "DMY")
**Generates: 20578
gen aftertrumppres = 1 if (date >= 20578)
replace aftertrumppres = 0 if (date < 20578)
label variable aftertrumppres "Trump Presumptive Nominee"
label define aftertrumppres 0 "No" 1 "Yes"
label values aftertrumppres aftertrumppres
**Weekly
gen weekaftertrumppres = 1 if weekyear >= tw(2016w18)
replace weekaftertrumppres = 0 if weekyear < tw(2016w18)
label values weekaftertrumppres aftertrumppres
**Monthly
gen monthaftertrumppres = 1 if monyear >= tm(2016m5)
replace monthaftertrumppres = 0 if monyear < tm(2016m5)
label values monthaftertrumppres aftertrumppres

**Nominated: July 19, 2016, Week 29 of 2016
di date("19july2016", "DMY")
**Generates: 20654
gen aftertrumpnom = 1 if (date >= 20654)
replace aftertrumpnom = 0 if (date < 20654)
label variable aftertrumpnom "Trump Nominated"
label define aftertrumpnom 0 "No" 1 "Yes"
label values aftertrumpnom aftertrumpnom
**Weekly
gen weekaftertrumpnom = 1 if weekyear >= tw(2016w29)
replace weekaftertrumpnom = 0 if weekyear < tw(2016w29)
label values weekaftertrumpnom aftertrumpnom
**Monthly
gen monthaftertrumpnom = 1 if monyear >= tm(2016m7)
replace monthaftertrumpnom = 0 if monyear < tm(2016m7)
label values monthaftertrumpnom aftertrumpnom

**Won Election: Nov. 9, 2016, Week 45 of 2016
di date("09nov2016", "DMY")
**Generates: 20767
gen aftertrumpelec = 1 if (date >= 20767)
replace aftertrumpelec = 0 if (date < 20767)
label variable aftertrumpelec "Trump Won Election"
label define aftertrumpelec 0 "No" 1 "Yes"
label values aftertrumpelec aftertrumpelec
**Weekly
gen weekaftertrumpelec = 1 if weekyear >= tw(2016w45)
replace weekaftertrumpelec = 0 if weekyear < tw(2016w45)
label values weekaftertrumpelec aftertrumpelec
**Monthly
gen monthaftertrumpelec = 1 if monyear >= tm(2016m11)
replace monthaftertrumpelec = 0 if monyear < tm(2016m11)
label values monthaftertrumpelec aftertrumpelec

**Inaguration: Jan. 20, 2017, Week 3 of 2017
di date("20jan2017", "DMY")
**Generates: 20839
gen aftertrumpinag = 1 if (date >= 20839)
replace aftertrumpinag = 0 if (date < 20839)
label variable aftertrumpinag "Trump Inaugurated"
label define aftertrumpinag 0 "No" 1 "Yes"
label values aftertrumpinag aftertrumpinag
**Weekly
gen weekaftertrumpinag = 1 if weekyear >= tw(2017w3)
replace weekaftertrumpinag = 0 if weekyear < tw(2017w3)
label values weekaftertrumpinag aftertrumpinag
**Monthly
gen monthaftertrumpinag = 1 if monyear >= tm(2017m1)
replace monthaftertrumpinag = 0 if monyear < tm(2017m1)
label values monthaftertrumpinag aftertrumpinag

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

//Tests: Trump
//2014-2019

*Duplicate Deletes
//Note: Only run by time period, clear, and then run again.
//e.g. drop duplicates for monyear, run monthly HC analyses, clear STATA, and reload before dropping for weekyear, and then repeat
//If I find a way to loop STATA commands, I'll rewrite this section -JL
duplicates drop weekyear, force
duplicates drop monyear, force
duplicates drop date, force

*Overall Hate Crime (Monthly)
regress hcpermon monthaftertrumpann if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
regress hcpermon monthaftertrumppres if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
regress hcpermon monthaftertrumpnom if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
regress hcpermon monthaftertrumpelec if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
regress hcpermon monthaftertrumpinag if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)

*Overall Hate Crime (Weekly)
regress hcperweek weekaftertrumpann  if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
regress hcperweek weekaftertrumppres if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
regress hcperweek weekaftertrumpnom if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
regress hcperweek weekaftertrumpelec  if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
regress hcperweek weekaftertrumpinag  if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

*Overall Hate Crime (Daily)
regress hcperday aftertrumpann  if date > = 19724 & date <21550, vce(robust)
regress hcperday aftertrumppres  if date > = 19724 & date <21550, vce(robust)
regress hcperday aftertrumpnom  if date > = 19724 & date <21550, vce(robust)
regress hcperday aftertrumpelec  if date > = 19724 & date <21550, vce(robust)
regress hcperday aftertrumpinag  if date > = 19724 & date <21550, vce(robust)

*Anti-Black Hate Crime (Monthly)
reg numblackmon monthaftertrumpann hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numblackmon monthaftertrumpann##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)

reg numblackmon monthaftertrumppres hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numblackmon monthaftertrumppres##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)

reg numblackmon monthaftertrumpnom hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numblackmon monthaftertrumpnom##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)

reg numblackmon monthaftertrumpelec hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numblackmon monthaftertrumpelec##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)

reg numblackmon monthaftertrumpinag hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numblackmon monthaftertrumpinag##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)



*Anti-Black Hate Crime (Weekly)
reg numblackweek weekaftertrumpann hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numblackweek weekaftertrumpann##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

reg numblackweek weekaftertrumppres hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numblackweek weekaftertrumppres##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

reg numblackweek weekaftertrumpnom hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numblackweek weekaftertrumpnom##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

reg numblackweek weekaftertrumpelec hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numblackweek weekaftertrumpelec##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

reg numblackweek weekaftertrumpinag hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numblackweek weekaftertrumpinag##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

*Anti-Black Hate Crime (Daily)
reg numblackdate aftertrumpann hcperday if date > = 19724 & date <21550, vce(robust)
reg numblackdate aftertrumpann##c.hcperday if date > = 19724 & date <21550, vce(robust)

reg numblackdate aftertrumppres hcperday if date > = 19724 & date <21550, vce(robust)
reg numblackdate aftertrumppres##c.hcperday if date > = 19724 & date <21550, vce(robust)

reg numblackdate aftertrumpnom hcperday if date > = 19724 & date <21550, vce(robust)
reg numblackdate aftertrumpnom##c.hcperday if date > = 19724 & date <21550, vce(robust)

reg numblackdate aftertrumpelec hcperday if date > = 19724 & date <21550, vce(robust)
reg numblackdate aftertrumpelec##c.hcperday if date > = 19724 & date <21550, vce(robust)

reg numblackdate aftertrumpinag hcperday if date > = 19724 & date <21550, vce(robust)
reg numblackdate aftertrumpinag##c.hcperday if date > = 19724 & date <21550, vce(robust)

**Anti-Islam Hate Crime (Monthly)
reg numislammon monthaftertrumpann hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numislammon monthaftertrumpann##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)

reg numislammon monthaftertrumppres hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numislammon monthaftertrumppres##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)

reg numislammon monthaftertrumpnom hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numislammon monthaftertrumpnom##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)

reg numislammon monthaftertrumpelec hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numislammon monthaftertrumpelec##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)

reg numislammon monthaftertrumpinag hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numislammon monthaftertrumpinag##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)


**Anti-Islam Hate Crime (Weekly)
reg numislamweek weekaftertrumpann hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numislamweek weekaftertrumpann##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

reg numislamweek weekaftertrumppres hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numislamweek weekaftertrumppres##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

reg numislamweek weekaftertrumpnom hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numislamweek weekaftertrumpnom##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

reg numislamweek weekaftertrumpelec hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numislamweek weekaftertrumpelec##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

reg numislamweek weekaftertrumpinag hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numislamweek weekaftertrumpinag##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

**Anti-Islam Hate Crime (Daily)
reg numislamdate aftertrumpann hcperday if date > = 19724 & date <21550, vce(robust)
reg numislamdate aftertrumpann##c.hcperday if date > = 19724 & date <21550, vce(robust)

reg numislamdate aftertrumppres hcperday if date > = 19724 & date <21550, vce(robust)
reg numislamdate aftertrumppres##c.hcperday if date > = 19724 & date <21550, vce(robust)

reg numislamdate aftertrumpnom hcperday if date > = 19724 & date <21550, vce(robust)
reg numislamdate aftertrumpnom##c.hcperday if date > = 19724 & date <21550, vce(robust)

reg numislamdate aftertrumpelec hcperday if date > = 19724 & date <21550, vce(robust)
reg numislamdate aftertrumpelec##c.hcperday if date > = 19724 & date <21550, vce(robust)

reg numislamdate aftertrumpinag hcperday if date > = 19724 & date <21550, vce(robust)
reg numislamdate aftertrumpinag##c.hcperday if date > = 19724 & date <21550, vce(robust)

**Anti-Jewish Hate Crime (Monthly)
reg numjewishmon monthaftertrumpann hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numjewishmon monthaftertrumpann##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)

reg numjewishmon monthaftertrumppres hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numjewishmon monthaftertrumppres##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)

reg numjewishmon monthaftertrumpnom hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numjewishmon monthaftertrumpnom##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)

reg numjewishmon monthaftertrumpelec hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numjewishmon monthaftertrumpelec##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)

reg numjewishmon monthaftertrumpinag hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numjewishmon monthaftertrumpinag##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)


**Anti-Jewish Hate Crime (Weekly)
reg numjewishweek weekaftertrumpann hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numjewishweek weekaftertrumpann##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

reg numjewishweek weekaftertrumppres hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numjewishweek weekaftertrumppres##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

reg numjewishweek weekaftertrumpnom hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numjewishweek weekaftertrumpnom##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

reg numjewishweek weekaftertrumpelec hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numjewishweek weekaftertrumpelec##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

reg numjewishweek weekaftertrumpinag hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numjewishweek weekaftertrumpinag##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

**Anti-Jewish Hate Crime (Daily)
reg numjewishdate aftertrumpann hcperday if date > = 19724 & date <21550, vce(robust)
reg numjewishdate aftertrumpann##c.hcperday if date > = 19724 & date <21550, vce(robust)

reg numjewishdate aftertrumppres hcperday if date > = 19724 & date <21550, vce(robust)
reg numjewishdate aftertrumppres##c.hcperday if date > = 19724 & date <21550, vce(robust)

reg numjewishdate aftertrumpnom hcperday if date > = 19724 & date <21550, vce(robust)
reg numjewishdate aftertrumpnom##c.hcperday if date > = 19724 & date <21550, vce(robust)

reg numjewishdate aftertrumpelec hcperday if date > = 19724 & date <21550, vce(robust)
reg numjewishdate aftertrumpelec##c.hcperday if date > = 19724 & date <21550, vce(robust)

reg numjewishdate aftertrumpinag hcperday if date > = 19724 & date <21550, vce(robust)
reg numjewishdate aftertrumpinag##c.hcperday if date > = 19724 & date <21550, vce(robust)


**Anti-Hispanic or Latino Hate Crime (Monthly)
reg numhispanicmon monthaftertrumpann hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numhispanicmon monthaftertrumpann##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)

reg numhispanicmon monthaftertrumppres hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numhispanicmon monthaftertrumppres##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)

reg numhispanicmon monthaftertrumpnom hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numhispanicmon monthaftertrumpnom##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)

reg numhispanicmon monthaftertrumpelec hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numhispanicmon monthaftertrumpelec##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)

reg numhispanicmon monthaftertrumpinag hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)
reg numhispanicmon monthaftertrumpinag##c.hcpermon if monyear > = tm(2014m1) & monyear <tm(2019m1), vce(robust)


**Anti-Hispanic or Latino Hate Crime (Weekly)
reg numhispanicweek weekaftertrumpann hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numhispanicweek weekaftertrumpann##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

reg numhispanicweek weekaftertrumppres hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numhispanicweek weekaftertrumppres##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

reg numhispanicweek weekaftertrumpnom hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numhispanicweek weekaftertrumpnom##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

reg numhispanicweek weekaftertrumpelec hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numhispanicweek weekaftertrumpelec##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

reg numhispanicweek weekaftertrumpinag hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)
reg numhispanicweek weekaftertrumpinag##c.hcperweek if weekyear > = tw(2014w1) & weekyear <tw(2019w1), vce(robust)

**Anti-Hispanic or Latino Hate Crime (Daily)
reg numhispanicdate aftertrumpann hcperday if date > = 19724 & date <21550, vce(robust)
reg numhispanicdate aftertrumpann##c.hcperday if date > = 19724 & date <21550, vce(robust)

reg numhispanicdate aftertrumppres hcperday if date > = 19724 & date <21550, vce(robust)
reg numhispanicdate aftertrumppres##c.hcperday if date > = 19724 & date <21550, vce(robust)

reg numhispanicdate aftertrumpnom hcperday if date > = 19724 & date <21550, vce(robust)
reg numhispanicdate aftertrumpnom##c.hcperday if date > = 19724 & date <21550, vce(robust)

reg numhispanicdate aftertrumpelec hcperday if date > = 19724 & date <21550, vce(robust)
reg numhispanicdate aftertrumpelec##c.hcperday if date > = 19724 & date <21550, vce(robust)

reg numhispanicdate aftertrumpinag hcperday if date > = 19724 & date <21550, vce(robust)
reg numhispanicdate aftertrumpinag##c.hcperday if date > = 19724 & date <21550, vce(robust)
