//
//  AssetUploadBody.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation

public struct AssetUploadBody{
    let filename: String
    let size: String
    let assetFolder: String
    
    enum CodingKeys: String, CodingKey {
        case filename
        case size
        case assetFolder = "asset_folder"
    }
}
