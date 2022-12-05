library(tidyverse)
library(tidycensus)
library(dplyr)
library(sf)

# api key
census_api_key("8b69f2765f65670c2183febdffce6afc73c72101", install=TRUE, overwrite=TRUE)
readRenviron("~/.Renviron")

# load original datasets
pfas_major_wwtps <- read_csv("data/pfas_project_major_wwtps.csv")
pfas_naics_sites <- read_csv("data/pfas_project_presumed_naics_sites.csv")

# need population, race, median household income, median age, households with kids,
# foreign-born or language spoken at home, for census tracts and ZCTAs

# load ACS variables
acs_2020 <- load_variables(2020, "acs5")

# population
# B01003_001 -> total population

pop_zctas <- get_acs(geography = "zcta",
                            variables = c(total_pop = "B01003_001"),
                            year = 2020)

pop_tract <- get_acs(geography = "zcta",
                            variables = c(total_pop = "B01003_001"),
                            year = 2020)

pfas_naics_with_pops <- pfas_naics_sites %>% 
                    left_join(pop_zctas, by=c('ZIP'='GEOID'))

# race
# B02001_001 -> race

race_zctas <- get_acs(geography = "zcta",
                     variables = c(race = "B02001_001"),
                     year = 2020)

race_tract <- get_acs(geography = "zcta",
                     variables = c(race = "B02001_001"),
                     year = 2020)

# ethnicity 
# B03001_002 -> not Hispanic/Latino
# B03001_003 -> Hispanic/Latino

# not Hispanic/Latino

not_hislat_zctas <- get_acs(geography = "zcta",
                      variables = c(not_hislat = "B03001_002"),
                      year = 2020)

not_hislat_tract <- get_acs(geography = "tract",
                            variables = c(not_hislat = "B03001_002"),
                            year = 2020)

# Hispanic/Latino

hislat_zctas <- get_acs(geography = "zcta",
                      variables = c(hislat = "B03001_003"),
                      year = 2020)

hislat_tract <- get_acs(geography = "tract",
                        variables = c(hislat = "B03001_003"),
                        year = 2020)

# median household income
# B19013_001 -> median household income

med_income_zctas <- get_acs(geography = "zcta",
                    variables = c(medincome = "B19013_001"),
                    year = 2020)

med_income_tract <- get_acs(geography = "tract",
                            variables = c(medincome = "B19013_001"),
                            year = 2020)

# median age 
# B01002_001 -> median age by sex

med_age_zctas <- get_acs(geography = "zcta",
                            variables = c(medage = "B01002_001"),
                            year = 2020)

med_age_tract <- get_acs(geography = "tract",
                            variables = c(medage = "B01002_001"),
                            year = 2020)

# households w/ kids
# B11012_003 -> total married couples w/ kids under 18
# B11012_006 -> total cohabiting couple w/ kids under 18
# B11012_010 -> total female householder w/ kids under 18

# married w/ kids

married_kids_zctas <- get_acs(geography = "zcta",
                         variables = c(married_kids = "B11012_003"),
                         year = 2020)

married_kids_tract <- get_acs(geography = "tract",
                         variables = c(married_kids = "B11012_003"),
                         year = 2020)


# cohabiting w/ kids

cohab_kids_zctas <- get_acs(geography = "zcta",
                              variables = c(cohab_kids = "B11012_006"),
                              year = 2020)

cohab_kids_tract <- get_acs(geography = "tract",
                              variables = c(cohab_kids = "B11012_006"),
                              year = 2020)

# female householder w/ kids

fem_kids_zctas <- get_acs(geography = "zcta",
                            variables = c(fem_kids = "B11012_010"),
                            year = 2020)

fem_kids_tract <- get_acs(geography = "tract",
                            variables = c(fem_kids = "B11012_010"),
                            year = 2020)

# male householder w/ kids

male_kids_zctas <- get_acs(geography = "zcta",
                          variables = c(male_kids = "B11012_015"),
                          year = 2020)

male_kids_tract <- get_acs(geography = "tract",
                          variables = c(male_kids = "B11012_015"),
                          year = 2020)

# foreign-born
# B05002_013 -> total foreign born

foreign_born_zctas <- get_acs(geography = "zcta",
                           variables = c(foreign_born = "B05002_013"),
                           year = 2020)

foreign_born_tract <- get_acs(geography = "tract",
                           variables = c(foreign_born = "B05002_013"),
                           year = 2020)

# languages 
# B06007_006 -> total speak other languages

other_langs_zctas <- get_acs(geography = "zcta",
                              variables = c(speak_otr_langs = "B06007_006"),
                              year = 2020)

other_langs_tract <- get_acs(geography = "tract",
                              variables = c(speak_otr_langs = "B06007_006"),
                              year = 2020)