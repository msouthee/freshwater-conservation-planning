library(tidyverse)
library(sf)


# SUMMARIZE SPECIES TARGETS

# read solutions
s <- readRDS("APU_17/output/APU_solutions_PAs.rds")

# spread out the average representation by species and target
s_repr_spread <- unnest(s, repr) %>%
  group_by(species, target) %>%
  summarize(average_repr = pct_representation) %>%
  # change formatting 
  mutate(target = scales::percent(target, prefix = "Target ", accuracy = 1))  %>%
  mutate(average_repr = scales::percent(average_repr)) %>%
  spread(target, average_repr)

# load species data
species <- read_csv("species.csv") %>%
  # set all column headings to lower case
  rename_all(tolower) %>%
  # strip the SP characters from the species codes and leave only number values with leading zeros
  separate(id, c("S", "id"), sep = "([P])") %>%
  # select only the species code id and the species name columns
  select(id, name) %>%
  mutate(id = as.integer(id)) %>%
  rename(species = id)

# join the species names to the output
species_targets_spread <- left_join(species, s_repr_spread, by = "species")

# write summary tables to output file
write_csv(species_targets_spread, "APU_17/results/APU17_representation_targets_by_species_PAs.csv")


# SUMMARIZE AREAS
# read planning units geometries
pu_sf <- read_sf("APU_17/output/APU_solutions_PAs.shp")

# load planning units and remove the geometry
pu_solutions <- pu_sf %>%
  st_set_geometry(NULL)

# # write the solution data as a csv
# write_csv(pu_solutions, "APU_17/output/APU_solutions_PAs.csv")

# get the total area for the study area
total_area <- sum(pu_solutions$area_km2)

# generate list of solution levels
solution_levels <- data_frame(level = seq(10, 20, 1)) 

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
output_table <- write_csv(solution_table, "APU_17/results/APU17_area_summary_PAs.csv")

# read in the summary targets table
summary_targets <- read_csv("APU_17/output/summary_targets_PAs.csv") %>%
  mutate(target = target_list)

# join targets and areas table
join_table = inner_join(solution_table, summary_targets, by = 'target')

# write output
output_table <- write_csv(join_table, "APU_17/results/APU17_area_targets_summary_PAs.csv")
