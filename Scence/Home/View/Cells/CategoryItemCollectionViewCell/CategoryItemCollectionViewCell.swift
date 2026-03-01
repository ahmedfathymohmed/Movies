//
//  CategoryItemCollectionViewCell.swift
//  Movies App Task
//
//  Created by Ahmed Fathy on 19/12/2025.
//

import UIKit

class CategoryItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contanierView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCategoriesListCollectionView()
    }
    override var isSelected: Bool {
        didSet {
            contanierView.backgroundColor = isSelected ? .yellow : .clear
            titleLabel.textColor = isSelected ? .black : .white
        }
    }
    
    func setupCell(with title: String) {
        titleLabel.text = title
    }
    
    func setupCategoriesListCollectionView() {
        contanierView.layer.borderColor = UIColor.yellow.cgColor
        contanierView.layer.borderWidth = 1.0
        contanierView.backgroundColor = .black
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        contanierView.layer.cornerRadius = 14

        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        
    }
}
