####################
# Contributor(s): Ayman Bari, 
# 16-June-2020 
# Description: Create social networks with tidygraph and ggraph packages, 
#   Use case - illustration for introduction to networks article: 
#   
####################


##### LOAD LIBRARIES ##### 
library(tidyverse)  # Standard - dplyr, tibble, etc. 
library(tidygraph)  # create tbl_graph objects 
library(ggraph)     # Plot tbl_graph objects 
library(igraph)     # Convert tbl_graph object to adjacency matrix 
library(babynames)  # For a list of unique names to add to a social graph 


########## CREATE A SOCIAL NETWORK WITH 9 PEOPLE ########## 
# Create nodes data frame - get random names from 
nodes <- get_random_names(9) 

# Create links data frame - source and target nodes
src <- sample(1:nrow(nodes), nrow(nodes)*2, replace = TRUE)     # set random source nodes vector 
target <- sample(1:nrow(nodes), nrow(nodes)*2, replace = TRUE)  # random target nodes vector 
links <- data.frame(src, target) %>%                            # create links data frame 
  filter(!(src == target))                                      # remove links with same source & target 
links <- unique(links[c("src", "target")])                      # remove duplicate edges 


########## CREATE A SOCIAL NETWORK WITH 9 PEOPLE ##########
# Cast from data frame to table graph object 
social_net_tbls <- tbl_graph(nodes = nodes, edges = links, directed = FALSE) 

# Plot network 
social_net <- ggraph(social_net_tbls, layout = "stress") +            # pass graph table, select "stress" layout
  theme_void() +                                                      # Remove default theme 
  geom_edge_link() +                                                  # plot links layer
  geom_node_point(size = 2) +                                         # plot nodes layer 
  geom_node_text(aes(label =  name), nudge_y = 0.05, nudge_x = 0.2)   # add layer with names to plot              

show(social_net)

# View adjacency matrix of table
as_adjacency_matrix(social_net_tbls, sparse = FALSE) 


########## ADD LINK ATTRIBUTES TO SOCIAL NETWORK ##########
# Adding attribute to links table (link_type = friends or contacts) 
links_w_attr <- links %>% mutate( 
    link_type = ifelse( 
      sample(c("friend", "contact"), 
             nrow(links), replace = TRUE, 
             prob = c(0.1, 0.9) 
             ) == "contact", 
      1, 2)) 

social_net_tbl_attrs <- tbl_graph(nodes = nodes, edges = links_w_attr, directed = FALSE) 

social_net_link_attr <- ggraph(social_net_tbl_attrs, layout = "stress") + 
  theme_void() + 
  geom_edge_link(aes(edge_width = links_w_attr$link_type), show.legend = F) + 
  scale_edge_width(range = c(1, 2)) + 
  geom_node_point(aes(color = sex), size = 2) + 
  geom_node_text(aes(label =  name), nudge_y = 0.05, nudge_x = 0.4) 

show(social_net_link_attr) 

