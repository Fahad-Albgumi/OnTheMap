//
//  FirstResponder.swift
//  OnTheMap
//
//  Created by fahad on 02/04/1441 AH.
//  Copyright © 1441 Fahad Albgumi. All rights reserved.
//

import Foundation
import UIKit

extension UIResponder {
    
    private static weak var _currentFirstResponder: UIResponder?
    
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        
        return _currentFirstResponder
    }
    
    @objc func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }
}
