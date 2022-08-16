//
//  RXSStoryblokClient.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation

public class RXSStoryblokClient: StoryblokClient{
    
    //MARK: Constants
    
    private var CONTENT_DELIVERY_V2_API_URL: String {
        "https://api" + (regionCode != nil ? "{\(regionCode!)}" : "") + ".storyblok.com/v2/cdn"
    }
    private var MANAGEMENT_API_URL: String {
        "https://mapi.storyblok.com"
    }
    private let DEFAULT_DATE_FORMATTER: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }()
    private var DEFAULT_DATE_DECODING_STRATEGY: JSONDecoder.DateDecodingStrategy {
        .formatted(DEFAULT_DATE_FORMATTER)
    }
    private var DEFAULT_DATE_ENCODING_STRATEGY: JSONEncoder.DateEncodingStrategy {
        .formatted(DEFAULT_DATE_FORMATTER)
    }
    
    //MARK: Properties
    
    private var apiKey: String?
    private var oAuthToken: String?
    private var spaceId: String?
    
    public var regionCode: String?
    
    //MARK: Initializer
    
    public required init() {}
    
    public required init(forApiKey apiKey: String){
        configureForContentDeliveryAccess(apiKey: apiKey)
    }
    
    public required init(forApiKey apiKey: String, withOAuthToken oAuthToken: String, andSpaceId spaceId: String){
        configureForManagementAccess(apiKey: apiKey, oAuthToken: oAuthToken, spaceId: spaceId)
    }
    
    //MARK: Configuration

    public func configureForContentDeliveryAccess(apiKey: String) {
        self.apiKey = apiKey
    }
    
    public func configureForManagementAccess(apiKey: String, oAuthToken: String, spaceId: String) {
        self.apiKey = apiKey
        self.oAuthToken = oAuthToken
        self.spaceId = spaceId
    }
    
    //MARK: Public API
    
    //Content Delivery V2 API
    public func fetchStory<T: StoryContent>(identifiedBy identifier: StoryIdentifier) async throws -> Story<T>? {
        let path = CONTENT_DELIVERY_V2_API_URL + "/stories/" + path(forStoryIdentifier: identifier)
        return try await Storyblok.configurationDelegate?.dataConnection().sendGetRequest(
            forPath: path,
            options: defaultOptions(withNetworkingType: .Default)
        )
    }
    
    //Content Delivery V2 API
    public func fetchStory<T: StoryContent>(identifiedBy identifier: StoryIdentifier, applying query: StoryblokSingleStoryQuery) async throws -> Story<T>? {
        let path = CONTENT_DELIVERY_V2_API_URL + "/stories/" + path(forStoryIdentifier: identifier) + query.description
        return try await Storyblok.configurationDelegate?.dataConnection().sendGetRequest(
            forPath: path,
            options: defaultOptions(withNetworkingType: .Default)
        )
    }
    
    //Content Delivery V2 API
    public func fetchStories<T: StoryContent>(applying query: StoryblokMultiStoryQuery) async throws -> Stories<T>? {
        let path = CONTENT_DELIVERY_V2_API_URL + "/stories/" + path(forStoryIdentifier: nil) + query.description
        return try await Storyblok.dataConnection.sendGetRequest(
            forPath: path,
            options: defaultOptions(withNetworkingType: .Default)
        )
    }
    
    //Management API
    public func createStory<T: StoryContent>(_ story: ManagementStory<T>) async throws -> ManagementStory<T>? {
        let path = MANAGEMENT_API_URL + "v1/spaces/\(spaceId ?? "SPACE ID REQUIRED")/stories/"
        return try await Storyblok.dataConnection.sendPostRequest(
            forPath: path,
            sending: story,
            options: defaultOptions(withNetworkingType: .Default)
        )
    }
    
    //Management API
    public func updateStory<T: StoryContent>(_ story: ManagementStory<T>) async throws -> ManagementStory<T>? {
        let path = MANAGEMENT_API_URL + "v1/spaces/\(spaceId ?? "SPACE ID REQUIRED")/stories/\(story.story.id)"
        return try await Storyblok.dataConnection.sendPutRequest(
            forPath: path,
            sending: story,
            options: defaultOptions(withNetworkingType: .Default)
        )
    }
    
    //Management API
    public func deleteStory(withId id: Int64) async throws{
        let path = MANAGEMENT_API_URL + "v1/spaces/\(spaceId ?? "SPACE ID REQUIRED")/stories/\(id)"
        try await Storyblok.dataConnection.sendDeleteRequest(
            forPath: path,
            options: defaultOptions(withNetworkingType: .Default)
        )
    }
    
    //Management API
//    public func uploadAsset(withFilename filename: String, andImageSize size: String) async throws -> AssetUpload? {
//        return nil
//    }
    
    //Management API
//    public func uploadAsset(withFilename filename: String, andImageSize size: String, intoFolderWithId assetFolderId: String) async throws -> AssetUpload? {
//       return nil
//    }
}

//MARK: Private Helpers

extension RXSStoryblokClient{
    private func path(forStoryIdentifier storyIdentifier: StoryIdentifier?) -> String{
        var path = ""
        var additionalParameter = ""
        
        if let storyIdentifier = storyIdentifier {
            switch storyIdentifier {
            case .Slug(let fullSlug):
                path += fullSlug
            case .ID(let storyId):
                path += storyId
            case .UUID(let uuid):
                path += uuid
                additionalParameter += "find_by=uuid"
            }
        }
        path += "?token=\(apiKey ?? "==API KEY MISSING==")" + (!additionalParameter.isEmpty ? "&\(additionalParameter)" : "")
        
        return path
    }
    
    private func defaultOptions(withNetworkingType networkingType: DCNetworkingType) -> [DCOption]{
        return [
            .dateDecodingStrategy(DEFAULT_DATE_DECODING_STRATEGY),
            .dateEncodingStrategy(DEFAULT_DATE_ENCODING_STRATEGY),
            .networkingType(networkingType)
        ]
    }
}
