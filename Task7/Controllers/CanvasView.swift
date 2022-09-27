//
//  CanvasView.swift
//  Task7
//
//  Created by neoviso on 9/23/22.
//

import UIKit
import CoreData

class CanvasView: UIView {
    
    private var undoLines: [Line] = []
    private var brushColor: UIColor = .black
    private var brushWidth: Float = 4
    
    weak var canvasViewController: CanvasViewController?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        canvasViewController?.selectedPicture?.lines.forEach { line in
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(CGFloat(line.width))
            for (index, point) in line.points!.enumerated() {
                if index == 0 {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
            }
            context.strokePath()
        }
        CoreDataStack.shared.saveContext()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if  canvasViewController?.selectedPicture?.lines.count == 0 {
            canvasViewController?.clearCanvasButton.isEnabled = true
            canvasViewController?.undoButton.isEnabled = true
        }
        if undoLines.count != 0 {
            canvasViewController?.redoButton.isEnabled = false
            undoLines.removeAll()
        }
        //canvasViewController?.selectedPicture?.appendLines(points: [], color: brushColor, width: brushWidth)
         canvasViewController?.selectedPicture?.lines.append(Line.init(points: [], color: brushColor, width: brushWidth))
        CoreDataStack.shared.saveContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        guard let lastLine =  canvasViewController?.selectedPicture?.lines.popLast() else { return }
        lastLine.points?.append(point)
         canvasViewController?.selectedPicture?.lines.append(lastLine)
        setNeedsDisplay()
        CoreDataStack.shared.saveContext()
    }
    
    func undo() {
        if  canvasViewController?.selectedPicture?.lines.count == 1 {
            canvasViewController?.undoButton.isEnabled = false
            canvasViewController?.clearCanvasButton.isEnabled = false
        }
        if canvasViewController?.redoButton.isEnabled == false {
            canvasViewController?.redoButton.isEnabled = true
        }
        undoLines.append((canvasViewController?.selectedPicture?.lines.removeLast())!)
        setNeedsDisplay()
        CoreDataStack.shared.saveContext()
    }
    
    func redo() {
        if undoLines.count == 1 {
            canvasViewController?.redoButton.isEnabled = false
        }
        if canvasViewController?.undoButton.isEnabled == false {
            canvasViewController?.undoButton.isEnabled = true
        }
        if canvasViewController?.clearCanvasButton.isEnabled == false {
            canvasViewController?.clearCanvasButton.isEnabled = true
        }
         canvasViewController?.selectedPicture?.lines.append(undoLines.last!)
        undoLines.removeLast()
        setNeedsDisplay()
        CoreDataStack.shared.saveContext()
    }
    
    func clear() {
        guard canvasViewController?.selectedPicture?.lines.count ?? 0 > 0 else { return }
        canvasViewController?.selectedPicture?.lines.removeAll()
        undoLines.removeAll()
        canvasViewController?.undoButton.isEnabled = false
        canvasViewController?.redoButton.isEnabled = false
        canvasViewController?.clearCanvasButton.isEnabled = false
        setNeedsDisplay()
        CoreDataStack.shared.saveContext()
    }
    
    func setBrushWidth(width: Float) {
        brushWidth = width
    }
    
    func setBrushColor(color: UIColor) {
        brushColor = color
    }
}

