//
//  TweetContextMenu.swift
//  Woloo
//
//  Created by CEPL on 08/05/25.
//

import Foundation

import UIKit

class TweetContextMenu: UIView {

    var actionHandler: ((String) -> Void)?

    private let options = [
        ("Block", UIImage(named: "icon_block"))]

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemBackground
        layer.cornerRadius = 7.01
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
        setupOptions()
    }

    private func setupOptions() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])

        for (title, icon) in options {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setImage(icon, for: .normal)
            button.tintColor = .label
            button.contentHorizontalAlignment = .left
            button.configuration = .plain()
            button.configuration?.imagePadding = 9
            button.configuration?.baseForegroundColor = .label
            button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.addTarget(self, action: #selector(optionTapped(_:)), for: .touchUpInside)

            stack.addArrangedSubview(button)
        }
    }

    @objc private func optionTapped(_ sender: UIButton) {
        actionHandler?(sender.configuration?.title ?? "")
        removeFromSuperview()
        superview?.removeFromSuperview() // Remove overlay too
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

