# hospitalquality

R scripts that analyze and rank hospitals based on mortality rates from the Hospital Compare data run by the U.S. Department of Health and Human Services.

## Data

The data comes from the Hospital Compare web site (http://hospitalcompare.hhs.gov) run by the U.S. Department of Health and Human Services. The purpose of the web site is to provide data and information about the quality of care at over 4,000 Medicare-certified hospitals in the U.S. This dataset essentially covers all major U.S. hospitals. This dataset is used for a variety of purposes, including determining whether hospitals should be fined for not providing high quality care to patients (see http://goo.gl/jAXFX
for some background on this particular topic).

* outcome-of-care-measures.csv: Contains information about 30-day mortality and readmission rates for heart attacks, heart failure, and pneumonia for over 4,000 hospitals.
* hospital-data.csv: Contains information about each hospital.
* Hospital_Revised_Flatfiles.pdf: Descriptions of the variables in each file (i.e the code book).

## HeartAttackMortality

Plots a histogram of the 30-day mortality rates for heart attacks.  Reads the outcome-of-care-measures.csv file and plots the 30-day mortality rates for heart attacks.

![alt text](https://raw.githubusercontent.com/donnemartin/hospitalquality/master/heart-attack-mortality.png)

## GetOutcomes

Utility function to read the outcome-of-care-measures.csv file and return a data frame of given outcomes within the given state.  The hospital name is the name provided in the Hospital.Name variable. Hospitals that do not have data on a particular outcome are excluded from the set of hospitals.

Called by BestHospitals, RankHospitals, and RankAllHospitals.

## BestHospitals

Returns a character vector with the name of the hospitals that have the best (i.e. lowest) 30-day mortality for the specified outcome in that state.

```R
# Tests
BestHospitals("TX", "heart attack")
# [1] "CYPRESS FAIRBANKS MEDICAL CENTER"
BestHospitals("TX", "heart failure")
# [1] "FORT DUNCAN MEDICAL CENTER"
BestHospitals("MD", "heart attack")
# [1] "JOHNS HOPKINS HOSPITAL, THE"
BestHospitals("MD", "pneumonia")
# [1] "GREATER BALTIMORE MEDICAL CENTER"
BestHospitals("BB", "heart attack")
# Error in BestHospitals("BB", "heart attack") : invalid state
BestHospitals("NY", "hert attack")
# Error in BestHospitals("NY", "hert attack") : invalid outcome
```

## RankStateHospitals

Returns a character vector with the name of the hospital that matches the ranking of the 30-day mortality for the specified outcome in the specified state.

```R
# Tests
RankStateHospital("TX", "heart failure", 4)
# [1] "DETAR HOSPITAL NAVARRO"
RankStateHospital("MD", "heart attack", "worst")
# [1] "HARFORD MEMORIAL HOSPITAL"
RankStateHospital("MN", "heart attack", 5000)
# [1] NA
```

## RankAllHospitals

Returns a data frame containing the names of the hospitals that are the best in their respective states for 30-day mortality for the specified outcome.  Returns a value for every state (some may be NA).

```R
head(RankAllHospitals("heart attack", 20), 10)
# hospital state
# AK <NA> AK
# AL D W MCMILLAN MEMORIAL HOSPITAL AL
# AR ARKANSAS METHODIST MEDICAL CENTER AR
# AZ JOHN C LINCOLN DEER VALLEY HOSPITAL AZ
# CA SHERMAN OAKS HOSPITAL CA
# CO SKY RIDGE MEDICAL CENTER CO
# CT MIDSTATE MEDICAL CENTER CT
# DC <NA> DC
# DE <NA> DE
# FL SOUTH FLORIDA BAPTIST HOSPITAL FL
tail(RankAllHospitals("pneumonia", "worst"), 3)
# hospital state
# WI MAYO CLINIC HEALTH SYSTEM - NORTHLAND, INC WI
# WV PLATEAU MEDICAL CENTER WV
# WY NORTH BIG HORN HOSPITAL DISTRICT WY
tail(RankAllHospitals("heart failure"), 10)
# hospital state
# TN WELLMONT HAWKINS COUNTY MEMORIAL HOSPITAL TN
# TX FORT DUNCAN MEDICAL CENTER TX
# UT VA SALT LAKE CITY HEALTHCARE - GEORGE E. WAHLEN VA MEDICAL CENTER UT
# VA SENTARA POTOMAC HOSPITAL VA
# VI GOV JUAN F LUIS HOSPITAL & MEDICAL CTR VI
# VT SPRINGFIELD HOSPITAL VT
# WA HARBORVIEW MEDICAL CENTER WA
# WI AURORA ST LUKES MEDICAL CENTER WI
# WV FAIRMONT GENERAL HOSPITAL WV
# WY CHEYENNE VA MEDICAL CENTER WY
```

##License

    Copyright 2014 Donne Martin

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
