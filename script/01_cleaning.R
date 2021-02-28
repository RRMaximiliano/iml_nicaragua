
# Load packages -----------------------------------------------------------

library(tidyverse)
library(readxl)

# Read data ---------------------------------------------------------------
project <- file.path("D:/Documents/GitHub/iml_nicaragua")
data    <- file.path(project, "data")
figs    <- file.path(project, "figs")
  
iml_raw <- read_excel(file.path(data, "raw", "raw_iml.xlsx")) %>% 
  janitor::clean_names()

iml <- iml_raw %>% 
  mutate(
    circunscripciones_y_delegaciones_del_iml = str_replace_all(circunscripciones_y_delegaciones_del_iml, "[:digit:]", ""),
    circunscripciones_y_delegaciones_del_iml = str_replace_all(circunscripciones_y_delegaciones_del_iml, "\\.", "") %>% trimws()
  ) %>% 
  rename(circunscripcion = 2) %>% 
  pivot_longer(
    3:8, 
    names_to = "tipologia",
    values_to = "casos"
  ) %>% 
  mutate(
    casos = as.character(str_replace_all(casos, ".000", "")),
    casos = str_replace_all(casos, "\\.", "") %>% as.numeric(),
    tipologia = str_replace_all(tipologia, "_", " ")
  ) %>% 
  arrange(year, circunscripcion) %>% 
  filter(tipologia != "total")
  
# Save data ---------------------------------------------------------------

iml %>% 
  write_csv(file.path(data, "iml.csv"))
  
iml %>% 
  write_rds(file.path(data, "iml.rds"))

