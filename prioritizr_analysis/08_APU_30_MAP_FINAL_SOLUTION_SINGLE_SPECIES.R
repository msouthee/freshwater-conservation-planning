library(tidyverse)
library(sf)
library(rmapshaper)

# LOAD SOLUTIONS FOR SP01
# read planning units geometries
pu_sf <- read_sf("APU_30/output/APU_solutions_SP01.shp")

# drop the shape area field because it messes with the figures
pu_sf <- select(pu_sf, -area_km2)

# select and prepare only a single solution
pu_map_soln <- pu_sf %>%
  ms_simplify(keep = 0.01) %>%
  ###### select the final solution target level ######
  select(soln_t28) %>%
  gather(targets, selected, -geometry) %>%
  mutate(targets = gsub("soln_t", "", targets),
         targets = paste0(targets, "%"),
         #targets = factor(targets, levels = t_lvl),
         selected = coalesce(selected, -1),
         selected = factor(selected, levels = 1:-1,
                           labels = c("Selected", "Not Selected", "No Data")))

# map output SP01
g <- ggplot(pu_map_soln) +
  geom_sf(aes(fill = selected), size = 0.05, color = "grey20") +
  scale_fill_manual(values = c("#0083be", "grey60", "black")) +
  labs(title = "Selected planning units to protect 30% of study area under current climate scenarios",
       fill = NULL) +
  facet_wrap(~ targets, nrow = 3) +
  theme_bw() +
  theme(legend.position = "bottom")

# save map SP01
ggsave("APU_30/figures/APU_final_solution_map_SP01.png", g, width = 15, height = 15)



# LOAD SOLUTIONS FOR SP09
# read planning units geometries
pu_sf <- read_sf("APU_30/output/APU_solutions_SP09.shp")

# drop the shape area field because it messes with the figures
pu_sf <- select(pu_sf, -area_km2)

# select and prepare only a single solution
pu_map_soln <- pu_sf %>%
  ###### select the final solution target level ######
  select(soln_t26) %>%
  ms_simplify(keep = 0.01) %>%
  gather(targets, selected, -geometry) %>%
  mutate(targets = gsub("soln_t", "", targets),
         targets = paste0(targets, "%"),
         #targets = factor(targets, levels = t_lvl),
         selected = coalesce(selected, -1),
         selected = factor(selected, levels = 1:-1,
                           labels = c("Selected", "Not Selected", "No Data")))

# map output SP09
g <- ggplot(pu_map_soln) +
  geom_sf(aes(fill = selected), size = 0.05, color = "grey20") +
  scale_fill_manual(values = c("#0083be", "grey60", "black")) +
  labs(title = "Selected planning units to protect 30% of study area under current climate scenarios",
       fill = NULL) +
  facet_wrap(~ targets, nrow = 3) +
  theme_bw() +
  theme(legend.position = "bottom")

# save map SP09
ggsave("APU_30/figures/APU_final_solution_map_SP09.png", g, width = 15, height = 15)



# LOAD SOLUTIONS FOR SP42
# read planning units geometries
pu_sf <- read_sf("APU_30/output/APU_solutions_SP42.shp")

# drop the shape area field because it messes with the figures
pu_sf <- select(pu_sf, -area_km2)

# select and prepare only a single solution
pu_map_soln <- pu_sf %>%
  ###### select the final solution target level ######
  select(soln_t36) %>%
  ms_simplify(keep = 0.01) %>%
  gather(targets, selected, -geometry) %>%
  mutate(targets = gsub("soln_t", "", targets),
         targets = paste0(targets, "%"),
         #targets = factor(targets, levels = t_lvl),
         selected = coalesce(selected, -1),
         selected = factor(selected, levels = 1:-1,
                           labels = c("Selected", "Not Selected", "No Data")))

# map output SP42
g <- ggplot(pu_map_soln) +
  geom_sf(aes(fill = selected), size = 0.05, color = "grey20") +
  scale_fill_manual(values = c("#0083be", "grey60", "black")) +
  labs(title = "Selected planning units to protect 30% of study area under current climate scenarios",
       fill = NULL) +
  facet_wrap(~ targets, nrow = 3) +
  theme_bw() +
  theme(legend.position = "bottom")

# save map SP42
ggsave("APU_30/figures/APU_final_solution_map_SP42.png", g, width = 15, height = 15)



# LOAD SOLUTIONS FOR SP46
# read planning units geometries
pu_sf <- read_sf("APU_30/output/APU_solutions_SP46.shp")

# drop the shape area field because it messes with the figures
pu_sf <- select(pu_sf, -area_km2)

# select and prepare only a single solution
pu_map_soln <- pu_sf %>%
  ###### select the final solution target level ######
  select(soln_t27) %>%
  ms_simplify(keep = 0.01) %>%
  gather(targets, selected, -geometry) %>%
  mutate(targets = gsub("soln_t", "", targets),
         targets = paste0(targets, "%"),
         #targets = factor(targets, levels = t_lvl),
         selected = coalesce(selected, -1),
         selected = factor(selected, levels = 1:-1,
                           labels = c("Selected", "Not Selected", "No Data")))

# map output SP46
g <- ggplot(pu_map_soln) +
  geom_sf(aes(fill = selected), size = 0.05, color = "grey20") +
  scale_fill_manual(values = c("#0083be", "grey60", "black")) +
  labs(title = "Selected planning units to protect 30% of study area under current climate scenarios",
       fill = NULL) +
  facet_wrap(~ targets, nrow = 3) +
  theme_bw() +
  theme(legend.position = "bottom")

# save map SP46
ggsave("APU_30/figures/APU_final_solution_map_SP46.png", g, width = 15, height = 15)