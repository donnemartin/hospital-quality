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
  #   rank: the ranking of the hospital within the given state
  #     Can be an integer or "best" or "worst"
  #
  # Returns:
  #   A value for every state (some may be NA). The first column in the
  #   data frame is named hospital, which contains the hospital name, and the
  #   second column is named state, which contains the 2-character abbreviation
  #   for the state name.
  #   If the number given by num is larger than the number of hospitals in that
  #   state, then the function returns NA

  source("utils.R")
  library(plyr)

  # Get our data frame of hospitals and given outcomes within the given state
  dfOutcomes <- GetOutcomes(state="all", outcome)

  # Get the numerical index of the hospital rank that we can use in
  # our dataframe
  hospitalRank <- TranslateRankToDataFrameIndex(dfOutcomes, rank)

  kFirstRow <- 1
  kStateCol <- 2
  dfOutcomes <- ddply(dfOutcomes,
                      c("State"),
                      function(dfOutcomes) {
                        # If we want the worst rank, return the last element
                        if (rank == "worst") {
                          hospitalRank <- nrow(dfOutcomes)
                        }

                        # If the hospitalRank is within the df rows,
                        # return the df index
                        # otherwise, return a data frame (NA, state, NA)
                        if (hospitalRank <= nrow(dfOutcomes)) {
                          return(dfOutcomes[hospitalRank, ])
                        } else {
                          dfResult <- data.frame(NA,
                                                 dfOutcomes[kFirstRow,
                                                            kStateCol],
                                                 NA)
                          return(dfResult)
                        }
                      })

  colnames(dfOutcomes) <- c("hospital", "state", "outcome")
  dfOutcomes <- subset(dfOutcomes, select=-outcome)

  return(dfOutcomes)
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