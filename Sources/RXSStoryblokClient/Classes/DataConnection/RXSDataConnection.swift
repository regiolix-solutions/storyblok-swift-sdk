//
//  RXSDataConnection.swift
//  RXS Storyblok Client
//
//  Created by Michael Medweschek on 12.08.22.
//

import Foundation
import UIKit

public class RXSDataConnection: DataConnection{
    private lazy var defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = configurationDelegate?.timeoutIntervalForRequest() ?? 100
        configuration.timeoutIntervalForResource = configurationDelegate?.timeoutIntervalForResource() ?? 180
        return URLSession(configuration: configuration)
    }()
    
    private lazy var responsiveSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.networkServiceType = .responsiveData
        configuration.timeoutIntervalForRequest = configurationDelegate?.timeoutIntervalForRequest() ?? 100
        configuration.timeoutIntervalForResource = configurationDelegate?.timeoutIntervalForResource() ?? 180
        return URLSession(configuration: configuration)
    }()
    
    private lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        configuration.networkServiceType = .background
        configuration.timeoutIntervalForRequest = configurationDelegate?.timeoutIntervalForRequest() ?? 100
        configuration.timeoutIntervalForResource = configurationDelegate?.timeoutIntervalForResource() ?? 180
        return URLSession(configuration: configuration)
    }()
    
    private weak var configurationDelegate: DataConnectionConfigurationDelegate?
    
    public required init(configurationDelegate: DataConnectionConfigurationDelegate?) {
        self.configurationDelegate = configurationDelegate
    }
    
    public func sendGetRequest<ResponseObject: Decodable>(forPath path: String, options: [DCOption]) async throws -> ResponseObject? {
        return try await sendRequest(forPath: path, withHttpMethod: "GET", options: options)
    }
    
    public func sendPostRequest<ResponseObject: Decodable, BodyObject: Encodable>(forPath path: String, sending body: BodyObject?, options: [DCOption]) async throws -> ResponseObject? {
        return try await sendRequest(forPath: path, withHttpMethod: "POST", sending: body, options: options)
    }
    
    public func sendPutRequest<ResponseObject: Decodable, BodyObject: Encodable>(forPath path: String, sending body: BodyObject?, options: [DCOption]) async throws -> ResponseObject? {
        return try await sendRequest(forPath: path, withHttpMethod: "PUT", sending: body, options: options)
    }
    
    public func sendDeleteRequest(forPath path: String, options: [DCOption]) async throws {
        guard let url = URL(string: path) else { return }
        
        let config = config(forOptions: options)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        if #available(iOS 15.0, *) {
            _ = try await config.session.data(for: request, delegate: nil)
        } else {
            _ = try await withCheckedThrowingContinuation({ continuation in
                startDataTaskWithCheckedThrowingContinuation(onSession: config.session, forRequest: request, andContinuation: continuation)
            })
        }
    }
    
    public func sendMultipartRequest<ResponseObject: Decodable>(forPath path: String, sendingImage image: UIImage, options: [DCOption]) async throws -> ResponseObject? {
        //TODO: Implement Multipart Request if needed
        return nil
    }
    
    private func sendRequest<ResponseObject: Decodable, BodyObject: Encodable>(forPath path: String, withHttpMethod httpMethod: String, sending body: BodyObject?, options: [DCOption]) async throws -> ResponseObject? {
        guard let url = URL(string: path) else { return nil }
        
        let config = config(forOptions: options)
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = data(fromEncodable: body, withDateEncodingStrategy: config.dateEncodingStrategy)
        
        var response: (data: Data, urlResponse: URLResponse)!
        
        if #available(iOS 15.0, *) {
            response = try await config.session.data(for: request, delegate: nil)
        } else {
            response = try await withCheckedThrowingContinuation({ continuation in
                startDataTaskWithCheckedThrowingContinuation(onSession: config.session, forRequest: request, andContinuation: continuation)
            })
        }
        
        return try handle(responseData: response.data, dateDecodingStrategy: config.dateDecodingStrategy)
    }
    
    private func sendRequest<ResponseObject: Decodable>(forPath path: String, withHttpMethod httpMethod: String, options: [DCOption]) async throws -> ResponseObject? {
        guard let url = URL(string: path) else { return nil }
        
        let config = config(forOptions: options)
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        var response: (data: Data, urlResponse: URLResponse)!
        
        if #available(iOS 15.0, *) {
            response = try await config.session.data(for: request, delegate: nil)
        } else {
            response = try await withCheckedThrowingContinuation({ continuation in
                startDataTaskWithCheckedThrowingContinuation(onSession: config.session, forRequest: request, andContinuation: continuation)
            })
        }
        
        return try handle(responseData: response.data, dateDecodingStrategy: config.dateDecodingStrategy)
    }
    
    private func startDataTaskWithCheckedThrowingContinuation(onSession session: URLSession, forRequest request: URLRequest, andContinuation continuation: CheckedContinuation<(Data, URLResponse)?, Error>){
        session.dataTask(with: request) { data, urlResponse, error in
            if let error = error{
                continuation.resume(with: .failure(error))
            }else if let data = data, let urlResponse = urlResponse{
                continuation.resume(with: .success((data, urlResponse)))
            }else{
                continuation.resume(with: .success(nil))
            }
        }.resume()
    }
}

//MARK: Private Helper Functions

extension RXSDataConnection{
    private func config(forOptions options: [DCOption]) -> RequestConfig{
        var session: URLSession = defaultSession
        var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601
        var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .iso8601
        
        for option in options {
            switch option {
            case .networkingType(let networkingType):
                switch networkingType {
                case .ResponsiveData:
                    session = responsiveSession
                case .Default:
                    session = defaultSession
                case .Download:
                    session = downloadSession
                }
            case .dateDecodingStrategy(let selectedDecodingStrategy):
                dateDecodingStrategy = selectedDecodingStrategy
            case .dateEncodingStrategy(let selectedEncodingStrategy):
                dateEncodingStrategy = selectedEncodingStrategy
            }
        }
        
        return RequestConfig(session: session, dateDecodingStrategy: dateDecodingStrategy, dateEncodingStrategy: dateEncodingStrategy)
    }
    
    private func data<BodyObject: Encodable>(fromEncodable encodable: BodyObject, withDateEncodingStrategy dateEncodingStrategy: JSONEncoder.DateEncodingStrategy) -> Data?{
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = dateEncodingStrategy
        if let jsonData = try? encoder.encode(encodable) {
            return jsonData
        }
        return nil
    }
}

struct RequestConfig{
    let session: URLSession
    let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy
    let dateEncodingStrategy: JSONEncoder.DateEncodingStrategy
}
