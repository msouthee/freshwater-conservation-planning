library(tidyverse)
library(sf)


# SUMMARIZE AREAS
# read planning units geometries
pu_sf <- read_sf("APU_30/output/APU_solutions_SP46.shp")

# load planning units and remove the geometry
pu_solutions <- pu_sf %>%
  st_set_geometry(NULL)

# # write the solution data as a csv
# write_csv(pu_solutions, "APU_30/output/APU_solutions_SP46.csv")

# get the total area for the study area
total_area <- sum(pu_solutions$area_km2)

# generate list of solution levels
solution_levels <- data_frame(level = seq(20, 30, 1)) 

# generate list of solution labels
solution_labels <- str_c("soln_t", solution_levels[[1]])

# generate dataframe of solution labels
solution_labels_df <- data_frame(solution = solution_labels)

# generate list of targets
target_list <-  str_c(solution_levels[[1]], "%")

# Add the targets to the solutions data frame
solution_labels_df <- mutate(solution_labels_df, target = target_list)

# create an empty list
mylist = list()

# Iterate through the solutions to extract the area of the selected planning units
for (i in seq.int(nrow(solution_labels_df))) {
  
  # create current solution label based on solution level
  lbl <- solution_labels_df$solution[i]
  
  # create filter to get selected records for the solution level
  my_filter <- paste0(lbl, ' == 1')
  
  # plug in the variables to get a table of the areas for each solution level
  current_sln <- pu_solutions %>%
    group_by(.dots = lbl) %>%
    summarize(solution_area = sum(area_km2)) %>%
    filter_(.dots = my_filter)
  
  # Extract area for each solution
  sln_area <- current_sln$solution_area
  
  # Append the area of selected planning units to current a list
  mylist <- append(mylist, sln_area)

}

# Add the area of selected planning units from the list to the dataframe
solution_table <- mutate(solution_labels_df, selected_area = as.numeric(mylist))

# Calculate the percent area of each solution
solution_table <- mutate(solution_table, percent_area = selected_area / total_area * 100)

# Write table as csv
output_table <- write_csv(solution_table, "APU_30/results/APU30_area_summary_SP46.csv")

# read in the summary targets table
summary_targets <- read_csv("APU_30/output/summary_targets_SP46.csv") %>%
  mutate(target = target_list)

# join targets and areas table
join_table = inner_join(solution_table, summary_targets, by = 'target')

# write output
output_table <- write_csv(join_table, "APU_30/results/APU30_area_targets_summary_SP46.csv")
