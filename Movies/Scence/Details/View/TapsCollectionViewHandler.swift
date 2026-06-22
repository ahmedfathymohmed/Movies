//
//  TapsCollectionViewHandler.swift
//  Movies
//
//  Created by Ahmed Fathy on 10/06/2026.
//

import Foundation
import UIKit

class TapsCollectionViewHandler: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var tabs: [String] = ["About Movie", "Reviews", "Cast"]
    var selectedIndex: Int = 0
    var onTabSelected: ((Int) -> Void)?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedTapCell", for: indexPath) as! SelectedTapCell
        cell.configure(with: tabs[indexPath.item], isSelected: indexPath.item == selectedIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / CGFloat(tabs.count)
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard selectedIndex != indexPath.item else { return }
        selectedIndex = indexPath.item
        collectionView.reloadData()
        onTabSelected?(selectedIndex) 
    }
}
