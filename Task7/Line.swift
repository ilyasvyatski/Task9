//
//  Line.swift
//  Task7
//
//  Created by neoviso on 9/23/22.
//

import UIKit

public class Line: NSObject, NSCoding {
    var points: [CGPoint]?
    let color: UIColor
    let width: Float
    
    public init(points: [CGPoint], color: UIColor, width: Float) {
        self.points = points
        self.color = color
        self.width = width
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(points, forKey: "points")
        coder.encode(color, forKey: "color")
        coder.encode(width, forKey: "width")
    }
    
    required public init?(coder: NSCoder) {
        points = coder.decodeObject(forKey: "points") as? [CGPoint]
        color = (coder.decodeObject(forKey: "color") as! UIColor)
        width = (coder.decodeObject(forKey: "width") as? Float ?? 1.0)
        super.init()
    }
}
