//
//  Story.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation

public struct Story<T: StoryContent>: Codable{
    public let id: Int64
    public let uuid: UUID
    public let name: String
    public let slug: String
    public let fullSlug: String
    public let defaultFullSlug: String?
    public let createdAt: Date?
    public let publishedAt: Date?
    public let releaseId: String?
    public let lang: String?
    public let content: T
    public let position: Int
    public let isStartpage: Bool
    public let tagList: [String]
    public let parentId: Int64?
    public let groupId: UUID?
    public let translatedSlugs: [TranslatedSlug]?
    public let alternates: [AlternateStory]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case uuid
        case name
        case slug
        case fullSlug = "full_slug"
        case defaultFullSlug = "default_full_slug"
        case createdAt = "created_at"
        case publishedAt = "published_at"
        case releaseId = "release_id"
        case lang
        case content
        case position
        case isStartpage = "is_startpage"
        case tagList = "tag_list"
        case parentId = "parent_id"
        case groupId = "group_id"
        case translatedSlugs = "translated_slugs"
        case alternates
    }
}
