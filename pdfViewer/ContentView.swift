//
//  ContentView.swift
//  pdfViewer
//
//  Created by minto on 8/9/2566 BE.
//

import SwiftUI
import PDFKit


@main
struct PDFImporterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var isImportingPDF = false

    var body: some View {
        NavigationView {
            List {
                // List of imported PDFs here
            }
            .navigationTitle("PDF Viewer")

            Button("Import PDF") {
                isImportingPDF.toggle()
            }
            .background(Color.black)
            .fileImporter(
                isPresented: $isImportingPDF,
                allowedContentTypes: [.pdf]
            ) { result in
                // Handle the imported PDF here
                // Display the confirmation dialog and import the document
            }
        }
        .onOpenURL { url in
            // Handle incoming URLs (PDFs) shared with the app
            // Display the confirmation dialog and import the document
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
