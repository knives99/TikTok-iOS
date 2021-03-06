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
        ExploreManager.shared.delegate = self
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
        //Banner
        sections.append(ExploreSection(type: .banners,
                                       cell: ExploreManager.shared.getExploreBanner().compactMap({
                                                return ExploreCell.banner(viewModel: $0)
                                            })
                                      )
        )
        //TrendingPosts
        var posts = [ExploreCell]()
        sections.append(ExploreSection(type: .trendingPosts,
                                       cell: ExploreManager.shared.getExploreTrendingPost().compactMap({ ExplorePostViewModel in
            ExploreCell.post(viewModel: ExplorePostViewModel)
        })))
        //users
        sections.append(ExploreSection(type: .users,
                                       cell: ExploreManager.shared.getExploreCreatos().compactMap({ ExploreUserViewModel in
            ExploreCell.user(viewModel: ExploreUserViewModel)
        })))
        //trending Hashtags
        sections.append(ExploreSection(type: .trendingHashtags,
                                       cell: ExploreManager.shared.getExploreHashtags().compactMap({ ExploreHashTagViewModel in
            ExploreCell.hashtag(viewModel: ExploreHashTagViewModel)
        })))
    
        //Popular
        sections.append(ExploreSection(type: .popular,
                                       cell: ExploreManager.shared.getExplorePopularPost().compactMap({ ExplorePostViewModel in
            ExploreCell.post(viewModel: ExplorePostViewModel)
        })
                                      ))
        //new/recent
        sections.append(ExploreSection(type: .new,
                                       cell: ExploreManager.shared.getExploreRecentPost().compactMap({ ExplorePostViewModel in
            ExploreCell.post(viewModel: ExplorePostViewModel)
        })))
        
        
        
    }
    func setUpCollectionView(){
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(ExplorePostCollectionViewCell.self, forCellWithReuseIdentifier: ExplorePostCollectionViewCell.identifier)
        collectionView.register(ExploreUserCollectionViewCell.self, forCellWithReuseIdentifier: ExploreUserCollectionViewCell.identifier)
        collectionView.register(ExploreBannerCollectionViewCell.self, forCellWithReuseIdentifier: ExploreBannerCollectionViewCell.identifier)
        collectionView.register(ExploreHashtagCollectionViewCell.self, forCellWithReuseIdentifier: ExploreHashtagCollectionViewCell.identifier)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreBannerCollectionViewCell.identifier, for: indexPath) as! ExploreBannerCollectionViewCell
            cell.configure(with: viewModel)
                    return cell
        case .post(let viewModel):
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExplorePostCollectionViewCell.identifier, for: indexPath) as! ExplorePostCollectionViewCell
                cell.configure(with: viewModel)
                    return cell
        case .hashtag(let viewModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreHashtagCollectionViewCell.identifier, for: indexPath) as! ExploreHashtagCollectionViewCell
                cell.configure(with: viewModel)
                    return cell
        case .user(let viewModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreUserCollectionViewCell.identifier, for: indexPath) as! ExploreUserCollectionViewCell
                cell.configure(with: viewModel)
                    return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let model = sections[indexPath.section].cell[indexPath.row]
        switch model{
            
        case .banner(let viewModel):
            viewModel.handler()
        case .post(let viewModel):
            viewModel.handler()
        case .hashtag(let viewModel):
            viewModel.handler()
        case .user(let viewModel):
            viewModel.handler()
        }
    }
    
    
}

extension ExploreViewController:UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action:  #selector(didTapCancel))
    }
    @objc private func didTapCancel(){
        navigationItem.rightBarButtonItem = nil
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = nil
        searchBar.resignFirstResponder()
    }
}

//MARK: -  SectionLayout
extension ExploreViewController {
    func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type
        switch sectionType{
        case .banners:
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                //fractional ??????????????????
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            )
            //?????? item ???????????????
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
             ?????? orthogonalScrollingBehavior ??????????????????????????????????????? iOS/macOS ??????????????????????????? cell ??????????????? CollectionView???????????? 90 ?????? TableView ??? ????????????? orthogonalScrollingBehavior ?????????????????? CollectionView ??? section ???????????????????????????????????? scroll view?????????????????????????????????????????????????????????????????????????????? scroll view?????????????????? cell ????????????????????????????????? dataSource ??????????????????????????????????????????????????????
             
             ??????????????????????????????????????????????????? orthogonalScrollingBehavior ???????????????????????????????????? section ????????? CollectionView ????????? 90 ???????????????????????? CollectionView ????????????????????????????????????????????????????????? section ??????????????????????????? CollectionView ????????????????????????????????????????????????????????? section ?????????????????????????????????????????????????????????????????????
             
             none??????????????????????????????????????????????????????????????????
             continuous??????????????????
             continuousGroupLeadingBoundary??????????????????????????????????????? group ?????????
             paging????????????????????? CollectionView ????????????????????????????????????
             groupPaging???????????????????????? group
             groupPagingCentered???????????????????????? group??????????????? group ???????????????
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
                    heightDimension: .absolute(300)),
                subitem: item,
                count: 2
            )
            let group = NSCollectionLayoutGroup.horizontal(
                                                            layoutSize: NSCollectionLayoutSize(
                                                            widthDimension: .absolute(110),
                                                            heightDimension: .absolute(300)),
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
                    widthDimension: .absolute(150),
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

extension ExploreViewController:ExploreManagerDalegate{
    func didTapHashtag(_ hashtag: String) {
        searchBar.text = hashtag
        searchBar.becomeFirstResponder()
    }
    
    func pushViewController(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
