library(httr)
library(dplyr)
library(plyr)
library(jsonlite)
library(xlsx)

# connect to APIs

country <- GET("http://api.nobelprize.org/v1/country.json")

# get main content
country_ct <- content(country, as = "text", encoding = "UTF-8") %>% 
  jsonlite::fromJSON(simplifyDataFrame = TRUE, flatten =TRUE)


# convert main content to data frame
country_df <- data.frame(country_ct$countries)

# write excel
write.xlsx(country_df, file = "country.xlsx")
