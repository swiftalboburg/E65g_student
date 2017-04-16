//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate, GridViewDataSource {
    
    @IBOutlet weak var gridView: GridView!
     var engine = StandardEngine.gridEngine

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let size = StandardEngine.gridEngine.rows
        
        engine.grid = Grid(size, size)
        gridView.size = size
        engine.delegate = self   //?????
        
        self.gridView.setNeedsDisplay()
        
        gridView.theGrid = self   //????
       
        
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
        if engine.tempRate > 0 {
            engine.refreshRate = engine.tempRate
        } else {
            engine.grid = engine.grid.next()
            gridView.setNeedsDisplay()
        }
        
    }
    
  
    @IBAction func stopButton(_ sender: UIButton) {
        engine.tempRate = 0
        engine.refreshRate = 0
    }
    
    
 

}

