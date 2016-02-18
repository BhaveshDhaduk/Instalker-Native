//
//  UIView.swift
//  Instalker
//
//  Created by umut on 18/02/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

import Foundation

import UIKit

@objc
@IBDesignable
class View:UIView{}

extension UIView {
    @IBInspectable var cornerRadius:CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    
    }
    
    @IBInspectable var borderWidth: CGFloat{
        get{
            return layer.borderWidth
        }
        set{
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get{
            if let borderColor = layer.borderColor{
                return UIColor(CGColor: borderColor)
            }
            return nil
        }
        
        set{
            layer.borderColor = newValue?.CGColor
        }
    }
    

}
