
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Download and clean GBIF occurrences <img src="https://raw.githubusercontent.com/FRBCesab/templates/main/logos/compendium-sticker.png" align="right" style="float:right; height:120px;"/>

<!-- badges: start -->

[![License: GPL (\>=
2)](https://img.shields.io/badge/License-GPL%20%28%3E%3D%202%29-blue.svg)](https://choosealicense.com/licenses/gpl-2.0/)
<!-- badges: end -->

<p align="left">
• <a href="#overview">Overview</a><br> • <a href="#data-sources">Data
sources</a><br> • <a href="#workflow">Workflow</a><br> •
<a href="#content">Content</a><br> •
<a href="#prerequisites">Prerequisites</a><br> •
<a href="#installation">Installation</a><br> •
<a href="#usage">Usage</a><br> • <a href="#citation">Citation</a><br> •
<a href="#contributing">Contributing</a><br> •
<a href="#acknowledgments">Acknowledgments</a><br> •
<a href="#references">References</a>
</p>

## Overview

This project aims to provide an unified workflow to retrieve and clean
GBIF occurrences for a given list of species. Occurrences are finally
aggregated on a World grid to compute species range sizes (number of
cells) and species richness.

## Data sources

This project uses the following databases:

| Database      | Usage                               | Reference       |                   Link                   |
|:--------------|:------------------------------------|:----------------|:----------------------------------------:|
| GBIF          | Get fish occurrences at World scale | GBIF.org (2024) |      [link](https://www.gbif.org/)       |
| Natural Earth | Create a World grid                 | None            | [link](https://www.naturalearthdata.com) |

A comprehensive description of all these databases is available
[here](https://github.com/frbcesab/gbif-bulk/blob/main/data/README.md).

## Workflow

The analysis pipeline follows these steps:

1.  Find GBIF accepted names & identifiers from a list of accepted names
2.  Download GBIF occurrences
3.  Clean GBIF occurrences
4.  Create a world grid (spatial raster)
5.  Intersect GBIF occurrences w/ a World raster
6.  Compute species range size
7.  Compute species richness

## Content

This repository is structured as follow:

- [`DESCRIPTION`](https://github.com/frbcesab/gbif-bulk/blob/main/DESCRIPTION):
  contains project metadata (author, description, license, dependencies,
  etc.).

- [`make.R`](https://github.com/frbcesab/gbif-bulk/blob/main/make.R):
  main R script to set up and run the entire project. Open this file to
  follow the workflow step by step.

- [`R/`](https://github.com/frbcesab/gbif-bulk/blob/main/R): contains R
  functions developed especially for this project.

- [`data/`](https://github.com/frbcesab/gbif-bulk/blob/main/data):
  contains raw data used in this project. See the
  [`README`](https://github.com/frbcesab/gbif-bulk/blob/main/data/README.md)
  for further information.

- [`analyses/`](https://github.com/frbcesab/gbif-bulk/blob/main/analyses):
  contains R scripts to run the workflow. The order to run these scripts
  is explained in the
  [`make.R`](https://github.com/frbcesab/gbif-bulk/blob/main/make.R) and
  the description of each script is available in the header of each
  file.

- [`outputs/`](https://github.com/frbcesab/gbif-bulk/blob/main/outputs):
  contains the outputs of the project. See the
  [`README`](https://github.com/frbcesab/gbif-bulk/blob/main/outputs/README.md)
  for a complete description of the files.

## Prerequisites

### System requirements

This project handles spatial objects with the R packages
[`sf`](https://r-spatial.github.io/sf/) and
[`terra`](https://rspatial.github.io/terra/) and require some additional
software: GDAL, GEOS, and PROJ.

### GBIF account

A GBIF account is required to download GBIF occurrences as ZIP files.
First, create a GBIF account by visiting this page
<https://www.gbif.org/user/profile>. Then, store your login information
locally in the `~/.Renviron` file. Use the function
`usethis::edit_r_environ()` to create/open this file and add the
following three lines:

    GBIF_USER='your_username'
    GBIF_PWD='your_password'
    GBIF_EMAIL='your_email'

Restart R, and check if everything is ok:

``` r
Sys.getenv("GBIF_USER")
Sys.getenv("GBIF_PWD")
Sys.getenv("GBIF_EMAIL")
```

## Installation

To install this compendium:

- [Fork](https://docs.github.com/en/get-started/quickstart/contributing-to-projects)
  this repository using the GitHub interface.
- [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
  your fork using `git clone fork-url` (replace `fork-url` by the URL of
  your fork). Alternatively, open [RStudio
  IDE](https://posit.co/products/open-source/rstudio/) and create a New
  Project from Version Control.

## Usage

Launch the
[`make.R`](https://github.com/frbcesab/gbif-bulk/blob/main/make.R) file
with:

``` r
source("make.R")
```

**Notes**

- All required packages listed in the
  [`DESCRIPTION`](https://github.com/frbcesab/gbif-bulk/blob/main/DESCRIPTION)
  file will be installed (if necessary)
- All required packages and R functions will be loaded
- Each script in
  [`analyses/`](https://github.com/frbcesab/gbif-bulk/blob/main/analyses)
  can be run independently
- Some steps listed in the
  [`make.R`](https://github.com/frbcesab/gbif-bulk/blob/main/make.R)
  might take time (several hours)

## Citation

Please use the following citation:

> Casajus N (2024) An unified workflow to retrieve and clean GBIF
> occurrences. URL: <https://github.com/frbcesab/gbif-bulk/>.

## Contributing

All types of contributions are encouraged and valued. For more
information, check out our [Contributor
Guidelines](https://github.com/frbcesab/gbif-bulk/blob/main/CONTRIBUTING.md).

Please note that this project is released with a [Contributor Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## Acknowledgments

This project has been developed for
[FRB-CESAB](https://www.fondationbiodiversite.fr/en/about-the-foundation/le-cesab/)
[research
groups](https://www.fondationbiodiversite.fr/en/the-frb-in-action/programs-and-projects/le-cesab/).

## References

GBIF.org (2024) GBIF Home Page. Available from: <https://www.gbif.org>
\[25 March 2024\].
