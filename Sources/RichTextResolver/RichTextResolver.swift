//
//  RichTextResolver.swift
//  Pods-RXSStoryblokClient_Example
//
//  Created by Michael Medweschek on 18.08.22.
//

import Foundation

public class RichTextResolver{
    public static func resolveNode<Schema: RichTextSchema>(_ node: RichTextNode, applyingSchema schema: Schema.Type, into initialValue: inout Schema.T){
        schema.transformNode(node, into: &initialValue)
    }
}
