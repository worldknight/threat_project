library(tidyverse)
library(gt)
library(webshot2)
setwd("~/GitHub/threat_project/analysis/obama/")

df <- data.frame(milestone = c(" Announcement", "Presumptive Candidate", "Nominated", "Elected", "Inaugurated"), day = c("0.21(0.11)", "0.01(0.10)", "-0.06(0.11)", "-0.25(0.11)*", "-0.28(0.11)**"), week = c("1.87(0.75)**", "0.50(0.74)", "0.13(0.76)", "-1.24(0.79)*", "-1.54(0.79)*"), month = c("7.81(3.52)*", "2.19(3.57)", "2.02(3.65)", "-5.17(3.82)", "-7.26(3.79)"))

table <- gt(df) %>% tab_header(title = "Change in Number of Anti-Black Hate Crimes between Jan 1. 2006 and Jan 1. 2011", subtitle = "OLS Linear Regression") %>% cols_label(milestone = "Milestone", day = "Day", week = "Week", month = "Month") %>% cols_align(align = "center") %>% tab_footnote("* p <= .05, ** p<=.01") %>% tab_source_note(source_note = "Note: Entires are coefficients with standard errors in parentheses.")
print(table)
gtsave(table, "regressions.png")
gtsave(table, "regressions.pdf")
