library(tidyverse)
library(sf)
library(prioritizr)
select <- dplyr::select
n_cores <- parallel::detectCores() - 1

# load data
# cost
cost <- read_csv("inputs/cost.csv") %>%
  # set all column headings to lower case
  rename_all(tolower) %>%
  rename(id = hydroid)

# species
species <- read_csv("inputs/species.csv") %>%
  # set all column headings to lower case
  rename_all(tolower) %>%
  # strip the SP characters from the species codes and leave only number values with leading zeros
  separate(id, c("S", "id"), sep = "([P])") %>%
  # select only the species code id and the species name columns
  select(id, name) %>%
  mutate(id = as.integer(id)) 

# representation matrix
rij <- read_csv("inputs/SDM_APU_current.csv") %>% 
  rename(hydroid = HydroID) %>%
  # rename the species code colums to leave only number values with leading zeros
  rename_at(.vars = vars(starts_with("SP")), .funs = funs(sub("[SP].", "", .))) %>%
  # transform the matrix into column format
  gather(species, amount, -hydroid) %>% 
  mutate(species = as.integer(species)) %>%
  rename(pu = hydroid)

# planning unit boundaries
bound <- read_csv("inputs/APU_boundary_connections_clean_MARXAN.csv")

# read planning units geometries
pu_sf <- read_sf("planning_units/Arctic_Planning_Units.shp") %>% 
  select(-contains("SOLN")) %>% 
  set_names(tolower(names(.))) %>% 
  rename(id = hydroid)

# base model
p <- problem(cost, species, "cost", rij = rij) %>% 
  # use the marxan objective function
  add_min_set_objective() %>% 
  add_binary_decisions() %>% 
  # solve with gurobi
  add_gurobi_solver(gap = 0.01, thread = n_cores)

# range of csm values and 50% targets
csm_targ <- expand.grid(csm = c(0, 0.1, 0.5, 1, 1.5, 2, 2.5, 3, 4, 5, 10, 20, 50, 100), 
                        target = 0.50)

# define model for each combination and solve
csm_targ <- csm_targ %>% 
  mutate(s = map2(csm, target, 
                  ~ add_connectivity_penalties(p, .x, bound) %>% 
                    add_relative_targets(.y) %>% 
                    solve()))

# calculate the CSM and cost of each solution

# cost
csm_targ <- csm_targ %>% 
  mutate(cost = map_dbl(s, ~ sum(filter(.x, solution_1 == 1)$cost)))

# boundary
calc_boundary <- function(s, b) {
  s1 <- select(s, id1 = id, x1 = solution_1)
  s2 <- select(s, id2 = id, x2 = solution_1)
  inner_join(b, s1, by = "id1") %>% 
    inner_join(s2, by = "id2") %>% 
    mutate(b = x1 * (1 - x2) * boundary) %>% 
    pull(b) %>% 
    sum()
}

csm_targ <- csm_targ %>% 
  mutate(boundary = map_dbl(s, calc_boundary, b = bound))

ggplot(csm_targ, aes(x = boundary, y = cost)) + 
  geom_point() +
  geom_line() +
  geom_text(aes(label = csm), vjust = -1) +
  scale_y_continuous(labels = scales::comma) +
  labs(x = "CSM", y = "Cost",
       title = "Cost vs. connectivity tradeoff - symmetrical")

# plot the results
plot <- ggplot(csm_targ, aes(x = boundary, y = cost)) + 
  geom_point() +
  geom_line() +
  geom_text(aes(label = csm), vjust = -1) +
  scale_y_continuous(labels = scales::comma) +
  labs(x = "CSM", y = "Cost",
       title = "Cost vs. connectivity tradeoff - symmetrical")
ggsave("CSM_Plots/APU_Plot_CSM_Compare_sym.png", plot, width = 15, height = 15)
