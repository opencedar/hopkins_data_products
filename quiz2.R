#5.

require(leaflet)

df %>% leaflet() %>% addTiles()


leaflet(df) %>% addTiles() #Correct

addTiles(leaflet(df)) #Correct
