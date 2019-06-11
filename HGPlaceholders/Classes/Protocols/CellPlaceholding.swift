//
//  Placeholdering.swift
//  Pods
//
//  Created by Hamza Ghazouani on 25/07/2017.
//
//

import UIKit

protocol CellPlaceholding {
    var titleLabel: UILabel? { get set }
    var subtitleLabel: UILabel? { get set }
    var placeholderImageView: UIImageView? { get set }
    var actionButton: UIButton? { get set }
    var activityIndicator: UIActivityIndicatorView? { get set }

    var cellView: UIView { get }

    // MARK: fill cell to selected style

    ///  Changes the cell style to match placeholder style
    ///
    /// - Parameters:
    ///   - style: the style to apply
    ///   - tintColor: the tint color, is used for some items when the style color is nil
    func apply(style: PlaceholderStyle, tintColor: UIColor?)

    ///  Sets in the cell the placeholder texts, image, ...
    ///
    /// - Parameter data: the data of the cell (texts, images, etc)
    func apply(data: PlaceholderData?)
}

extension UIView {
    func setLayerShadow(color: UIColor, offset: CGSize, radius: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

// MARK: default implementation

extension CellPlaceholding {
    ///  Changes the cell style to match placeholder style
    ///
    /// - Parameters:
    ///   - style: the style to apply
    ///   - tintColor: the tint color, is used for some items when the style color is nil
    internal func apply(style: PlaceholderStyle, tintColor: UIColor?) {
        cellView.backgroundColor = style.backgroundColor

        let buttonBackgroundColor = style.actionBackgroundColor ?? tintColor
        actionButton?.backgroundColor = buttonBackgroundColor

        let actionColor = style.actionTitleColor
        actionButton?.setTitleColor(actionColor, for: .normal)
        actionButton?.titleLabel?.font = style.actionTitleFont
        actionButton?.setBackgroundImage(style.actionBackgroundImage, for: .normal)
        actionButton?.layer.cornerRadius = style.actionCornerRadius

        if let _ = style.actionShadowColor {
            
            actionButton?.layer.cornerRadius = 0
            actionButton?.setBackgroundImage(style.actionBackgroundImage?.image(withRoundRadius: style.actionCornerRadius), for: .normal)

            actionButton?.clipsToBounds = false
            actionButton?.setLayerShadow(color: style.actionShadowColor!, offset: style.actionShadowOffset, radius: style.actionShadowRadius)
        }

        activityIndicator?.color = style.activityIndicatorColor

        titleLabel?.textColor = style.titleColor
        titleLabel?.font = style.titleFont
        titleLabel?.textAlignment = style.titleTextAlignment

        subtitleLabel?.textColor = style.subtitleColor
        subtitleLabel?.font = style.subtitleFont
        subtitleLabel?.textAlignment = style.subtitleTextAlignment
    }

    ///  Sets in the cell the placeholder texts, image, ...
    ///
    /// - Parameter data: the data of the cell (texts, images, etc)
    internal func apply(data: PlaceholderData?) {
        actionButton?.setTitle(data?.action, for: .normal)
        actionButton?.isHidden = (data?.action == nil)

        titleLabel?.text = data?.title
        subtitleLabel?.text = data?.subtitle
        placeholderImageView?.image = data?.image

        data?.showsLoading == true ? activityIndicator?.startAnimating() : activityIndicator?.stopAnimating()
    }
}

extension UIImage {
    public func image(withRoundRadius radius: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard
            let context = UIGraphicsGetCurrentContext(),
            let cgImage = self.cgImage
        else { return nil }

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -rect.size.height)

        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        path.close()

        context.saveGState()
        path.addClip()
        context.draw(cgImage, in: rect)
        context.restoreGState()

        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
