#Testing Group Threat Through Hate Crime & Presidential Campaigns (OBAMA)
# PI: Ashley V. Reichelmann
# Researcher: Jonathan A. LLoyd
# Last Updated: Feb 6 2024
#Dataset: Hate Crime Statistics, 1991-2020

#Setup
setwd("~/GitHub/threat_project/analysis/obama/")
require(tidyverse)
require(lubridate)
require(table1)
require(ggplot2)
require(ggrepel)
require(jtools)
require(writexl)
require(table1)


#Data Importation and Time Setup
df <- read_csv('../../initial_run/hate_crime_FBI_website.csv')
colnames(df) <- tolower(colnames(df))
df$date <- dmy(df$incident_date)

#Filter to Relevant Years: 2006-2011
df <- df %>% filter(date>="2006-01-01" & date<= "2011-01-01")

#Recoding Offense Types
df <- df %>% mutate(anti_black = if_else(str_detect(bias_desc, "Anti-Black"), TRUE, FALSE), anti_latinx= if_else(str_detect(bias_desc, "Anti-Hispanic or Latino"), TRUE, FALSE), anti_muslim = if_else(str_detect(bias_desc, "Anti-Islamic"), TRUE, FALSE), anti_jewish = if_else(str_detect(bias_desc, "Anti-Jewish"), TRUE, FALSE))

#Hate Crimes by Analytic Unit
week_hc <- df %>% group_by(week = lubridate::floor_date(date, "week")) %>% summarize(freq=n(), anti_black = sum(anti_black == TRUE), anti_jewish = sum(anti_jewish == TRUE), anti_latinx = sum(anti_latinx == TRUE), anti_muslim = sum (anti_muslim == TRUE))

month_hc <- df %>% group_by(month = lubridate::floor_date(date, "month")) %>% summarize(freq=n(),anti_black = sum(anti_black == TRUE), anti_jewish = sum(anti_jewish == TRUE), anti_latinx = sum(anti_latinx == TRUE), anti_muslim = sum (anti_muslim == TRUE))

daily_hc <- df %>% group_by(date) %>% summarize(freq=n(),anti_black = sum(anti_black == TRUE), anti_jewish = sum(anti_jewish == TRUE), anti_latinx = sum(anti_latinx == TRUE), anti_muslim = sum (anti_muslim == TRUE))

##Coding Event Dates
milestones <- data.frame(milestone = c("Announcement", "Presumptive Candidate", "Nominated", "Elected", "Inaugurated"), date = as.Date(c("2007-10-02", "2008-06-03", "2008-08-27", "2008-11-04", "2009-01-20")))

#Aggregating Dates
month_milestones <- milestones %>% group_by(month = lubridate::floor_date(date, "month"))
week_milestones <- milestones %>% group_by(week = lubridate::floor_date(date, "week"))
daily_milestones <- milestones %>% group_by(date = date)

#Data Prep
##Daily
daily_data <- left_join(daily_hc, daily_milestones, by = "date")
daily_data <- daily_data %>% mutate(afterann = if_else(date >= "2007-10-02", TRUE, FALSE), afterpres = if_else(date >= "2008-06-03", TRUE, FALSE), afternom = if_else(date >= "2008-08-27", TRUE, FALSE), afterelec = if_else(date >= "2008-11-04", TRUE, FALSE), afterinaug = if_else(date >= "2009-01-20", TRUE, FALSE))


##Monthly
month_data <- left_join(month_hc, month_milestones, by = "month") %>% select(-date)
month_data <- month_data %>% mutate(afterann = if_else(month >= "2007-10-01", TRUE, FALSE), afterpres = if_else(month >= "2008-06-01", TRUE, FALSE), afternom = if_else(month >= "2008-08-01", TRUE, FALSE), afterelec = if_else(month >= "2008-11-01", TRUE, FALSE), afterinaug = if_else(month >= "2009-01-01", TRUE, FALSE))

##Weekly
week_data <- left_join(week_hc, week_milestones, by = "week") %>% select(-date)
week_data <- week_data %>% mutate(afterann = if_else(week >= "2007-09-30", TRUE, FALSE), afterpres = if_else(week >= "2008-06-01", TRUE, FALSE), afternom = if_else(week >= "2008-08-24", TRUE, FALSE), afterelec = if_else(week >= "2008-11-02", TRUE, FALSE), afterinaug = if_else(week >= "2009-01-18", TRUE, FALSE))

