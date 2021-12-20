//
//  VersionLabel.swift
//  
//
//  Created by Jeff Cooper on 12/20/21.
//

import UIKit

@IBDesignable
class VersionLabel: UIView {
    @IBInspectable var showBuild: Bool = false {
        didSet { updateText() }
    }

    @IBInspectable var fontSize: CGFloat = 22 {
        didSet { updateFont() }
    }

    @IBInspectable var fontColour: UIColor = .black {
        didSet { updateFont() }
    }

    @IBInspectable var fontName: String = "Courier" {
        didSet { updateFont() }
    }

    @IBInspectable var showVersionText: Bool = false {
        didSet { updateText() }
    }

    private func updateText() {
        textLabel.text = textToShow
    }

    private func updateFont() {
        textLabel.font = UIFont(name: fontName, size: fontSize)
        textLabel.textColor = fontColour
    }

    private let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "n/a"
    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "n/a"
    private var textToShow: String {
        return "\(showVersionText ? "Version: " : "")\(version)\(showBuild ? "-\(build)" : "")"
    }

    lazy var textLabel: UILabel = {
        let textLabel = UILabel(frame: frame)
        textLabel.font = UIFont(name: fontName, size: fontSize)
        textLabel.text = textToShow
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    private func setupView() {
        addSubview(textLabel)
        updateFont()
        setupLayout()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            //pin headerTitle to headerView
            textLabel.topAnchor.constraint(equalTo: self.topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }

    //custom views should override this to return true if
    //they cannot layout correctly using autoresizing.
    //from apple docs https://developer.apple.com/documentation/uikit/uiview/1622549-requiresconstraintbasedlayout
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
}
