//
//  PostViewCell.swift
//  Pachi
//
//  Created by Takafumi Ogaito on 2019/02/19.
//  Copyright © 2019 Takafumi Ogaito. All rights reserved.
//

import UIKit
import Pring
import FirebaseUI

class PostViewCell: UITableViewCell {
    
    var disposer: Disposer<Post>?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 12
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    func setData(post: Post) {
        subjectLabel?.text = post.latitude.description
        bodyLabel?.text = post.longitude.description
        let width = self.scrollView.frame.width
        let imageView = UIImageView(frame: CGRect(x: CGFloat(0) * width, y: 0, width: width, height: width))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imageView.sd_setImage(with: post.image?.downloadURL) { (image, error, _, _) in
            print(image)
        }
        scrollView.addSubview(imageView)
        scrollView.contentSize = CGSize(width: width * CGFloat(1), height: width)
    }
}

@IBDesignable
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}
