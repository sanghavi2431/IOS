//
//  TagFlowLayout.swift
//  BSTagView
//
//  Created by Sami on 5/15/20.
//  Copyright © 2020 Hungrynaki.com. All rights reserved.
//

import UIKit

class TagFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }

        var leftMargin: CGFloat = sectionInset.left
        var maxY: CGFloat = -1.0

        for layoutAttribute in attributes {
            // Only apply custom layout to cells in Section 0
            if layoutAttribute.representedElementCategory == .cell,
               layoutAttribute.indexPath.section == 0 {

                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }

                var frame = layoutAttribute.frame
                frame.origin.x = leftMargin
                layoutAttribute.frame = frame

                leftMargin += frame.width + minimumInteritemSpacing
                maxY = max(frame.maxY, maxY)
            }
        }

        return attributes
    }
}
