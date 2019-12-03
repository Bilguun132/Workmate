//
//  APIService.swift
//  Workmate
//
//  Created by Bilguun Batbold on 3/12/19.
//  Copyright © 2019 Bilguun. All rights reserved.
//

import Foundation

class APIService {
    
    //MARK: - Variables

    private var apiKey = ""
    
    private let baseURLString = "https://api.helpster.tech/v1"
    var baseURL: URL? = nil
    
    private let urlSession = URLSession.shared
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    enum ServiceEndPoint: String {
        case login = "auth/login/"
        case testStaff = "staff-requests/26074/"
        case testStaffClockIn = "staff-requests/26074/clock-in/"
        case testStaffClockOut = "staff-requests/26074/clock-out/"
    }
    
    static let shared = APIService()
    
    init (){
        self.baseURL = URL(string: baseURLString)
    }
    
    //MARK: - Generic Private Methods
    
    /**
     Generic method to fetch resources of type T
     
     - parameter url: request url
     - parameter completion: completion handler
     
     - returns: Result<>
     
     */
    
    private func fetchResources<T:Decodable>(url: URL, completion: @escaping (Result<T, APIServiceError>) -> ()) {
        
        urlSession.dataTask(with: url) { (result) in
            switch result {
            case .success(let (response,data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure( _):
                completion(.failure(.apiError))
            }
        }.resume()
    }
    
    /**
     Generic method to fetch resources of type T
     
     - parameter request: ful request
     - parameter completion: completion handler
     
     - returns: Result<>
     
     */
    
    private func fetchResources<T:Decodable>(request: URLRequest, completion: @escaping (Result<T, APIServiceError>) -> ()) {
        
        urlSession.dataTask(with: request) { (result) in
            switch result {
            case .success(let (response,data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure( _):
                completion(.failure(.apiError))
            }
        }.resume()
    }
    
    //MARK: - Public function
    
    func login(username: String = "+6281313272005", password: String = "alexander", result: @escaping (Result<LoginResponse, APIServiceError>) -> ()) {
        guard let loginUrl = baseURL?.appendingPathComponent(ServiceEndPoint.login.rawValue) else {
            result(.failure(.invalidEndpoint))
            return
        }
        
        var postBody = [String: String]()
        postBody["username"] = username
        postBody["password"] = password
        do {
            let data = try JSONSerialization.data(withJSONObject: postBody, options: [])
            var request = URLRequest(url: loginUrl)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            fetchResources(request: request, completion: result)
        }
        catch {
            result(.failure(.invalidEndpoint))
        }
    }
    
    func getTestUser(result: @escaping (Result<User, APIServiceError>) -> ()) {
        guard let url = baseURL?.appendingPathComponent(ServiceEndPoint.testStaff.rawValue) else {
            result(.failure(.invalidEndpoint))
            return
        }
        
        fetchResources(url: url, completion: result)
    }
    
    func clockInTestUser(latitude: String = "-6.2446691", longitude: String = "106.8779625", result: @escaping (Result<ClockInResponse, APIServiceError>) -> ()) {
        guard let clockInUrl = baseURL?.appendingPathComponent(ServiceEndPoint.testStaffClockIn.rawValue) else {
            result(.failure(.invalidEndpoint))
            return
        }
        
        var postBody = [String: String]()
        postBody["latitude"] = latitude
        postBody["longitude"] = longitude
        do {
            let data = try JSONSerialization.data(withJSONObject: postBody, options: [])
            var request = URLRequest(url: clockInUrl)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(apiKey, forHTTPHeaderField: "Authorization")
            fetchResources(request: request, completion: result)
        }
        catch {
            result(.failure(.invalidEndpoint))
        }
    }
    
    func clockOutTestUser(latitude: String = "-6.2446691", longitude: String = "106.8779625", result: @escaping (Result<ClockOutResponse, APIServiceError>) -> ()) {
        guard let clockOutUrl = baseURL?.appendingPathComponent(ServiceEndPoint.testStaffClockOut.rawValue) else {
            result(.failure(.invalidEndpoint))
            return
        }
        
        var postBody = [String: String]()
        postBody["latitude"] = latitude
        postBody["longitude"] = longitude
        do {
            let data = try JSONSerialization.data(withJSONObject: postBody, options: [])
            var request = URLRequest(url: clockOutUrl)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(apiKey, forHTTPHeaderField: "Authorization")
            fetchResources(request: request, completion: result)
        }
        catch {
            result(.failure(.invalidEndpoint))
        }
    }
    
    func setApiKey(with key: String) {
        self.apiKey = key
    }
    
    
}


public enum APIServiceError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}
