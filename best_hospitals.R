BestHospitals <- function(state, outcome) {
  # Reads the outcome-of-care-measures.csv file and returns a character vector
  # with the name of the hospital that has the best (i.e. lowest) 30-day
  # mortality for the specified outcome in that state. The hospital name is the
  # name provided in the Hospital.Name variable. Hospitals that do not have data
  # on a particular outcome are excluded from the set of hospitals when
  # deciding the rankings.
  #
  # Args:
  #   state: the 2-character abbreviated name of a state
  #   outcome: the mortality outcome, must be one of the following:
  #     “heart attack”, “heart failure”, or “pneumonia”.
  #
  # Returns:
  #   The name of the hospital within the given state with the best (minimum)
  #   value for the given mortality rate outcome

  source("utils.R")

  # Get our data frame of hospitals and given outcomes within the given state
  dfOutcomes <- GetOutcomes(state, outcome)

  # Get the subset of hospitals and mortalities with the minimum mortality
  # Since dfOutcomes is already sorted in ascending order based on
  # outcome and already excludes NAs, this is simply the first element
  kMinOutcomeIndex = 1
  dfResult <- dfOutcomes[kMinOutcomeIndex, ]

  # Return hospital name in that state with lowest 30-day death rate
  kResultHospitalCol <- 1
  return(dfResult[, kResultHospitalCol])
}

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