//
//  SBBlogPost.swift
//  RXSStoryblokClient_Example
//
//  Created by Michael Medweschek on 18.08.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import RXSStoryblokClient

class SBBlogPost: StoryContent{
    var richtext: RichTextNode
    
    private enum CodingKeys : String, CodingKey {
        case richtext
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        richtext = try container.decode(RichTextNode.self, forKey: .richtext)
        try super.init(from: decoder)
    }
}
