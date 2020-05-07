library(prioritizr)
library(tidyverse)
library(sf)
library(rmapshaper)
select <- dplyr::select
n_cores <- parallel::detectCores() - 1

#### LOAD FILES SCRIPT ####
# cost
cost <- read_csv("cost.csv") %>%
  # set all column headings to lower case
  rename_all(tolower) %>%
  rename(id = hydroid)

# species
species <- read_csv("species.csv") %>%
  # set all column headings to lower case
  rename_all(tolower) %>%
  # strip the SP characters from the species codes and leave only number values with leading zeros
  separate(id, c("S", "id"), sep = "([P])") %>%
  # select only the species code id and the species name columns
  select(id, name) %>%
  mutate(id = as.integer(id)) 

# filter species records
species <- filter(species, id == 42)

# representation matrix
rij <- read_csv("APU/SDM_APU_current.csv") %>% 
  rename(hydroid = HydroID) %>%
  # rename the species code colums to leave only number values with leading zeros
  rename_at(.vars = vars(starts_with("SP")), .funs = funs(sub("[SP].", "", .))) %>%
  # transform the matrix into column format
  gather(species, amount, -hydroid) %>% 
  mutate(species = as.integer(species)) %>%
  rename(pu = hydroid)

# filter rij matrix
rij <-  filter(rij, species == 42)

# planning unit boundaries
bound <- read_csv("APU/APU_boundary_connections_clean_MARXAN.csv")

#### END LOAD FILES SCRIPT ####

#### RUN PRIORITIZR ANALYSIS SCRIPT ####

# set up problem
p <- problem(cost, species, "cost", rij = rij) %>% 
  # use the marxan objective function
  add_min_set_objective() %>% 
  add_binary_decisions() %>% 
  # solve with gurobi
  add_gurobi_solver(gap = 0, thread = n_cores) %>% 
  # add boundary terms, here 1/d between upstream/downstream units
  add_connectivity_penalties(2.5, bound)

# prioritize at different target levels
target_levels <- data_frame(target = seq(0.1, 0.9, 0.1))

# solve
s <- target_levels %>%
  mutate(solution = map(target, ~ add_relative_targets(p, .x) %>% solve()))

# calculate cost and representation levels
s <- s %>%
  mutate(cost = map_dbl(solution, ~ sum(filter(.x, solution_1 == 1)$cost)))

calc_representation <- function(x, rij) {
  totals <- rij %>%
    group_by(species) %>%
    summarize(total = sum(amount))
  x %>%
    filter(solution_1 == 1) %>%
    select(pu = id) %>%
    inner_join(rij, by = "pu") %>%
    group_by(species) %>%
    summarize(amount = sum(amount)) %>%
    inner_join(totals, by = "species") %>%
    mutate(pct_representation = amount / total)
}

s <- mutate(s, repr = map(solution, calc_representation, rij = rij))

# summarize results
s_repr <- unnest(s, repr) %>%
  group_by(target) %>%
  summarize(targets_met = sum(pct_representation >= target),
            average_repr = mean(pct_representation)) %>%
  mutate(target = scales::percent(target))

s_cost <- unnest(s, cost) %>%
  select(target, cost) %>%
  mutate(target = scales::percent(target))

inner_join(s_cost, s_repr, by = "target") %>%
  knitr::kable(col.names = c("Target", "Total Cost", "# Targets Met",
                             "Mean % representation"),
               digits = 1,
               align = c("l", "c", "c", "c"))


# write summary tables to output file
write_csv(s_cost, "APU/output/summary_costs_SP42.csv")
write_csv(s_repr, "APU/output/summary_targets_SP42.csv")

# read planning units geometries
pu_sf <- read_sf("planning_units/Arctic_Planning_Units.shp") %>% 
  select(-contains("SOLN")) %>% 
  set_names(tolower(names(.))) %>% 
  rename(id = hydroid)

# join the solutions to the spatial planning data
pu_sf <- select(pu_sf, id, shape_area)

for (i in seq.int(nrow(s))) {
  lbl <- round(100 * s$target[i]) %>%
    as.character() %>%
    paste0("soln_t", .)
  sln <- s$solution[[i]] %>%
    select(id, solution_1) %>%
    set_names(c("id", lbl))
  pu_sf <- left_join(pu_sf, sln, by = "id")
}

# calculate area in km2 and drop shape_area field
pu_sf <- mutate(pu_sf, area_km2 = shape_area / 1000000) %>%
  select(-shape_area)

# write the output files
write_sf(pu_sf, "APU/output/APU_solutions_SP42.shp")
saveRDS(s, "APU/output/APU_solutions_SP42.rds")

#### END PRIORITIZR ANALYSIS SCRIPT ####

# #### MAP OUTPUT SCRIPT ####
# 
# # drop the shape area field because it messes with the figures
# pu_sf <- select(pu_sf, -area_km2)
# 
# # map the solutions
# t_lvl <- s$target %>%
#   scales::percent()
# 
# pu_map <- pu_sf %>%
#   ms_simplify(keep = 0.01) %>%
#   gather(targets, selected, -id, -geometry) %>%
#   mutate(targets = gsub("soln_t", "", targets),
#          targets = paste0(targets, "%"),
#          targets = factor(targets, levels = t_lvl),
#          selected = coalesce(selected, -1),
#          selected = factor(selected, levels = 1:-1,
#                            labels = c("Selected", "Not Selected", "No Data")))
# 
# # map
# g <- ggplot(pu_map) +
#   geom_sf(aes(fill = selected), size = 0.05, color = "grey20") +
#   scale_fill_manual(values = c("#0083be", "grey60", "black")) +
#   labs(title = "Selected planning units at different target levels under current climate scenarios",
#        fill = NULL) +
#   facet_wrap(~ targets, nrow = 3) +
#   theme_bw() +
#   theme(legend.position = "bottom")
# ggsave("APU/figures/APU_solutions_map_SP42.png", g, width = 15, height = 15)

