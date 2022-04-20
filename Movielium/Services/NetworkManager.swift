//
//  NetworkManager.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 20.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import Foundation

/// Body parameters to post
/// - Tag: APIParameters
typealias APIParameters = [String: String]

final class NetworkManager {
    
    private typealias RemoteDataResult<Value> = Result<Value, RemoteDataError>
    
    private let dispatchQueueMain: DispatchQueue = .main
    
    // MARK: - HTTPMethods
    /// - Tag: HTTPMethod
    enum HTTPMethod: String {
        case post
        case get
    }
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - 1. Request
    // 1. Create Request
    private func createRequest(with url: URL, method: HTTPMethod, parameters: APIParameters) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        let body = handleBody(with: parameters)
        request.httpBody = body.data(using: .utf8)
        return request
    }
    
    // MARK: - 2. Data Task
    // Fetch Data and Create Task
    /// Fetch Data and Create Task with URL
    /// - Parameters:
    ///   - url: URL value which is URL.
    ///   - method: [HTTPMethod](x-source-tag://HTTPMethod)
    ///   - parameters: [APIParameters](x-source-tag://APIParameters).
    ///   - completion: (Result<Data, NetworkError>) -> Void.
    func fetchData(with url: URL, method: HTTPMethod, parameters: APIParameters,
                         completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        dispatchQueueMain.async { [weak self] in
            guard let request = self?.createRequest(with: url, method: method, parameters: parameters) else {
                completionHandler(.failure(NetworkError.unknown)); return
            }
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
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
        let object = try? JSONDecoder().decode(ResponseData.self, from: data!)
        return object?.statusMessage
    }
    
    private func getResponseCode(from response: URLResponse?) -> Int {
        let response = response as? HTTPURLResponse
        return response?.statusCode ?? 400
    }
        
    // MARK: - 3. Fetch Result
    private func fetchResult<T: Decodable>(
        endpoint: Endpoint,
        method: HTTPMethod,
        parameters: APIParameters,
        completion: @escaping (RemoteDataResult<T>) -> Void) {
            
        guard let url = URL(string: endpoint.urlString) else {
            completion(.failure(RemoteDataError.unknown)); return
        }
        
        fetchData(with: url, method: method, parameters: parameters) { result in
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
    
    // MARK: - Parameters
    
    /// Creates a percent-escaped, URL encoded query string components from the given key-value pair recursively.
    ///
    /// - Parameters:
    ///   - key:   Key of the query component.
    ///   - value: Value of the query component.
    ///
    /// - Returns: The percent-escaped, URL encoded query string components.
    private func queryComponents(from dictionary: APIParameters) -> [(String, String)] {
        return dictionary.map { (escape($0.key), escape("\($0.value)")) }
    }
    
    /// Creates a percent-escaped string following RFC 3986 for a query string key or value.
    ///
    /// - Parameter string: `String` to be percent-escaped.
    ///
    /// - Returns:          The percent-escaped `String`.
    public func escape(_ string: String) -> String {
        string.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? string
    }
    
    private func handleBody(with parameters: APIParameters) -> String {
        return queryComponents(from: parameters).map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
}

// MARK: - CharacterSet
extension CharacterSet {
    /// Creates a CharacterSet from RFC 3986 allowed characters.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    public static let afURLQueryAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }()
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
