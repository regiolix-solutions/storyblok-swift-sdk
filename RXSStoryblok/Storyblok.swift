//
//  Storyblok.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation

public class Storyblok{
    
    //MARK: Configuration
    
    public static weak var configurationDelegate: StoryblokConfigurationDelegate?
    
    //MARK: Exposed Properties
    
    public static var shared: StoryblokClient = RXSStoryblokClient()
    
    //MARK: Internal Properties
    
    internal static var dataConnection: DataConnection {
        configurationDelegate?.dataConnection() ?? defaultDataConnection
    }
    
    //MARK: Private Properties
    
    private static var managedClients: [String: StoryblokClient] = [:]
    
    private static var defaultDataConnection = RXSDataConnection(configurationDelegate: nil)
    
    //MARK: Exposed Functions
        
    public static func contentDeliveryClient(forApiKey apiKey: String) -> StoryblokClient{
        RXSStoryblokClient(forApiKey: apiKey)
    }
    
    public static func contentDeliveryClient<Client: StoryblokClient>(forApiKey apiKey: String) -> Client{
        Client(forApiKey: apiKey)
    }
    
    public static func contentDeliveryClient(forApiKey apiKey: String, identifiedBy identifier: String) -> StoryblokClient{
        let newClient = RXSStoryblokClient(forApiKey: apiKey)
        managedClients.updateValue(newClient, forKey: identifier)
        return newClient
    }
    
    public static func contentDeliveryClient<Client: StoryblokClient>(forApiKey apiKey: String, identifiedBy identifier: String) -> Client{
        let newClient = Client(forApiKey: apiKey)
        managedClients.updateValue(newClient, forKey: identifier)
        return newClient
    }
    
    public static func contentDeliveryClient(identifiedBy identifier: String) -> StoryblokClient?{
        if let managedClient = managedClients[identifier]{
            return managedClient
        }
        return nil
    }
    
    public static func contentDeliveryClient<Client: StoryblokClient>(identifiedBy identifier: String) -> Client?{
        if let managedClient = managedClients[identifier] as? Client{
            return managedClient
        }
        return nil
    }
    
    public static func managementClient(forApiKey apiKey: String, withOAuthToken token: String, andSpaceId spaceId: String) -> StoryblokClient{
        RXSStoryblokClient(forApiKey: apiKey, withOAuthToken: token, andSpaceId: spaceId)
    }
    
    public static func managementClient<Client: StoryblokClient>(forApiKey apiKey: String, withOAuthToken token: String, andSpaceId spaceId: String) -> Client{
        Client(forApiKey: apiKey, withOAuthToken: token, andSpaceId: spaceId)
    }
    
    public static func managementClient(forApiKey apiKey: String, withOAuthToken token: String, andSpaceId spaceId: String, identifiedBy identifier: String) -> StoryblokClient{
        let newClient = RXSStoryblokClient(forApiKey: apiKey, withOAuthToken: token, andSpaceId: spaceId)
        managedClients.updateValue(newClient, forKey: identifier)
        return newClient
    }
    
    public static func managementClient<Client: StoryblokClient>(forApiKey apiKey: String, withOAuthToken token: String, andSpaceId spaceId: String, identifiedBy identifier: String) -> Client{
        let newClient = Client(forApiKey: apiKey, withOAuthToken: token, andSpaceId: spaceId)
        managedClients.updateValue(newClient, forKey: identifier)
        return newClient
    }
    
    public static func managementClient(identifiedBy identifier: String) -> StoryblokClient?{
        if let managedClient = managedClients[identifier]{
            return managedClient
        }
        return nil
    }
    
    public static func managementClient<Client: StoryblokClient>(identifiedBy identifier: String) -> Client?{
        if let managedClient = managedClients[identifier] as? Client{
            return managedClient
        }
        return nil
    }
}

public protocol StoryblokConfigurationDelegate: DataConnectionConfigurationDelegate{
    func dataConnection() -> DataConnection
}

public extension StoryblokConfigurationDelegate{
    func dataConnection() -> DataConnection{
        RXSDataConnection(configurationDelegate: self)
    }
}
