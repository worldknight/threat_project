#Testing Group Threat Through Hate Crime & Presidential Campaigns (TRUMP
# PI: Ashley V. Reichelmann
# Researcher: Jonathan A. LLoyd
# Last Updated: February 11, 2023

#Dataset: Hate Crime Statistics, 1991-2020

#Setup
setwd("~/GitHub/threat_project/analysis/trump/")
require(tidyverse)
require(lubridate)
require(table1)
require(ggplot2)
require(ggrepel)
require(jtools)



#Data Importation and Time Setup
df <- read_csv('../../initial_run/hate_crime_FBI website.csv')
colnames(df) <- tolower(colnames(df))
df$date <- dmy(df$incident_date)

#Filter to Relevant Years: 2006-2011
df <- df %>% filter(date>="2014-01-01" & date<= "2019-01-01")

#Recoding Offense Types
df <- df %>% mutate(anti_black = if_else(str_detect(bias_desc, "Anti-Black"), TRUE, FALSE), anti_latinx= if_else(str_detect(bias_desc, "Anti-Hispanic or Latino"), TRUE, FALSE), anti_muslim = if_else(str_detect(bias_desc, "Anti-Islamic"), TRUE, FALSE), anti_jewish = if_else(str_detect(bias_desc, "Anti-Jewish"), TRUE, FALSE))


#Hate Crimes by Week and Month
week_hc <- df %>% group_by(week = lubridate::floor_date(date, "week")) %>% summarize(freq=n(), anti_black = sum(anti_black == TRUE), anti_jewish = sum(anti_jewish == TRUE), anti_latinx = sum(anti_latinx == TRUE), anti_muslim = sum (anti_muslim == TRUE))


month_hc <- df %>% group_by(month = lubridate::floor_date(date, "month")) %>% summarize(freq=n(),anti_black = sum(anti_black == TRUE), anti_jewish = sum(anti_jewish == TRUE), anti_latinx = sum(anti_latinx == TRUE), anti_muslim = sum (anti_muslim == TRUE))


##Coding Event Dates
milestones <- data.frame(milestone = c("06/15/2015: Announcement", "05/04/2016: Presumptive Candidate", "07/19/2016: Nominated", "11/09/2016: Elected", "01/20/2017: Inaugurated"), date = as.Date(c("2015-06-15", "2016-05-04", "2016-07-19", "2016-11-09", "2017-01-20")))


#Aggregating Dates
month_milestones <- milestones %>% group_by(month = lubridate::floor_date(date, "month"))
week_milestones <- milestones %>% group_by(week = lubridate::floor_date(date, "week"))

#Data Prep
##Monthly
month_data <- left_join(month_hc, month_milestones, by = "month") %>% select(-date)
month_data <- month_data %>% mutate(afterann = if_else(month >= "2015-06-01", TRUE, FALSE), afterpres = if_else(month >= "2016-05-01", TRUE, FALSE), afternom = if_else(month >= "2016-07-01", TRUE, FALSE), afterelec = if_else(month >= "2016-11-01", TRUE, FALSE), afterinaug = if_else(month >= "2017-01-01", TRUE, FALSE))

##Weekly
week_data <- left_join(week_hc, week_milestones, by = "week") %>% select(-date)
week_data <- week_data %>% mutate(afterann = if_else(week >= "2015-06-14", TRUE, FALSE), afterpres = if_else(week >= "2016-05-01", TRUE, FALSE), afternom = if_else(week >= "2016-07-17", TRUE, FALSE), afterelec = if_else(week >= "2016-11-06", TRUE, FALSE), afterinaug = if_else(week >= "2017-01-15", TRUE, FALSE))



#Plotting
break_dates<-as.Date(c("2014-01-01", "2014-07-01", "2015-01-01", "2015-07-01", "2015-01-01", "2015-07-01", "2015-01-01", "2015-07-01", "2016-01-01", "2016-07-01", "2017-01-01", "2017-07-01", "2018-01-01", "2018-07-01"))

colors = c("Overall" = "purple", "Anti-Latinx" = "green")

trump_plot_combo_month <- ggplot(month_data, aes(label = milestone)) + scale_color_manual(values=colors) + geom_line(aes(x = month, y=anti_latinx, colour = "Anti-Latinx")) + geom_line(aes(x = month, y=freq, colour = "Overall")) + scale_x_date(date_labels = "%B-%Y", breaks = break_dates, limits = as.Date(c("2014-01-01", "2018-12-01"))) + xlab("Time") + ylab("Incidents per Month") + geom_point(aes(x = month, y = freq, color = "Overall")) + geom_point(aes(x = month, y = anti_latinx, color = "Anti-Latinx")) + geom_label_repel(aes(x = month, y = freq, label = milestone), nudge_y = 175, direction = "y") + geom_label_repel(aes(x = month, y = anti_latinx, label = milestone), nudge_y = 100, direction = "y" ) + theme_bw() + labs(title = "Hate Crimes & the 2016 Trump Campaign", subtitle = "Anti-Latinx and Overall Hate Crimes from January 2014-January 2019",caption = "Virginia Tech", color = "") + theme(legend.position = "bottom") + ylim(0, 800)
print(trump_plot_combo_month)


trump_plot_combo_week <- ggplot(week_data, aes(label = milestone)) + scale_color_manual(values=colors) + geom_line(aes(x = week, y=anti_latinx, colour = "Anti-Latinx")) + geom_line(aes(x = week, y=freq, colour = "Overall")) + scale_x_date(date_labels = "Week %U-%Y", date_breaks = "6 months", limits = as.Date(c("2013-12-29", "2018-12-30"))) + xlab("Time") + ylab("Incidents per Week") + geom_point(aes(x = week, y = freq, color = "Overall")) + geom_point(aes(x = week, y = anti_latinx, color = "Anti-Latinx")) + geom_label_repel(aes(x = week, y = freq, label = milestone), nudge_y = 0, direction = "y") + geom_label_repel(aes(x = week, y = anti_latinx, label = milestone), nudge_y = 40, direction = "y" ) + theme_bw() + labs(title = "Hate Crimes & the 2016 Trump Campaign", subtitle = "Anti-Latinx and Overall Hate Crimes from January 2014-January 2019",caption = "Virginia Tech", color = "") + theme(legend.position = "bottom") + ylim(0, 250)
print(trump_plot_combo_week)

#Save Plots
ggsave("hc_plot_month.png", plot = trump_plot_combo_month, dpi = 300)
ggsave("hc_plot_week.png", plot = trump_plot_combo_week, dpi = 300)


#Regression Setup
predictors <- list("~ afterann", "~ afterpres", "~ afternom", "~ afterelec", "~ afterinaug")
groups <- list("freq", "anti_latinx")
combo_predictors <- paste(predictors, "+ freq")
reg.model <- as.list(outer(groups, predictors, paste))
combo_reg.model <- as.list(outer("anti_latinx", combo_predictors, paste))

##Regression Models
month_regressions <- lapply(reg.model, lm, data = month_data)
week_regressions <- lapply(reg.model, lm, data = week_data)
combo_month_regressions <- lapply(combo_reg.model, lm, data = month_data)
combo_week_regressions <- lapply(combo_reg.model, lm, data = week_data)

##Save Output
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
