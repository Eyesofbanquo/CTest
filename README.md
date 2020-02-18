# Code Test 

### Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Git](#git)
4. [Gameplan](#gameplan)
5. [Closing Thoughts](#thoughts)

### Overview

This is the `iOS` code test for Nike. The requirements/steps for the code test are described below (pulled directly from code test document).

**The app should:**
•  use Auto Layout
•  Not use storyboards or nibs
•  Not use any third party libraries
•  DO NOT force unwrap your code or show signs of forced unwrapping your code

**Expected behavior:**
> On launch, the user should see a UITableView showing one album per cell. Each cell should display the name of the album, the artist, and the album art (thumbnail image). Tapping on a cell should push another view controller onto the navigation stack where we see a larger image at the top of the screen and the same information that was shown on the cell, plus genre, release date, and copyright info below the image. A button should also be included on this second view that when tapped fast app switches to the album page in the iTunes store. The button should be centered horizontally and pinned 20 points from the bottom of the view and 20 points from the leading and trailing edges of the view. Unlike the first one, this “detail” view controller should NOT use a UITableView for layout. 

# <a id="architecture">Architecture</a>

The suggested architecture was MVVM but I'll actually be using MVP. Why? Because MVVM is a bit archaic going forward with both iOS *and* iPadOS. MVVM looks to use a View Model for databinding with a view which is fine if the view is static. But what if your view is also a component? 

The problem with MVVM is that although the ViewModel is a component, it's still a component that the view controller depends on and since the view isn't abstracted out to being a component on the controller then this means that all the view model essentially does is act as code refactor. 

Using MVP I hope to accomplish 1 thing:

1. Abstract out the view from the view controller for future flexibility. This would mean that one could easily create views for iOS, iPadOS in any way shape or form without ever needing to touch the controller.

The reason this is important is obvious: With a ViewModel if you wanted a iPad layout or a macOS layout you may be tempted to have the controller hold all of the constraints and then adapt accordingly. By using MVP with an abstracted view, you turn the controller into a hub of events. It uses dependency injection to pull in functionality and since the view's type has been erased it means that you can have n-number of views (n being an integer). Everything in all layers will be a component so simply mocks are all that would be needed for unit testing.

**tl;dr** - *The approach will be MVP instead of MVVM but with a twist. This is essentially still MVVM by turning the ViewController into the ViewModel but since this will use delegates/existential types instead of data binding then the ViewController will act more like the Presenter. The key takeaway is the use of delegates/existential types on the View part so that the View can be abstracted just like the Presenter/ViewModel and Model. This allows for flexibility when it comes to presenting any view through the controller*

# <a id="git">Git</a>

Since this is just a code test I'll be using just the `master` branch and independent `feature` branches that will be pushed directly onto `master`. Usually there's `develop`, `staging` and other intermediate branches but that would just end up in PRs that would be ignored. The branch history will be viewable through PRs but mroe than likely I'll delete each branch after each merge just to keep the repo clean.

# <a id="gameplan">Gameplan</a>

### The Endpoint

The endpoint to hit for this project is 

> `https://rss.itunes.apple.com/en-us`

Under the FAQ a question that was asked was how many items should be returned for the table view. "Up to you" was the answer but we can do better than that. The `RSS` feed has a simple `URL` whenever you set it up to return items. The format is as follows:

>  `https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/`**COUNT**`/explicit.json`

Where **COUNT** can be any of the following limits:

1. 10
2. 25
3. 50
4. 100

For flexibility, the app should be able to build this string. Since it's only one `URL` there's no need to use `URLComponents` to build the `URLRequest`. All that is needed is the string `URL`. To take it one step further, there will be a class called `ItunesURLGenerator` that will build the `URL` by using `ExpressibleByIntegerLiteral` so that all you'd need to do is provide a number for the limit because although iTunes provides those 4 limits, you can pass in any number you want. Meaning:

> `https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/1/explicit.json`

Is valid.

***

## The Network Layer

The network layer will be a simple layer bulit around `URLSession`. It will have a function called `retrieveData(url:completion)` that will retrieve the data and return it through the completion block. This will perform an asynchronous call using `URLSession` and return the data **on the main thread** automatically. No need to call the main thread from the calling class.

The network layer will also have a function called `downloadData(url:completion)` and this will be used for downloading images. 

This network layer will be injected into the view controller.


## Storage Layer

The storage layer will be a simple data store that will store the itunes types into a simple struct. To emulate a real database with real database calls this data store will be of type `Decodable` and an interface will be provided on the object for retrieving specific types. Here's an example

~~~swift
// One way of retrieval
let storage = Storage()
let albumData = storage.get(Album.self)

// Another way of retrieval
let storage = Storage(type: Album.self)
~~~

### Caching

The storage layer will also handle the caching. Each storage object will have a cache type that is keyed by a `CacheKey` `protocol`

~~~swift
protocol CacheKey {
init?(stringValue: String)
var stringValue: String
}
~~~

The cache is accessed like so

~~~swift
let storage = Storage(type: Album.self)
let firstItemImage = storage.cache.get(.image, forKey: "1")
~~~

## Model Layer

The model layer will be a simple `Decodable` `struct` that maps to the API. Since I'm not personally familiar with the API, all of the properties on the model will be assigned through `init(from:)` which is supplied when conforming to `Decodable`. This allows me to control what's decoded depending on if keys exist or not.

## Process Layer

This layer is going to be used for downloading images. The table could have 1000 records and one of the requirements is handling image downloading. You start at index 0 (the first row) and the tableview uses reusable cells so there's the possibility of showing the wrong album art on a cell if you were to go to to index 88 (the eighty-ninth row). 

This is where data-binding from the viewmodel seems nice at first but also ends up being a problem. If the view model has references to the network layer, storage layer, model layer, and now the process layer then the view model is no better than the old MVC pattern. So the Process Layer will be another component added to the controller. This will essentially be a wrapper for `OperationQueue`.

~~~swift
let manager = Process.standard

manager.add(key:url)
~~~

The key will be an identifier associated with a single model record. `Process.default` *is* a singleton but with a twist. It's used as a guide. You can either create your own `Process` object or use the `.default`. The difference is that `Process.default` *is not* the same type as `Process` and you wont be able to create `ProcessDefault` types.

## Downloading images

The logic behind downloading images goes as follows

1. Check the cache to see if the image exists
2. If the cache doesnt exist then check to see if a Process is running
3. If a Process is not running then begin downloading

This is done each time in `cellForRow`.

## Testing

`XCTest` will be used for unit testing. The reason I'm pushing something closer to MVP than MVVM is for testing. Tests should be straightforward once everything is a component, including the view. 

TDD won't be used for this project. Instead, a logic-based "argument" approach will be used. Essentially, this means that each test in every test case should justify why that component exists. Although tests can be ran randomly, the argument can be read linearly. 

For example: When testing the storage layer you know it's going to need a data store and a way to access the data. But in order to access data, you'll need to understand a few conditions:

1. What happens if you don't have any data?
2. What happens if you try to access at a location that doesn't exist?

Those may seem like 2 separate tests but they're really 3 tests. 

1. What happens if you don't have any data?
2. What happens if you try to access at a location that doesn't exist *given you don't have any data*
3. What happens if you try to access at a location that doesn't exist *given you have data*

And these 3 are really a subset of one test:

1. What happens when you access storage?

Knowing this, then you can clean up the 3 tests above

1. What happens if you don't have any data **in storage**?
2. What happens if you try to access at a location that doesn't exist *given you don't have any data* **in storage**?
3. What happens if you try to access at a location that doesn't exist *given you have data* **in storage**?

After breaking this down now also shows that there are more than just 3 tests for those 2 scenarios too. As defined in the storage layer, you have a data store *and* a cache. So those 3 tests become 

1. What happens if you don't have any data **in the data store**?
2. What happens if you try to access at a location that doesn't exist *given you don't have any data* **in the data store**?
3. What happens if you try to access at a location that doesn't exist *given you have data* **in the data store**?
4. What happens if you don't have any data **in the cache**?
5. What happens if you try to access at a location that doesn't exist *given you don't have any data* **in the cache**?
6. What happens if you try to access at a location that doesn't exist *given you have data* **in the cache**?

So what looked to be only 2 tests actually ended up being 6. This could've been overlooked by TDD since you'd work on the smallest units possible but by going back and forth between the component + the test, and making the test a form of documentation, then you can catch these and write real world tests to explain how to use the components.

# <a id="thoughts">Closing Thoughts</a>

Everything in this README so far will be written before any code has been created. The main takeaway is that I'll be attempting an existential approach to MVP instead of MVVM. The reasoning is that it moves away from a view model approach, that when abstracted out, uses generics/universal types and favors the use of protocol oriented programming and existential types. All this means is that every layer is independent of one another.
