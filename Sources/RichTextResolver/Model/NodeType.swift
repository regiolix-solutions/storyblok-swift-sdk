//
//  NodeType.swift
//  Pods-RXSStoryblokClient_Example
//
//  Created by Michael Medweschek on 18.08.22.
//

import Foundation

public enum NodeType: String, Codable{
    case Doc = "doc"
    case HorizontalRule = "horizontal_rule"
    case Blockquote = "blockquote"
    case BulletList = "bullet_list"
    case CodeBlock = "code_block"
    case HardBreak = "hard_break"
    case Text = "text"
    case Heading = "heading"
    case Image = "image"
    case ListItem = "list_item"
    case OrderedList = "ordered_list"
    case Paragraph = "paragraph"
    case Blok = "blok"
}
