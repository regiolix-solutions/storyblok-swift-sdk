//
//  StoryblokClient.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation

public protocol StoryblokClient{
    init()
    init(forApiKey apiKey: String)
    init(forApiKey apiKey: String, withOAuthToken token: String, andSpaceId spaceId: String)
    func configureForContentDeliveryAccess(apiKey: String)
    func configureForManagementAccess(apiKey: String, oAuthToken: String, spaceId: String)
    func fetchStory<T: StoryContent>(identifiedBy identifier: StoryIdentifier) async throws -> Story<T>?
    func fetchStory<T: StoryContent>(identifiedBy identifier: StoryIdentifier, applying query: StoryblokSingleStoryQuery) async throws -> Story<T>?
    func fetchStories<T: StoryContent>(applying query: StoryblokMultiStoryQuery) async throws -> Stories<T>?
    func createStory<T: StoryContent>(_ story: ManagementStory<T>) async throws -> ManagementStory<T>?
    func updateStory<T: StoryContent>(_ story: ManagementStory<T>) async throws -> ManagementStory<T>?
    func deleteStory(withId id: Int64) async throws
    //func uploadAsset(withFilename filename: String, andImageSize size: String) async throws -> AssetUpload?
    //func uploadAsset(withFilename filename: String, andImageSize size: String, intoFolderWithId assetFolderId: String) async throws -> AssetUpload?
}
