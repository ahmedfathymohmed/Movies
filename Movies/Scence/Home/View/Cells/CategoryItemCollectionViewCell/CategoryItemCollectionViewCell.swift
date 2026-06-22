//
//  CategoryItemCollectionViewCell.swift
//  Movies App Task
//
//  Created by Ahmed Fathy on 19/12/2025.
//

import UIKit

class CategoryItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCategoriesListCollectionView()
    }
    override var isSelected: Bool {
        didSet {
                    containerView.backgroundColor = isSelected ? UIColor(hex: "0296E5") : .clear
            titleLabel.textColor = isSelected ? .black : .white
        }
    }
    
    func setupCell(with title: String) {
        titleLabel.text = title
    }
    
    func setupCategoriesListCollectionView() {
        
        containerView.layer.borderColor = UIColor(hex: "0296E5").cgColor
        containerView.layer.borderWidth = 1.0
        containerView.backgroundColor = .black
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        containerView.layer.cornerRadius = 12

        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        
    }
}
