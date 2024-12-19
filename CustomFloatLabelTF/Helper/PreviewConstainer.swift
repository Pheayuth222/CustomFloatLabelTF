//
//  PreviewConstainer.swift
//  CustomFloatLabelTF
//
//  Created by Yuth Fight's iMac on 19/12/24.
//

import SwiftUI
import UIKit

// Preview : UIViewController
struct PreviewContainer<T: UIViewController>: UIViewControllerRepresentable {
    
    let viewControllerBuider : T
    
    init(_ viewControllerBuilder: @escaping () -> T) {
        
        self.viewControllerBuider = viewControllerBuilder()
    }
    
    // MARK: - UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> T {
        return viewControllerBuider
    }
    
    func updateUIViewController(_ uiViewController: T, context: Context) {
        
    }
    
}
