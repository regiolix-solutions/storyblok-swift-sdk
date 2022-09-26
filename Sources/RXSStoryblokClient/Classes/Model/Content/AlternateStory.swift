//
//  AlternateStory.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation

public struct AlternateStory: Codable{
    let id: Int64
    let name: String
    let slug: String
    let fullSlug: String
    let isFolder: Bool
    let parentId: Int64
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case fullSlug = "full_slug"
        case isFolder = "is_folder"
        case parentId = "parent_id"
    }
}
