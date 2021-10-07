//
//  File.swift
//  
//
//  Created by Jeff Cooper on 6/1/21.
//

import UIKit

@IBDesignable
open class ImageStripKnob: ImageKnob {
    @IBInspectable var basename: String? = nil
    @IBInspectable var imageExtension: String = "png"
    @IBInspectable var baseWidth: CGFloat = 0
    @IBInspectable var baseHeight: CGFloat = 0
    @IBInspectable var isVertical: Bool = true

    public var imageStrip: UIImage? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        generateImageBank()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        generateImageBank()
    }

    public override func updateKnobPosition(normalised: Float) {
        generateImageBank()
        super.updateKnobPosition(normalised: normalised)
    }

    public override func layoutSubviews() {
        generateImageBank()
        super.layoutSubviews()
    }

    private func generateImageBank() {
        if baseWidth > 0 && baseHeight > 0,
           images.count == 0 {
            var images = [UIImage]()
            var baseImage: UIImage
            if let basename = basename {
                let imageFilename = "\(basename).\(imageExtension)"
                guard let foundImage = UIImage(named: imageFilename) else {
                    fatalError("could not find an image named \(imageFilename)")
                }
                baseImage = foundImage
                imageStrip = baseImage
            } else if let imageStrip = imageStrip {
                baseImage = imageStrip
            } else {
                return
            }
            let numberOfFrames = isVertical ? baseImage.size.height / baseHeight : baseImage.size.width / baseWidth
            for frame in 0..<Int(numberOfFrames) {
                let offset = (isVertical ? baseHeight : baseWidth) * CGFloat(frame)
                let rect = CGRect(x: isVertical ? 0 : offset,
                                 y: isVertical ? offset : 0,
                                 width: baseWidth, height: baseHeight)
                if let image = cropImage(image: baseImage, rect: rect) {
                    images.append(image)
                }
            }
            self.images = images
            refreshKnobPosition()
        }
    }

    private func cropImage(image: UIImage, rect: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage,
              let croppedCGImage = cgImage.cropping(to: rect)
        else { return nil }
        return UIImage(cgImage: croppedCGImage)
    }
}

