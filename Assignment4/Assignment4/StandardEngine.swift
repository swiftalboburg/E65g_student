//
//  StandardEngine.swift
//  Assignment4
//
//  Created by Ana Luisa Nystedt on 4/13/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import Foundation

public class StandardEngine : EngineProtocol {
    
    static var gridEngine = StandardEngine(10,10)
    
    var delegate : EngineDelegate?
    var grid : GridProtocol
    var refreshRate = 0.0
    var refreshTimer : Timer
    var rows : Int
    var cols : Int
    
    
    
    
    public required init(_ rows : Int, _ columns : Int) {
        
        self.rows = rows
        self.cols = columns
        grid = Grid(rows,cols)
        refreshTimer = Timer()
        
        
    }
    
    func step() -> GridProtocol {
        let newGrid = grid.next()
        grid = newGrid
        delegate?.engineDidUpdate(withGrid : grid as! Grid)
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "GridUpdate")
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["StandardEngine" : self])
        nc.post(n)
        
        
        return grid
        
    }
    
}
