
<!-- README.md is generated from README.Rmd. Please edit that file -->

# qgshiny

[![Travis-CI Build
Status](https://travis-ci.org/neyhartj/qgshiny.svg?branch=master)](https://travis-ci.org/neyhartj/qgshiny)  
<!-- [![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/qgshiny)](https://cran.r-project.org/package=qgshiny) -->

## Author

Jeff Neyhart

## Description

This is an R package that includes a Shiny Application for teaching
introductory quantitative genetics through interactive simulations. This
app was first designed for the HORT/AGRO 4401 course at the University
of Minnesota, however it may be widely applicable.

## Installation

You may install the stable version of the package from CRAN by running:

    install.packages("qgshiny")

Alternatively, you can install the developmental version from GitHub by
using the `devtools` package:

    devtools::install_github("neyhartj/qgshiny")

## Run the App

### Local installation and deployment

To run the Shiny App locally, load the `qgshiny` package and use the
`run_example()` function:

    library(qgshiny)
    
    run_qgshiny()

### shinyapps.io deployment

This application may also be accessed remotely from the shinyapps.io
platform [here](https://neyhartj.shinyapps.io/qgshiny/)

<!-- ## Read More -->

<!-- The development of `qgshiny` is described in detail in a paper submitted to the journal *Natural Sciences Education*, available [here]. -->

<!-- ## Teaching Material -->

<!-- I have written a lab worksheet to accompany the shiny app. You may access the PDF [here](https://github.com/neyhartj/qgdemo/raw/master/teaching_materials/qgdemo_problem_set.pdf) and a copy of the intendend answer key [here](https://github.com/neyhartj/qgdemo/raw/master/teaching_materials/qgdemo_problem_set_answers.pdf). -->

## Support and Feature Requests

To request a new module or to fix a bug, please [email
me](mailto:neyhartje@gmail.com) or [open an
issue](https://github.com/neyhartj/qgshiny/issues/new) on GitHub.
