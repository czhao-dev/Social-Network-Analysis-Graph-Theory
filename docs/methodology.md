# Methodology

## Graph Representation

Each social network is represented as an edge-list graph. Facebook relationships are treated as undirected ties. Google+ relationships are treated as directed ties when ego-network files are available.

## Network-Level Metrics

The analysis computes:

- Number of vertices and edges
- Connectivity
- Diameter, or diameter of the largest connected component when the graph is disconnected
- Average and maximum degree
- Core nodes above a configurable degree threshold

## Ego Networks

An ego network is the induced subgraph containing one focal user and that user's immediate neighbors. Ego networks make it possible to inspect local social structure around highly connected or representative users.

## Community Detection

The pipeline supports several `igraph` community detection methods:

- Fast-Greedy
- Edge-Betweenness
- Infomap
- Walktrap

Fast-Greedy is used as the default for the Facebook ego-network summary because it is efficient on undirected graphs and produces interpretable local communities.

## Embeddedness and Dispersion

Embeddedness measures how many mutual neighbors two connected users share. Dispersion estimates how spread out those mutual neighbors are inside the ego network. Together, the two metrics help distinguish close-knit relationships from bridge-like relationships across social contexts.

## Google+ Circle Matching

When Google+ `.circles` files are available, detected communities can be compared with user-defined circles. For each circle, the match score is the largest overlap with any detected community divided by the total overlap across communities.
