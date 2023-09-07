//
//  ContentView.swift
//  Novanotes
//
//  Created by minto on 6/9/2566 BE.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            RepresentUIView().background(Color.yellow)
            RepresentUIScrollView().background(Color.red)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
