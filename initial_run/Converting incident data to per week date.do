** Important dates

** Obama
*Announcement = Feb 10, 2007 = 17,207
* Presumptive nominee = June 3, 2008 = 17,686
* Nominated = August 27, 2008 = 17,771
* Won election = Nov. 4, 2008 = 17840
* Inaugurated = Jan. 20, 2009 = 17,917


** Trump


gen hatecrime = 1 if STATNUM !=0
tab hatecrime, missing

** Creating overall hate crimes #
bys date: egen hcperday = sum(hatecrime)
bys weekyear: egen hcperweek = sum(hatecrime)
bys monyear: egen hcpermon = sum(hatecrime)

** Converting incident level data to crimes per week
bys date: egen numblackdate = sum(antiblack)
bys weekyear: egen numblackweek = sum(antiblack)
bys monyear: egen numblackmon = sum(antiblack)

tab date, nolabel
list antiblack numblackdate numblackweek numblackmon if date == 20453

** Creating date count
use "C:\Users\avr\Dropbox\Ashley - Root\VT\Research\Hate crimes data\hates_1992-2015_full counts.dta"
keep antiblack date numblackdate hcperday
duplicates drop date, force

*** before and after important events
gen afterann = 1 if date >= 17207
replace afterann = 0 if date < 17207

gen afterpresnom = 1 if date >= 17686
replace afterpresnom = 0 if date < 17686

gen afternominate = 1 if date >= 17771
replace afternominate =0 if date < 17771

gen afterelec = 1 if date >=17840
replace afterelec =0 if date < 17840

gen afterinaug = 1 if date >= 17917
replace afterinaug = 0 if date < 17917


**Creating weekly
gen week = week(date)
gen weekyear = yw(MASTERYR,w)
format weekyear %tw

** Creating week count
use "C:\Users\avr\Dropbox\Ashley - Root\VT\Research\Hate crimes data\hates_1992-2015_full counts.dta"
keep antiblack weekyear numblackweek date hcperweek
duplicates drop weekyear, force
drop antiblack

*** before and after important events
gen afterann = 1 if weekyear > tw(2007w6)
replace afterann = 0 if weekyear <= tw(2007w6)

gen afterpresnom = 1 if weekyear >= tw(2008w23)
replace afterpresnom = 0 if weekyear < tw(2008w23)

gen afternominate = 1 if weekyear >= tw(2008w35)
replace afternominate =0 if weekyear < tw(2008w35)

gen afterelec = 1 if weekyear >= tw(2008w45)
replace afterelec =0 if weekyear < tw(2008w45)

gen afterinaug = 1 if weekyear > tw(2009w3) 
replace afterinaug = 0 if weekyear <= tw(2009w3) 



** Creating monthly
gen monyear=ym(MASTERYR,month)
format monyear %tm

** Creating month count
use "C:\Users\avr\Dropbox\Ashley - Root\VT\Research\Hate crimes data\hates_1992-2015_full counts.dta"
keep antiblack monyear numblackmon date hcpermon
duplicates drop monyear, force
drop antiblack

** Important dates
*Announcement = Feb 10, 2007 = 17, 2007
* Presumptive nominee = June 3, 2008 = 17,686
* Nominated = August 27, 2008 = 17,771
* Won election = Nov. 4, 2008 = 17840
* Inaugurated = Jan. 20, 2009 = 17,917

*** before and after important events
gen afterann = 1 if monyear > = tm(2007m2)
replace afterann = 0 if monyear < tm(2007m2)

gen afterpresnom = 1 if monyear >= tm(2008m6)
replace afterpresnom = 0 if monyear < tm(2008m6)

gen afternominate = 1 if monyear > tm(2008m8)
replace afternominate =0 if monyear <= tm(2008m8)

gen afterelec = 1 if monyear >= tm(2008m11)
replace afterelec =0 if monyear < tm(2008m11)

gen afterinaug = 1 if monyear > tm(2009m1)
replace afterinaug = 0 if monyear <= tm(2009m1)
