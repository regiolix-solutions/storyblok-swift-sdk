//
//  Fields.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation

public struct Fields{
    let key: String
    let acl: String
    let expires: String
    let cacheControl: String
    let contentType: String
    let policy: String
    let xAmzCredential: String
    let xAmzAlgorithm: String
    let xAmzDate: String
    let xAmzSignature: String
    
    enum CodingKeys: String, CodingKey {
        case key
        case acl
        case expires = "Expires"
        case cacheControl = "Cache-Control"
        case contentType = "Content-Type"
        case policy
        case xAmzCredential = "x-amz-credential"
        case xAmzAlgorithm = "x-amz-algorithm"
        case xAmzDate = "x-amz-date"
        case xAmzSignature = "x-amz-signature"
    }
}
