####################
# Contributor(s): Ayman Bari, 
# 21-June-2020 
# Description: Sample networks source file, 
####################


##### LOAD LIBRARIES #####
library(babynames)  # For a list of unique names to add to a social graph 


##### FUNCTIONS #####
# Get random list of names for graph/network nodes 
get_random_names <- function(n) { 
  unique_babynames <- distinct(babynames, name, .keep_all = TRUE) # Filter out duplicate names 
  index <- sample(1:nrow(unique_babynames), n, replace = FALSE)   # Sample of n from unique_babynames 
  names <- unique_babynames[index, ]                              # Select rows sample index 
  names                                                           # Return df of n names + attrs 
} 
