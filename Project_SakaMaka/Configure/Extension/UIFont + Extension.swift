//
//  UIFont + Extension.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/18/24.
//

import UIKit

extension UIFont {
    enum Pretendard: String {
        case pretendardBold = "Pretendard-Bold"
        case pretendardSemiBold = "Pretendard-SemiBold"
        case pretendardMedium = "Pretendard-Medium"
        case pretendardRegular = "Pretendard-Regular"
    }
}

extension UIFont {
    
    static let h1 = UIFont(name: Pretendard.pretendardBold.rawValue, size: 24)!
    static let h2 = UIFont(name: Pretendard.pretendardBold.rawValue, size: 22)!
    static let h2_2 = UIFont(name: Pretendard.pretendardMedium.rawValue, size: 22)!
    static let h3 = UIFont(name: Pretendard.pretendardBold.rawValue, size: 20)!
    static let h4 = UIFont(name: Pretendard.pretendardBold.rawValue, size: 18)!
    static let h5 = UIFont(name: Pretendard.pretendardBold.rawValue, size: 17)!
    static let h6 = UIFont(name: Pretendard.pretendardBold.rawValue, size: 15)!
    
    static let b1 = UIFont(name: Pretendard.pretendardMedium.rawValue, size: 17)!
    static let b2 = UIFont(name: Pretendard.pretendardMedium.rawValue, size: 15)!
    static let b3 = UIFont(name: Pretendard.pretendardRegular.rawValue, size: 15)!
    static let b4 = UIFont(name: Pretendard.pretendardMedium.rawValue, size: 14)!
    static let b5 = UIFont(name: Pretendard.pretendardSemiBold.rawValue, size: 13)!
    static let b6 = UIFont(name: Pretendard.pretendardRegular.rawValue, size: 13)!
    static let b7 = UIFont(name: Pretendard.pretendardMedium.rawValue, size: 12)!
    static let b8 = UIFont(name: Pretendard.pretendardRegular.rawValue, size: 12)!
    static let b9 = UIFont(name: Pretendard.pretendardRegular.rawValue, size: 11)!
    
}



