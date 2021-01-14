# freshwater-conservation-planning

Freshwater conservation planning in the far north of Ontario, Canada: identifying priority watersheds for the conservation of fish biodiversity in an intact boreal landscape

Citation: Southee FM, Edwards BA, Chetkiewicz C-LB, and O’Connor CM. 2021. Freshwater conservation planning in the far north of Ontario, Canada: identifying priority watersheds for the conservation of fish biodiversity in an intact boreal landscape. FACETS 6: 1–28. doi:10.1139/facets-2020-0015

This repository contains the input datasets and R scripts used in the aforementioned paper. Included in this repository are the following datasets: watershed planning units shapefile (planning_units.7z), inputs for the freshwater conservation planning analysis (Inputs folder), R scripts used to develop a cost index based on a PCA of human disturbances known to affect freshwater species (CostIndexPCA folder), and R scripts used to run the prioritizr conservation planning analysis using six different scenarios to meet two area-based conservation targets (17% and 30%) (prioritizr_analysis folder).

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

Copyright M. Southee / WCS Canada 2020.


