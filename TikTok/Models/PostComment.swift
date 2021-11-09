//
//  PostComment.swift
//  TikTok
//
//  Created by Bryan on 2021/11/9.
//

import Foundation

struct PostComment{
    let text :String
    let user: User
    let date :Date
    
    static func mockComments() ->[PostComment]{
        let user = User(username: "kanyeWest", profilePictureURL: nil, identifier: UUID().uuidString)
        var comments = [PostComment]()
        
        let text = ["A","B","C","D","E"]
        for comment in text{
            comments.append(PostComment(text: comment, user: user, date: Date()))
        }
        return comments
    }
    
}
