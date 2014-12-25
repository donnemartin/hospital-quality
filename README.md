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

## GetOutcomes

Utility function to read the outcome-of-care-measures.csv file and return a data frame of given outcomes within the given state.  The hospital name is the name provided in the Hospital.Name variable. Hospitals that do not have data on a particular outcome are excluded from the set of hospitals.

Called by BestHospitals, RankHospitals, and RankAllHospitals.

## BestHospitals

Returns a character vector with the name of the hospitals that have the best (i.e. lowest) 30-day mortality for the specified outcome in that state.

## RankHospitals

Returns a character vector with the name of the hospital that matches the ranking of the 30-day mortality for the specified outcome in that state.

## RankAllHospitals

Returns a data frame containing the names of the hospitals that are the best in their respective states for 30-day mortality for the specified outcome.  Returns a value for every state (some may be NA).
