//
//  UIScrollView.swift
//  Novanotes
//
//  Created by minto on 7/9/2566 BE.
//

import SwiftUI

struct RepresentUIScrollView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = CustomUIScrollView()
        scrollView.isScrollEnabled = true
//        scrollView.contentSize = CGSize(width: 500, height: 1000)

        return scrollView
//        return MyCustomUIScrollView()
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


class MyCustomUIScrollView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        isScrollEnabled = true
        contentSize = CGSize(width: 500, height: 1000)
    }
}

class CustomUIScrollView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
        
//        super.init(frame: frame)
        contentSize = CGSize(width: 5000, height: 1000000)
        
        let greenView = UIView(frame: CGRect(x: 100, y: 0, width: 300, height: 500))
        greenView.backgroundColor = UIColor.green
        
        // Add the greenView as a subview
        addSubview(greenView)
        
        let drawView = SmoothedDraw(frame: CGRect(x: 400, y: 0, width: 300, height: 300))
        drawView.backgroundColor = UIColor.cyan
        
        addSubview(drawView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        if let allTouches = event?.allTouches {
            for touch in allTouches {
                if touch.type == .pencil {
                    print("pencil")
                }
                if touch.type == .direct {
                    print("direct")
                }
                if touch.type == .indirect {
                    print("indirect")
                }
            }
        }
        return true
    }
}

class SmoothedDraw: UIView {
    var path = UIBezierPath()
    var path2 = UIBezierPath()
    var ctr = 0
    var pts = [CGPoint](repeating: .zero, count: 5)
    var savedpts: [CGPoint] = []
    
    
    var whitePath = UIBezierPath()
    
    //    var cachedDrawView = cachedDraw(pts: [])
    
    override func draw(_ rect: CGRect) {
        //        path = UIBezierPath(roundedRect: rect, cornerRadius:10)
        path.lineWidth = 10.0 // Set the line width as needed
        path.lineCapStyle = .round
        
        UIColor.blue.setStroke()
        
        //        path.move(to: CGPoint(x: 500, y: 500))
        //        path.addLine(to: CGPoint(x: 500, y: 900))
        //        path.stroke()
        
        
        path2.lineWidth = 10.0
        path2.lineCapStyle = .round
        
        //        UIColor.blue.setStroke()
        //        path2.stroke()
        //        setNeedsDisplay()
        
        
        //        UIColor.red.setStroke()
        //        path.move(to: CGPoint(x: 900, y: 500))
        //        path.addLine(to: CGPoint(x: 500, y: 900))
        path.stroke()
        UIColor.blue.setStroke()
        path2.stroke()
        setNeedsDisplay()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setNeedsDisplay()
        ctr = 0
        if let touch = touches.first {
            pts[0] = touch.location(in: self)
        }
        
        path.move(to: pts[0])
        path.addLine(to: pts[0])
        path.stroke()
        setNeedsDisplay()
    }
    
    //    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        if let touch = touches.first {
    //            let p = touch.location(in: self)
    //            path.move(to: CGPoint(x:600, y: 800))
    //            path.addLine(to: CGPoint(x: 300, y: 600))
    //            path.addLine(to: p) // Add this line to draw a line from the starting point to the current touch point
    //            setNeedsDisplay()
    //        }
    //    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        path.stroke()
        //                print(touches)
        if let touch = touches.first {
            let p = touch.location(in: self)
            ctr += 1
            pts[Int(ctr)] = p
            //            if ctr == 1 {
            //                path.move(to: pts[0])
            //                path.addLine(to: pts[1])
            //                path.stroke()
            //                setNeedsDisplay()
            //            }
            //
            
            if ctr == 1 {
                path.move(to: pts[0])
                path.addLine(to: pts[1])
                path.stroke()
                setNeedsDisplay()
//                print("1")
            }
            
            if ctr == 2 {
                path.removeAllPoints()
                path.move(to: pts[0])
                path.addQuadCurve(to: pts[2], controlPoint: pts[1])
                path.stroke()
                setNeedsDisplay()
//                print("2")
            }
            
            
            if ctr == 3 {
                path.removeAllPoints()
                path.move(to: pts[0])
                path.addCurve(to: pts[3], controlPoint1: pts[1], controlPoint2: pts[2])
                path.stroke()
                setNeedsDisplay()
//                print("3")
            }
            
            if ctr == 4 {
                path.removeAllPoints()
                pts[3] = CGPoint(x: (pts[2].x + pts[4].x) / 2.0, y: (pts[2].y + pts[4].y) / 2.0)
                path2.move(to: pts[0])
                path2.addCurve(to: pts[3], controlPoint1: pts[1], controlPoint2: pts[2])
                //                path2.addLine(to: CGPoint(x: 500, y: 900))
                path2.stroke()
                setNeedsDisplay()
//                print("4")
                
                
                
                for i in 0...4 {
                    savedpts.append(pts[i])
                }
                //
                //                path2.move(to: savedpts[0])
                //                path2.addCurve(to: savedpts[3], controlPoint1: savedpts[1] , controlPoint2: savedpts[2])
//                                                print(savedpts)
                //
                //                path2.addLine(to: CGPoint(x: 500, y: 1000))
                //                path2.addLine(to: savedpts[1])
                //                path2.addLine(to: savedpts[2])
                //
                //                for i in 1...savedpts.count-1 {
                //                    path2.addLine(to: savedpts[i])
                //                }
                //
                //                path2.stroke()
                //                setNeedsDisplay()
                
                
                pts[0] = pts[3]
                pts[1] = pts[4]
//                print("5")
                ctr = 1
                
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if ctr == 0 {
            path2.move(to: pts[0])
            path2.addLine(to: pts[0])
            path2.stroke()
            setNeedsDisplay()
        }
        
        if ctr == 1 {
            path2.move(to: pts[0])
            path2.addLine(to: pts[1])
            path2.stroke()
            setNeedsDisplay()
//            print("e1")
        }
        
        if ctr == 2 {
            path2.move(to: pts[0])
            path2.addQuadCurve(to: pts[2], controlPoint: pts[1])
            path2.stroke()
            setNeedsDisplay()
//            print("e2")
        }
        
        if ctr == 3 {
            path2.move(to: pts[0])
            path2.addCurve(to: pts[3], controlPoint1: pts[1], controlPoint2: pts[2])
            path2.stroke()
            setNeedsDisplay()
//            print("e3")
        }
        
        ctr = 0
        //        path.removeAllPoints()
    }
    
}
