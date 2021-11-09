//
//  PostModel.swift
//  TikTok
//
//  Created by Bryan on 2021/11/5.
//

import Foundation

struct PostModel{
    let identifier : String
    let user = User(username: "kanyeWest", profilePictureURL: nil, identifier: UUID().uuidString)
    var isLikedByCurrentUser = false
    static func mockMOdels() ->[PostModel]{
        var posts = [PostModel]()
        for x in 0...100{
            let post  = PostModel(identifier: UUID().uuidString)
            posts.append(post)
        }
        return posts
    }
}
