# Storyblok Swift SDK - 0.1.0

[![Version](https://img.shields.io/cocoapods/v/RXSStoryblokClient.svg?style=flat)](https://cocoapods.org/pods/RXSStoryblokClient)
[![License](https://img.shields.io/cocoapods/l/RXSStoryblokClient.svg?style=flat)](https://cocoapods.org/pods/RXSStoryblokClient)
[![Platform](https://img.shields.io/cocoapods/p/RXSStoryblokClient.svg?style=flat)](https://cocoapods.org/pods/RXSStoryblokClient)

## TL;DR
This is a Swift SDK/Wrapper around the Storyblok Delivery API and the Storyblok Management API. As of now, only Story fetching, creation and deletion is supported.
### Version 0.1.0
* Added static `Storyblok` class for Client Management.
  * Configure and use the shared Client for basic use cases that only require 1 Client.
  * Create new Content Delivery or Management Clients managed by the static `Storyblok` class and retrieve them at a later time using an identifier.
  * Create new Content Delivery or Management Clients and manage them yourself.
* Added Storyblok Delivery API for fetching stories.
  * Fetch a single story, optionally applying a `StoryblokSingleStoryQuery`.
  * Fetch multiple stories, optionally applying a `StoryblokMultipleStoryQuery`.
* Added Storyblok Management API for creating and deleting stories.
  * Create a new story.
  * Delete a story by Id.

# What is Storyblok?
* Website: https://www.storyblok.com

# Installation

RXSStoryblokClient is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RXSStoryblokClient'
```

# Examples And Usage
## Initialize Storyblok SDK
### For a single Space
The simplest and most common use case would be to access only a single space. This can easily be done by configuring the shared client exposed by the static `Storyblok` class. You can do so by calling the following function on the shared client.


#### For Content Delivery Access (Fetching Data)

```swift 
Storyblok.shared.configureForContentDeliveryAccess(apiKey: String)
```

#### For Management Access (Fetching & Manipulating Data)

```swift
Storyblok.shared.configureForManagementAccess(apiKey: String, oAuthToken: String, spaceId: String)
```

### For multiple Spaces
If your use case requires access to more than 1 space, you can use the client management functions exposed by the static `Storyblok` class to initialize new ContentDelivery or Management Clients and optionally let them be retained and managed by the static `Storyblok` class by adding an identifier upon creation.

#### For creating a Content Delivery Client you need to manage yourself

```swift
Storyblok.shared.contentDeliveryClient(forApiKey apiKey: String) -> StoryblokClient
```

#### For creating a Content Delivery Client managed by the static `Storyblok` class

```swift
Storyblok.shared.contentDeliveryClient(forApiKey apiKey: String, identifiedBy identifier: String) -> StoryblokClient
```

#### For retrieving a Content Delivery Client managed by the static `Storyblok` class

```swift
Storyblok.shared.contentDeliveryClient(identifiedBy identifier: String) -> StoryblokClient
```

#### For creating a Management Client you need to manage yourself

```swift
Storyblok.shared.managementClient(forApiKey apiKey: String, withOAuthToken token: String, andSpaceId spaceId: String) -> StoryblokClient
```

#### For creating a Management Client managed by the static `Storyblok` class

```swift
Storyblok.shared.managementClient(forApiKey apiKey: String, withOAuthToken token: String, andSpaceId spaceId: String, identifiedBy identifier: String) -> StoryblokClient
```

#### For retrieving a Management Client managed by the static `Storyblok` class

```swift
Storyblok.shared.managementClient(identifiedBy identifier: String) -> StoryblokClient
```

### Custom Client

By default these functions will return a new instance of the `RXSStoryblokClient` class which conforms to the `StoryblokClient` protocol. If for some reason you feel the need to implement custom logic for the communication with the Storyblok API you could create your own `StoryblokClient`. All of the functions above are generic and will create a new instance of the infered Type. 

#### Example for using a custom `StoryblokClient`

```swift
let client: MyStoryblokClient = Storyblok.shared.contentDeliveryClient<Client: StoryblokClient>(forApiKey apiKey: String, identifiedBy identifier: String) -> Client
```

## Usage
Whatever method you choose for creating and managing your `StoryblokClient`s, for actually retrieving and manipulating data the `StoryblokClient` protocol exposes the following functions

#### Fetching a single Story
```swift
func fetchStory<T: StoryContent>(identifiedBy identifier: StoryIdentifier) async throws -> Story<T>?
func fetchStory<T: StoryContent>(identifiedBy identifier: StoryIdentifier, applying query: StoryblokSingleStoryQuery) async throws -> Story<T>?
```

#### Fetching multiple Stories
```swift
func fetchStories<T: StoryContent>(applying query: StoryblokMultiStoryQuery) async throws -> Stories<T>?
```

#### Creating a Story
```swift
func createStory<T: StoryContent>(_ story: ManagementStory<T>) async throws -> ManagementStory<T>?
```

#### Updating a Story
```swift
func updateStory<T: StoryContent>(_ story: ManagementStory<T>) async throws -> ManagementStory<T>?
```

#### Deleting a Story
```swift
func deleteStory(withId id: Int64) async throws
```

## Examples
This is an example for basic usage of the SDK

```swift
//Create a task to call async functions
Task(){
    do{
        //Configure the shared StoryblokClient for Content Delivery Access
        Storyblok.shared.configureForContentDeliveryAccess(apiKey: "3nogoFf7qI8bbvrwtaXQAQtt")
        
        //Explicitely add your expected data type to make sure Swift can infer the generic type for the function call
        //Fetch multiple stories, adding a query that only loads stories that have full slugs starting with "blog"
        if let response: Stories<StoryContent> = try await Storyblok.shared.fetchStories(applying:
                .queryForStories()
                .startingWith("blog")
        ){
            //Do something with the retrieved data
            stories = response.stories
        }
    } catch {
        //Handle error
    }
}
```

## Configuration
You can configure the SDK on a global level by setting the static configurationDelegate property in the `Storyblok` class. To do so, the object you assign has to conform to the `StoryblokConfigurationDelegate`. Note that all of the protocol's functions have default implementations and are therefor not required.

#### Custom DataConnection
If you - for example - already use Alamofire in your project you can return your own implementation of the `DataConnection` protocol here. 
```swift
func dataConnection() -> DataConnection
```

#### Timeouts
```swift
func timeoutIntervalForRequest() -> TimeInterval
func timeoutIntervalForResource() -> TimeInterval
```

#### Cellular Data for Background Downloads
```swift
func allowsCellularAccessForBackgroundDownloads() -> Bool
```

# Author

Medweschek Michael, medwe@me.com

# License

RXSStoryblokClient is available under the MIT license. See the LICENSE file for more info.

