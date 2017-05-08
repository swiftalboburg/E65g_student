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

    @IBAction func resetButton(_ sender: UIButton) {
        engine.cols = engine.rows
        engine.grid = Grid(engine.rows, engine.cols)
        engine.aliveCounter = 0
        engine.emptyCounter = 0
        engine.bornCounter = 0
        engine.diedCounter = 0
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "NextGridUpdate")
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["standardEngine" : self])
        nc.post(n)
        self.gridView.setNeedsDisplay()
        

    }
    
    func catchNotification(notification:Notification) -> Void {
       let pushedEngine = notification.userInfo?["standardEngine"] as! StandardEngine
        engine.rows = pushedEngine.rows
        engine.cols = engine.rows
        engine.grid = pushedEngine.grid
        engine.loadingFrom = .json
        engine.aliveCounter = 0
        engine.emptyCounter = 0
        engine.bornCounter = 0
        engine.diedCounter = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
       
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "PushGrid")
        nc.addObserver(
            forName: name,
            object: nil,
            queue : nil,
            using : catchNotification)
        
        
        
        if engine.loadingFrom != .json {
            let defaults = UserDefaults.standard
            // Do any additional setup after loading the view, typically from a nib.
            engine.grid.configuration = (defaults.object(forKey: "simulationConfiguration") as? [String: [[Int]]]) ?? [:]
            print(engine.grid.configuration)
            let savedSize = (defaults.object(forKey: "size") as! Int)
            
            engine.rows = savedSize
            
            engine.loadingFrom = .file
            
            if (engine.grid.configuration.isEmpty == false) {
               // defaults.removeObject(forKey:"size")
               // let savedSize = (defaults.object(forKey: "size") as! Int)
               // let savedSize = 114
               // engine.rows = savedSize
                
                engine.grid = Grid(savedSize, savedSize, cellInitializer: engine.grid.dictionaryInitializer)
                //engine.loadingFrom = .file
            } else {
                 engine.grid = Grid(savedSize, savedSize)
                
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

