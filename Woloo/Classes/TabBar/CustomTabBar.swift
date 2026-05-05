//
//  CustomTabBar.swift
//  JetLiveStream
//
//  Created by Ashish Khobragade on 28/09/20.
//  Copyright © 2020 Ashish Khobragade. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBar {

    private var shapeLayer: CAShapeLayer?
    private var blurEffectView: UIVisualEffectView? // Store reference for reusability

    override func draw(_ rect: CGRect) {
      //  self.addBlurEffect() // Add blur first
        self.addShape()
    }
    
    /// Visual height of the pill above the home indicator (matches previous 68pt design).
    private let customContentHeight: CGFloat = 68
    private let horizontalInset: CGFloat = 12

    override func layoutSubviews() {
        super.layoutSubviews()

        tintColor = .black
        unselectedItemTintColor = .black

        // Use superview bounds + safeAreaInsets instead of safeAreaLayoutGuide.layoutFrame.
        // On newer iOS (18+), layoutFrame for the tab bar controller’s view can disagree with
        // UITabBarController’s own tab bar layout and causes stretching / wrong Y / width.
        guard let container = superview else { return }

        let safeBottom = container.safeAreaInsets.bottom
        // Extend tab bar into the bottom safe area (home indicator) like the system bar.
        let totalHeight = customContentHeight + safeBottom
        let width = max(0, container.bounds.width - (horizontalInset * 2))
        let x = horizontalInset
        let y = container.bounds.height - totalHeight

        frame = CGRect(x: x, y: y, width: width, height: totalHeight)

        // Center default ~49pt items within the *content* area above the home inset.
        let itemVerticalInset = (customContentHeight - 49) / 2
        let imageInset: CGFloat = 6

        for item in items ?? [] {
            item.titlePositionAdjustment = UIOffset(horizontal: -8, vertical: -8)
            item.imageInsets = UIEdgeInsets(
                top: itemVerticalInset - imageInset,
                left: 0,
                bottom: -(itemVerticalInset - imageInset),
                right: 0
            )
        }

        // Keep rounded background path in sync (draw() may not run again after layout changes).
        if let layer = shapeLayer {
            layer.path = createPath()
        } else {
            addShape()
        }
    }
    
    private func addBlurEffect() {
            // Remove existing blur effect to prevent duplication
            blurEffectView?.removeFromSuperview()
            
            // Create and configure blur effect
        let blurEffect = UIBlurEffect(style: .regular)
            let visualEffectView = UIVisualEffectView(effect: blurEffect)
            visualEffectView.frame = bounds
            visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            visualEffectView.alpha = 0.4 // 40% blur intensity

            // Insert blur effect below other layers
            self.insertSubview(visualEffectView, at: 0)
            self.blurEffectView = visualEffectView
        }
    

    private func addShape() {

        let shapeLayer = CAShapeLayer()
                shapeLayer.path = createPath()
        shapeLayer.fillColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.95).cgColor // Adjust to your desired color
                shapeLayer.shadowColor = UIColor.black.cgColor
                shapeLayer.shadowOpacity = 0.2
                shapeLayer.shadowOffset = CGSize(width: 0, height: 2)
                shapeLayer.shadowRadius = 4

                if let oldShapeLayer = self.shapeLayer {
                    self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
                } else {
                    self.layer.insertSublayer(shapeLayer, at: 0)
                }

                self.shapeLayer = shapeLayer
    }


    func createPath() -> CGPath {
        
        let cornerRadius: CGFloat = 11.73 // Set desired corner radius
               let path = UIBezierPath(
                   roundedRect: bounds.inset(by: safeAreaInsets),
                   cornerRadius: cornerRadius
               )
               return path.cgPath
    }


    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
}
