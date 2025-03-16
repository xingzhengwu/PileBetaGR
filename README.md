
<!-- README.md is generated from README.Rmd. Please edit that file -->

# PileBetaGR

<!-- badges: start -->

<!-- badges: end -->

The PileBetaGR software is a statistical package that enables the independent use of geometric reliability methods used in exploratory load settlement data analysis. Please refer to the publication on this package: https://doi.org/10.1016/j.softx.2025.102123 

## Installation

You can install the released version of PileBetaGR from
[GitHub](https://github.com/) with:

``` r
library(remotes)
install_github("xingzhengwu/PileBetaGR")
```

## Example

This is a basic example which shows you how to solve a common problem:


```r
library("PileBetaGR")

	data(CurveMihalikQpssBridge)
	CurveMihalikQpssBridge
	data(P1P2MihalikRegPars)
	P1P2MihalikRegPars

#
https://github.com/xingzhengwu/PileBetaGR/blob/main/docs/PileBetaGR_4.3.2.pdf

# Run Shiny web application 
runShinyPileBetaGR()
```
