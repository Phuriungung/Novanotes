import SwiftUI
import UIKit

class FreeDrawingImageViewDrawLayer: UIView {
    
    var drawingLayer: CAShapeLayer?
    var line = [CGPoint]()
    
    var sublayers: [CALayer] {
        return self.layer.sublayers ?? [CALayer]()
    }
    
    let lineWidth: CGFloat = 5
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let newTouchPoint = touches.first?.location(in: self) else { return }
        line.append(newTouchPoint)
        
        let lastTouchPoint: CGPoint = line.last ?? .zero
        
        let rect = calculateRectBetween(lastPoint: lastTouchPoint, newPoint: newTouchPoint)
        
        layer.setNeedsDisplay(rect)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        flattenImage()
    }
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        
        let drawingLayer = self.drawingLayer ?? CAShapeLayer()
        let linePath = UIBezierPath()
        drawingLayer.contentsScale = UIScreen.main.scale
        
        
        for (index, point) in line.enumerated() {
            if index == 0 {
                linePath.move(to: point)
            } else {
                linePath.addLine(to: point)
            }
        }
        
        drawingLayer.path = linePath.cgPath
        drawingLayer.opacity = 1
        drawingLayer.lineWidth = lineWidth
        drawingLayer.lineCap = .round
        drawingLayer.fillColor = UIColor.clear.cgColor
        drawingLayer.strokeColor = UIColor.red.cgColor
        
        if self.drawingLayer == nil {
            self.drawingLayer = drawingLayer
            layer.addSublayer(drawingLayer)
        }
    }
    
    func checkIfTooManyPoints() {
        let maxPoints = 25
        if line.count > maxPoints {
            updateFlattenedLayer()
            // we leave two points to ensure no gaps or sharp angles
            _ = line.removeFirst(maxPoints - 2)
        }
    }
    
    func flattenImage() {
        updateFlattenedLayer()
        line.removeAll()
    }
    
    func updateFlattenedLayer() {
        // 1
        guard let drawingLayer = drawingLayer else {return}
            // 2
            let optionalDrawing = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(
                NSKeyedArchiver.archivedData(withRootObject: drawingLayer, requiringSecureCoding: false))
            as? CAShapeLayer
            // 3
            let newDrawing = optionalDrawing
            // 4
            self.layer.addSublayer(newDrawing!)
    }
    
    
    
    
    func clear() {
        emptyFlattenedLayers()
        drawingLayer?.removeFromSuperlayer()
        drawingLayer = nil
        line.removeAll()
        layer.setNeedsDisplay()
    }
    
    func emptyFlattenedLayers() {
        for case let layer as CAShapeLayer in sublayers {
            layer.removeFromSuperlayer()
        }
    }
    
    func calculateRectBetween(lastPoint: CGPoint, newPoint: CGPoint) -> CGRect {
        let originX = min(lastPoint.x, newPoint.x) - (lineWidth / 2)
        let originY = min(lastPoint.y, newPoint.y) - (lineWidth / 2)
        
        let maxX = max(lastPoint.x, newPoint.x) + (lineWidth / 2)
        let maxY = max(lastPoint.y, newPoint.y) + (lineWidth / 2)
        
        let width = maxX - originX
        let height = maxY - originY
        
        return CGRect(x: originX, y: originY, width: width, height: height)
    }
}

