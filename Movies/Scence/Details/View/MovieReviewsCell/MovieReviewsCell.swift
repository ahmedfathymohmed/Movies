//
//  MovieReviewsCell.swift
//  Movies
//
//  Created by Ahmed Fathy on 20/05/2026.
//

import UIKit

class MovieReviewsCell: UITableViewCell {
    
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewContentLabel: UILabel!
    @IBOutlet weak var reviewContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let backgroundColor = UIColor(named: "#242A32") 
            
            self.backgroundColor = backgroundColor
            contentView.backgroundColor = backgroundColor
        
            ratingLabel.textColor = UIColor(hex: "#0296E5")

            reviewContentView?.backgroundColor = backgroundColor
            usernameLabel?.textColor = .white
            reviewContentLabel?.textColor = .white
            }
    func configure(with Review: ReviewItem) {
        usernameLabel.text = Review.authorDetails?.username ?? Review.author ?? "Unknown"
        reviewContentLabel.text = Review.content ?? "No content available"
        ratingLabel.text = Review.authorDetails?.rating.map { String($0) } ?? "0.0"

        userAvatarImageView.image = UIImage(named: "Ellipse 2")

    }
    
}
