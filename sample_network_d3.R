####################
# Contributor(s): Ayman Bari, 
# 16-June-2020 
# Description: Create social networks, 
#   Use case - illustration for introduction to networks article:  
#   
####################


##### LOAD LIBRARIES #####
library(igraph)     # Converting dataframes to graph objects 
library(tidyverse)  # Standard - dplyr, tibble, 
library(networkD3)  # Plotting networks (interactive) 
library(ggraph)     # Plot tbl_graph objects 
library(tidygraph)  # as_tbl_graph -> convert dataframes to table graph objects 
library(babynames)  # For a list of unique names to add to a social graph 


##########FUNCTIONS ########## 
get_random_names <- function(n) { 
  index <- sample(1:nrow(babynames), n, replace = FALSE) 
  names <- babynames[index, ] 
  names 
}


########## CREATE A SOCIAL NETWORK WITH 9 PEOPLE ##########
# Create nodes data frame - get random names from 
nodes <- get_random_names(9) 

# Create links data frame - source and target nodes
src <- sample(1:nrow(names), nrow(names)*2, replace = TRUE)     # random source nodes 
target <- sample(1:nrow(names), nrow(names)*2, replace = TRUE)  # random target nodes 
links <- data.frame(src, target) %>%                            # create links df 
  filter(!src == target) %>%                                    # remove links with same source & target 
  - 1                                                           # change df index to start from 0 (required for NetworkD3)


########## CREATE NETWORK ##########
ColourScale <- 'd3.scaleOrdinal().range(["#000000", "#0000FF"]);'

forceNetwork(Links = links, Nodes = nodes, 
             Source = "src", Target = "target", 
             NodeID = "name", 
             Group = "sex", 
             fontSize = 20, zoom = TRUE, 
             linkColour = "black", 
             charge = -500,
             opacityNoHover = 1, 
             colourScale = ColourScale, 
             legend = TRUE
             ) 


##################################################
# Snippet refrence
# Source: http://curleylab.psych.columbia.edu/netviz/netviz2.html#/12
# Date accessed: 18.06.2020
# D3 pallete codes: https://observablehq.com/@d3/color-schemes  

### Adding a colorScale
# library(RColorBrewer)
# scalecolors <- function(nodes, palette) {
#   n <- length(unique(nodes$year))
#   cols <- rev(RColorBrewer::brewer.pal(n, palette))
#   cols <- paste0("'", paste(cols, collapse = "', '"), "'")
#   networkD3::JS(paste0('d3.scale.ordinal().domain([0,', n, ']).range([', cols, '])'))
# }
# 
# scalecolors(nodes, 'YlOrRd')

# Used in edges_to_names function 
########################################




