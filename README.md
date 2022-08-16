# Storyblok Swift SDK - 0.1

## TL;DR
This is a Swift SDK/Wrapper around the Storyblok Delivery API and the Storyblok Management API. As of now, only Story fetching, creation and deletion is supported.
### Version 0.1
* Added static Storyblok class for Client Management.
  * Configure and use the shared Client for basic use cases that only require 1 Client.
  * Create new Content Delivery or Management Clients managed by the static Storyblok class and retrieve them at a later time using an identifier.
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
## Cocoapods
Add the following line to your podfile
```
pod 'RXSStoryblokClient'
```
Now install the pod
```
pod install
```

# Examples And Usage
## Initialize Storyblok SDK
The simplest and most common use case would be to access only a single space. This can easily be done by configuring the shared client exposed by the static Storyblok class. You can do so by calling the following function on the shared Client.

For Content Delivery Access (Fetching Data)
`Storyblok.shared.configureForContentDeliveryAccess(apiKey: YOUR_API_KEY)`

For Management Access (Fetching & Manipulating Data)
`Storyblok.shared.configureForManagementAccess(apiKey: String, oAuthToken: String, spaceId: String)`

If your use case requires access to more than 1 space, you can use the client management functions exposed by the static Storyblok class to initialize new ContentDelivery or Management Clients and optionally let them be retained and managed by the static Storyblok class by adding an identifier upon creation.

For creating a Content Delivery Client you need to manage yourself
`Storyblok.shared.contentDeliveryClient(forApiKey apiKey: String) -> StoryblokClient`

For creating a Content Delivery Client managed by the static Storyblok class
`Storyblok.shared.contentDeliveryClient(forApiKey apiKey: String, identifiedBy identifier: String) -> StoryblokClient`

For retrieving a Content Delivery Client managed by the static Storyblok class
`Storyblok.shared.contentDeliveryClient(identifiedBy identifier: String) -> StoryblokClient`

For creating a Management Client you need to manage yourself
`Storyblok.shared.managementClient(forApiKey apiKey: String, withOAuthToken token: String, andSpaceId spaceId: String) -> StoryblokClient`

For creating a Management Client managed by the static Storyblok class
`Storyblok.shared.managementClient(forApiKey apiKey: String, withOAuthToken token: String, andSpaceId spaceId: String, identifiedBy identifier: String) -> StoryblokClient`

For retrieving a Management Client managed by the static Storyblok class
`Storyblok.shared.managementClient(identifiedBy identifier: String) -> StoryblokClient`

By default these functions will return a new instance of the RXSStoryblokClient class which conforms to the StoryblokClient protocol. If for some reason you feel the need to implement custom logic for the communication with the Storyblok API you could create you own StoryblokClient. All of the functions above are generic and will create a new instance of the infered Type. 

An example for using a custom StoryblokClient would be
`let client: MyStoryblokClient = Storyblok.shared.contentDeliveryClient<Client: StoryblokClient>(forApiKey apiKey: String, identifiedBy identifier: String) -> Client`

## Usage
Whatever method you choose for creating and managing you Storyblok clients, for actually retrieving and manipulating data the StoryblokClient protocol exposes the following functions

`func fetchStory<T: StoryContent>(identifiedBy identifier: StoryIdentifier) async throws -> Story<T>?`
`func fetchStory<T: StoryContent>(identifiedBy identifier: StoryIdentifier, applying query: StoryblokSingleStoryQuery) async throws -> Story<T>?`
`func fetchStories<T: StoryContent>(applying query: StoryblokMultiStoryQuery) async throws -> Stories<T>?`
`func createStory<T: StoryContent>(_ story: ManagementStory<T>) async throws -> ManagementStory<T>?`
`func updateStory<T: StoryContent>(_ story: ManagementStory<T>) async throws -> ManagementStory<T>?`
`func deleteStory(withId id: Int64) async throws`

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