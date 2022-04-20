//
//  NetworkManager.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 20.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import Foundation

final class NetworkManager {
    
    typealias RemoteDataResult<Value> = Result<Value, RemoteDataError>
    
    private let dispatchQueueMain: DispatchQueue = .main
    
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - 1. Data Task
    // Fetch Data and Create Task
    /// Fetch Data and Create Task with URL
    /// - Parameters:
    ///   - url: URL value which is URL.
    ///   - completionHandler: (Result<Data, NetworkError>) -> Void.
    private func fetchData(with url: URL,
                           completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        
        dispatchQueueMain.async { [weak self] in
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                let responseMessage = self?.fetchResponseErrorMessage(with: response, from: data)
                
                let dataTaskError: NetworkError? = {
                    switch responseMessage {
                    case let (message?): return NetworkError.response(message)
                    default:             return error.map { NetworkError.fetchFailed($0)}
                    }
                }()
                
                let result = Result<Data, NetworkError>(value: data, error: dataTaskError)
                completionHandler(result)
            }
            task.resume()
        }
            
    }
    
    
    // to handle response message from the response code that is fetched from server
    private func fetchResponseErrorMessage(with response: URLResponse?, from data: Data?) -> String? {
        let responseCode = getResponseCode(from: response)
        guard responseCode != 200 else { return nil }
        guard let data = data else { return nil }

        let object = try? JSONDecoder().decode(ResponseData.self, from: data)
        return "\(object?.statusCode ?? 007). \(object?.statusMessage ?? "Unknown Error message")"
    }
    
    private func getResponseCode(from response: URLResponse?) -> Int {
        let response = response as? HTTPURLResponse
        
        let data = response?.description
        Logger.verbose("\(data ?? "response?.description = nil") ")
        return response?.statusCode ?? 400
    }
        
    // MARK: - 2. Fetch Result
    
    
    /// Generic function to fetch data from .json file which is come from server.
    ///
    /// - Parameters:
    ///   - endpoint: [Endpoint](x-source-tag://Endpoint)
    ///   - completion: (RemoteDataResult<T>
    func fetchResult<T: Decodable>(
        endpoint: Endpoint,
        completion: @escaping (RemoteDataResult<T>) -> Void) {
            
            Logger.verbose(endpoint.urlString)
            
            guard let url = URL(string: endpoint.urlString) else {
                completion(.failure(RemoteDataError.unknown)); return
            }
            
            fetchData(with: url) { result in
                switch result {
                case .failure(let networkError):
                    completion(.failure(RemoteDataError.known(networkError.localizedDescription)))
                case .success(let data):
                    do {
                        let object = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(object))
                    } catch {
                        completion(.failure(RemoteDataError.unknown))
                    }
                }
            }
        }
    
}

// MARK: - Swift.Result
extension Swift.Result {
      // ... snip
    init(value: Success?, error: Failure?) {
        if let error = error {
            self = .failure(error)
        } else if let value = value {
            self = .success(value)
        } else {
            fatalError("Could not create Result")
        }
    }
}
