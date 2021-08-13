//
//  PostController.swift
//  Networking
//
//  Created by Lee on 8/5/21.
//

import Foundation

class PostController {
    static let shared = PostController()
    var post: Post?
    
    func createPost() {
        post = Post()
        post?.body = "this is body"
        post?.title = "this is title"
    }
}
