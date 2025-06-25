# 📊 Psychometric Item Analysis Dashboard

This is an interactive R Shiny application for exploring psychometric item-level data, including item difficulty, discrimination, and content domain trends over time. It was designed as a prototype tool for internal assessment and psychometric review, similar to use cases at certifying organizations like NCCPA.

## 🚀 Features

- Interactive filters by content domain and test date  
- Scatterplot of item difficulty vs. discrimination  
- Time-series plot of average item metrics  
- Summary statistics and downloadable filtered data  
- Built with `shiny`, `plotly`, `ggplot2`, `DT`, and `dplyr`

## 🗂️ Data

The app uses a mock dataset (`psychometric_items.csv`) containing the following fields:

- `ItemID`: Unique identifier for each exam item  
- `Difficulty`: Proportion correct (0 to 1)  
- `Discrimination`: Point-biserial correlation  
- `ContentDomain`: Item topic classification  
- `TestDate`: Date of item administration

## 📦 Installation

Clone this repository and open the project in RStudio:

```bash
git clone https://github.com/yourname/psychometric-dashboard.git
