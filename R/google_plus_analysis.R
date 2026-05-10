circle_overlap_scores <- function(graph, circles, method = c("walktrap", "infomap")) {
  method <- match.arg(method)
  communities <- detect_communities(graph, method = method)
  community_sets <- igraph::communities(communities)

  scores <- sapply(circles, function(circle) {
    overlaps <- sapply(community_sets, function(community) {
      length(intersect(circle, as_vertex_ids(community)))
    })

    if (sum(overlaps) == 0) {
      return(NA_real_)
    }

    max(overlaps) / sum(overlaps)
  })

  data.frame(
    circle_id = seq_along(circles),
    method = method,
    match_score = as.numeric(scores),
    row.names = NULL
  )
}

read_google_plus_circles <- function(path) {
  lines <- readLines(path, warn = FALSE)
  lapply(lines, function(line) {
    parts <- strsplit(line, "\t")[[1]]
    parts[-1]
  })
}
