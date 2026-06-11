# mcPHASES Exploratory Analysis

Exploratory analysis of the mcPHASES dataset — a longitudinal, multimodal record of menstrual health integrating wearable physiological signals, urinary hormone measurements, continuous glucose monitoring, and daily self-reported symptoms from 42 participants over 3–6 months.

**Dataset:** Mariakakis et al., Scientific Data 2026 
https://www.nature.com/articles/s41597-026-06805-3

## Setup

### 1. Get the data
Download the dataset from the link above and place all CSV files in `data/raw/`. This folder is gitignored: data is not included in the repository, in accordance with the DUA.

### 2. Restore R environment
```r
install.packages("renv")
renv::restore()
```

### 3. Run analyses
Quarto notebooks are in `analysis/`. SQL queries are in `sql/`.

## Stack
R | DuckDB | SQL | Quarto | ggplot2

## Structure
- `sql/` — data assembly and exploration queries
- `R/` — reusable functions
- `analysis/` — Quarto notebooks
- `outputs/figures/` — final plots