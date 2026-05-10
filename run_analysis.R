local_library <- ".Rlibs"
if (dir.exists(local_library)) {
  .libPaths(c(normalizePath(local_library), .libPaths()))
}

source("R/utils.R")
source("R/load_data.R")
source("R/community_detection.R")
source("R/facebook_analysis.R")
source("R/google_plus_analysis.R")

ensure_package("igraph")

ensure_dir("figures")
ensure_dir("results")

facebook_graph <- load_facebook_graph()
facebook_results <- analyze_facebook_network(
  graph = facebook_graph,
  core_degree_threshold = 200,
  figures_dir = "figures",
  results_dir = "results"
)

write_summary_metrics(facebook_results$summary, "results/summary_metrics.csv")

message("Analysis complete. Results written to results/ and figures/.")
