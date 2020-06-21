####################
# Contributor(s): Ayman Bari, 
# 16-June-2020 
# Description: Create social networks with NetworkD3 package, 
#   Use case - illustration for introduction to networks article: 
#   
####################


##### LOAD LIBRARIES #####
library(igraph)     # Converting dataframes to graph objects 
library(tidyverse)  # Standard - dplyr, tibble, 
library(networkD3)  # Plotting networks (interactive) 
library(ggraph)     # Plot tbl_graph objects 
library(tidygraph)  # as_tbl_graph -> convert data frames to table graph objects 
library(babynames)  # For a list of unique names to add to a social graph 


########## FUNCTIONS ########## 
get_random_names <- function(n) { 
  index <- sample(1:nrow(babynames), n, replace = FALSE) 
  names <- babynames[index, ] 
  names 
} 


########## CREATE A SOCIAL NETWORK WITH 9 PEOPLE ##########
# Create nodes data frame - get random names from 
nodes <- get_random_names(9) 

# Create links data frame - source and target nodes
src <- sample(1:nrow(nodes), nrow(names)*2, replace = TRUE)     # set random source nodes vector 
target <- sample(1:nrow(nodes), nrow(names)*2, replace = TRUE)  # random target nodes vector 
links <- data.frame(src, target) %>%                            # create links data frame 
  filter(!src == target) %>%                                    # remove links with same source & target 
  - 1                                                           # change data frame index to start from 0 (required for NetworkD3) 


########## CREATE NETWORK ##########
# Create the node colors 
ColourScale <- 'd3.scaleOrdinal().range(["#000000", "#0000FF"]);'
# Render the network 
social_net_d3 <- forceNetwork(Links = links, Nodes = nodes, 
             Source = "src", Target = "target", 
             NodeID = "name", 
             Group = "sex", 
             fontSize = 20, zoom = TRUE, 
             linkColour = "black", 
             charge = -500,
             opacityNoHover = 1, 
             colourScale = ColourScale, 
             legend = TRUE) 

show(social_net_d3)


########## LES MIS. NETWORK - EXAMPLE ##########
data("MisLinks")
data("MisNodes")

forceNetwork(Links = MisLinks, 
             Nodes = MisNodes, 
             Source = "source", 
             Target = "target", 
             NodeID = "name", 
             Group = "group", 
             zoom = TRUE, 
             linkColour = "black", 
             charge = -20, 
             opacityNoHover = 1)

