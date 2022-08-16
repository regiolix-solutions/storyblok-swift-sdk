//
//  Stories.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation

public struct Stories<T: Codable>: Codable{
    public let stories: [Story<T>]
    public let perPage: Int?
    public let total: Int?
    
    enum CodingKeys: String, CodingKey {
        case stories
        case perPage = "per_page"
        case total
    }
}
