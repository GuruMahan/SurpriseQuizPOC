//
//  UIScreenExtention.swift
//  Surprise QuizUI Demo
//
//  Created by Guru Mahan on 19/01/23.
//

import Foundation

import SwiftUI

extension UIScreen {
    var safeAreaInsets: UIEdgeInsets {
        let first = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return first?.safeAreaInsets ?? .zero
    }
}


struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
