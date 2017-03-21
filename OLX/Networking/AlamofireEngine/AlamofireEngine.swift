//
//  AlamofireEngine.swift
//  OLX
//
//  Created by Jake Enzien on 3/12/17.
//  Copyright © 2017 Jacob Enzien. All rights reserved.
//

import Alamofire
import Foundation
import Freddy

final class AlamofireEngine: NetworkEngine {
    
    private let sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
    private let delegate: Alamofire.SessionDelegate
    private let adapter = OfflineModeAdapter()
    init() {
        self.delegate = sessionManager.delegate
        sessionManager.adapter = adapter
        delegate.dataTaskWillCacheResponse = { (session, dataTask, cachedResponse) -> CachedURLResponse? in
            return cachedResponse
        }
    }
    
    // MARK: - NetworkEngine
    func enqueue<Model: JSONDecodable>(url: URL, params: [String: String], forceCache: Bool, completion: @escaping (Model?,Error?)->()) {
        sessionManager.request(url, parameters: params).responseData { [weak self] (response) in
            guard let `self` = self else {
                return
            }
            
            if response.error != nil {
                completion(nil, response.error)
                return
            }
            
            let parseResponse: (model: Model?, error: Error?) = self.parseResponse(response: response)
            completion(parseResponse.model, parseResponse.error)
        }
    }
    
    // MARK: - private
    func parseResponse<Model: JSONDecodable>(response: DataResponse<Data>) -> (model: Model?, error: Error?) {
        guard let data = response.data else {
            return (nil, nil)
        }
        
        do {
            let json = try JSON(data: data)
            let model = try Model(json: json)
            return (model, nil)
        } catch {
            return (nil, error)
        }
    }
    
    private final class OfflineModeAdapter: RequestAdapter {
        private let manager = NetworkReachabilityManager(host: "api-v2.olx.com")
        private var currentReachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
        
        init() {
            manager?.listener = { [weak self] status in
                self?.currentReachabilityStatus = status
            }
            manager?.startListening()
        }
        
        deinit {
            manager?.stopListening()
        }
        
        func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
            var urlRequest = urlRequest
            
            switch currentReachabilityStatus {
            case .reachable, .unknown:
                urlRequest.cachePolicy = .useProtocolCachePolicy
            default:
                urlRequest.cachePolicy = .returnCacheDataElseLoad
                
            }
            
            return urlRequest
        }
    }
}
