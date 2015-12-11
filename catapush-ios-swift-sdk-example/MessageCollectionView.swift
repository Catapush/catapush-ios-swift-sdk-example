//
//  MessageCollectionView.swift
//  catapush-ios-swift-sdk-example
//
//  Created by Chiarotto Alessandro on 11/12/15.
//  Copyright © 2015 Catapush s.r.l. All rights reserved.
//

import Foundation
import UIKit
class MessageCollectionView : UICollectionView {
    
    static var backGroundColor = UIColor(red: 249.0/255.0, green: 250.0/255.0, blue: 252.0/255.0, alpha: 1)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = MessageCollectionView.backGroundColor
    }
    
}
