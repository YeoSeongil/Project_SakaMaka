//
//  UIImageView + Extension.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/27/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    /// 이미지 URL을 Parsing하여 imageView로 생성합니다.
    /// ```
    /// UIImageView.setImageKingfisher(with: imageURL)
    /// ```
    /// - Parameters:
    ///   - urlString: 이미지 URL
    func setImageKingfisher(with urlString: String) {
        guard let url = URL.init(string: urlString) else {
            return
        }
        kf.indicatorType = .activity
        kf.setImage(with: url)
    }
}
