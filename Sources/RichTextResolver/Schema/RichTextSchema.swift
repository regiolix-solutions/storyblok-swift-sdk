//
//  RichTextSchema.swift
//  Pods-RXSStoryblokClient_Example
//
//  Created by Michael Medweschek on 18.08.22.
//

import Foundation

public protocol RichTextSchema{
    associatedtype T
    static func transformNode(_ node: RichTextNode, into result: inout T)
}
