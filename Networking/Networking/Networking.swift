//
//  Networking.swift
//  Networking
//
//  Created by Lee on 8/5/21.
//

import Foundation

enum NetError: Error {
    case badURL
    case badRequest(Error)
    case couldNotUnwrap
}

class NetworkServicing {
//    typealias DataCompletion = (Result<Data, NetError>) -> Void
//    func perform(urlRequest: URLRequest, completion: @escaping DataCompletion)
    static let shared = NetworkServicing()

    func perform(urlRequest: URLRequest, completion: @escaping (Result<Data, NetError>) -> Void) {
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Error: \(error)\nFunction: \(#function)\nDescription: \(error.localizedDescription)")
                return completion(.failure(.badRequest(error)))
            }
            if let response = response as? HTTPURLResponse {
                print("RESPONSE CODE: \(response.statusCode)")
            }
            guard let data = data else {completion(.failure(.couldNotUnwrap))
                return
            }
            DispatchQueue.main.async { completion(.success(data)) }
        }.resume()
    }
    
    func fetch<T: Decodable>(_ endpoint: PostServiceEndPoint, completion: @escaping (Result<T, NetError>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(.badURL))
            return
        }
        print(url.absoluteString)
        perform(urlRequest: URLRequest(url: url)) { result in
            switch result {
            case .success(let data):
                guard let decodedObjects = data.decode(type: T.self) else {
                    completion(.failure(.couldNotUnwrap))
                    return
                }
                completion(.success(decodedObjects))
            case .failure(let error):
                completion(.failure(.badRequest(error)))
            }
        }
    }
}

extension Data {
    func decode<T: Decodable>(type: T.Type, decoder: JSONDecoder = JSONDecoder()) -> T? {
        do {
            let object = try decoder.decode(T.self, from: self)
            return object
        } catch {
            print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
        }
        return nil
    }
}
