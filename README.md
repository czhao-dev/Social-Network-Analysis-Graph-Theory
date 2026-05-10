# Community Detection in Social Networks

This project analyzes large-scale online social networks through the lens of graph theory. It uses Facebook and Google+ style social graph data to study how communities form, how influential core users shape local neighborhoods, and how algorithmic community detection compares with user-defined groups.

The repository is organized as a reproducible portfolio project. It includes a modular R analysis pipeline, small sample data for quick runs, documentation for sourcing the original public datasets, and generated result/figure directories.

## Project Goals

- Measure structural properties of social graphs, including connectivity, diameter, degree distribution, and core nodes.
- Build ego networks around highly connected users to inspect local community structure.
- Compare community detection methods such as Fast-Greedy, Edge-Betweenness, Infomap, and Walktrap.
- Compute social-network metrics such as embeddedness and dispersion.
- Evaluate how detected Google+ communities align with user-defined circles when circle metadata is available.

## Key Techniques

- Graph construction from edge lists
- Degree distribution analysis
- Ego-network extraction
- Core-node identification
- Community detection with `igraph`
- Embeddedness and dispersion scoring
- Community-level summaries using size, density, modularity, clustering coefficient, betweenness, and assortativity

## Repository Structure

```text
.
├── .gitignore
├── LICENSE
├── README.md
├── run_analysis.R
├── R/
│   ├── community_detection.R
│   ├── facebook_analysis.R
│   ├── google_plus_analysis.R
│   ├── load_data.R
│   └── utils.R
├── data/
│   ├── README.md
│   └── sample/
│       ├── facebook_sample_edges.txt
│       └── google_plus_sample_edges.txt
├── docs/
│   └── methodology.md
├── figures/
│   └── .gitkeep
├── report/
│   └── case_study.md
└── results/
    └── .gitkeep
```

## Data

The original analysis was designed for public SNAP social-network datasets:

- Facebook combined ego-network edge list
- Google+ ego-network edge and circle files

Large raw datasets are intentionally not committed to this repository. See [data/README.md](data/README.md) for download and placement instructions. The small files in `data/sample/` let the pipeline run quickly and demonstrate the analysis workflow.

## Quick Start

Install R and the `igraph` package:

```r
install.packages("igraph")
```

Run the sample analysis:

```r
source("run_analysis.R")
```

Outputs are written to:

- `results/summary_metrics.csv`
- `results/facebook_core_nodes.csv`
- `figures/facebook_degree_distribution.png`
- `figures/facebook_ego_network.png`

## Running With Full Data

Place full raw data files under `data/raw/`:

```text
data/raw/facebook_combined.txt
data/raw/gplus/
```

Then run:

```r
source("run_analysis.R")
```

The pipeline automatically uses the full Facebook edge list when `data/raw/facebook_combined.txt` exists; otherwise it falls back to the included sample file.

## Skills Demonstrated

This project demonstrates the ability to:

- Translate real social data into graph representations.
- Design reproducible analytical workflows.
- Compare graph algorithms empirically.
- Communicate technical results through clear metrics, figures, and documentation.

## Limitations

The sample data is intentionally tiny and is only meant to verify the workflow. Meaningful conclusions require the full public datasets. Google+ circle matching also requires per-user `.edges` and `.circles` files, not just a combined edge list.

## License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for the full license text.
