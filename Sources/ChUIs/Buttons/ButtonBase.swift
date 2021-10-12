//
//  ButtonBase.swift
//
//
//  Created by Jeff Cooper on 10/7/21.
//

import UIKit

open class ButtonBase: UIView {

    @IBInspectable public var imageContentMode: UIView.ContentMode = .scaleAspectFit
    private var imageView: UIImageView!

    // Init / Lifecycle
    override init(frame: CGRect) {
        imageView = UIImageView(frame: frame)
        super.init(frame: frame)
        initFunctions()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.imageView = UIImageView(frame: frame)
        initFunctions()
    }

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initFunctions()
    }

    public func updateImage(image: UIImage?) {
        imageView.image = image
        setNeedsDisplay()
    }

    private func initFunctions() {
        clipsToBounds = true
        isUserInteractionEnabled = true
        imageView.backgroundColor = .clear
        imageView.frame = bounds
        imageView.contentMode = imageContentMode
        addSubview(imageView)
        self.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: imageView!, attribute: NSLayoutConstraint.Attribute.centerX,
                           relatedBy: NSLayoutConstraint.Relation.equal, toItem: self,
                           attribute: NSLayoutConstraint.Attribute.centerX,
                           multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView!, attribute: NSLayoutConstraint.Attribute.centerY,
                           relatedBy: NSLayoutConstraint.Relation.equal, toItem: self,
                           attribute: NSLayoutConstraint.Attribute.centerY,
                           multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView!, attribute: NSLayoutConstraint.Attribute.width,
                           relatedBy: NSLayoutConstraint.Relation.equal, toItem: self,
                           attribute: NSLayoutConstraint.Attribute.width,
                           multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView!, attribute: NSLayoutConstraint.Attribute.height,
                           relatedBy: NSLayoutConstraint.Relation.equal, toItem: self,
                           attribute: NSLayoutConstraint.Attribute.height,
                           multiplier: 1, constant: 0).isActive = true
    }
}
