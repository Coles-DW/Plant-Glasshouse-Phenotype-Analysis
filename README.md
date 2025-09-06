# Plant Glasshouse Phenotype Analysis

This repository contains R scripts for analyzing treatment and nutrient effects on plant phenotypes, including disease scores, root growth, and shoot growth. 

## Repository Contents

- `phenotype_analysis.R` : R script performing data import, visualization, statistical models, and contrasts.
- `phenotype_analysis.RData` : Saved workspace after analysis.
- `rawdata/` : Folder to store raw phenotype data (example CSV/XLSX files).

## Requirements

- R >= 4.0
- R packages:
  - tidyverse, ggeffects, car, emmeans, patchwork, readxl

Install packages with:

```r
install.packages(c("tidyverse", "ggeffects", "car", "emmeans", "patchwork", "readxl"))

Usage

Clone the repository:

git clone https://github.com/Coles-DW/Plant-Glasshouse-Phenotype-Analysis.git


Place your phenotype data in rawdata/.

Update file names in phenotype_analysis.R as needed.

Run the R script to generate plots, models, ANOVA, and treatment contrasts.

Outputs

Boxplots of disease score, root weight, and shoot weight

Linear and generalized linear model summaries

ANOVA results and treatment contrasts

Estimated marginal means plots

R workspace file phenotype_analysis.RData

License

MIT License
