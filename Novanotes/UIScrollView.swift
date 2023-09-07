//
//  UIScrollView.swift
//  Novanotes
//
//  Created by minto on 7/9/2566 BE.
//

import SwiftUI

struct RepresentUIScrollView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIScrollView {
        UIScrollView()
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        
    }
    
    typealias UIViewType = UIScrollView
    
}

struct RepresentUIView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        UIScrollView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    typealias UIViewType = UIView
    
}

class customUIScrollView: UIScrollView {
    
}
