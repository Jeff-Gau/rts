##Saves out the Parent Survey for Mild TBI at baseline

library(tidyverse)
library(rts)
library(expss)
d <- get_rts_data()

nrow(d)
ncol(d)


#Not all cases in this file have data. Selecting only those that do have data. Select if [mild0_parent_survey_complete] = 2. Also,
#select only variables from the Parent Survey for Mild TBI at baseline
d2 <-subset(d,redcap_event_name=="baseline_arm_1" & mild0_parent_survey_complete==2,
            select=c(record_id,pdem_1_m0:mild0_parent_survey_complete) )

nrow(d2)
ncol(d2)

#Renaming and computing new variables

d3 <-d2 %>%
  mutate(severity=1) %>%
  rename(id = record_id,
         dem0_1 = pdem_1_m0)



#Creating Variable Labels
d3 = apply_labels(d3,
                  id = "Family ID Number",
                  severity = 'Mild or Severe BI',
                  severity = c("Mild/Moderate" = 1, "Severe" = 2),
                  dem0_1 ="Parent Survey: Mild: Baseline: What is your parental role?",
                  dem0_1 =c('Mother'= 1, 'Father'= 2, 'Stepmother' = 3, 'Stepfather = 4', 'Ohter caregive/guardian' = 5)
                  )

glimpse(d3)

#Saving out the data file

write.csv(d3, "C:\\Users\\jeffg\\Dropbox\\3. R\\Work-UO\\CDC-RTS\\Public\\rts\\data\\ParentSurveyMild0.csv")



