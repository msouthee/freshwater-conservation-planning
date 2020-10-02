library(tidyverse)
library(sf)
library(rmapshaper)

# LOAD SOLUTIONS
s <- readRDS("APU_30/output/APU_solutions_PAs.rds")

# read planning units geometries
pu_sf <- read_sf("APU_30/output/APU_solutions_PAs.shp")

# drop the shape area field because it messes with the figures
pu_sf <- select(pu_sf, -area_km2)

# set target level range
t_lvl <- s$target %>%
  scales::percent()

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

# map output
g <- ggplot(pu_map_soln) +
  geom_sf(aes(fill = selected), size = 0.05, color = "grey20") +
  scale_fill_manual(values = c("#0083be", "grey60", "black")) +
  labs(title = "Selected planning units to protect 30% of study area under current climate scenarios",
       fill = NULL) +
  facet_wrap(~ targets, nrow = 3) +
  theme_bw() +
  theme(legend.position = "bottom")

# save map
ggsave("APU_30/figures/APU_final_solution_map_PAs.png", g, width = 15, height = 15)