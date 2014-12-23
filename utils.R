IsInteger <- function(value) {
  # Determines whether the input is a valid integer
  #
  # Args:
  #   value: the input to test
  #
  # Returns:
  #   TRUE if the input is an integer
  #   FALSE otherwise

  return(all.equal(value, as.integer(value)))
}

GetOutcomesInState <- function(state, outcome) {
  # Reads the outcome-of-care-measures.csv file and returns a data frame of
  # given outcomes within the given state.  The hospital name is the
  # name provided in the Hospital.Name variable. Hospitals that do not have data
  # on a particular outcome are excluded from the set of hospitals.
  #
  # Args:
  #   state: the 2-character abbreviated name of a state
  #   outcome: the mortality outcome, must be one of the following:
  #     “heart attack”, “heart failure”, or “pneumonia”.
  #
  # Returns:
  #   A data frame of given outcomes within the given state.
  #   The data frame is sorted by outcome (ASC) and hospital name (ASC)
  #   NAs are removed

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

  # Convert the heart attack mortality column from string to numeric,
  # which will introduce a warning about NAs being introduced
  # This is necessary for the hist call below
  dfOutcomes[, mortalityCol] <-
    as.numeric(dfOutcomes[, mortalityCol])

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

  # Change the column names to something more manageable
  colnames(dfOutcomesInState) <- c("Hospital.Name", "Outcome")

  # Sort the dataset by outcome and hospital name
  # Ommit any NAs
  kResultOutcomeCol <- 2
  dfOutcomesInState <- dfOutcomesInState[order(dfOutcomesInState$Outcome,
                                               dfOutcomesInState$Hospital.Name,
                                               na.last=NA), ]

  return(dfOutcomesInState)
}