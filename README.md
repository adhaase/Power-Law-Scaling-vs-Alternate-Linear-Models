# Power-Law-Scaling-vs-Alternate-Linear-Models
R script which cleans and analyzes a dataset from the U.S. Bureau of Economic Analysis describing MSAs regarding the viability of the Power Law Scaling Proposal vs. competing linear models.

# Statistical Methods contained in analysis:
*  Created visuals via ggplot2 regarding residual plots for normal and homoskedastic error
*  Calculated squared error loss on the log scale
*  Applied k-fold (5-fold) cross validation to gauge error estimates per polynomial
*  Fit alternate linear models for the data as GLMs
*  Conducted hypothesis testing via ANOVA.   
