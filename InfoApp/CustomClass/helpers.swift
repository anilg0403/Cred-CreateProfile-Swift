//
//  helpers.swift
//  InfoApp
//
//  Created by Anil Gupta on 21/05/20.
//  Copyright © 2020 Anil Gupta. All rights reserved.
//

import Foundation
import UIKit

public typealias UIButtonTargetClosure = (UIButton) -> ()

extension UIColor {
    
    // MARK: - Initialization
    
    convenience public init?(hex: String) {
        
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var int = UInt32()
        Scanner(string: hexSanitized).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hexSanitized.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    // MARK: - Computed Properties
    
    public var toHex: String? {
        return toHex()
    }
    
    // MARK: - From UIColor to String
    
    public func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

public extension UIView{
    func removeAllSubviews(){
        for subview  in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func removeAllSubviewsWithTag(_ tag : Int){
        for subview  in self.subviews {
            if subview.tag == tag{
                subview.removeFromSuperview()
            }
        }
    }
}

// MARK:- Adding Target Closure
public extension UIButton {
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addTargetClosure(closure: @escaping UIButtonTargetClosure) {
        targetClosure = closure
        removeTarget(self, action: #selector(UIButton.closureAction), for: .touchUpInside)
        addTarget(self, action: #selector(UIButton.closureAction), for: .touchUpInside)
    }
    
    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
    
    func addMinimumFontScale() {
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.baselineAdjustment = .alignCenters
        self.titleLabel?.minimumScaleFactor = 10/(self.titleLabel?.font.pointSize)!
    }
}

public class ClosureWrapper: NSObject {
    let closure: UIButtonTargetClosure
    init(_ closure: @escaping UIButtonTargetClosure) {
        self.closure = closure
    }
}

public extension UITextField {
    
    func validate() -> Bool {
        guard let text = self.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            return false
        }
        return true
    }
    
}

public extension UITextView {

    func validate() -> Bool{
        guard let text = self.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            return false
        }
        return true
    }

}
