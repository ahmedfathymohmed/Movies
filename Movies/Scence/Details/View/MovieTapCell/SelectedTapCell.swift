//
//  MovieTapCell.swift
//  Movies
//
//  Created by Ahmed Fathy on 25/05/2026.
//

import UIKit

class SelectedTapCell: UICollectionViewCell {
    
    @IBOutlet weak var selectedTapView: UIView!
    @IBOutlet weak var selectedTaplabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectedTapView.alpha = 0
    }
    func configure(with title: String, isSelected: Bool) {
        selectedTaplabel.text = title
        
        UIView.animate(withDuration: 0.3) {
            self.selectedTaplabel.font = .systemFont(ofSize: 16, weight: isSelected ? .semibold : .regular)
            self.selectedTaplabel.textColor = isSelected ? .white : UIColor(white: 1.0, alpha: 0.6)
            self.selectedTapView.alpha = isSelected ? 1 : 0
            self.selectedTapView.backgroundColor = UIColor(hex: "#3A3F47")
        }
    }
}
