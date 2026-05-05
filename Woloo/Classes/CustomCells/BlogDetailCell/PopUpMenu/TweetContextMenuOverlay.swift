//
//  TweetContextMenuOverlay.swift
//  Woloo
//
//  Created by CEPL on 08/05/25.
//

import Foundation
import UIKit

class TweetContextMenuOverlay: UIView {

    private let menuView = TweetContextMenu()

    init(anchor: CGRect, in parentView: UIView, actionHandler: @escaping (String) -> Void) {
        super.init(frame: parentView.bounds)
        backgroundColor = UIColor.black.withAlphaComponent(0.05)

        // Configure menu
        menuView.actionHandler = actionHandler
        addSubview(menuView)

        menuView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuView.topAnchor.constraint(equalTo: topAnchor, constant: anchor.maxY),
            menuView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            menuView.widthAnchor.constraint(equalToConstant: 200)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        addGestureRecognizer(tap)
    }

    @objc private func dismiss() {
        self.removeFromSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
