////
////  APIResultTableViewCell.swift
////  Meal Planner
////
////  Created by Sterling Jenkins on 4/27/23.
////
//
//import UIKit
//
//class APIResultTableViewCell: UITableViewCell {
//
//    @IBOutlet weak var recipeimage: UIImageView!
//    
//    @IBOutlet weak var recipeTitleLabel: UILabel!
//    
//    @IBOutlet weak var favoriteButton: UIButton!
//    
//    var delegate: RecipeCellDelegate?
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//    @IBAction func favoriteButtonTapped() {
//        favoriteButton.isSelected.toggle()
//        delegate?.favoriteButtonTapped(cell: self)
//    }
//    
//    @IBAction func calendarButtonTapped() {
//        delegate?.calendarButtonTapped(cell: self, passing: nil)
//    }
//    
//}