#Plotting
break_dates<-as.Date(c("2006-01-01", "2006-07-01", "2007-01-01", "2007-07-01", "2008-01-01", "2008-07-01", "2009-01-01", "2009-07-01", "2010-01-01", "2010-07-01"))
shapes = c("Overall" = 0, "Anti-Black" = 17)

obama_ab_month <- ggplot(month_data, aes(label = milestone)) + geom_line(aes(x = month, y = anti_black), size = 1,color = "black") + geom_label_repel(aes(x = month, y = anti_black, label= milestone), nudge_y = -70, nudge_x = 0, direction = "y", color = "black", size = 4) + geom_point(aes(x = month, y = anti_black), size = 2, color = "black") + theme_bw() + labs(title = "Hate Crimes & the 2008 Obama Campaign", subtitle = "Anti-Black Hate Crimes from January 2006-January 2011",caption = "Virginia Tech") + theme(legend.position = "bottom") + ylim(100, 300) + scale_x_date(date_labels = "%B-%y", date_breaks = "6 months", limits = as.Date(c("2006-01-01", "2010-12-01"))) + xlab("Time") + ylab("Incidents per Month")
print(obama_ab_month)

obama_plot_combo_month <- ggplot(month_data, aes(label = milestone)) + scale_shape_manual(values=shapes) + geom_line(aes(x = month, y=anti_black)) + geom_line(aes(x = month, y=freq)) + scale_x_date(date_labels = "%B-%y", breaks = break_dates, limits = as.Date(c("2006-01-01", "2010-12-01"))) + xlab("Time") + ylab("Incidents per Month") + geom_point(aes(x = month, y = freq, shape = "Overall")) + geom_point(aes(x = month, y = anti_black, shape = "Anti-Black")) + geom_label_repel(aes(x = month, y = freq, label = milestone), nudge_y = 175, direction = "y") + geom_label_repel(aes(x = month, y = anti_black, label = milestone), nudge_y = -100, direction = "y" ) + theme_bw() + labs(title = "Hate Crimes & the 2008 Obama Campaign", subtitle = "Anti-Black and Overall Hate Crimes from January 2006-January 2011",caption = "Virginia Tech", shape = "") + theme(legend.position = "bottom") + ylim(0, 900)
print(obama_plot_combo_month)

obama_ab_week <- ggplot(week_data, aes(label = milestone)) + geom_line(aes(x = week, y = anti_black), color = "black") + geom_label_repel(aes(x = week, y = anti_black, label= milestone), nudge_y = 90, direction = "y", color = "black") + geom_point(aes(x = week, y = anti_black), color = "black") + theme_bw() + labs(title = "Hate Crimes & the 2008 Obama Campaign", subtitle = "Anti-Black Hate Crimes from January 2006-January 2011",caption = "Virginia Tech") + theme(legend.position = "bottom") + ylim(0, 175) + scale_x_date(date_labels = "%B-%y", date_breaks = "6 months", limits = as.Date(c("2006-01-01", "2010-12-26"))) + xlab("Time") + ylab("Incidents per Week")
print(obama_ab_week)

obama_plot_combo_week <- ggplot(week_data, aes(label = milestone)) + scale_shape_manual(values=shapes) + geom_line(aes(x = week, y=anti_black)) + geom_line(aes(x = week, y=freq)) + scale_x_date(date_labels = "Week %U-%Y", date_breaks = "6 months", limits = as.Date(c("2006-01-01", "2010-12-26"))) + xlab("Time") + ylab("Incidents per Week") + geom_point(aes(x = week, y = freq, shape = "Overall")) + geom_point(aes(x = week, y = anti_black, shape = "Anti-Black")) + geom_label_repel(aes(x = week, y = freq, label = milestone), nudge_y = 100, direction = "y") + geom_label_repel(aes(x = week, y = anti_black, label = milestone), nudge_y = -75, direction = "y" ) + theme_bw() + labs(title = "Hate Crimes & the 2008 Obama Campaign", subtitle = "Anti-Black and Overall Hate Crimes from January 2006-January 2011",caption = "Virginia Tech", shape = "") + theme(legend.position = "bottom") + ylim(NA, 300)
print(obama_plot_combo_week)

