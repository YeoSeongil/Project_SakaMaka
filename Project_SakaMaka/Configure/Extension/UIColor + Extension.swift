//
//  UIColor + Extension.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/18/24.
//

import UIKit

extension UIColor {
  /// Hex Color를 변환시켜 UIColor 색상을 설정합니다.
  /// ```
  /// let homeColor: UIColor = UIColor(hex: 0xF4F100)
  /// ```
  /// - Parameters:
  ///   - hexCode: 16진수의 Unsigned Int 값
  ///   - alpha: 투명도 값으로 0 or 1로 가져와야 합니다.
  convenience init(hexCode: UInt, alpha: CGFloat = 1.0) {
    self.init(
      red: CGFloat((hexCode & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((hexCode & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(hexCode & 0x0000FF) / 255.0,
      alpha: CGFloat(alpha)
    )
  }
}

extension UIColor {
    static let PrestigeBlue = UIColor(hexCode: 0x2f3542)
    static let Turquoise = UIColor(hexCode: 0x1abc9c)
}
