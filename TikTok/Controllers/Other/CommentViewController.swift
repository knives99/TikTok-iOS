//
//  CommentViewController.swift
//  TikTok
//
//  Created by Bryan on 2021/11/9.
//

import UIKit

protocol CommentsViewControllerDelegate:AnyObject{
    func didTapCloseForComments(with viewController:CommentViewController)
}

class CommentViewController: UIViewController {
    
    private let post:PostModel?
    weak var delegate:CommentsViewControllerDelegate?
    private var comments = [PostComment]()
    
    private let tableview:UITableView = {
        let tableview = UITableView()
        tableview.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        return tableview
    }()
    
    private let closeButton:UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    init(post:PostModel){
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        view.backgroundColor = .white
        fetchPostComments()
        view.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self
    }
    @objc private func didTapClose(){
        delegate?.didTapCloseForComments(with: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.frame = CGRect(x: view.width - 45 , y: 10, width: 35, height: 35)
        tableview.frame = CGRect(x: 0, y: closeButton.bottom, width: view.width, height: view.width - closeButton.bottom)
    }
    
    func fetchPostComments(){
        //DatabaseManager.shared.fetchComment
        self.comments = PostComment.mockComments()
    }

}

extension CommentViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        guard let cell = tableview.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: comment)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
