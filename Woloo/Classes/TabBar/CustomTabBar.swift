//
//  CustomTabBar.swift
//  JetLiveStream
//
//  Created by Ashish Khobragade on 28/09/20.
//  Copyright © 2020 Ashish Khobragade. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBar {

    private var shapeLayer: CALayer?
    private var blurEffectView: UIVisualEffectView? // Store reference for reusability

    override func draw(_ rect: CGRect) {
      //  self.addBlurEffect() // Add blur first
        self.addShape()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Adjust frame to stay within the safe area
        self.tintColor = .black // Change to your desired selected item color
        self.unselectedItemTintColor = .black // Change to your desired unselected item color
        let safeAreaFrame = superview?.safeAreaLayoutGuide.layoutFrame ?? frame
        let customHeight: CGFloat = 68 // Custom tab bar height
        let horizontalInset: CGFloat = 12 // Equal gap on both sides

        frame = CGRect(
            x: safeAreaFrame.origin.x + horizontalInset,
            y: safeAreaFrame.origin.y + safeAreaFrame.height - customHeight,
            width: safeAreaFrame.width - (2 * horizontalInset),
            height: customHeight
        )

        // Adjust the spacing for tab bar items
        let itemVerticalInset = (customHeight - 68) / 2 // 49 is the default height of a tab bar item

        // Adjust image and title insets
        let imageInset: CGFloat = 6 // Adjust this value to control the image position

        for item in items ?? [] {
            // Adjust title position so it stays close to the image
            item.titlePositionAdjustment = UIOffset(horizontal: -8, vertical: -8)

            // Adjust image insets to make sure the image stays centered
            item.imageInsets = UIEdgeInsets(
                top: itemVerticalInset - imageInset,  // Adjusted vertical inset
                left: 0,
                bottom: -(itemVerticalInset - imageInset), // Adjusted vertical inset
                right: 0
            )
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
