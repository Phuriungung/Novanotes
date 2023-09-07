//
//  ContentView.swift
//  test
//
//  Created by minto on 7/9/2566 BE.
//


import SwiftUI

struct NewContentView: View {
    @State private var isPencilTouching = false

    var body: some View {
        ScrollView {
            VStack {
                ForEach(1...100, id: \.self) { i in
                    Text("Item \(i)")
                        .frame(width: 200, height: 50)
                        .background(isPencilTouching ? Color.red : Color.blue)
                }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    // Check if the touch is with an Apple Pencil
                    if UIDevice.current.model == "Apple Pencil" {
                        isPencilTouching = true
                    } else {
                        // Allow scrolling for other touch events
                        isPencilTouching = false
                    }
//                    print(isPencilTouching)
                }
        )
    }
}

struct NewContentView_Previews: PreviewProvider {
    static var previews: some View {
        NewContentView()
    }
}
