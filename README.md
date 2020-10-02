# freshwater-conservation-planning
Ontario Northern Boreal - Prioritizr Freshwater Conservation Planning Analysis Repository

This repository contains the datasets and scripts used in a freshwater conservation planning analysis in Ontario's Northern Boreal conducted by WCS Canada. It includes a shapefile of the watershed planning units (planning_units.7z), the inputs for the freshwater conservation planning analysis (Inputs folder), and the R scripts that were used to develop a cost index based on a PCA of human disturbances known to affect freshwater species (CostIndexPCA folder), and the R scripts run the prioritiz conservation planning analysis using six different scenarios to meet two area-based conservation targets (17% and 30%) (prioritizr_analysis folder).

Description of files in the prioritizr_analysis folder:
01_APU_ANALYSIS = initial conservation planning analyses with targets ranging from 10-90% species representation
02_APU_Summarize = summary of results from initinal conservation planning analyses
03_APU_17_ANALYSIS = conservation planning analysis to meet the 17% area-based target
04_APU_17_Summarize = summary of resuts from conservtation planning analysis to meet 17% area-based target
06_APU_30_ANALYSIS = conservation planning analysis to meet the 30% area-based target
07_APU_30_Summarize = summary of resuts from conservtation planning analysis to meet 30% area-based target


Scenario List based on R script suffix:
No suffix = Freshwater fish biodiversity scenario (i.e. 30 species)
PA_LOCKED_IN = Freshwater fish biodiversity scenario (i.e. 30 species) with protected areas locked in
SP01_Lake_Sturgeon = Focal species scenario - Lake Sturgeon
SP09_Lake_Whitefish = Focal species scenario - Lake Whitefish
SP42_Brook_Trout = Focal species scenario - Brook Trout
SP46_Walleye = Focal species scenario - Walleye

Copyright M. Southee / WCS Canada 2020
