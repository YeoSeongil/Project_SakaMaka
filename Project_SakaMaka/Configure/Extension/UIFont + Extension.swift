//
//  UIFont + Extension.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/18/24.
//

import UIKit

extension UIFont {
    static func setFont(_ style: Pretendard, ofSize size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size)!
    }
}

enum Pretendard: String {
    case pretendardBold = "Pretendard-Bold"
    case pretendardSemiBold = "Pretendard-SemiBold"
    case pretendardMedium = "Pretendard-Medium"
    case pretendardRegular = "Pretendard-Regular"
}

extension UIFont {
    @nonobjc class var h1: UIFont {
        return UIFont.setFont(.pretendardBold, ofSize: 24)
    }
    
    @nonobjc class var h2: UIFont {
        return UIFont.setFont(.pretendardBold, ofSize: 22)
    }
    
    @nonobjc class var h2_2: UIFont {
        return UIFont.setFont(.pretendardMedium, ofSize: 22)
    }
    
    @nonobjc class var h3: UIFont {
        return UIFont.setFont(.pretendardBold, ofSize: 20)
    }
    
    @nonobjc class var h4: UIFont {
        return UIFont.setFont(.pretendardBold, ofSize: 18)
    }
    
    @nonobjc class var h5: UIFont {
        return UIFont.setFont(.pretendardSemiBold, ofSize: 15)
    }
    
    @nonobjc class var h6: UIFont {
        return UIFont.setFont(.pretendardSemiBold, ofSize: 160)
    }
    
    @nonobjc class var b1: UIFont {
        return UIFont.setFont(.pretendardMedium, ofSize: 17)
    }
    
    @nonobjc class var b2: UIFont {
        return UIFont.setFont(.pretendardMedium, ofSize: 15)
    }
    
    @nonobjc class var b3: UIFont {
        return UIFont.setFont(.pretendardRegular, ofSize: 15)
    }
    
    @nonobjc class var b4: UIFont {
        return UIFont.setFont(.pretendardMedium, ofSize: 14)
    }
    
    @nonobjc class var b5: UIFont {
        return UIFont.setFont(.pretendardSemiBold, ofSize: 13)
    }
    
    @nonobjc class var b6: UIFont {
        return UIFont.setFont(.pretendardRegular, ofSize: 13)
    }
    
    @nonobjc class var b7: UIFont {
        return UIFont.setFont(.pretendardMedium, ofSize: 12)
    }
    
    @nonobjc class var b8: UIFont {
        return UIFont.setFont(.pretendardRegular, ofSize: 12)
    }
    
    @nonobjc class var b9: UIFont {
        return UIFont.setFont(.pretendardSemiBold, ofSize: 11)
    }
}