year_avg <- daily_data %>% group_by(year = year(date)) %>% summarise(mean_hc = mean(freq), mean_ab = mean(anti_black))

obama_plot_year_avg <- ggplot(year_avg) + scale_shape_manual(values= shapes) + geom_line(aes(x=year, y = mean_ab)) + geom_line(aes(x = year, y = mean_hc)) + geom_point(aes(x = year, y = mean_hc, shape = "Overall")) + geom_point(aes(x = year, y = mean_ab, shape = "Anti-Black")) + xlab("Year") + ylab("Average Daily Incidents") + theme_bw() + labs(title = "Hate Crimes & the 2008 Obama Campaign", subtitle = "Anti-Black and Overall Hate Crimes from January 2006-January 2011",caption = "Virginia Tech", shape = "") + theme(legend.position = "bottom")
print(obama_plot_year_avg)


#Save Plots
ggsave("hc_plot_month_bw.png", plot = obama_plot_combo_month, dpi = 300)
ggsave("hc_plot_week_bw.png", plot = obama_plot_combo_week, dpi = 300)
ggsave("anti_black_plot_month_bw.png", plot = obama_ab_month, dpi = 300)
ggsave("hc_plot_daily_bw.png", plot = obama_plot_year_avg, dpi = 300)

#Regression Setup
predictors <- list("~ afterann", "~ afterpres", "~ afternom", "~ afterelec", "~ afterinaug")
groups <- list("freq", "anti_black")
combo_predictors <- paste(predictors, "+ freq")
reg.model <- as.list(outer(groups, predictors, paste))
combo_reg.model <- as.list(outer("anti_black", combo_predictors, paste))

##Regression Models
month_regressions <- lapply(reg.model, lm, data = month_data)
week_regressions <- lapply(reg.model, lm, data = week_data)
combo_month_regressions <- lapply(combo_reg.model, lm, data = month_data)
combo_week_regressions <- lapply(combo_reg.model, lm, data = week_data)
combo_daily_regressions <- lapply(combo_reg.model, lm, data = daily_data)


##Save Output (TXT)
sink("weekly_regressions.txt")
lapply(week_regressions, summ)
sink()
sink("monthly_regressions.txt")
lapply(month_regressions, summ)
sink()
sink("combo_monthly_regressions.txt")
lapply(combo_month_regressions, summ)
sink()
sink("combo_weekly_regressions.txt")
lapply(combo_week_regressions, summ)
sink()
sink("combo_daily_regressions.txt")
lapply(combo_daily_regressions, summ)
sink()

##Save Output (Word)
export_summs(combo_month_regressions, to.file = "docx", file.name="combo_monthly_regressions.docx")
export_summs(combo_week_regressions, to.file = "docx", file.name="combo_weekly_regressions.docx")
export_summs(combo_daily_regressions, to.file = "docx", file.name = "combo_daily_regressions.docx")
export_summs(week_regressions, to.file = "docx", file.name="weekly_regressions.docx")
export_summs(month_regressions, to.file = "docx", file.name = "monthly_regressions.docx")

#Descriptives
month_freqs <- month_hc %>% group_by(month) %>% summarise(num = anti_black)
label(month_freqs$month) <- "Month"
label(month_freqs$num) <- "Number of Anti-Black Hate Crimes"
table1(~num, month_freqs)
write_xlsx(month_freqs, path = "month_freqs.xlsx")

week_freqs <- week_hc %>% group_by(week) %>% summarise(num = anti_black)
label(week_freqs$week) <- "Week"
label(week_freqs$num) <- "Number of Anti-Black Hate Crimes"
table1(~num, week_freqs)
write_xlsx(week_freqs, path = "week_freqs.xlsx")

day_freqs <- daily_hc %>% group_by(date) %>% summarise(num = anti_black)
label(day_freqs$date) <- "Day"
label(day_freqs$num) <- "Number of Anti-Black Hate Crimes"
table1(~num, day_freqs)
write_xlsx(day_freqs, path = "day_freqs.xlsx")