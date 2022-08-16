//
//  DataConnection.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation
import UIKit

public protocol DataConnection{
    init(configurationDelegate: DataConnectionConfigurationDelegate?)
    
    func sendGetRequest<ResponseObject: Decodable>(forPath path: String, options: [DCOption]) async throws -> ResponseObject?
    func sendPostRequest<ResponseObject: Decodable, BodyObject: Encodable>(forPath path: String, sending body: BodyObject?, options: [DCOption]) async throws -> ResponseObject?
    func sendPutRequest<ResponseObject: Decodable, BodyObject: Encodable>(forPath path: String, sending body: BodyObject?, options: [DCOption]) async throws -> ResponseObject?
    func sendDeleteRequest(forPath path: String, options: [DCOption]) async throws
    func sendMultipartRequest<ResponseObject: Decodable>(forPath path: String, sendingImage image: UIImage, options: [DCOption]) async throws -> ResponseObject?
    func handle<ResponseObject: Decodable>(responseData data: Data?, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy) throws -> ResponseObject?
}

public extension DataConnection{
    func handle<ResponseObject: Decodable>(responseData data: Data?, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy) throws -> ResponseObject?{
        do{
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            return try decoder.decode(ResponseObject.self, from: data ?? Data())
        }catch let decodeError {
            print("===DECODINGERROR===")
            print(decodeError.localizedDescription)
            print("===================")
            print(decodeError)
            print("===================")
            print(String(data: data ?? Data(), encoding: .utf8) ?? "")
            print("===================")
            return nil
        }
    }
}

public protocol DataConnectionConfigurationDelegate: NSObject{
    func timeoutIntervalForRequest() -> TimeInterval
    func timeoutIntervalForResource() -> TimeInterval
    func allowsCellularAccessForBackgroundDownloads() -> Bool
}

public extension DataConnectionConfigurationDelegate{
    func timeoutIntervalForRequest() -> TimeInterval{
        100
    }
    
    func timeoutIntervalForResource() -> TimeInterval{
        180
    }
    
    func allowsCellularAccessForBackgroundDownloads() -> Bool{
        true
    }
}

public enum DCNetworkingType{
    case ResponsiveData
    case Default
    case Download
}

public enum DCOption{
    case networkingType(_ type: DCNetworkingType)
    case dateDecodingStrategy(_ strategy: JSONDecoder.DateDecodingStrategy)
    case dateEncodingStrategy(_ strategy: JSONEncoder.DateEncodingStrategy)
}
