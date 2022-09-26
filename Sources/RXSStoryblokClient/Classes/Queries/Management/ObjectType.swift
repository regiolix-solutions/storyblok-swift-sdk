//
//  ObjectType.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation

public enum ObjectType{
    case Story
    case Asset
    
    func path() -> String{
        switch self {
        case .Story:
            return "stories/"
        case .Asset:
            return "assets/"
        }
    }
}
