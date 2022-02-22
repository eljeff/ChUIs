//
//  ImageKnobWithNameAndCount.swift
//  
//
//  Created by Jeff Cooper on 6/1/21.
//

import UIKit

@IBDesignable
open class ImageKnobWithNameAndCount: ImageKnob {
    @IBInspectable var basename: String? = nil
    @IBInspectable var imageExtension: String = "png"
    @IBInspectable var numberOfImages: Int = 0
    @IBInspectable var firstIndex: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        generateImageBank()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        generateImageBank()
    }
    
    public override func updateUI(denormalised: Float) {
        let clampedValue = (minimumValue...maximumValue).clamp(CGFloat(denormalised))
        generateImageBank()
        super.updateUI(denormalised: Float(clampedValue))
    }
    
    public override func updateUI(normalised: Float) {
        let denormalised = CGFloat(normalised) * (maximumValue - minimumValue) + minimumValue
        updateUI(denormalised: Float(denormalised))
    }

    public override func layoutSubviews() {
        generateImageBank()
        super.layoutSubviews()
    }

    private func generateImageBank() {
        if numberOfImages > 0 && images.count == 0 {
            var images = [UIImage]()
            for i in firstIndex ..< (firstIndex + numberOfImages) {
                var frameIndexString: String
                if numberOfImages < 10 {
                    frameIndexString = String(format: "%01d", i)
                } else if numberOfImages < 100 {
                    frameIndexString = String(format: "%02d", i)
                } else if numberOfImages < 1000 {
                    frameIndexString = String(format: "%03d", i)
                } else {
                    fatalError("more than 1000 images not supported (you asked for \(numberOfImages))")
                }
                let imageFilename = "\(basename ?? "")\(frameIndexString).\(imageExtension)"
                if let image = UIImage(named: imageFilename) {
                    images.append(image)
                } else {
                    print("error: could not add image \(imageFilename) to array")
                }
            }
            if images.count != numberOfImages {
                print("error: numberOfImages (\(numberOfImages)) does not match found images found (\(images.count))")
            }
            self.images = images
            refreshKnobPosition()
        }
    }
}
