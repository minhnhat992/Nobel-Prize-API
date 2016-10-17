library(httr)
library(dplyr)
library(plyr)
library(jsonlite)
library(xlsx)

# connect to APIs
prize <- GET("http://api.nobelprize.org/v1/prize.json")

# get the main contents
prize_ct <- content(prize, as = "text", encoding = "UTF-8") %>% 
  jsonlite::fromJSON(simplifyDataFrame = TRUE, flatten =TRUE)


# convert main contents to data frame
prize_df <- data.frame(prize_ct$prizes)


# loop to untangle nested column.We need to "un-nest" the 3rd column, which can be achieved by using cbind to
# combine "un-nested" 3rd column with the rest in cartesian format


prizes_final <- data.frame()

for (val in 1:nrow(prize_df)){
  
  test <- data.frame(cbind(prize_df[val,c(1,2,4)], prize_df[,3][val]))
  
  prizes_final <- rbind.fill(prizes_final, test)

  }


# reorder column
prizes_final <- select(prizes_final,
                       year,
                       category,
                       id,
                       firstname,
                       surname,
                       motivation,
                       share,
                       overallMotivation)

# write excel file
write.xlsx(prizes_final, "prizes.xlsx")

