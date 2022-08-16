//
//  ManagementStory.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation

public struct ManagementStory<T: StoryContent>: Codable{
    let story: Story<T>
    let publish: Int //1 = publish, 0 = do not publish //TODO: Check if this can be wrapped to improve usability of the SDK (enum raw value e.g.)
}
