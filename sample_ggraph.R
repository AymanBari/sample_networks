####################
# Contributor(s): Ayman Bari, 
# 16-June-2020 
# Description: Create social networks with tidygraph and ggraph packages, 
#   Use case - illustration for introduction to networks article: 
#   
####################


##### LOAD LIBRARIES ##### 
library(tidyverse)    # Standard - dplyr, tibble, etc. 
library(tidygraph)    # create tbl_graph objects 
library(ggraph)       # Plot tbl_graph objects 
library(igraph)       # Convert tbl_graph object to adjacency matrix 
library(DataCombine)  # FindReplace(), index to names to print links df


########## FUNCTIONS ########## 
source("sample_network_src.R")


########## CREATE A SOCIAL NETWORK WITH 9 PEOPLE ########## 
# Create nodes df - get random names from 
nodes <- get_random_names(9) 

# Create links df - source and target nodes
src <- sample(1:nrow(nodes), nrow(nodes)*2, replace = TRUE)     # set random source nodes vector 
target <- sample(1:nrow(nodes), nrow(nodes)*2, replace = TRUE)  # random target nodes vector 
links <- data.frame(src, target) %>%                            # create links df 
  filter(!(src == target))                                      # remove links with same source & target 
links <- unique(links[c("src", "target")])                      # remove duplicate edges 


########## CREATE A SOCIAL NETWORK WITH 9 PEOPLE ##########
# Cast from df to table graph object 
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


########## REPLACE INDECIES WITH NAMES IN LINKS DF ##########
# This is for illustrative purposes only. 
# In reality, the links df with index values only can be used to render the graph

# Type cast from num. to char. - required for FindReplace()
links_w_attr$src <- as.character(links_w_attr$src)
links_w_attr$target <- as.character(links_w_attr$target)

# Replace src index with names from nodes df in links df
links_w_attr_names <- FindReplace(data = links_w_attr, 
                              Var = "src", 
                              replaceData = (nodes %>% mutate(index = 1:nrow(nodes))), 
                              from = "index", 
                              to = "name") 

# Replace target index with names from nodes df in links df
links_w_attr_names <- FindReplace(data = links_w_attr_names, 
                                  Var = "target", 
                                  replaceData = (nodes %>% mutate(index = 1:nrow(nodes))), 
                                  from = "index", 
                                  to = "name")  

View(links_w_attr_names)
