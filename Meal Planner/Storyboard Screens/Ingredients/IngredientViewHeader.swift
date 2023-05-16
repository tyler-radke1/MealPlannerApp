//
//  IngredientViewHeader.swift
//  Meal Planner
//
//  Created by Vasiliy on 5/11/23.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier: String = String(describing: self)
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
   
    
    // Override `textLabel` to add `@IBOutlet` annotation
    
    @IBOutlet var headerTitle: UILabel!
    
//    @IBOutlet override var textLabel: UILabel? {
//            get { return _textLabel }
//            set { _textLabel = newValue }
//        }
//    private var _textLabel: UILabel?
    
    @IBAction func deleteButtonTapped() {
        print("Hi!")
    }
    //    private var _textLabel: UILabel?

//    func createHeaderInStoryboard() {
//        let storyboard =
//    }
}
