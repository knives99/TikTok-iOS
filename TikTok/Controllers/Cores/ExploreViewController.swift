//
//  ExploreViewController.swift
//  TikTok
//
//  Created by Bryan on 2021/11/5.
//

import UIKit


class ExploreViewController: UIViewController {
    
    private let searchBar :UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "search....."
        bar.layer.masksToBounds = true
        bar.layer.cornerRadius = 8
        return bar
    }()
    
    private var sections = [ExploreSection]()
    
    private var collectionView:UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureModels()
        setUpSearchBar()
        setUpCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        
    }
    func setUpSearchBar(){
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    func configureModels(){
        var cells = [ExploreCell]()
        for _ in 0...1000 {
            let cell = ExploreCell.banner(viewModel:ExploreBannerViewModel(image: nil,
                                                                           title: "FOo",
                                                                           handler: {}
                                                                          ))
            cells.append(cell)
        }
        //Banner
        sections.append(ExploreSection(type: .banners,
                                       cell: cells
                                      )
        )
        //TrendingPosts
        var posts = [ExploreCell]()
        for _ in 0...40{
            posts.append(.post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {})))
        }
        sections.append(ExploreSection(type: .trendingPosts,
                                       cell: posts))
        //users
        sections.append(ExploreSection(type: .users,
                                       cell: [.user(viewModel: ExploreUserViewModel(profilePictureUrl: nil,               username: "", followerCount: 0, handler: {})),
                                              .user(viewModel: ExploreUserViewModel(profilePictureUrl: nil, username: "", followerCount: 0, handler: {})),
                                              .user(viewModel: ExploreUserViewModel(profilePictureUrl: nil, username: "", followerCount: 0, handler: {})),
                                              .user(viewModel: ExploreUserViewModel(profilePictureUrl: nil, username: "", followerCount: 0, handler: {})),
                                              .user(viewModel: ExploreUserViewModel(profilePictureUrl: nil, username: "", followerCount: 0, handler: {})),
                                              .user(viewModel: ExploreUserViewModel(profilePictureUrl: nil, username: "", followerCount: 0, handler: {}))
                                             ]))
        //trending Hashtags
        sections.append(ExploreSection(type: .trendingHashtags,
                                       cell: [.hashtag(viewModel: ExploreHashTagViewModel(text: "#foryoy", icon: nil, count: 1, handler: {})),
                                              .hashtag(viewModel: ExploreHashTagViewModel(text: "#foryoy", icon: nil, count: 1, handler: {})),
                                              .hashtag(viewModel: ExploreHashTagViewModel(text: "#foryoy", icon: nil, count: 1, handler: {})),
                                              .hashtag(viewModel: ExploreHashTagViewModel(text: "#foryoy", icon: nil, count: 1, handler: {})),
                                              .hashtag(viewModel: ExploreHashTagViewModel(text: "#foryoy", icon: nil, count: 1, handler: {})),
                                              .hashtag(viewModel: ExploreHashTagViewModel(text: "#foryoy", icon: nil, count: 1, handler: {}))
                                              
                                             ]))
        // recommender
        sections.append(ExploreSection(type: .recommended,
                                       cell: [.post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption:         "", handler: {})),
                                              .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {})),
                                              .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {})),
                                              .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {})),
                                              .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {}))
                                             ]))
        //Popular
        sections.append(ExploreSection(type: .popular,
                                       cell: [.post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption:         "", handler: {})),
                                              .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {})),
                                              .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {})),
                                              .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {})),
                                              .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {}))
                                             ]))
        //new/recent
        sections.append(ExploreSection(type: .new,
                                       cell: [.post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption:         "", handler: {})),
                                              .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {})),
                                              .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {})),
                                              .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {})),
                                              .post(viewModel: ExplorePostViewModel(thumbnailImage: nil, caption: "", handler: {}))
                                             ]))
        
        
        
    }
    func setUpCollectionView(){
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
    func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type
        switch sectionType{
        case .banners:
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                //fractional 用百分比表示
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            )
            //增加 item 邊緣的空間
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            //Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(200)),
                subitems: [item])
            
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            /*
             這個 orthogonalScrollingBehavior 的出現，可以說解救了無數的 iOS/macOS 工程師，再也不用在 cell 裡面放一個 CollectionView、或是轉 90 度的 TableView 了 🍻！這個 orthogonalScrollingBehavior 一旦被設定， CollectionView 的 section 實作會變成一個特別的橫向 scroll view，對於使用這個參數的我們，完全不用去考慮這個多出來的 scroll view，傳遞資料給 cell 還是可以像以前一樣，在 dataSource 裡面直接傳遞就好，可以說是非常方便！
             
             雖然我們一直說「橫向滾動」，但其實 orthogonalScrollingBehavior 代表的意義，是我要讓這個 section 可以與 CollectionView 滾動的 90 度方向滾動。一般 CollectionView 如果是垂直滾動的話，這個參數的意義就是 section 可以橫向滾動。如果 CollectionView 是橫向滾動的話，這個參數的意義就變成讓 section 可以垂直滾動。它還可以有許多不同的設定值如下：
             
             none：顧名思義，就是不會有垂直向的滾動（預設值）
             continuous：連續的滾動
             continuousGroupLeadingBoundary：連續的滾動，但會最後停在 group 的前緣
             paging：每次會滾動跟 CollectionView 一樣寬（或一樣高）的距離
             groupPaging：每次會滾動一個 group
             groupPagingCentered：每次會滾動一個 group，並且停在 group 置中的地方
             */
            //Return
            return sectionLayout
        case .trendingHashtags:
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            //Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)),
                subitems: [item]
            )

            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: verticalGroup)
            //Return
            return sectionLayout

        case .trendingPosts,.new,.recommended:
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            //Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(100),
                    heightDimension: .absolute(240)),
                subitem: item,
                count: 2
            )
            let group = NSCollectionLayoutGroup.horizontal(
                                                            layoutSize: NSCollectionLayoutSize(
                                                            widthDimension: .absolute(110),
                                                            heightDimension: .absolute(240)),
                                                            subitems: [verticalGroup])
            
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            //Return
            return sectionLayout
        case .users:
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            //Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(200)),
                subitems: [item])
            
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            //Return
            return sectionLayout
        case .popular:
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            //Group
            let group = NSCollectionLayoutGroup.horizontal(
                                                            layoutSize: NSCollectionLayoutSize(
                                                            widthDimension: .absolute(110),
                                                            heightDimension: .absolute(200)),
                                                            subitems: [item])
            
            //Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            //Return
            return sectionLayout
        }
    }
}

extension ExploreViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].cell[indexPath.row]
        switch model{
            
        case .banner(let viewModel):
            break
        case .post(let viewModel):
            break
        case .hashtag(let viewModel):
            break
        case .user(let viewModel):
            break
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    
}

extension ExploreViewController:UISearchBarDelegate{
    
}

