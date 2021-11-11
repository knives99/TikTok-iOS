//
//  ExploreHashTagViewModel.swift
//  TikTok
//
//  Created by Bryan on 2021/11/11.
//

import Foundation
import UIKit
struct ExploreHashTagViewModel{
    let text :String
    let icon :UIImage?
    let count : Int //number of posts associated with tag
    let handler:(()->Void)
}
