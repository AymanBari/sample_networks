# How to model a social network with R 
An example of how to model social networks with R. [This article](https://towardsdatascience.com/how-to-model-a-social-network-with-r-878b3a76c5a1) gives a step-by-step explanation of how we build these networks.  
We use two network packages in this example:
* [ggraph](https://www.rdocumentation.org/packages/ggraph/versions/2.0.3)
* [networkD3](https://www.rdocumentation.org/packages/networkD3/versions/0.4)

## Background
There are three main components that we consider when modelling a network:
* **Nodes**: the points in the network (referred to as vertices in graph theory)
* **Links**: the lines that connect the nodes (referred to as edges in graph theory)
* And their **attributes**: encode more information about our network (can be node and/or network attributes)

## Required Libraries  
```r
library(tidyverse)    # Standard - dplyr, tibble, etc. 
library(tidygraph)    # create tbl_graph objects 
library(ggraph)       # Plot tbl_graph objects 
library(igraph)       # Convert tbl_graph object to adjacency matrix 
library(DataCombine)  # FindReplace(), index to names to print links df 
library(networkD3)    # Plotting networks (interactive) 
library(babynames)    # For a list of unique names to add to a social graph 
```
## Steps 
A simple network (without attributes) can be genereated in a few steps: 
1. Create a random set of unique nodes (for a social network, we can use names) 
2. Create a random links - a data frame indicating the source and target nodes of each link  
3. Pass the two to ggraph and render the network 

## Sample Code 
### 1. Random Nodes 
For this, we created a function to get a list of unique names from the [babynames](https://www.rdocumentation.org/packages/babynames/versions/1.0.0) package. This function takes a single parameter - the number of names (nodes) to included in your network. 
```r
# Sample use - get a list of 10 names 
nodes <- get_random_names(10) 
```
### 2. Random links
First we create a source vector (where the link starts), and a target vector (where the link ends):
```r
src <- sample(1:nrow(nodes), nrow(nodes)*2, replace = TRUE)     # set random source nodes vector 
target <- sample(1:nrow(nodes), nrow(nodes)*2, replace = TRUE)  # random target nodes vector 
```
Then we add both vectors into a single data frame to model the links of the network: 
```r
links <- data.frame(src, target) %>%                            # create links df 
  filter(!(src == target))                                      # remove links with same source & target 
links <- unique(links[c("src", "target")])                      # remove duplicate edges 
```
### 3. Render network  
To render the network, we need to create a graph object from the links and nodes dataframes we created:
```r
# Cast from df to table graph object 
social_net_tbls <- tbl_graph(nodes = nodes, edges = links, directed = FALSE) 
```
Now, we just need to pass it to our graphing function (either ggraph or networkD3) to render.  
#### With ggraph:
```r
# Plot network 
social_net <- ggraph(social_net_tbls, layout = "stress") +            # pass graph table, select "stress" layout
  theme_void() +                                                      # Remove default theme 
  geom_edge_link() +                                                  # plot links layer
  geom_node_point(size = 2) +                                         # plot nodes layer 
  geom_node_text(aes(label =  name), nudge_y = 0.05, nudge_x = 0.2)   # add layer with names to plot              

show(social_net)
```
#### With networkD3:
```r
social_net_d3 <- forceNetwork(Links = links, Nodes = nodes, 
             Source = "src", Target = "target", 
             NodeID = "name", 
             Group = "sex", 
             fontSize = 20, zoom = TRUE, 
             linkColour = "black", 
             charge = -500,
             opacityNoHover = 1, 
             legend = TRUE) 

show(social_net_d3)
```
## Results - sample networks
Available [here](https://towardsdatascience.com/how-to-model-a-social-network-with-r-878b3a76c5a1). 

