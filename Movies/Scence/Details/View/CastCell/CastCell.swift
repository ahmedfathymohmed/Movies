//
//  CastCell.swift
//  Movies
//
//  Created by Ahmed Fathy on 24/05/2026.
//
import UIKit
class CastCell: UICollectionViewCell {

    @IBOutlet weak var nameOfCastLabel: UILabel!
    @IBOutlet weak var castImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUPCell()
    }
    func setUPCell(){
        nameOfCastLabel.textColor = .white
        nameOfCastLabel.font = .systemFont(ofSize: 14, weight: .medium)
        castImage.layer.cornerRadius = 50
    }
    func configure(with member: CastMember) {
            nameOfCastLabel.text = member.name
            
            if let profilePath = member.profilePath {
                Task { [weak self] in
                    let image = await ImageLoader.shared.loadImage(from: profilePath)
                    await MainActor.run {
                        self?.castImage.image = image
                    }
                }
            } else {
                castImage.image = UIImage(named: "placeholder")
            }
        }
}
