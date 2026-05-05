//
//  BulletPoints.swift
//  Woloo
//
//  Created by ideveloper2 on 09/06/21.
//

import Foundation
import UIKit

class BulletPoints {

    static let shared = BulletPoints()
    
    func add(bulletList strings: [String],
             font: UIFont,
             indentation: CGFloat = 15,
             lineSpacing: CGFloat = 3,
             paragraphSpacing: CGFloat = 10,
             textColor: UIColor = .black,
             bulletColor: UIColor = .red) -> NSAttributedString {

        func createParagraphAttirbute() -> NSParagraphStyle {
            var paragraphStyle: NSMutableParagraphStyle
            let nonOptions = NSDictionary() as! [NSTextTab.OptionKey: Any]

            paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            paragraphStyle.tabStops = [
                NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
            paragraphStyle.defaultTabInterval = indentation
            paragraphStyle.firstLineHeadIndent = 0
            paragraphStyle.lineSpacing = lineSpacing
            paragraphStyle.paragraphSpacing = paragraphSpacing
            paragraphStyle.headIndent = indentation
            return paragraphStyle
        }

        let bulletPoint = "\u{2022}"
        let textAttributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: textColor]
        let bulletAttributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: bulletColor]
        let buffer = NSMutableAttributedString.init()

        for string in strings {
            let formattedString = "\(bulletPoint)\t\(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)
            let paragraphStyle = createParagraphAttirbute()

            attributedString.addAttributes(
                [NSAttributedString.Key.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))

            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))

            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: bulletPoint)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            buffer.append(attributedString)
        }

        return buffer
    }
}
