read_edge_list_graph <- function(path, directed = FALSE) {
  if (!file.exists(path)) {
    stop(sprintf("Edge list not found: %s", path), call. = FALSE)
  }

  edges <- read.table(path, header = FALSE, stringsAsFactors = FALSE)
  if (ncol(edges) < 2) {
    stop(sprintf("Expected at least two columns in edge list: %s", path), call. = FALSE)
  }

  graph <- igraph::graph_from_data_frame(edges[, 1:2], directed = directed)
  igraph::simplify(graph, remove.multiple = TRUE, remove.loops = TRUE)
}

load_facebook_graph <- function() {
  full_path <- "data/raw/facebook_combined.txt"
  sample_path <- "data/sample/facebook_sample_edges.txt"

  if (file.exists(full_path)) {
    message("Loading full Facebook edge list from data/raw/facebook_combined.txt")
    return(read_edge_list_graph(full_path, directed = FALSE))
  }

  message("Full Facebook edge list not found; using sample data.")
  read_edge_list_graph(sample_path, directed = FALSE)
}

load_google_plus_graph <- function(path = "data/sample/google_plus_sample_edges.txt") {
  read_edge_list_graph(path, directed = TRUE)
}
