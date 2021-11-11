//
//  ExploerBannerViewModel.swift
//  TikTok
//
//  Created by Bryan on 2021/11/11.
//

import Foundation
import UIKit

struct ExplorePostViewModel{
    let thumbnailImage :UIImage?
    let caption :String
    let handler:(()->Void)
}
