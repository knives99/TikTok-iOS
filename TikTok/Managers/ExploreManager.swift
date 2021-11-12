//
//  ExploreManager.swift
//  TikTok
//
//  Created by Bryan on 2021/11/12.
//

import Foundation
import UIKit

protocol ExploreManagerDalegate:AnyObject{
    func pushViewController(_ vc:UIViewController)
    func didTapHashtag(_ hashtag:String)
}

final class ExploreManager{
    static let shared = ExploreManager()
    
    weak var delegate : ExploreManagerDalegate?
    
    enum BannerAction : String{
        case post
        case hashtag
        case user
    }
    
    //MARK: - Public
    public func getExploreBanner() -> [ExploreBannerViewModel]{
        guard let exploreData = parseExploreData() else{
            return []
        }

        return exploreData.banners.compactMap { Banner in
            ExploreBannerViewModel(image: UIImage(named: Banner.image), title: Banner.title) {
                [weak self] in
                guard let action = BannerAction(rawValue: Banner.action) else{return}
                DispatchQueue.main.async {
                    let vc = UIViewController()
                    vc.view.backgroundColor = .systemBackground
                    vc.title = action.rawValue.uppercased()
                    self?.delegate?.pushViewController(vc)
                }
                switch action {
                case .post:
                    //post
                    break
                case .hashtag:
                    // search for hashtag
                    break
                case .user:
                    // profile
                    break
                }
            }
        
        }


        
    }
    public func getExploreCreatos() -> [ExploreUserViewModel]{
        guard let exploreData = parseExploreData() else{
            return []
        }
        return exploreData.creators.compactMap { Creator in
            ExploreUserViewModel(profilePictureUrl: UIImage(named: Creator.image), username: Creator.username, followerCount: Creator.followers_count) {
                DispatchQueue.main.async {
                    [weak self] in
                    let userId = Creator.id
                    //Fetch user object from firebase
                    let vc = ProfileViewController(user: User(username: "hoe", profilePictureURL: nil, identifier: userId))
                    self?.delegate?.pushViewController(vc)
                }
            }
        }
    }
    public func getExploreHashtags() -> [ExploreHashTagViewModel]{
        guard let exploreData = parseExploreData() else{
            return []
        }
        return exploreData.hashtags.compactMap { Hashtag in
            ExploreHashTagViewModel(text: "#\(Hashtag.tag)", icon: UIImage(systemName: Hashtag.image), count: Hashtag.count) {
                [weak self] in
                DispatchQueue.main.async {
                    self?.delegate?.didTapHashtag(Hashtag.tag)
                }
            }
        }
    }
    
    public func getExploreTrendingPost() -> [ExplorePostViewModel]{
        guard let exploreData = parseExploreData() else{
            return []
        }
        return exploreData.trendingPosts.compactMap { Post in
            ExplorePostViewModel(thumbnailImage: UIImage(named: Post.image), caption: Post.caption) {
                [weak self] in
                DispatchQueue.main.async {
                    // use id to fetch post from firebase
                    let vc = PostViewController(model: PostModel(identifier: Post.id))
                    self?.delegate?.pushViewController(vc)
                }

            }
        }
    }
    
    public func getExplorePopularPost() -> [ExplorePostViewModel]{
        guard let exploreData = parseExploreData() else{
            return []
        }
        return exploreData.popular.compactMap { Post in
            ExplorePostViewModel(thumbnailImage: UIImage(named: Post.image), caption: Post.caption) {
                [weak self] in
                DispatchQueue.main.async {
                    // use id to fetch post from firebase
                    let vc = PostViewController(model: PostModel(identifier: Post.id))
                    self?.delegate?.pushViewController(vc)
                }
            }
        }
    }
    
    public func getExploreRecentPost() -> [ExplorePostViewModel]{
        guard let exploreData = parseExploreData() else{
            return []
        }
        return exploreData.recentPosts.compactMap { Post in
            ExplorePostViewModel(thumbnailImage: UIImage(named: Post.image), caption: Post.caption) {
                [weak self] in
                DispatchQueue.main.async {
                    // use id to fetch post from firebase
                    let vc = PostViewController(model: PostModel(identifier: Post.id))
                    self?.delegate?.pushViewController(vc)
                }
            }
        }
    }
    
    
}


    
    
    
    //MARK: - private
    private func parseExploreData() -> ExploreResponser?{
        guard let path = Bundle.main.path(forResource: "explore", ofType: "json") else{
            return nil
        }
        do{
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(ExploreResponser.self, from: data)
        }catch{
            print(error)
            return nil
        }
    }
    


struct ExploreResponser: Codable {
    let banners:[Banner]
    let trendingPosts:[Post]
    let creators:[Creator]
    let recentPosts:[Post]
    let hashtags:[Hashtag]
    let popular:[Post]
    let recommended:[Post]
}

struct Banner:Codable{
    let id: String
    let image: String
    let title: String
    let action: String
}

struct Post:Codable {
    let id: String
    let image: String
    let caption: String
}

struct Hashtag:Codable{
    let image :String
    let tag :String
    let count: Int
}

struct Creator:Codable{
    let id: String
    let image: String
    let username: String
    let followers_count: Int
}
