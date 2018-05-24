# Power Law Scaling vs Alternate Linear Models
R script which cleans and analyzes a dataset from the U.S. Bureau of Economic Analysis describing MSAs regarding the viability of the Power Law Scaling Proposal vs. competing linear models.

## Statistical Methods contained in analysis:
*  Created visuals via ggplot2 regarding residual plots for normal and homoskedastic error
*  Calculated squared error loss on the log scale
*  Applied k-fold (5-fold) cross validation to gauge error estimates per polynomial
*  Fit alternate linear models for the data as GLMs
*  Conducted hypothesis testing via ANOVA.   

## Overview
  U.S. statistical agencies divided the United States into hundreds of metropolitan statistical
areas for economic analysis. It is estimated that these MSA’s contribute to the country’s gross
domestic product, which in turn yield gross metropolitan products.

  My hypothesis is based around the disagreement of the power law scaling proposition, and I
assume that the finance and ict variables have the most significant impact on GMP. I agree with the competing theory to the supra-linear power law scaling proposition. It seems more reasonable that moving alone is not the only factor to attribute to economic productivity; it
can also be attributed to current financial establishments and concentrations, along with
information, communication, and technology.

The goal of my research is to assess the validity of this statement. Based on: GMP follows a
supra-linear power law scaling model or if larger MSA’s GMP’s stem from different types of
economic activity by utilizing alternate models predicting GMP as a linear function of population
size, comparing the model’s fit to the MSA data using loss functions, and offering an assessment of
the power-law scaling model relative to other models of GMP. By regressing over the different
primary and second variables in the dataset, it will clarify whether or not GMP follows a supralinear
power law scaling model, or instead is more attributed to a specific economic activity
concentration.

## Methodology
### Dealing with Missing Data
The original dataset had multiple fields with missing data denoted as “NA” in the
dataframes: finance, prof.tech, ict, management. In order to obtain an accurate analysis and viable
working environment, it was necessary for me omit these fields. It is important to consider the
aspect of how missing data on our relevant variables impacts the overall analysis. Therefore, to
investigate this missingness, I summarized the proportions of the data by each variable and on
pairs of variable that were representative of my hypothesis. Blindly using an incomplete dataset
may yield biased results; it was first necessary to clean the dataset and proceed with a cautionary
approach to the overall analysis.

### Initial Model Generation
Initial graphical analysis via scatterplot was generated with ggplot2. The reproducibility
appendix contains plots: GMP vs Pop, log(GMP) vs Pop, and log(GMP) vs log(Pop). I chose to utilize
the value of the logarithm because of the distinction between these three plots, which led me to
pursue that variation with my remaining models. The reproducibility appendix provides the visual
representation of the former two comparisons, with heavy clusterization near the axis origin. The
close correlation in the dual log plot was my primary motive for utilizing the logarithm when
characterizing the datasets primary variables.

### Residuals and Relationship Between the Power Law Scaling Model

//TODO
