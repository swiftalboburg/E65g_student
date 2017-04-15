//
//  StandardEngine.swift
//  Assignment4
//
//  Created by Ana Luisa Nystedt on 4/13/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import Foundation

 class StandardEngine : EngineProtocol {
    
  

    var rows : Int
    var cols : Int
    var refreshTimer : Timer
    
    var delegate : EngineDelegate?
    var grid : GridProtocol
    var refreshRate = 0.0   {
        didSet {
    /*        if refreshRate > 0.0 {
                refreshTimer = Timer.scheduledTimer(
                    withTimeInterval: refreshRate,
                    repeats: true
                ) { (t: Timer) in
                    self.grid = self.step()
                    print("refreshrateDidSet")
                }
            }
            else {
                refreshTimer.invalidate()
      //          refreshTimer = nil
          }
 */
        }
    }


    
    
    
    required init(_ rows : Int, _ columns : Int) {
    
        self.rows = rows
        self.cols = columns
        self.grid = Grid(rows,cols)
        self.refreshTimer = Timer()
        
    }
    
    
    static var gridEngine = StandardEngine(10,10)
    
    func step() -> GridProtocol {
        let newGrid = grid.next()
        grid = newGrid
        delegate?.engineDidUpdate(withGrid : grid as! Grid)
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "GridUpdate")
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["standardEngine" : self])
        nc.post(n)
        
        
        return grid
        
    }
    
   
    
}
