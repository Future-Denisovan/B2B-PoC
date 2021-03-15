# B2B-PoC


Generating marketing leads for B2B is a useful tool for anyone in business, and if someone knows a little bit of R, they generate a dataset using the GooglePlacesAPI. Basically, using code in R to send calls to google maps and capture business data. Today, I’ll give you a demonstration on how to do that. I have a friend that is in the specialty pet food business, so I’m going to find all the stores, their phone numbers, and their addresses that sell pet food in a few cities as a proof on concept.
What you will need to accomplish this:
•	Google
•	GoogleAPI key
•	GooglePlaces API enabled
First, R Studio is an Integrated Development Environment(IDE) for people usually doing some kind of statistics or analysis, basically it allows you to code in R and have some idea of what is going on. What variables are stored, what the variables are stored as, a spot to see any graphs your code makes. Since most people that are interested in pursuing a career in analytics or data have some familiarity with R Studio, I’ll forge ahead to the GoogleAPI part, which many of those same people might not know about.

So essentially, GooglePlaces API allows someone to access all the rich data stored in Google Maps. Google is okay with you accessing this information, so long as you abide by their terms of service and pay for any services that you use above a certain limit. Google documents how to access that data with JSON, here is an example of what making some of those searches in JSON look like:
https://developers.google.com/maps/documentation/places/web-service/place-id
Feel free to click around and get a lay of the land on some of the terms so you have an idea of what information is available for different functions in the Places API.
So you aren’t going to have to know how to code in JSON or any other language in order to use the GooglePlacesAPI, today all you’ll need to have is some familiarity in R. First though, you’ll need that GoogleAPI key, essentially it allows you to access the Google maps data and will keep track of how much to charge to your account. Go to this page and it’ll show you step by step how to get one.
https://developers.google.com/maps/documentation/places/web-service/get-api-key
You’ll have to put in some method of payment, but you’ll get $300 of credit to start out with, and everything we will be doing isn’t going to use a lot of that.
Warning! Once you get your API key, do not publish it publicly with your code on Github or Stack overflow-crawlers may quickly pick it up and start using it. 😉 If this happens to you, you can delete it and generate a new one.
You will have a Google Cloud Console, where you’ll be able to see what services you are using.
https://console.cloud.google.com/
This is what your GoogleAPI console should look like:
 
As I’ve been trying to create this demonstration, I’ve been making calls to the GooglePlacesAPI, so that is where you see the web traffic on the left. There are different filters to see duration by days or hours-so mess around with this. Make sure you click that “Activate” of your credit, so that your card won’t be charged and your credit is instead. If you go to the navigation menu, then “Billing” you will be able to see this.
 
As you can see, I’ve burned up $71.11 of my credit. I made a loop that did 26,000 location searches though. So my demo by itself will not use up anywhere close to that much(except, I’ll say it again, make sure you do not share that API key publically).
Once you’ve familiarize yourself with the Google API & Services dashboard, enable the GooglePlacesAPI. You can do this by clicking on “Library” on the left, then searching for “Places”. Looks like this, big blue button, will say something like “Enable” instead of manage, just click that.
 
Once you’ve done that, you will be all set to make Places API calls. Now we need to setup R Studio, which will be super easy.
Go to my github and either fork or copy/paste my code and follow along.

The package to make calls to the Google Places API is “googleway”. This is what line 1 does. Once you have installed the package, go ahead enter your api key in the api_key variable, on line 6.
 
Line 9 is the list of cities that we want to search. This could be changed to any list of cities or locations we want, just be aware if you have a lot of cities, like 1500 cities than you maybe waiting for a while(because you are getting live information from the web).  

So now I’m going to loop through our list of cities, and create the search term we will pass to the PlacesAPI. I like using paste, it puts two strings together. The first part of my search term is “Pet Food in” and the second part will be whichever city we are on. 
After that, I make the actual call to PlacesAPI. A really useful feature here is you can pass the “place_type” you are looking for. Google places are tagged with “store” or “bar” and we can control what specific places we are looking for. In this case, we only care about places tagged as “pet_store”, and it is really nice, as opposed to return lots of results we don’t want and having to drop them based on logic statements.
 
It is stored in a list of lists called dt. It is a little gnarly compared to many of the data you maybe used to working with in R, but you can click the little magnifying glass and see its structure after the code runs.
 
Anyway, yours will look a little different from mine because it is from google maps, for me it seems to come up a little different depending on the time of day. Also, something to note, this is only getting the first page of search results from each city-so if there are more than one page, it won’t pick up those, that will take a next page variable being passed and another loop I think so I didn’t want to try to put that here.
For the city we grab the names of the stores and store them in “namedata” and the addresses and store them in “addressdata” then we do a nested loop inside our first one because we need to make a different call to the PlacesAPI to get the business phone number. It is inconvenient, if someone knows how to do this in a faster way I’d love to here it. 
 
The first call we had returns a “place_id” that is unique to each search term. We pass that into “google_place_details” call to get that phone number. It is three levels down in that call, and then we append it to a little store called “numberdata”.
Alright now we have each piece that we want for the first original search in the city of Puyallup, WA that returns our pet food stores, we do another loop and bind each element together (essentially-horizontally) into a “newrow”. This newrow we add to our store_data. Once this happens, we loop back up to the beginning and start on the next city. 

Some things that would be nice to test is what happens if a business doesn’t have a phone number or address? I’m guessing than all our returns will be off by one and completely wrong. So you’d have to introduce some error handling in this. 
The final product though, should look like something to the left. You can write this to a .csv, and use it to follow up on business leads, or plot how saturated a particular region is. 
Hope you learned something useful! IM on LinkedIn or email me if you have questions/suggestions! I’m just trying to expose people to new capabilities without having to learn another language or make people aware of the possibilities using data to make more informed decisions.

