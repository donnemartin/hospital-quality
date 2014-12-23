HeartAttackMortality <- function() {
  # Plots a histogram of the 30-day mortality rates for heart attacks
  # Reads the outcome-of-care-measures.csv file and plots the 30-day mortality
  # rates for heart attacks.
  #
  # Args:
  #   None
  #
  # Returns:
  #   a histogram of the 30-day mortality rates for heart attacks

  dfOutcomes <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  kHeartAttackMortalityCol <- 11

  # Convert the heart attack mortality column from string to numeric,
  # which will introduce a warning about NAs being introduced
  # This is necessary for the hist call below
  dfOutcomes[, kHeartAttackMortalityCol] <-
    as.numeric(dfOutcomes[, kHeartAttackMortalityCol])

  # Graph a histogram of the heart attack mortality
  hist(dfOutcomes[, kHeartAttackMortalityCol])
}