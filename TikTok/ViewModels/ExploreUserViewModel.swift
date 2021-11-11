//
//  ExploreUserViewModel.swift
//  TikTok
//
//  Created by Bryan on 2021/11/11.
//

import Foundation
import UIKit
struct ExploreUserViewModel{
    let profilePictureUrl:URL?
    let username:String
    let followerCount:Int
    let handler:(()->Void)
}
