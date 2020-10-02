library(tidyverse)
library(sf)
library(rmapshaper)

# reset target levels from APU analysis
t_lvl <- seq(0.1, 0.9, 0.1) %>%
  scales::percent(accuracy = 1)

# read planning units geometries
pu_sf <- read_sf("APU/output/APU_solutions.shp")

# drop the shape area field because it messes with the figures
pu_sf <- select(pu_sf, -area_km2)

pu_map <- pu_sf %>%
  ms_simplify(keep = 0.01) %>%
  gather(targets, selected, -id, -geometry) %>%
  mutate(targets = gsub("soln_t", "", targets),
         targets = paste0(targets, "%"),
         targets = factor(targets, levels = t_lvl),
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