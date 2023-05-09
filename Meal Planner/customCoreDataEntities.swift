//
//  customCoreDataEntities.swift
//  Meal Planner
//
//  Created by Vasiliy on 5/9/23.
//

import Foundation
import UIKit
import CoreLocation

public class CoreDataIndexPath: NSObject, NSSecureCoding {
    
    var indexPath: IndexPath
    
    init(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    public static var supportsSecureCoding: Bool = true
    
    public func encode(with coder: NSCoder) {
        do {
            let indexpath = try NSKeyedArchiver.archivedData(withRootObject: indexPath, requiringSecureCoding: true)
            coder.encode(indexpath)
        } catch  {
            print(error)
        }
    }
    
    public required convenience init?(coder decoder: NSCoder) {
        let decodedIndexPath = decoder.decodeObject(forKey: "indexPath") as! IndexPath
        self.init(indexPath: decodedIndexPath)
    }
}

//MARK: - coreData Value Transformers
@objc(CorDataIndexPathTransformer)
final class CorDataIndexPathTransformer: NSSecureUnarchiveFromDataTransformer {
    static let name = NSValueTransformerName(rawValue: String(describing: CorDataIndexPathTransformer.self))
        
        override static var allowedTopLevelClasses: [AnyClass] {
            return [CoreDataIndexPath.self, NSString.self]
        }
        
        public static func register() {
            let transformer = CorDataIndexPathTransformer()
            ValueTransformer.setValueTransformer(transformer, forName: name)
        }
        
        override public class func allowsReverseTransformation() -> Bool {
            return true
        }
}
