# Package: Interactive Exploration of Air Quality Sensor Data

[![CRAN status](https://www.r-pkg.org/badges/version/MyPackage)](https://CRAN.R-project.org/package=MyPackage)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R build status](https://github.com/yourusername/MyPackage/workflows/R-CMD-check/badge.svg)](https://github.com/ETC5523-2025/assignment-4-packages-and-shiny-apps-Janhavi232009/tree/main/jgb)

---

## Overview

MyPackage provides a cleaned dataset from ETC5523 Assignments 3 based on the [article](https://www.theguardian.com/technology/2022/nov/20/amazon-warehouse-new-york-brooklyn-red-hook) and an interactive Shiny application that allows users to explore, visualize, and analyze the data dynamically. The package is designed for teaching, learning, and interactive data exploration.

- **Dataset:** `sensor_data` — cleaned, structured, and ready for from Purple Air (kaggle).
- **Shiny app:** launch using `launch_app()` to explore the data interactively.

---

## Installation

You can install the development version directly from GitHub:

```r
# install remotes if not already installed
install.packages("remotes")

# install package
remotes::install_github("ETC5523-2025/assignment-4-packages-and-shiny-apps-Janhavi232009/jgb")

# Load the package
library(jgb)

```
## Usage

1. Load the dataset

```r
data(sensor_data, package = "jgb")
head(sensor_data)
```

2. Lauch the interactive Shiny 

```r
launch_app()
```
This opens a browser window with the interactive air-quality dashboard, where you can:

- Select sensors or time periods

- View dynamic plots of PM2.5 levels

- Compare air-quality metrics across groups

- Interpret data interactively

## Documentation and Website

Full documentation, including function references, dataset details, and vignettes, is available on the pkgdown site:
https://etc5523-2025.github.io/assignment-4-packages-and-shiny-apps-Janhavi232009/index.html
