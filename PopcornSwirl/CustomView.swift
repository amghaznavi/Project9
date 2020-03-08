//
//  CustomView.swift
//  PopcornSwirl
//
//  Created by Am GHAZNAVI on 29/01/2020.
//  Copyright © 2020 Am GHAZNAVI. All rights reserved.
//

import UIKit


extension UIView {
    
    func roundCorner() {
        layer.cornerRadius = frame.height / 5
        layer.masksToBounds = true
    }
    
}
