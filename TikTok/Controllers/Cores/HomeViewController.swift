//
//  ViewController.swift
//  TikTok
//
//  Created by Bryan on 2021/11/5.
//

import UIKit

class HomeViewController: UIViewController {
    
        let horizontalScrollView:UIScrollView = {
        let scrollView = UIScrollView()
        
        //描述的当scrollview的显示超过内容区域的边缘以及返回时，是否有弹性，
        scrollView.bounces = false
        
        // 以一頁為單位滑動
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let control:UISegmentedControl = {
        let titles = ["Following", "For you"]
        let control = UISegmentedControl(items: titles)
        control.backgroundColor = nil
        control.selectedSegmentTintColor = .white
        control.selectedSegmentIndex = 1
        return control
    }()
    
    let forYouPageViewController = UIPageViewController(transitionStyle: .scroll,
                                                navigationOrientation: .vertical,
                                                options: [:])
    let followingPageViewController = UIPageViewController(transitionStyle: .scroll,
                                                navigationOrientation: .vertical,
                                                options: [:])
    
    private var forYouPosts = PostModel.mockMOdels()
    private var followingPosts = PostModel.mockMOdels()
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(horizontalScrollView)
        setUpFeed()
        horizontalScrollView.delegate = self
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
        setUpHeaderButtons()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }
    func setUpHeaderButtons(){

        control.addTarget(self, action: #selector(didChangeSegmentControl(_:)), for: .valueChanged)
        navigationItem.titleView = control
    }
    @objc private func didChangeSegmentControl(_ sender:UISegmentedControl){
        horizontalScrollView.setContentOffset(CGPoint(x: view.width * CGFloat(sender.selectedSegmentIndex), y: 0), animated: true)
    }
    
    private func setUpFeed(){
        horizontalScrollView.contentSize = CGSize(width: view.width * 2, height: view.height)
        setUpFollowingFeed()
        setUpForYouFeed()
    }
    
    func setUpFollowingFeed(){
        guard let model = followingPosts.first else{
            return
        }
        
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        
        followingPageViewController.setViewControllers([PostViewController(model: model)], direction: .forward, animated: false, completion: nil)
        followingPageViewController.dataSource = self
        horizontalScrollView.addSubview(followingPageViewController.view)
        followingPageViewController.view.frame = CGRect(x: 0, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
        //把paginVC 和 home VC加入父子關係 不清楚為什麼要這麼做
        addChild(followingPageViewController)
        followingPageViewController.didMove(toParent: self)
    }
    
    func setUpForYouFeed(){

        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        
        forYouPageViewController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        forYouPageViewController.dataSource = self
        horizontalScrollView.addSubview(forYouPageViewController.view)
        forYouPageViewController.view.frame = CGRect(x: view.width, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
        //把paginVC 和 home VC加入父子關係 不清楚為什麼要這麼做
        addChild(forYouPageViewController)
        forYouPageViewController.didMove(toParent: self)
    }
    
}

extension HomeViewController:UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else{
            return nil
        }
        guard let index = currentPosts.firstIndex(where: {
            $0.identifier == fromPost.identifier
        })else{
            return nil
        }
        if index == 0{
            return nil
        }
        let priorIndex = index - 1
        let model = currentPosts[priorIndex]
        let vc = PostViewController(model: model)
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else{
            return nil
        }
        guard let index = currentPosts.firstIndex(where: {
            $0.identifier == fromPost.identifier
        })else{
            return nil
        }
        guard index < (currentPosts.count-1) else {
            return nil
        }
        let nextIndex = index + 1
        let model = currentPosts[nextIndex]
        let vc = PostViewController(model: model)
        return vc
    }
    
    var currentPosts:[PostModel]{
        if horizontalScrollView.contentOffset.x == 0{
            //Following
            return followingPosts
        }
        //For you
        return forYouPosts
    }

}

extension HomeViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x <= (view.width / 2){
            control.selectedSegmentIndex = 0
        }else if scrollView.contentOffset.x > (view.width/2){
            control.selectedSegmentIndex = 1
        }
            
    }
}
