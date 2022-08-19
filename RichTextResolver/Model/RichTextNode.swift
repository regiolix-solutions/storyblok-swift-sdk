//
//  Node.swift
//  Pods-RXSStoryblokClient_Example
//
//  Created by Michael Medweschek on 18.08.22.
//

import Foundation

public struct RichTextNode: Codable{
    let type: NodeType
    let text: String?
    let marks: [NodeMark]?
    let attributes: NodeAttributes?
    let content: [RichTextNode]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case text
        case marks
        case attributes = "attrs"
        case content
    }
}
