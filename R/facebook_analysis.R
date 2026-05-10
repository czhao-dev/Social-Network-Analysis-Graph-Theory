analyze_facebook_network <- function(graph, core_degree_threshold, figures_dir, results_dir) {
  degrees <- igraph::degree(graph)
  core_threshold <- min(core_degree_threshold, max(degrees))
  core_nodes <- names(degrees)[degrees >= core_threshold]

  summary <- list(
    vertices = igraph::vcount(graph),
    edges = igraph::ecount(graph),
    connected = igraph::is_connected(graph),
    diameter_or_largest_component_diameter = safe_diameter(graph),
    average_degree = mean(degrees),
    max_degree = max(degrees),
    core_degree_threshold = core_threshold,
    core_node_count = length(core_nodes)
  )

  plot_degree_distribution(degrees, file.path(figures_dir, "facebook_degree_distribution.png"))

  core_df <- data.frame(
    vertex = core_nodes,
    degree = as.numeric(degrees[core_nodes]),
    row.names = NULL
  )
  core_df <- core_df[order(core_df$degree, decreasing = TRUE), ]
  write.csv(core_df, file.path(results_dir, "facebook_core_nodes.csv"), row.names = FALSE)

  ego_vertex <- choose_ego_vertex(graph, degrees)
  ego_graph <- igraph::make_ego_graph(graph, order = 1, nodes = ego_vertex)[[1]]
  plot_ego_network(ego_graph, ego_vertex, file.path(figures_dir, "facebook_ego_network.png"))

  communities <- detect_communities(ego_graph, method = "fast_greedy")
  community_df <- community_summary(ego_graph, communities)
  write.csv(community_df, file.path(results_dir, "facebook_ego_communities.csv"), row.names = FALSE)

  embeddedness_df <- embeddedness_scores(ego_graph, ego_vertex)
  dispersion_df <- dispersion_scores(ego_graph, ego_vertex)
  social_scores <- merge(embeddedness_df, dispersion_df, by = "vertex", all = TRUE)
  social_scores$dispersion_to_embeddedness <- ifelse(
    social_scores$embeddedness > 0,
    social_scores$dispersion / social_scores$embeddedness,
    NA
  )
  write.csv(social_scores, file.path(results_dir, "facebook_ego_social_scores.csv"), row.names = FALSE)

  list(
    summary = summary,
    core_nodes = core_df,
    ego_communities = community_df,
    ego_social_scores = social_scores
  )
}

choose_ego_vertex <- function(graph, degrees) {
  if ("1" %in% igraph::V(graph)$name) {
    return("1")
  }
  names(which.max(degrees))
}

plot_degree_distribution <- function(degrees, path) {
  png(path, width = 1200, height = 800, res = 150)
  hist(
    degrees,
    breaks = 30,
    col = "#4C78A8",
    border = "white",
    main = "Facebook Degree Distribution",
    xlab = "Degree",
    ylab = "Node Count"
  )
  dev.off()
}

plot_ego_network <- function(graph, ego_vertex, path) {
  communities <- detect_communities(graph, method = "fast_greedy")
  membership <- igraph::membership(communities)
  colors <- membership
  colors[igraph::V(graph)$name == ego_vertex] <- max(membership) + 1

  png(path, width = 1200, height = 900, res = 150)
  plot(
    graph,
    vertex.size = ifelse(igraph::V(graph)$name == ego_vertex, 7, 4),
    vertex.color = colors,
    vertex.label = NA,
    edge.color = "#B8B8B8",
    main = "Ego Network Community Structure"
  )
  dev.off()
}
