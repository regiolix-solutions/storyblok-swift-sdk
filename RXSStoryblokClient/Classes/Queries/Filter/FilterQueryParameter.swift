//
//  FilterQueryParameter.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation

public class FilterQueryParameter: NSObject{
    public override var description: String { "filter_query[\(attribute)][\(filterOperation.rawValue)]=\(value)" }
    
    let attribute: String
    let filterOperation: FilterOperation
    let value: String
    
    init(whereAttribute attribute: String, is operation: FilterOperation, value: String){
        self.attribute = attribute
        self.filterOperation = operation
        self.value = value
    }
}
