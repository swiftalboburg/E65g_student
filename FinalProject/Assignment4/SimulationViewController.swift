//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate, GridViewDataSource {
    
    
    @IBOutlet weak var timerSwitch: UISwitch!
    @IBOutlet weak var gridView: GridView!
     var engine = StandardEngine.gridEngine

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
   
    }
    
    @IBAction func changedTimerSwitch(_ sender: UISwitch) {
        if (sender.isOn) {
            engine.refreshRate = engine.tempRate
            
        } else {
             engine.refreshTimer?.invalidate()
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        
        timerSwitch.isOn = false
       let size = StandardEngine.gridEngine.rows
        
       let emptyCount = lazyPositions(self.engine.grid.size)
            .filter( { return  self.engine.grid[$0.row, $0.col] == .empty })
            .count
        if (emptyCount == size * size) {
            engine.grid = Grid(size, size)
        }
        
        gridView.size = size
        
        engine.delegate = self   //?????
        
        self.gridView.setNeedsDisplay()
        
        gridView.theGrid = self       //????
        
        
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) { (n) in
                self.gridView.setNeedsDisplay()
        }
        
    }
    
    public subscript (row: Int, col: Int) -> CellState {
        get { return engine.grid[row,col] }
        set { engine.grid[row,col] = newValue }
    }
    
    func engineDidUpdate(withGrid: Grid) {
        self.gridView.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func stepBtnAction(_ sender: Any) {
        
            engine.grid = engine.step()//engine.grid.next()
            gridView.setNeedsDisplay()
        
        
    }
    
  
    
    
 

}

