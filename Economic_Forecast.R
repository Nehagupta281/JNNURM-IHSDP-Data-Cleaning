#----------------------------- RData files  -----------------------------------------------------------
load("weo_19_clean.RData")
load("weo_20_clean.RData")
load("weo_21_clean.RData")

load("Economic_differentials.RData")

#--------------##########################################------------------
library(rJava)
library("xlsx")
library(reshape2)
#----------------------------- Reading Weo data in R -----------------------------------------------------------
weo_19<-read.xlsx("WEO_Oct20.xlsx", sheetName = "WEO_Oct19", header=TRUE)
weo_20<-read.xlsx("WEO_Oct20.xlsx", sheetName = "WEO_Oct20", header=TRUE)
weo_21<-read.xlsx("WEO_Jan21.xlsx", sheetName = "WEO_Jan21", header=TRUE)

dim(weo_20) # answer is 196   9
dim(weo_19) # answer is 195 11
dim(weo_21) # answer is 31 11

#----------------------------- Cleaning and saving Weo data as .RData -----------------------------------------------------------
weo_19_clean<-weo_19[,c(1,7:9)]
colnames(weo_19_clean)<-c("Country", "Actual_2018_(%)_Oct19", "Proj_2019_(%)_Oct19", "Proj_2020_(%)_Oct19")
# save(weo_19_clean, file = "weo_19_clean.RData")

weo_20_clean<-weo_20[,c(1,6:8)]
colnames(weo_20_clean)<-c("Country", "Actual_2019_(%)_Oct20", "Proj_2020_(%)_Oct20", "Proj_2021_(%)_Oct20")
# save(weo_20_clean, file = "weo_20_clean.RData")

weo_21_clean<-weo_21[1:30,c(1:5)]
colnames(weo_21_clean)<-c("Country", "Actual_2019_(%)_Jan21", "Actual_2020_(%)_Jan21", "Proj_2021_(%)_Jan21", "Proj_2022_(%)_Jan21")
weo_21_clean$Country<-as.character(weo_21_clean$Country)
weo_21_clean[6,1]<-"Egypt"
weo_21_clean[9,1]<-"India"
weo_21_clean[11,1]<-"Iran"
weo_21_clean[20,1]<-"Pakistan"
# save(weo_21_clean, file = "weo_21_clean.RData")

dim(weo_19_clean) # answer is 195   4
dim(weo_20_clean) # answer is 196   4
dim(weo_21_clean) # answer is 30 5

#----------------------------- Merging, operating and saving Economic differential data as .RData -----------------------------------------------------------

Economic_differentials<-merge(weo_19_clean,weo_20_clean, by.x="Country", by.y="Country", all.x=T, all.y=T)
Economic_differentials<-merge(Economic_differentials,weo_21_clean, by.x="Country", by.y="Country", all.x=T, all.y=T)
Economic_differentials<-Economic_differentials[-c(76,196),]
dim(Economic_differentials) # answer is 196 11

Economic_differentials$Country<-as.character(Economic_differentials$Country)
i <- c(2:7)  # Specify columns you want to change
Economic_differentials[ , i] <- apply(Economic_differentials[ , i], 2, function(x) as.numeric(as.character(x),digits=4))
Economic_differentials[ , i] <- lapply(Economic_differentials[ , i], round, 2)
sapply(Economic_differentials, class)  # Get classes of all columns
View(Economic_differentials)

Economic_differentials$'growth_differential_2019'<-Economic_differentials$`Proj_2019_(%)_Oct19`-Economic_differentials$`Actual_2019_(%)_Oct20`
Economic_differentials$'growth_differential_2020'<-Economic_differentials$`Proj_2020_(%)_Oct20`-Economic_differentials$`Actual_2020_(%)_Jan21`
dim(Economic_differentials) # answer is 196 13

Economic_differentials$'growth_differential_2019_N'<-Economic_differentials$`Actual_2019_(%)_Oct20`- Economic_differentials$`Proj_2019_(%)_Oct19`
Economic_differentials$'growth_differential_2020_N'<-Economic_differentials$`Proj_2020_(%)_Oct20`- Economic_differentials$`Proj_2020_(%)_Oct19`

# save(Economic_differentials, file = "Economic_differentials.RData")

#----------------------------- saving Economic differential data as .xlsx -----------------------------------------------------------
library("writexl")
# write_xlsx(Economic_differentials,"Economic_differentials.xlsx")



