detect_communities <- function(graph, method = c("fast_greedy", "edge_betweenness", "infomap", "walktrap")) {
  method <- match.arg(method)

  if (method == "fast_greedy") {
    return(igraph::cluster_fast_greedy(igraph::as_undirected(graph)))
  }
  if (method == "edge_betweenness") {
    return(igraph::cluster_edge_betweenness(igraph::as_undirected(graph)))
  }
  if (method == "infomap") {
    return(igraph::cluster_infomap(graph))
  }

  igraph::cluster_walktrap(graph)
}

as_vertex_ids <- function(vertices) {
  if (inherits(vertices, "igraph.vs")) {
    return(igraph::as_ids(vertices))
  }
  as.character(vertices)
}

community_summary <- function(graph, communities) {
  membership <- igraph::membership(communities)
  community_ids <- sort(unique(membership))

  rows <- lapply(community_ids, function(id) {
    vertices <- names(membership)[membership == id]
    subgraph <- igraph::induced_subgraph(graph, vertices)
    clustering <- igraph::transitivity(subgraph, type = "globalundirected")
    if (is.na(clustering)) {
      clustering <- 0
    }

    data.frame(
      community_id = id,
      size = igraph::vcount(subgraph),
      density = graph_density_safe(subgraph),
      clustering_coefficient = clustering,
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, rows)
}

embeddedness_scores <- function(ego_graph, ego_vertex) {
  neighbors <- igraph::as_ids(igraph::neighbors(ego_graph, ego_vertex))

  scores <- sapply(neighbors, function(vertex) {
    vertex_neighbors <- igraph::as_ids(igraph::neighbors(ego_graph, vertex))
    length(intersect(neighbors, vertex_neighbors))
  })

  data.frame(
    vertex = names(scores),
    embeddedness = as.numeric(scores),
    row.names = NULL
  )
}

dispersion_scores <- function(ego_graph, ego_vertex) {
  neighbors <- igraph::as_ids(igraph::neighbors(ego_graph, ego_vertex))

  scores <- sapply(neighbors, function(vertex) {
    vertex_neighbors <- igraph::as_ids(igraph::neighbors(ego_graph, vertex))
    mutual <- intersect(
      neighbors,
      vertex_neighbors
    )

    if (length(mutual) < 2) {
      return(0)
    }

    mutual_graph <- igraph::induced_subgraph(ego_graph, mutual)
    distances <- igraph::distances(mutual_graph)
    distances[is.infinite(distances)] <- 0
    sum(distances) / 2
  })

  data.frame(
    vertex = names(scores),
    dispersion = as.numeric(scores),
    row.names = NULL
  )
}
