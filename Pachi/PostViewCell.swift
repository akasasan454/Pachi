//
//  PostViewCell.swift
//  Pachi
//
//  Created by Takafumi Ogaito on 2019/02/19.
//  Copyright © 2019 Takafumi Ogaito. All rights reserved.
//

import UIKit
import Pring

class PostViewCell: UITableViewCell {
    
    var disposer: Disposer<User>?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    var images: [UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 12
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        images = [UIImage(named: "1"),UIImage(named: "2"),UIImage(named: "3")] as! [UIImage]
        for (index, image) in images.enumerated() {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(index) * self.scrollView.frame.width, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.width))
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            imageView.image = image
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: self.scrollView.frame.width * CGFloat(images.count), height: self.scrollView.frame.width)
    }
}

@IBDesignable
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}
