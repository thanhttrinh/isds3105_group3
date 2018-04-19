---
title: "Main"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE)
```

# Introduction 
We are interested in which variables affect the starting salary for an initial job offer the most. We have developed the following questions that we will explore:

- How much does having an internship affect your starting salary
- Does it matter if the internship is related to the respective major?
- How much does one internship differ from many? 



```{r}
# Connect to DB
library(tidyverse)
conStudent <- src_mysql(
                   host = "ba-isdsclass-programdev.lsu.edu",
                  port = 3306,
                  user = 'student',
                  password = 'student',
                  dbname = "isds_3105")



graduates <- tbl(conStudent, 'graduation')
internships <- tbl(conStudent, 'internship')
wage <- tbl(conStudent, 'paidInternship')

# Filter to join hourly wage and remove results that have NA for that column, sort by ascending
internships <- internships %>% left_join(wage) %>% filter(!is.na(hourlyWage))

internships <- internships %>% left_join(graduates) %>% arrange(graduationId)
```

We have realized that there is a large sum of "dirty" data, and will thus do some cleanup. Some hourly wages appear to be above $40-$45, which seems very unreasonable for even out of state internships in high cost-of-living states such as California. That being said, I will filter out the results greater than $40/h. 


```{r}
internships <- internships %>% filter(hourlyWage <= 45) %>% select(internshipId, jobTitle, graduationId, weeklyCompensation, hourlyWage)


# TODO: add column for n, where n = number of internships for a given student denoted by 'graduationId'
#internships <- internships %>% group_by(graduationId) %>% mutate(count = add_tally())


```

