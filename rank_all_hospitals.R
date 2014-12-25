rankall <- function(outcome, rank="best") {
  # Reads the outcome-of-care-measures.csv file and returns a 2-column data
  # frame containing the hospital in each state that has the ranking specified
  # in rank. For example the function call (heart attack", "best") would return
  # a data frame containing the names of the hospitals that are the best in
  # their respective states for 30-day heart attack death rates. The function
  # returns a value for every state (some may be NA). The first column in the
  # data frame is named hospital, which contains the hospital name, and the
  # second column is named state, which contains the 2-character abbreviation
  # for the state name. Hospitals that do not have data on a particular outcome
  # should be excluded from the set of hospitals when deciding the rankings.
  #
  # Args:
  #   outcome: the mortality outcome, must be one of the following:
  #     “heart attack”, “heart failure”, or “pneumonia”.
  #   num: the ranking of the hospital within the given state
  #     Can be an integer or "best" or "worst"
  #
  # Returns:
  #   A value for every state (some may be NA). The first column in the
  #   data frame is named hospital, which contains the hospital name, and the
  #   second column is named state, which contains the 2-character abbreviation
  #   for the state name.
  #   If the number given by num is larger than the number of hospitals in that
  #   state, then the function returns NA


  ## Read outcome data
  ## Check that state and outcome are valid
  ## For each state, find the hospital of the given rank
  ## Return a data frame with the hospital names and the
  ## (abbreviated) state name

  source("utils.R")
  library(plyr)

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
  #if (!is.element(state, dfOutcomes[, kStateCol])) {
  #  stop("State not found in data set")
  #}

  # Get the subset of hospitals and mortalities for the given state and outcome
  kHospitalNameCol <- 2
  dfOutcomesInState <- subset(dfOutcomes,
                              select=c(kHospitalNameCol,
                                       kStateCol,
                                       mortalityCol))

  # Change the column names to something more manageable
  colnames(dfOutcomesInState) <- c("Hospital.Name", "State", "Outcome")

  # Sort the dataset by outcome and hospital name
  # Ommit any NAs
  kResultOutcomeCol <- 2
  dfOutcomesInState <- dfOutcomesInState[order(dfOutcomesInState$State,
                                               dfOutcomesInState$Outcome,
                                               dfOutcomesInState$Hospital.Name,
                                               na.last=NA), ]

  hospitalRank <- NULL

  # Check if rank is valid
  if (rank == "best") {
    hospitalRank <- 1
  } else if (rank == "worst") {
    hospitalRank <- nrow(dfOutcomesInState)
  } else if (IsInteger(rank)) {
    hospitalRank <- rank
  } else {
    stop("Invalid rank")
  }

  dfOutcomesInState <- ddply(dfOutcomesInState,
                             c("State"),
                             function(x) {
                               if (rank == "worst") {
                                 hospitalRank <- nrow(x)
                               }

                               if (hospitalRank <= nrow(x)) {
                                 return(x[hospitalRank, ])
                               } else {
                                 y <- data.frame(x[hospitalRank, 1],
                                                 x[1, 2],
                                                 x[hospitalRank, 3])

                                 # Change the column names to
                                 # something more manageable
                                 colnames(y) <- c("Hospital.Name",
                                                  "State",
                                                  "Outcome")

                                 return(y)
                               }
                             })

  colnames(dfOutcomesInState) <- c("hospital", "state", "outcome")
  dfOutcomesInState <- subset(dfOutcomesInState, select=-outcome)

  return(dfOutcomesInState)
}

# Tests
head(rankall("heart attack", 20), 10)
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
tail(rankall("pneumonia", "worst"), 3)
# hospital state
# WI MAYO CLINIC HEALTH SYSTEM - NORTHLAND, INC WI
# WV PLATEAU MEDICAL CENTER WV
# WY NORTH BIG HORN HOSPITAL DISTRICT WY
tail(rankall("heart failure"), 10)
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