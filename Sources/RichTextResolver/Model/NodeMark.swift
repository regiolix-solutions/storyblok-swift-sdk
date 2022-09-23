//
//  NodeMarks.swift
//  Pods-RXSStoryblokClient_Example
//
//  Created by Michael Medweschek on 18.08.22.
//

import Foundation

struct NodeMark: Codable{
    let type: NodeMarkType
}

enum NodeMarkType: String, Codable{
    case Bold = "bold"
    case Italic = "italic"
    case Strikethrough = "strike"
    case Underline = "underline"
    case Code = "code"
    case Link = "link"
}
