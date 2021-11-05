//
//  PostViewController.swift
//  TikTok
//
//  Created by Bryan on 2021/11/5.
//

import UIKit

class PostViewController: UIViewController {
    
    var model:PostModel
    
    private let likedButton:UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    private let commemtButton:UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    private let shareButton:UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment  = .left
        label.numberOfLines = 0
        label.text = "check out this Video"
        label.font = .systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Init
    
    
    init(model:PostModel){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let colors:[UIColor] = [
            .red,.green,.blue,.orange,.black,.white,.systemPink]
        view.backgroundColor = colors.randomElement()
        setUpButtons()
        setUpDoubleTapToLike()
        view.addSubview(captionLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size : CGFloat = 40
        let yStart:CGFloat = view.height - (size * 4) - 30 - view.safeAreaInsets.bottom - (tabBarController?.tabBar.height ?? 0)
        
       for(index,button) in  [likedButton,commemtButton,shareButton].enumerated() {
            button.frame = CGRect(x: view.width - size - 10, y: yStart + (CGFloat(index) * 10) + (CGFloat(index)*size), width: size, height: size)
        }
        // label 自我調適大小
        captionLabel.sizeToFit()
        let labelSize = captionLabel.sizeThatFits(CGSize(width: view.width - size - 12, height: view.height))
        captionLabel.frame = CGRect(x: 5, y: view.height - view.safeAreaInsets.bottom - labelSize.height - (tabBarController?.tabBar.height ?? 0), width: view.width - size - 12, height: labelSize.height)
    }
    
    func setUpButtons(){
        view.addSubview(likedButton)
        view.addSubview(commemtButton)
        view.addSubview(shareButton)
        likedButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commemtButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
    }
    @objc private func didTapLike(){
        model.isLikedByCurrentUser = !model.isLikedByCurrentUser
        likedButton.tintColor = model.isLikedByCurrentUser ? .systemRed : .white
    }
    @objc private func didTapComment(){
        // Present comment tray
        
    }
    @objc private func didTapShare(){
        guard let url = URL(string: "https://www.tiktok.com") else{return}
        //下方冒出來的分享按鍵
        let vc = UIActivityViewController(activityItems: [url],
                                          applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    func  setUpDoubleTapToLike(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        //大家都知道如果要讓非按鈕元件可以被按或是被互動 只要讓該元件的isUserInteractionEnabled屬性給定True即可
        view.isUserInteractionEnabled = true
    }
    @objc private func didDoubleTap(_ gesture:UITapGestureRecognizer){
        if !model.isLikedByCurrentUser{
            model.isLikedByCurrentUser = true
        }
        let touchPoint = gesture.location(in: view)
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .systemRed
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = touchPoint
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        view.addSubview(imageView)
        
        UIView.animate(withDuration: 0.2) {
            imageView.alpha = 1
        }completion: { done in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if done{
                    UIView.animate(withDuration: 0.4) {
                        imageView.alpha = 0
                    }completion: { done in
                        if done{
                            imageView.removeFromSuperview()
                        }
                    }
                }
            }
        }
    }

}
