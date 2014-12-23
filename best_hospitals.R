BestHospitals <- function(state, outcome) {
  # Reads the outcome-of-care-measures.csv file and returns a character vector
  # with the name of the hospitals that have the best (i.e. lowest) 30-day
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
  #   The names of the hospital within the given state with the best (minimum)
  #   value for the given mortality rate outcome

  # Read outcome data
  dfOutcomes <- read.csv("outcome-of-care-measures.csv",
                         colClasses = "character")

  mortalityCol <- NULL

  # Determine the column index to read based on the given outcome
  if (outcome == "heart attack") {
    kHeartAttackMortalityCol <- 11
    mortalityCol <- kHeartAttackMortalityCol
  } else if (outcome == "heart failure") {
    kHeartFailureMortalityCol <- 17
    mortalityCol <- kHeartFailureMortalityCol
  } else if (outcome == "pneumonia") {
    kPneumoniaMortalityCol <- 23
    mortalityCol <- kPneumoniaMortalityCol
  } else {
    stop("Invalid outcome: Must be 'heart attack, 'heart failure', 'pnumonia")
  }

  kStateCol <- 7

  # Check if we have data on the given state
  if (!is.element(state, dfOutcomes[, kStateCol])) {
    stop("State not found in data set")
  }

  # Get the subset of hospitals and mortalities for the given state and outcome
  kHospitalNameCol <- 2
  dfOutcomesInState <- subset(dfOutcomes,
                              select=c(kHospitalNameCol, mortalityCol),
                              subset=(State == state))

  # Get the subset of hospitals and mortalities with the minimum mortality
  # Exclude NAs
  kResultOutcomeCol = 2
  dfResult <-
    dfOutcomesInState[which(dfOutcomesInState[, kResultOutcomeCol] ==
                              min(dfOutcomesInState[, kResultOutcomeCol],
                                  na.rm=TRUE)), ]

  # Return hospital names in that state with lowest 30-day death rate
  kResultHospitalCol = 1
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