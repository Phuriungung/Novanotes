import SwiftUI

class SmoothedDraw: UIView {
    var path = UIBezierPath()
    var path2 = UIBezierPath()
    var eraserpath = UIBezierPath()
    var bezierPath = UIBezierPath()
    var ctr = 0
    var pts = [CGPoint](repeating: .zero, count: 5)
    var savedpts: [CGPoint] = []
    private var incrementalImage: UIImage?
    
    var whitePath = UIBezierPath()
    
    override func draw(_ rect: CGRect) {
        
        incrementalImage?.draw(in: rect)
        //        path = UIBezierPath(roundedRect: rect, cornerRadius:10)
        path.lineWidth = 5.0 // Set the line width as needed
        path.lineCapStyle = .round
        
        UIColor.blue.setStroke()
        
        path2.lineWidth = 5.0
        path2.lineCapStyle = .round
        
        path.stroke()
        UIColor.red.setStroke()
        path2.stroke()
//        setNeedsDisplay()
        
        bezierPath.move(to: CGPoint(x: 500, y: 500))
        bezierPath.addLine(to: CGPoint(x: 100, y: 900))
        
        // Create a new CGPath with a different path
        let newPath = UIBezierPath()
        newPath.move(to: CGPoint(x: 150, y: 500))
        newPath.addCurve(to: CGPoint(x: 200, y: 900), controlPoint1: CGPoint(x: 170, y: 170), controlPoint2: CGPoint(x: 180, y: 30))
        
        let newlyPath = UIBezierPath()
        
        let a = 500
        newlyPath.move(to: CGPoint(x: 0, y: a))
        //        newlyPath.addCurve(to: CGPoint(x: 200, y: 900), controlPoint1: CGPoint(x: 170, y: 170), controlPoint2: CGPoint(x: 180, y: 30))
        //        newlyPath.addLine(to: CGPoint(x: 900, y: 500))
        newlyPath.addLine(to: CGPoint(x: 170, y: 170))
        
        // Assign the new CGPath to the cgPath property of the UIBezierPath
        bezierPath.cgPath = newlyPath.cgPath
        
        bezierPath.cgPath = newPath.cgPath.lineSubtracting(newlyPath.cgPath)
        
        
        // Now, bezierPath contains the new path defined by newPath's CGPath.
        UIColor.green.setStroke()
        bezierPath.lineWidth = 20
        bezierPath.stroke()
//        setNeedsDisplay()
        
    }
    func calculateRectBetween(lastPoint: CGPoint, newPoint: CGPoint) -> CGRect {
        let originX = min(lastPoint.x, newPoint.x) - (path.lineWidth / 2)
        let originY = min(lastPoint.y, newPoint.y) - (path.lineWidth / 2)

        let maxX = max(lastPoint.x, newPoint.x) + (path.lineWidth / 2)
        let maxY = max(lastPoint.y, newPoint.y) + (path.lineWidth / 2)

        let width = maxX - originX
        let height = maxY - originY

        return CGRect(x: originX, y: originY, width: width, height: height)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch.type == .pencil {
                setNeedsDisplay()
                ctr = 0
                if let touch = touches.first {
                    pts[0] = touch.location(in: self)
                }
                
                path.move(to: pts[0])
                path.addLine(to: pts[0])
                let rect = calculateRectBetween(lastPoint: pts[0], newPoint: pts[0])
                setNeedsDisplay(rect)
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch.type == .pencil {
//                path.stroke()
                //                print(touches)
                if let touch = touches.first {
                    let p = touch.location(in: self)
                    ctr += 1
                    pts[Int(ctr)] = p
                    
                    if ctr == 1 {
                        path.move(to: pts[0])
                        path.addLine(to: pts[1])
                        let rect = calculateRectBetween(lastPoint: pts[1], newPoint: pts[0])
                        setNeedsDisplay(rect)
                        
                    }
                    
                    if ctr == 2 {
                        path.removeAllPoints()
                        path.move(to: pts[0])
                        path.addQuadCurve(to: pts[2], controlPoint: pts[1])
                        let rect = calculateRectBetween(lastPoint: pts[2], newPoint: pts[0])
                        setNeedsDisplay(rect)
                        
                    }
                    
                    
                    if ctr == 3 {
                        path.removeAllPoints()
                        path.move(to: pts[0])
                        path.addCurve(to: pts[3], controlPoint1: pts[1], controlPoint2: pts[2])
                        let rect = calculateRectBetween(lastPoint: pts[3], newPoint: pts[0])
                        setNeedsDisplay(rect)
                        
                    }
                    
                    if ctr == 4 {
                        path.removeAllPoints()
                        pts[3] = CGPoint(x: (pts[2].x + pts[4].x) / 2.0, y: (pts[2].y + pts[4].y) / 2.0)
                        path2.move(to: pts[0])
                        path2.addCurve(to: pts[3], controlPoint1: pts[1], controlPoint2: pts[2])
                        let rect = calculateRectBetween(lastPoint: pts[4], newPoint: pts[0])
                        setNeedsDisplay(rect)
                        
                        //                        print(path2.cgPath)
                        
                        
                        
                        
                        
                        
                        
                        for i in 0...4 {
                            savedpts.append(pts[i])
                        }
                        
                        pts[0] = pts[3]
                        pts[1] = pts[4]
                        
                        ctr = 1
                        
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch.type == .pencil {
                
                if ctr == 0 {
                    path2.move(to: pts[0])
                    path2.addLine(to: pts[0])
//                    path2.stroke()
                    setNeedsDisplay()
                }
                
                if ctr == 1 {
                    path2.move(to: pts[0])
                    path2.addLine(to: pts[1])
//                    path2.stroke()
                    setNeedsDisplay()
                    //            print("e1")
                }
                
                if ctr == 2 {
                    path2.move(to: pts[0])
                    path2.addQuadCurve(to: pts[2], controlPoint: pts[1])
//                    path2.stroke()
                    setNeedsDisplay()
                    //            print("e2")
                }
                
                if ctr == 3 {
                    path2.move(to: pts[0])
                    path2.addCurve(to: pts[3], controlPoint1: pts[1], controlPoint2: pts[2])
//                    path2.stroke()
                    setNeedsDisplay()
                    //            print("e3")
                }
                drawBitmap()
                path2.removeAllPoints()
                
                ctr = 0
                //        path.removeAllPoints()
            }
            
        }
    }
    private func drawBitmap() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        UIColor.black.setStroke()
        
        if incrementalImage == nil { // first draw; paint background white by ...
            let rectPath = UIBezierPath(rect: bounds)
            UIColor.white.setFill()
            rectPath.fill() // filling it with white
        }
        
        incrementalImage?.draw(at: CGPoint.zero)
        path2.stroke()
        incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}
