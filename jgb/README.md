# MyPackage: Interactive Exploration of Air Quality Sensor Data

[![CRAN status](https://www.r-pkg.org/badges/version/MyPackage)](https://CRAN.R-project.org/package=MyPackage)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R build status](https://github.com/yourusername/MyPackage/workflows/R-CMD-check/badge.svg)](https://github.com/yourusername/MyPackage/actions)

---

## Overview

**MyPackage** provides a **cleaned dataset from ETC5523 Assignments 3** and an **interactive Shiny application** that allows users to explore, visualize, and analyze the data dynamically. The package is designed for teaching, learning, and interactive data exploration.

- **Dataset:** `sensor_data` — cleaned, structured, and ready for from Prurple Air (kaggle).
- **Shiny app:** launch using `run_app()` to explore the data interactively.
- **Vignettes:** step-by-step examples to reproduce key analyses from previous assignments.

---

## Installation

You can install the development version directly from GitHub:

```r
# install remotes if not already installed
install.packages("remotes")

# install package
remotes::install_github("assignment-4-packages-and-shiny-apps-Janhavi232009/jgb")
