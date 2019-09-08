# Create a small iOS app using Swift to list beverages from PunkAPI
List and show beer details using [Punk API](https://punkapi.com).

## App features

- Fetch beers from the Punk API using Alamofire (with only extra pale malt)
- Display these beers in a TableView (show his image, name, tagline, and description)
- Implement an infinite scroll to show all beers (using pagination from PunkAPI)
- Use a caching to display beers before we made any call to the Punk API (RealmSwift). I've choose to preload 5 beers.
- Add a search bar to find a specific beer with his name. (Search bar appear by scrolling TableView to the top)

## Running the Project
Xcode deployment target 12.4
Pods already added to the repo, so you don't need to have cocoapods installed nor run pod install

- Open `PunkAPI.xcworkspace`
- Build & run.

## Third-Party Libraries Used

- [Alamofire](https://github.com/Alamofire/Alamofire) - HTTP networking library.
- [RealmSwift](https://github.com/realm/realm-cocoa) - Realm is a mobile database that runs directly inside phones.
- [SDWebImage](https://github.com/SDWebImage/SDWebImage) - Image loading and caching library.

## Screenshots

![Alt text](Screenshots/ListView.png?raw=true "Optional Title")
