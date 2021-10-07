//
//  ImageKnob.swift
//  
//
//  Created by Jeff Cooper on 5/7/21.
//  This is more a convenience layer on top of ImageKnob.
//  Instead of providing the images programatically, you can set a base name and a number of images,
//  and it will attempt to load images named: basename+imageIndex.extension
//
//  Since this is relying on un-testable user input via IB, there are lots of ways to screw this up,
//  so pay attention...
//  Image frame numbers are padded w/ zeros, so if you have less than 10 images, there is no padding,
//  10-100 will pad with one zero, and 100+ will pad w two zeros. 1000 or more images is not supported.
//
//  Example... 8 frames, images are named image1.png, image2.png, image8.png etc.
//  Example... 18 frames, images are named image01.png, image02.png, image18.png etc.
//  Example... 128 frames, images are named image001.png, image002.png, image128.png etc.
//
//  If you made a typo or it can't find the images, it will print an error to the console to let you know.
//  You need to set the 'firstIndex' to the first frame number in your image set, likely 0 or 1 (frame0.png vs frame1.png)
//

import UIKit

@IBDesignable
open class ImageKnob: Knob {

    public var images = [UIImage]()
    public var frameCount: Int { return images.count }

    private var imageView = UIImageView()

    public override func updateKnobPosition(normalised: Float) {
        let frameNumber = max(min(Int(normalised * Float(frameCount).rounded()), frameCount - 1), 0)
        guard frameNumber < frameCount else {
            if frameCount != 0 {
                print("error: requested frame \(frameNumber), have \(frameCount)")
            }
            return
        }
        imageView.image = images[frameNumber]
        super.updateKnobPosition(normalised: normalised)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: frame)
        setupImageView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImageView()
    }

    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupImageView()
    }

    private func setupImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        imageView.contentMode = .scaleAspectFit
    }
}
