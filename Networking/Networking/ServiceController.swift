//
//  ServiceController.swift
//  Networking
//
//  Created by Lee on 8/5/21.
//

import Foundation

/*
 GET Posts ==> https://jsonplaceholder.typicode.com/posts
 GET Post Comments ==> https://jsonplaceholder.typicode.com/comments?postId=1
 POST Post ==>  https://jsonplaceholder.typicode.com/posts
 */

enum PostServiceEndPoint {
    static let baseURL = "https://jsonplaceholder.typicode.com"

    case getPosts
    case getPostComments(String)
    case postPost(String)
   
    
    var path: String {
        switch self {
//        case .trending(let mediaType, _):
//            return "trending/\(mediaType)/day"
//        case .whereToWatch(let mediaType, let id):
//            return "\(mediaType)/\(id)/watch/providers"
//        case .upcomingMovie(_):
//            return "movie/upcoming"
//        case .similar(let mediaType, let id):
//            return "\(mediaType)/\(id)/similar"
//        case .search(_):
//            return "search/multi"
        case .getPosts:
            return "post"
        case .getPostComments(let postId):
            return "comments"
        case .postPost(let post):
            return "post"
        }
    }
    
    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        switch self {
//        case .trending(_, let page):
//            items.append(URLQueryItem(name: "page", value: String(page)))
//            return items
//        case .whereToWatch(_, _):
//            return items
//        case .upcomingMovie(let page):
//            items.append(URLQueryItem(name: "language", value: "en-US"))
//            items.append(URLQueryItem(name: "region", value: "US"))
//            items.append(URLQueryItem(name: "page", value: String(page)))
//            return items
//        case .similar(_, _):
//            return items
//        case .search(let searchTerm):
//            items.append(URLQueryItem(name: "include_adult", value: "false"))
//            items.append(URLQueryItem(name: "query", value: searchTerm))
//            return items
       // var items: [URLQueryItem] = []
        case .getPosts:
            return items
        case .getPostComments(let postId):
            items.append(URLQueryItem(name: "postId", value: postId))
            return items
        case .postPost(_):
            return items
        }
    }
    
    var url: URL? {
        guard var url = URL(string: PostServiceEndPoint.baseURL) else { return nil }
        url.appendPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        return components?.url
    }
}

//struct MediaService: NetworkServicing {
//    func fetch<T: Decodable>(_ endpoint: PostServiceEndPoint, completion: @escaping (Result<T, NetError>) -> Void) {
//        guard let url = endpoint.url else {
//            completion(.failure(.badURL))
//            return
//        }
//        print(url.absoluteString)
//        perform(urlRequest: URLRequest(url: url)) { result in
//            switch result {
//            case .success(let data):
//                guard let decodedObjects = data.decode(type: T.self) else {
//                    completion(.failure(.couldNotUnwrap))
//                    return
//                }
//                completion(.success(decodedObjects))
//            case .failure(let error):
//                completion(.failure(.badRequest(error)))
//            }
//        }
//    }
//}
//
