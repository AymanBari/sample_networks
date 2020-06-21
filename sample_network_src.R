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
  index <- sample(1:nrow(babynames), n, replace = FALSE) 
  names <- babynames[index, ] 
  names 
} 