library(httr)
library(dplyr)
library(plyr)
library(jsonlite)

# connect to APIs
laureate <- GET("http://api.nobelprize.org/v1/laureate.json")

# get main content
laureate_ct <- content(laureate, as = "text", encoding = "UTF-8") %>% 
  jsonlite::fromJSON(simplifyDataFrame = TRUE, flatten =TRUE)

# convert main content to data frame
laureate_df <- data.frame(laureate_ct$laureates)

# loop to untangle nested column.We need to "un-nest" the 3rd column, which can be achieved by using cbind to
# combine "un-nested" 3rd column with the rest in cartesian format


laureate_final <- data.frame()

for (val in 1: nrow(laureate_df)){
  
  test <- data.frame(cbind(laureate_df[val,-13], laureate_df[,13][val]))
  
  laureate_final <- rbind.fill(laureate_final, test)
  
  test <- data.frame()

}

# There's still one nested column (17th column) in the new table. Need to do the loop again

laureate_final_df <- data.frame()

for (row in 1:nrow(laureate_final)) {
  
  if (length(unlist(laureate_final[,17][row])) != 0) #some of the values in nested columns are empty. Need an if statment to take care of that.
    {
    
    test <- data.frame(cbind(laureate_final[row,-17],laureate_final[,17][row])) 
    
    } 
  
  else 
    
    {
    
      test <- data.frame(laureate_final[row,-17])
    
    }
  
  laureate_final_df <- rbind.fill(laureate_final_df, test)
  
  test <- data.frame()
}

# write excel file
write.xlsx(laureate_final_df, file = "laureate.xlsx")
