//
//  ReviewsTableViewHandler.swift
//  Movies
//
//  Created by Ahmed Fathy on 10/06/2026.
//

import Foundation

import UIKit

class ReviewsTableViewHandler: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var reviews: [ReviewItem] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieReviewsCell", for: indexPath) as! MovieReviewsCell
        cell.configure(with: reviews[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
