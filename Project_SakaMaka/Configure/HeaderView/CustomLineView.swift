//
//  CustomLineView.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 6/1/24.
//

import UIKit

class CustomLineView: UIView {
    
    // 라인의 색상과 두께를 설정할 수 있는 변수
    var lineColor: UIColor = .black
    var lineWidth: CGFloat = 1.0
    
    private let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupLayer()
    }
    
    private func setupLayer() {
        self.layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.bounds.height / 2))
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height / 2))
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
    }
}
