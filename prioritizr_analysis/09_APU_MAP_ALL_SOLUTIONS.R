library(tidyverse)
library(sf)
library(rmapshaper)

# # LOAD SOLUTIONS
# s <- readRDS("APU/output/APU_solutions.rds")

# read planning units geometries
pu_sf <- read_sf("APU/output/APU_solutions.shp")

#### MAP OUTPUT SCRIPT ####

# drop the shape area field because it messes with the figures
pu_sf <- select(pu_sf, -area_km2)

# # map the solutions
# t_lvl <- s$target %>%
#   scales::percent()

# # testing each step to see what is breaking the mapping code
# pu_map <- pu_sf %>%
#   # ms_simplify(keep = 0.01) %>%
#   #gather(targets, selected, -id, -geometry)
#   st_set_geometry(NULL) %>% 
#   gather(targets, selected, -id) %>%
#   # turns targets into just values
#   mutate(targets = gsub("soln_t", "", targets),
#          targets = paste0(targets, "%"),
#          #targets = factor(targets, levels = t_lvl),
#          selected = coalesce(selected, -1),
#          selected = factor(selected, levels = 1:-1,
#                            labels = c("Selected", "Not Selected", "No Data"))
#          )

pu_map <- pu_sf %>%
  ms_simplify(keep = 0.01) %>%
  gather(targets, selected, -id, -geometry) %>%
  mutate(targets = gsub("soln_t", "", targets),
         targets = paste0(targets, "%"),
         #targets = factor(targets, levels = t_lvl),
         selected = coalesce(selected, -1),
         selected = factor(selected, levels = 1:-1,
                           labels = c("Selected", "Not Selected", "No Data")))

# map
g <- ggplot(pu_map) +
  geom_sf(aes(fill = selected), size = 0.05, color = "grey20") +
  scale_fill_manual(values = c("#0083be", "grey60", "black")) +
  labs(title = "Selected planning units at different target levels under current climate scenarios",
       fill = NULL) +
  facet_wrap(~ targets, nrow = 3) +
  theme_bw() +
  theme(legend.position = "bottom")
ggsave("APU/figures/APU_solutions_map.png", g, width = 15, height = 15)