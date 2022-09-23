//
//  HtmlSchema.swift
//  Pods-RXSStoryblokClient_Example
//
//  Created by Michael Medweschek on 18.08.22.
//

import Foundation

public class HtmlSchema: RichTextSchema{
    public typealias T = String
        
    public static func transformNode(_ node: RichTextNode, into result: inout String) {
        switch node.type {
        case .Doc:
            transformChildNodes(forNode: node, into: &result)
        case .HorizontalRule, .HardBreak, .Image:
            if let tag = node.associatedTags().first{
                addSingleTag(tag, into: &result)
            }
        case .Blockquote, .CodeBlock, .Heading, .ListItem, .BulletList, .OrderedList, .Paragraph:
            addBlock(wrappedWithTags: node.associatedTags(), containgChildNodesOf: node, into: &result)
        case .Text:
            addTextBlock(wrappedWithTags: node.associatedMarkTags(), containg: node.text ?? "", into: &result)
        case .Blok:
            //Bloks not supported in Html
            break
        }
    }
    
    private static func transformChildNodes(forNode node: RichTextNode, into result: inout String){
        if let content = node.content{
            for subNode in content{
                transformNode(subNode, into: &result)
            }
        }
    }
    
    private static func addBlock(wrappedWithTags tags: [Tag], containgChildNodesOf node: RichTextNode?, into result: inout String){
        for tag in tags{
            result += tag.openingTag()
        }
        if let node = node{
            transformChildNodes(forNode: node, into: &result)
        }
        for tag in tags.reversed(){
            result += tag.closingTag()
        }
    }
    
    private static func addTextBlock(wrappedWithTags tags: [Tag], containg text: String, into result: inout String){
        for tag in tags{
            result += tag.openingTag()
        }
        result += text
        for tag in tags.reversed(){
            result += tag.closingTag()
        }
    }
    
    private static func addSingleTag(_ tag: Tag, into result: inout String){
        result += tag.openingTag()
    }
        
    fileprivate struct Tag{
        let identifier: String
        let attributes: [String: String?]?
        
        init(identifier: String, attributes: [String: String?]? = nil){
            self.identifier = identifier
            self.attributes = attributes
        }
        
        func openingTag() -> String {
            var tag = "<\(identifier)"
            for attribute in attributes ?? [:] where attribute.value != nil{
                tag += " \(attribute.key)=\"\(attribute.value!)\""
            }
            tag += ">"
            return tag
        }
        
        func closingTag() -> String { "</\(identifier)>"}
    }
}

extension RichTextNode{
    fileprivate func associatedTags() -> [HtmlSchema.Tag]{
        switch type {
        case .HorizontalRule:
            return [HtmlSchema.Tag(identifier: "hr")]
            
        case .Blockquote:
            return [HtmlSchema.Tag(identifier: "blockquote")]

        case .BulletList:
            return [HtmlSchema.Tag(identifier: "ul")]

        case .CodeBlock:
            return [HtmlSchema.Tag(identifier: "pre"), HtmlSchema.Tag(identifier: "code")]

        case .HardBreak:
            return [HtmlSchema.Tag(identifier: "br")]


        case .Heading:
            let level = attributes?.level ?? 1
            return [HtmlSchema.Tag(identifier: "h\(level)")]

        case .Image:
            return [HtmlSchema.Tag(identifier: "img", attributes: [
                "src": attributes?.src,
                "alt": attributes?.alt,
                "title": attributes?.title
            ])]

        case .ListItem:
            return [HtmlSchema.Tag(identifier: "li")]

        case .OrderedList:
            return [HtmlSchema.Tag(identifier: "ol")]

        case .Paragraph:
            return [HtmlSchema.Tag(identifier: "p")]

        case .Doc, .Text, .Blok:
            return []
        }
    }
    
    fileprivate func associatedMarkTags() -> [HtmlSchema.Tag]{
        var tags = [HtmlSchema.Tag]()
        for mark in marks ?? []{
            switch mark.type{
            case .Code:
                tags.append(HtmlSchema.Tag(identifier: "code"))
                
            case .Bold:
                tags.append(HtmlSchema.Tag(identifier: "bold"))
                
            case .Italic:
                tags.append(HtmlSchema.Tag(identifier: "i"))

            case .Link:
                tags.append(HtmlSchema.Tag(identifier: "a"))

            case .Strikethrough:
                tags.append(HtmlSchema.Tag(identifier: "s"))

            case .Underline:
                tags.append(HtmlSchema.Tag(identifier: "u"))

            }
        }
        return tags
    }
}
