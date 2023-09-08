import SwiftUI
import PDFKit
import UIKit

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PDFKitView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitView>) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFKitView>) {
        // Leave this empty as we don't need to update the PDF
    }
}

struct ContentView: View {
    @State private var selectedPDFUrl: URL? // Store the selected PDF URL here
    
    @State var imported = false
    @State var fileUrl: URL?
    
    var body: some View {
        VStack {
            
            Button(action: {imported.toggle()}, label: {
                Text("Import file")
            })
            if let theUrl = fileUrl {
                Text("file url is \(theUrl.absoluteString)")
            }
        }
        .fileImporter(isPresented: $imported, allowedContentTypes: [.pdf]) { res in
            do {
                fileUrl = try res.get()
                print("---> fileUrl: \(fileUrl)")
            } catch{
                print ("error reading: \(error.localizedDescription)")
            }
            
            
            
            Image(systemName: "doc.viewfinder")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Text("PDF Viewer")
                .foregroundColor(.accentColor)
            
            if let pdfUrl = selectedPDFUrl { // Check if a PDF has been selected
                PDFKitView(url: fileUrl!)
            }
        }
        .padding()
    }
}

@main
struct PDFViewerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
