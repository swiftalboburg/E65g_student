//
//  ConfigurationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController,  GridViewDataSource //EngineDelegate,
{
   
    
    
    var initialConfiguration : [[Int]]?
    var  saveClosure: (([[Int]]) -> Void)?
    
   
    @IBOutlet weak var gridView: GridView!
    
    var otherEngine =  StandardEngine(10,10)
    var engine = StandardEngine.gridEngine

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
   
    }
    
    @IBAction func saveConfigToSimulator(_ sender: Any) {
        engine.cols = otherEngine.cols
        engine.rows = otherEngine.rows
        engine.grid = otherEngine.grid
        
        engine.wasGridEdited = true
        
    }
    func findMax()-> Int {
        let max1 = initialConfiguration?.max(by: { (a, b) -> Bool in
            return a.max()! < b.max()!
        })?.max()
        return max1!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        otherEngine.rows = findMax() * 2
        otherEngine.cols = findMax() * 2
        let size = otherEngine.rows
        
        Grid.jsonConfig = initialConfiguration
        
        
        otherEngine.grid = Grid(size, size, cellInitializer: Grid.jsonInitializer)
        gridView.size = size
     //   engine.delegate = self   //?????
        
        self.gridView.setNeedsDisplay()
        
        gridView.theGrid = self   //????
        
        
        /*let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) { (n) in
                self.gridView.setNeedsDisplay()
        }
 */
        
    }
    
    public subscript (row: Int, col: Int) -> CellState {
        get { return otherEngine.grid[row,col] }
        set { otherEngine.grid[row,col] = newValue }
    }
    
    func engineDidUpdate(withGrid: Grid) {
        self.gridView.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
       
    
 

}

