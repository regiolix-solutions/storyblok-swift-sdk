//
//  AssetUpload.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation

public struct AssetUpload{
    let prettyUrl: String
    let publicUrl: String
    let postUrl: String
    let fields: Fields
    
    enum CodingKeys: String, CodingKey {
        case prettyUrl = "pretty_url"
        case publicUrl = "public_url"
        case postUrl = "post_url"
        case fields
    }
}
