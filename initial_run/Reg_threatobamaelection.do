***Test per month
** afterann & afterinaug significant
use "C:\Users\avr\Dropbox\Ashley - Root\VT\Research\Hate crimes data\hates_1992-2015_bymon.dta", clear

*Announcement = Feb 10, 2007 = 17, 200
* Presumptive nominee = June 3, 2008 = 17,686
* Nominated = August 27, 2008 = 17,771
* Won election = Nov. 4, 2008 = 17840
* Inaugurated = Jan. 20, 2009 = 17,917

** Line tests
line numblackmon hcpermon monyear if monyear > = tm(2006m1) & monyear <tm(2011m1)
line numblackmon hcpermon monyear if monyear > = tm(2007m1) & monyear <tm(2009m3)

reg numblackmon afterann hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numblackmon afterann##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numblackmon afterpresnom hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numblackmon afterpresnom##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numblackmon afternominate hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numblackmon afternominate##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numblackmon afterelec hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numblackmon afterelec##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)

reg numblackmon afterinaug hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)
reg numblackmon afterinaug##c.hcpermon if monyear > = tm(2006m1) & monyear <tm(2011m1), vce(robust)


** Test per week
** Afterann was significant
use "C:\Users\avr\Dropbox\Ashley - Root\VT\Research\Hate crimes data\hates_1992-2015_byweek.dta", clear

*Announcement = Feb 10, 2007 = 17, 200
* Presumptive nominee = June 3, 2008 = 17,686
* Nominated = August 27, 2008 = 17,771
* Won election = Nov. 4, 2008 = 17840
* Inaugurated = Jan. 20, 2009 = 17,917

** Line tests
line numblackweek hcperweek weekyear if weekyear > = tw(2006w1) & weekyear <tw(2011w1)
line numblackweek hcperweek weekyear if weekyear > = tw(2007w1) & weekyear <tw(2009w12)

reg numblackweek afterann hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numblackweek afterann##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numblackweek afterpresnom hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numblackweek afterpresnom##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numblackweek afternominate hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numblackweek afternominate##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numblackweek afterelec hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numblackweek afterelec##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

reg numblackweek afterinaug hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)
reg numblackweek afterinaug##c.hcperweek if weekyear > = tw(2006w1) & weekyear <tw(2011w1), vce(robust)

*** Test per day
** Afterpresnom int, afternominate int, & election are sig

use "C:\Users\avr\Dropbox\Ashley - Root\VT\Research\Hate crimes data\hates_1992-2015_bydate.dta", clear

*Announcement = Feb 10, 2007 = 17, 200
* Presumptive nominee = June 3, 2008 = 17,686
* Nominated = August 27, 2008 = 17,771
* Won election = Nov. 4, 2008 = 17840
* Inaugurated = Jan. 20, 2009 = 17,917

** Line tests
line numblackdate date if date > = 16802 & date <18628
line numblackdate date if date > = 17100 & date <18000

reg numblackdate afterann hcperday if date > = 16802 & date <18628, vce(robust)
reg numblackdate afterann##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numblackdate afterpresnom hcperday if date > = 16802 & date <18628, vce(robust)
reg numblackdate afterpresnom##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numblackdate afternominate hcperday if date > = 16802 & date <18628, vce(robust)
reg numblackdate afternominate##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numblackdate afterelec hcperday if date > = 16802 & date <18628, vce(robust)
reg numblackdate afterelec##c.hcperday if date > = 16802 & date <18628, vce(robust)

reg numblackdate afterinaug hcperday if date > = 16802 & date <18628, vce(robust)
reg numblackdate afterinaug##c.hcperday if date > = 16802 & date <18628, vce(robust)
