//
//  StoryContent.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation

public class StoryContent: Codable{
    let _uid: String
    let component: String
    
    init(_uid: String, component: String){
        self._uid = _uid
        self.component = component
    }
}
