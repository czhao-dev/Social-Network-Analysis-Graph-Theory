ensure_package <- function(package) {
  if (!requireNamespace(package, quietly = TRUE)) {
    stop(
      sprintf("Package '%s' is required. Install it with install.packages('%s').", package, package),
      call. = FALSE
    )
  }
}

ensure_dir <- function(path) {
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
  }
}

write_summary_metrics <- function(summary, path) {
  summary_df <- data.frame(
    metric = names(summary),
    value = unlist(summary, use.names = FALSE),
    row.names = NULL
  )
  write.csv(summary_df, path, row.names = FALSE)
}

safe_diameter <- function(graph) {
  if (igraph::is_connected(graph)) {
    return(igraph::diameter(graph, directed = igraph::is_directed(graph)))
  }
  components <- igraph::components(graph)
  largest_component <- which.max(components$csize)
  largest_vertices <- which(components$membership == largest_component)
  induced <- igraph::induced_subgraph(graph, largest_vertices)
  igraph::diameter(induced, directed = igraph::is_directed(induced))
}

graph_density_safe <- function(graph) {
  if (igraph::vcount(graph) < 2) {
    return(0)
  }
  igraph::edge_density(graph, loops = FALSE)
}
