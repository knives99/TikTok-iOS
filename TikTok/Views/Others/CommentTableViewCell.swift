//
//  CommentTableViewCell.swift
//  TikTok
//
//  Created by Bryan on 2021/11/9.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    static let identifier = "CommentTableViewCell"
    
    private let avatarImageView :UIImageView = {
        let imadeView = UIImageView()
        imadeView.clipsToBounds = true
        imadeView.layer.masksToBounds = true
        return imadeView
    }()
    
    private let commentLabel :UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    private let dateLabel :UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(avatarImageView)
        contentView.addSubview(commentLabel)
        contentView.addSubview(dateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commentLabel.sizeToFit()
        dateLabel.sizeToFit()
        //Assign frames
        let imageSize:CGFloat = 70
        avatarImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height: imageSize)

        let commentLabelHeight  = min(contentView.height - dateLabel.top , commentLabel.height)
        commentLabel.frame = CGRect(x: avatarImageView.right + 10 , y: 5, width: contentView.width - avatarImageView.right - 10, height: commentLabelHeight)
        dateLabel.frame = CGRect(x: avatarImageView.right + 10 , y: contentView.height - dateLabel.height - 5, width: dateLabel.width, height: commentLabelHeight)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        commentLabel.text = nil
        avatarImageView.image = nil
    }
    public func configure(with model:PostComment){
        commentLabel.text = model.text
        dateLabel.text = .date(with: model.date)
        if let url = model.user.profilePictureURL{
            print(url)
        }else{
            avatarImageView.image = UIImage(systemName: "person.circle")
        }
        
    }
}
