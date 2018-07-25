# Weather App
Fetches weather data from the DarkSky weather API with the help of your current location or one manually entered. Shows two separate techniques on updating a collection but are combined in this project. 

*NOTE: Testing on the simulator will require you to edit the scheme and give a default location.*


## Using MVVM Technique
Use of `WeatherViewModel` instances in collection view cells. This approach was ideal because of the formatting capabilities of the WeatherViewModel (dates, temperatures, etc.) and ideally for testing as well. Giving the ViewModel those responsibilities freed up much room inside ViewControllers and segregated tasks. In `MainViewController` the setting of LocationViewModel triggers a method inside of an observer to create an array of WeatherViewModels.
### Drawbacks
Can be overkill for simple classes. 
With CoreData, some of the code seemed redundant.

## DarkSKY API
Data was fetched using a URL containing a unique key + latitude and longitude coordinates obtained from either CoreLocation or a manually entered place, name, or zip code that was reverse geocoded.  
### Fetched
To get this API Data, I created a general networking class `NetworkController` that could be used by other parts of the application such as Location. And in a perfect world where I have as much time as I'd want: current weather data for each cell.

## CoreData
### Persisting
Managed Object Context saves Location which has a one to many relationship with Weather. Managing them wasn't difficult.
### Fetching
When the app launches, NSFetchRequest is used to load a list of Locations with the current location (Boolean property of Location) at the 0 index. If there are none, the user will be redirected to the `FindLocationViewController` where they input a location.
### Benefits
CoreData is useful because it also allows for easy implementation of NSFetchedResultsController. Because it observe the results of  CoreData, adding, updating, deleting, and moving of cells was easy to implement inside of the  `LocationsTableViewController`. It also helps my code have only one current location object existing at a time as it updates its properties with up-to-date data.
### Drawbacks
Made testing the models difficult. 

## Flow
Once the user downloads the app, they will be taken to a screen where they will be asked to enter a location, or use their own. This screen shows whenever the app launches and no Locations are available. Once a location is given, the `MainViewController` is then loaded with up to date weather info for the week. Users can tap on a cell to see more information or be taken to their list of Locations.  

## UI
Aside from the use of view controllers in the storyboard, all UI was created programmatically with sizes made from NSAnchors. Stackviews were utilized when elements needed to be grouped together. 
### Benefit
Mistakes were easy to fix. Storyboard often times confuses the crap out of me with many warnings and missing constraints. Although that could very well be a drawback!
### Drawback
Setting constraints, frames, etc. can add to your lines of code by a lot. Another option one of the views could have been to use VFL. 
