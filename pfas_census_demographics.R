# environment setup
library(tidyverse)
library(tidycensus)
library(dplyr)
library(purrr)
options(tigris_use_cache = TRUE)

# api key
census_api_key("8b69f2765f65670c2183febdffce6afc73c72101", install=TRUE, overwrite=TRUE)
readRenviron("~/.Renviron")

# load ACS variables
dp_variables <- load_variables(2020, dataset = "acs5/profile", cache = TRUE)

# profile variables
censusvariables = c(population = "DP05_0001",
                    hisp_latino = "DP05_0071",
                    white = "DP05_0077",
                    black = "DP05_0078",
                    ai_an = "DP05_0079",
                    asian = "DP05_0080",
                    nh_pi = "DP05_0081",
                    other = "DP05_0082",
                    two_or_more = "DP05_0083",
                    median_age = "DP05_0018",
                    median_hh_income = "DP03_0062",
                    hh_with_under18 = "DP02_0014",
                    born_in_US = "DP02_0090",
                    foreign_born = "DP02_0094",
                    language_all_over_5 = "DP02_0112",
                    language_english = "DP02_0113",
                    language_not_english = "DP02_0114",
                    language_not_english_very_well = "DP02_0115",
                    language_spanish = "DP02_0116",
                    language_indo_euro = "DP02_0118",
                    language_asian_pi = "DP02_0120",
                    language_other = "DP02PR_0122")

# zctas
zctas <- get_acs(geography = "zcta",
output = 'wide',
year = 2020,
variables = censusvariables) %>% 
  select(GEOID, NAME, populationE, hisp_latinoE, whiteE, blackE, ai_anE, asianE, nh_piE, otherE, two_or_moreE, median_ageE, 
         median_hh_incomeE, hh_with_under18E, born_in_USE, foreign_bornE, language_all_over_5E, language_englishE, 
         language_not_englishE, language_not_english_very_wellE, language_spanishE, language_indo_euroE, language_asian_piE, 
         language_otherE)

# tracts
us_states <- unique(fips_codes$state)[1:51]

tracts <- map_df(us_states, function(x) {
  get_acs(geography = "tract",
          state=x,
          output = 'wide',
          year = 2020,
          variables = censusvariables) %>% 
    select(GEOID, NAME, populationE, hisp_latinoE, whiteE, blackE, ai_anE, asianE, nh_piE, otherE, two_or_moreE, median_ageE, 
           median_hh_incomeE, hh_with_under18E, born_in_USE, foreign_bornE, language_all_over_5E, language_englishE, 
           language_not_englishE, language_not_english_very_wellE, language_spanishE, language_indo_euroE, language_asian_piE, 
           language_otherE)})

# load/join known datasets
known_sites_tracts <- read_csv("data/known_sites_tracts.csv")
known_sites_zctas <- read_csv("data/known_sites_zctas.csv")

known_sites_tracts_w_pop <- known_sites_tracts %>% 
  left_join(tracts, by=c('GEOID'='GEOID'))

known_sites_zctas_w_pop <- known_sites_zctas %>% 
  left_join(zctas, by=c('ZCTA5CE20'='GEOID'))

write.csv(known_sites_tracts_w_pop, "data/known_sites_tracts_w_pop.csv", row.names=FALSE)
write.csv(known_sites_zctas_w_pop, "data/known_sites_zctas_w_pop.csv", row.names=FALSE)