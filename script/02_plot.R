
# packages ----------------------------------------------------------------
Sys.setlocale("LC_TIME", "Spanish_Spain.1252")

library(lubridate)
library(zoo)
library(hrbrthemes)
library(scales)
library(ggtext)

# Read data ---------------------------------------------------------------

iml <- read_rds(file.path(data, "iml.rds"))

# Plot --------------------------------------------------------------------


iml %>%
  group_by(year, circunscripcion) %>% 
  summarize(total = sum(casos, na.rm = TRUE)) %>% 
  ungroup() %>% 
  group_by(circunscripcion) %>% 
  add_count(circunscripcion) %>% 
  filter(n == 6) %>% 
  ggplot(aes(x = year, y = total, group = circunscripcion, color = circunscripcion)) +
  geom_line(size = 1.2) +
  facet_wrap(~circunscripcion, scales = "free_y") +
  scale_x_continuous(breaks = c(2015, 2017, 2019)) +
  scale_y_continuous(label = comma) + 
  labs(
    title = "Total número de peritajes por circunscripción en Nicaragua", 
    subtitle = "Periodo: 2014-2019",
    y = "Peritajes", 
    x = NULL,
    caption = "Data: Instituto de Medicina Legal | Plot: @rrmaximiliano"
  ) + 
  theme_ipsum_rc() + 
  theme(
    legend.position  = "none",
    panel.background = element_rect(color = "black", fill = "white"),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_blank(),
    axis.title.y = element_text(size = 12),
    plot.caption = element_text(size = 12)
  ) 

ggsave(file.path(figs, "peritajes.png"),
       dpi = 320, height = 12, width = 16, scale = 0.8)

