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
    
   // enum sources { case file, json, none}
   // public var loadingFrom : sources = .none

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if engine.loadingFrom != .json {
            let defaults = UserDefaults.standard
            // Do any additional setup after loading the view, typically from a nib.
            engine.grid.configuration = (defaults.object(forKey: "simulationConfiguration") as? [String: [[Int]]]) ?? [:]
            print(engine.grid.configuration)
        
            if (engine.grid.configuration.isEmpty == false) {
                let savedSize = defaults.object(forKey: "size") as! Int
                engine.rows = savedSize
                engine.grid = Grid(savedSize, savedSize, cellInitializer: engine.grid.dictionaryInitializer)
                engine.loadingFrom = .file
            }
        }

   
    }
    
    
    @IBAction func SaveSimulation(_ sender: UIButton) {
        var configuration: [String:[[Int]]] = [:]
        
        configuration = engine.grid.setConfiguration()
        print(configuration)
        let defaults = UserDefaults.standard
        defaults.set(configuration, forKey: "simulationConfiguration")
        defaults.set(engine.rows, forKey: "size")

        
        
        

    }
    
    @IBAction func changedTimerSwitch(_ sender: UISwitch) {
        if (sender.isOn) {
           // engine.refreshRate = engine.tempRate
            if engine.refreshRate > 0.0 {
                engine.refreshTimer = Timer.scheduledTimer(
                    withTimeInterval: engine.refreshRate,
                    repeats: true
                ) { (t: Timer) in
                    self.engine.grid = self.engine.step()
                    let nc = NotificationCenter.default
                    let name = Notification.Name(rawValue: "NextGridUpdate")
                    let n = Notification(name: name,
                                         object: nil,
                                         userInfo: ["standardEngine" : self])
                    nc.post(n)
                    
                }
            }
            else {
                engine.refreshTimer?.invalidate()
                engine.refreshTimer = nil
            }
            

            
        } else {
             engine.refreshTimer?.invalidate()
             engine.refreshTimer = nil
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        
        
       let size = engine.rows
        
        if engine.loadingFrom == .none  {
            engine.grid = Grid(size, size)
        }
        if engine.loadingFrom == .json {
        
        }
      /*
         
       let emptyCount = lazyPositions(self.engine.grid.size)
            .filter( { return  self.engine.grid[$0.row, $0.col] == .empty })
            .count
        if (emptyCount == size * size) {   //Is empty
            engine.grid = Grid(size, size)
        }
 */
        gridView.size = size
        
        engine.delegate = self   //??
        
        self.gridView.setNeedsDisplay()
        
        gridView.theGrid = self       //?
        
        
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

