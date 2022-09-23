//
//  SingleStory.swift
//  RXSStoryblokClient
//
//  Created by Luís Miguel Novais Lopes on 23/09/2022.
//

import Foundation

public struct SingleStory<T: StoryContent>: Codable{
    public let story: Story<T>
}
