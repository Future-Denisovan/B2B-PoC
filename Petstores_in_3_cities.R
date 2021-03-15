install.packages("googleway")#Link here:https://www.rdocumentation.org/packages/googleway/versions/2.7.3

library(googleway)#Desc:https://www.rdocumentation.org/packages/googleway/versions/2.7.3/topics/google_places
                  #Desc:https://www.rdocumentation.org/packages/googleway/versions/2.7.3/topics/google_place_details
#Put your API key here.
api_key <- 'ChIJrTLr-GyuEmsRBfy61i59si0'

#List of cities we want to search
cities<-list("Puyallup,WA","Seattle,WA","Portland,OR")

#Create this dataframe outside our loop, this is where we will store all our results.
store_data<-data.frame()

#Loop only 3 times because we have 3 cities.
for(a in 1:3){
  #Our search term is a string generated from the paste function, which is just taking each city at a time and pasting the "Pet Food in" at the beginning,
  search_term<- paste("Pet Food in",cities[[a]],sep = " ")#so the entire search term is "Pet Food in Puyallup,WA" for the first run and so on. Also the double brackets for the "cities[[]]" will
                                                          #have to be changed if you change your cities from a list to a dataframe or something else. 
  
  #This is the actual call, and it will store it in a list. Notice I passed the place_type of "pet_store". There are all kinds of place types you can pass to restrict your results. 
  dt <- google_places(search_string =  search_term, place_type = "pet_store",#See here: https://developers.google.com/maps/documentation/places/web-service/supported_types
                      key = api_key)
  
  #So the way that data gets returned is a little messy, so we need to pull out the pieces we want and into the format we want.
  namedata<-dt$results$name
  addressdata<-dt$results$formatted_address
  numberdata<-list()
  for(r in 1:nrow(dt$results)){#We have to nest another loop inside our first one, because the pet store's numbers are not avaliable in the origional call. So we 
                                #are making another call based on the unique "place_id" that is returned for each search result and returning the phone numbers.
    place<-dt$results$place_id[r]#Here is that place id
    
    place_selected<-google_place_details(place, language = NULL, simplify = TRUE,#Making the call to get the google_place_details
                                         curl_proxy = NULL, key = api_key)
    number<-place_selected$result$formatted_phone_number#extract the phone number, its 3 levels down.
    
    numberdata<-rbind(numberdata,number)#rbind is adding each number to the end of my number dataset-which I will eventually combine with the names of the places I found
    
  }
  #Great so now I want to combine the names, numbers and addresses in each city together, before going on to the next city, so that is what this loop accomplishes.
  
  for(j in 1:nrow(numberdata)){
    
    newrow<-cbind(namedata[j],numberdata[[j]],addressdata[j])#cbind is combining these terms along the row-horizontally essentially
    
    store_data<-rbind(store_data,newrow)
    
  }
  #Once the first pass is made, our code loops back up and runs "Seattle, WA" through everything
  
}

