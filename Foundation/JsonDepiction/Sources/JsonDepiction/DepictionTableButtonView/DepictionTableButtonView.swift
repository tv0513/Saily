//
//  DepictionTableButtonView.swift
//  Sileo
//
//  Created by CoolStar on 7/6/19.
//  Copyright © 2019 CoolStar. All rights reserved.
//

import UIKit

class DepictionTableButtonView: DepictionBaseView, UIGestureRecognizerDelegate {
    private var selectionView: UIView
    private var titleLabel: UILabel
    private var chevronView: UIImageView

    private var action: String
    private var backupAction: String

    private let openExternal: Bool

    required init?(dictionary: [String: Any], viewController: UIViewController, tintColor: UIColor, isActionable: Bool) {
        guard let title = dictionary["title"] as? String else {
            return nil
        }

        guard let action = dictionary["action"] as? String else {
            return nil
        }
        selectionView = UIView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        chevronView = UIImageView(image: UIImage(named: "Chevron")?.withRenderingMode(.alwaysTemplate))

        self.action = action
        backupAction = (dictionary["backupAction"] as? String) ?? ""

        openExternal = (dictionary["openExternal"] as? Bool) ?? false

        super.init(dictionary: dictionary, viewController: viewController, tintColor: tintColor, isActionable: isActionable)

        titleLabel.text = title
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        addSubview(titleLabel)

        addSubview(chevronView)

        let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DepictionTableButtonView.buttonTapped))
        tapGestureRecognizer.minimumPressDuration = 0.05
        tapGestureRecognizer.delegate = self
        addGestureRecognizer(tapGestureRecognizer)

        accessibilityTraits = .link
        isAccessibilityElement = true
        accessibilityLabel = titleLabel.text
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func depictionHeight(width _: CGFloat) -> CGFloat {
        44
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.textColor = tintColor
        chevronView.tintColor = tintColor

        var containerFrame = bounds
        containerFrame.origin.x = 16
        containerFrame.size.width -= 32

        selectionView.frame = bounds
        titleLabel.frame = CGRect(x: containerFrame.minX, y: 12, width: containerFrame.width - 20, height: 20.0)
        chevronView.frame = CGRect(x: containerFrame.maxX - 9, y: 15, width: 7, height: 13)
    }

    override func accessibilityActivate() -> Bool {
        buttonTapped(nil)
        return true
    }

    @objc func buttonTapped(_ gestureRecognizer: UIGestureRecognizer?) {
        if let gestureRecognizer {
            if gestureRecognizer.state == .began {
                selectionView.alpha = 1
            } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled || gestureRecognizer.state == .failed {
                selectionView.alpha = 0
            }

            if gestureRecognizer.state != .ended {
                return
            }
        }

        if !processAction(action) {
            processAction(backupAction)
        }
    }

    @discardableResult func processAction(_ action: String) -> Bool {
        if action.isEmpty {
            return false
        }
        return DepictionButton.processAction(action, parentViewController: parentViewController, openExternal: openExternal)
    }
}
