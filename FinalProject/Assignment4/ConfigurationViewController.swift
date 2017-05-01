//
//  ConfigurationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController, EngineDelegate, GridViewDataSource {
    
    
    var initialConfiguration : [[Int]]?
    var  saveClosure: (([[Int]]) -> Void)?
    
    @IBOutlet weak var gridView: GridView!
     var engine = StandardEngine.gridEngine

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
   
    }
    
    
    func findMax()-> Int {
        let max1 = initialConfiguration?.max(by: { (a, b) -> Bool in
            return a.max()! < b.max()!
        })?.max()
        return max1!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        engine.rows = findMax() * 2
        let size = engine.rows
        
        Grid.jsonConfig = initialConfiguration
        
        
        engine.grid = Grid(size, size, cellInitializer: Grid.jsonInitializer)
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

    
    
       
    
 

}

