//
//  GridView.swift
//  Assignment3
//
//  Created by Ana Luisa Nystedt on 4/10/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable class GridView: UIView {
    var theGrid = Grid(0,0)
    
    
    @IBInspectable var livingColor : UIColor  = UIColor.blue
    
    @IBInspectable var emptyColor : UIColor = UIColor.white
    
    @IBInspectable var bornColor : UIColor = UIColor.green
    
    @IBInspectable var diedColor : UIColor = UIColor.black
    
    @IBInspectable var gridColor : UIColor = UIColor.gray
    
    @IBInspectable var gridWidth : CGFloat = 0.0
    
    @IBInspectable var size : Int = 20 {
        didSet{
            theGrid = Grid(size, size)
        }
    }
    
    override func draw(_ rect: CGRect) {
        let boardSize = CGSize(
            width: rect.size.width/CGFloat(size),
            height: rect.size.height/CGFloat(size)
        )
        let base = rect.origin
        (0 ..< size).forEach { i in
            (0 ..< size).forEach { j in
                let origin = CGPoint(
                    x: base.x + (CGFloat(j) * boardSize.width),
                    y: base.y + (CGFloat(i) * boardSize.height)
                )
                let subRect = CGRect(
                    origin: origin,
                    size: boardSize
                )
                let path = UIBezierPath(ovalIn: subRect)
                
                
                //theGrid[Position(i,j)].isAlive ? livingColor.setFill() : emptyColor.setFill()
                switch theGrid[Position(i,j)] {
                  case .alive : livingColor.setFill()
                  case .empty : emptyColor.setFill()
                  case .born : bornColor.setFill()
                  case .died : diedColor.setFill()
                }
                
                path.fill()
            }
        }
        
        
        //create the path
        (0 ..< size+1 ).forEach {
            drawLine(
                start: CGPoint(x: CGFloat($0)/CGFloat(size) * rect.size.width, y: 0.0),
                end:   CGPoint(x: CGFloat($0)/CGFloat(size) * rect.size.width, y: rect.size.height)
            )
            
            drawLine(
                start: CGPoint(x: 0.0, y: CGFloat($0)/CGFloat(size) * rect.size.height ),
                end: CGPoint(x: rect.size.width, y: CGFloat($0)/CGFloat(size) * rect.size.height)
            )
        }
    }
    
    
    
    func drawLine(start:CGPoint, end: CGPoint) {
        let path = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        path.lineWidth = gridWidth
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        path.move(to: start)
        
        //add a point to the path at the end of the stroke
        path.addLine(to: end)
        
        //draw the stroke
        gridColor.setStroke()
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = nil
    }
    
    // Updated since class
    typealias Position = (row: Int, col: Int)
    var lastTouchedPosition: Position?
    
    func process(touches: Set<UITouch>) -> Position? {
        guard touches.count == 1 else { return nil }
        let pos = convert(touch: touches.first!)
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        
        theGrid[pos] = theGrid[pos].toggle(theGrid[pos])
        // print(theGrid[pos].description())
        setNeedsDisplay()
        return pos
    }
    
    func convert(touch: UITouch) -> Position {
        let touchY = touch.location(in: self).y
        let gridHeight = frame.size.height
        let row = touchY / gridHeight * CGFloat(size)
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let col = touchX / gridWidth * CGFloat(size)
        let position = (row: Int(row), col: Int(col))
        return position
    }
    
    
    
    
}
