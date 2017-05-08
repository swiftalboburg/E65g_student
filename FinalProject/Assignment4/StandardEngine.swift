//
//  StandardEngine.swift
//  Assignment4
//
//  Created by Ana Luisa Nystedt on 4/13/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import Foundation

 class StandardEngine : EngineProtocol {

    static var gridEngine : StandardEngine = StandardEngine(10,10)

    var rows : Int
    var cols : Int
    var refreshTimer : Timer?
    var loadingFrom : sources = .none
    var aliveCounter = 0
    var emptyCounter = 0
    var bornCounter = 0
    var diedCounter = 0
    
    
    var delegate : EngineDelegate?
    var grid : GridProtocol
    var tempRate = 0.0
    var refreshRate = 0.0  
    
    
    
    required init(_ rows : Int, _ columns : Int) {
    
        self.rows = rows
        self.cols = columns
        self.grid = Grid(rows,columns)
        self.refreshTimer = Timer()
        
        
    }
    
    
    
    func step() -> GridProtocol {
        let newGrid = grid.next()
        grid = newGrid
        delegate?.engineDidUpdate(withGrid : grid as! Grid)
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "NextGridUpdate")
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["standardEngine" : self])
        nc.post(n)
        
        
        return grid
        
    }
    
   
    
}
