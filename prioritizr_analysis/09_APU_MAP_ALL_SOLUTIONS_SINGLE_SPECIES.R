library(tidyverse)
library(sf)
library(rmapshaper)


# reset target levels from APU analysis
t_lvl <- seq(0.1, 0.9, 0.1) %>%
  scales::percent(accuracy = 1)

# LOAD SOLUTIONS FOR SP01
# read planning units geometries
pu_sf <- read_sf("APU/output/APU_solutions_SP01.shp")

# drop the shape area field because it messes with the figures
pu_sf <- select(pu_sf, -area_km2)

# # testing without geometry
# pu_no_geom <- pu_sf %>%
#     st_set_geometry(NULL) %>%
#     gather(targets, selected, -id) %>%
#     mutate(targets = gsub("soln_t", "", targets),
#            targets = paste0(targets, "%"),
#            targets = factor(targets, levels = t_lvl),
#            selected = coalesce(selected, -1),
#            selected = factor(selected, levels = 1:-1,
#                              labels = c("Selected", "Not Selected", "No Data")))


# select and prepare data
pu_map_soln <- pu_sf %>%
  ms_simplify(keep = 0.01) %>%
  gather(targets, selected, -id, -geometry) %>%
  mutate(targets = gsub("soln_t", "", targets),
         targets = paste0(targets, "%"),
         targets = factor(targets, levels = t_lvl),
         targets = paste0("Species Rep: ", targets),
         selected = coalesce(selected, -1),
         selected = factor(selected, levels = 1:-1,
                           labels = c("Selected", "Not Selected", "No Data")))

# map output SP01
g <- ggplot(pu_map_soln) +
  geom_sf(aes(fill = selected), size = 0.05, color = "grey20") +
  scale_fill_manual(values = c("#0083be", "grey60", "black")) +
  labs(title = "Selected planning units at different target levels under current climate scenarios for Lake Sturgeon",
       fill = NULL) +
  facet_wrap(~ targets, nrow = 3) +
  theme_bw() +
  theme(legend.position = "bottom")

# save map SP01
ggsave("APU/figures/APU_final_solution_map_SP01.png", g, width = 15, height = 15)



# LOAD SOLUTIONS FOR SP09
# read planning units geometries
pu_sf <- read_sf("APU/output/APU_solutions_SP09.shp")

# drop the shape area field because it messes with the figures
pu_sf <- select(pu_sf, -area_km2)

# select and prepare data
pu_map_soln <- pu_sf %>%
  ms_simplify(keep = 0.01) %>%
  gather(targets, selected, -id, -geometry) %>%
  mutate(targets = gsub("soln_t", "", targets),
         targets = paste0(targets, "%"),
         targets = factor(targets, levels = t_lvl),
         targets = paste0("Species Rep: ", targets),
         selected = coalesce(selected, -1),
         selected = factor(selected, levels = 1:-1,
                           labels = c("Selected", "Not Selected", "No Data")))

# map output SP09
g <- ggplot(pu_map_soln) +
  geom_sf(aes(fill = selected), size = 0.05, color = "grey20") +
  scale_fill_manual(values = c("#0083be", "grey60", "black")) +
  labs(title = "Selected planning units at different target levels under current climate scenarios for Lake Whitefish",
       fill = NULL) +
  facet_wrap(~ targets, nrow = 3) +
  theme_bw() +
  theme(legend.position = "bottom")

# save map SP09
ggsave("APU/figures/APU_final_solution_map_SP09.png", g, width = 15, height = 15)



# LOAD SOLUTIONS FOR SP42
# read planning units geometries
pu_sf <- read_sf("APU/output/APU_solutions_SP42.shp")

# drop the shape area field because it messes with the figures
pu_sf <- select(pu_sf, -area_km2)

# select and prepare data = ERROR OCCURRING HERE
pu_map_soln <- pu_sf %>%
  ms_simplify(keep = 0.01) %>%
  gather(targets, selected, -id, -geometry) %>%
  mutate(targets = gsub("soln_t", "", targets),
         targets = paste0(targets, "%"),
         targets = factor(targets, levels = t_lvl),
         targets = paste0("Species Rep: ", targets),
         selected = coalesce(selected, -1),
         selected = factor(selected, levels = 1:-1,
                           labels = c("Selected", "Not Selected", "No Data")))

# map output SP42
g <- ggplot(pu_map_soln) +
  geom_sf(aes(fill = selected), size = 0.05, color = "grey20") +
  scale_fill_manual(values = c("#0083be", "grey60", "black")) +
  labs(title = "Selected planning units at different target levels under current climate scenarios for Brook Trout",
       fill = NULL) +
  facet_wrap(~ targets, nrow = 3) +
  theme_bw() +
  theme(legend.position = "bottom")

# save map SP42
ggsave("APU/figures/APU_final_solution_map_SP42.png", g, width = 15, height = 15)



# LOAD SOLUTIONS FOR SP46
# read planning units geometries
pu_sf <- read_sf("APU/output/APU_solutions_SP46.shp")

# drop the shape area field because it messes with the figures
pu_sf <- select(pu_sf, -area_km2)

# select and prepare data
pu_map_soln <- pu_sf %>%
  ms_simplify(keep = 0.01) %>%
  gather(targets, selected, -id, -geometry) %>%
  mutate(targets = gsub("soln_t", "", targets),
         targets = paste0(targets, "%"),
         targets = factor(targets, levels = t_lvl),
         targets = paste0("Species Rep: ", targets),
         selected = coalesce(selected, -1),
         selected = factor(selected, levels = 1:-1,
                           labels = c("Selected", "Not Selected", "No Data")))

# map output SP46
g <- ggplot(pu_map_soln) +
  geom_sf(aes(fill = selected), size = 0.05, color = "grey20") +
  scale_fill_manual(values = c("#0083be", "grey60", "black")) +
  labs(title = "Selected planning units at different target levels under current climate scenarios for Walleye",
       fill = NULL) +
  facet_wrap(~ targets, nrow = 3) +
  theme_bw() +
  theme(legend.position = "bottom")

# save map SP46
ggsave("APU/figures/APU_final_solution_map_SP46.png", g, width = 15, height = 15)