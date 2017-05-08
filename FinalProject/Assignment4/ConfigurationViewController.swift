//
//  ConfigurationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController,  GridViewDataSource, EngineDelegate
{
   
    
    @IBOutlet weak var configName: UITextField!
    
    var initialConfiguration : [GridPosition]?
    var configurationName: String = "New Value"
    //var  saveClosure: ((String) -> Void)?
    var saveClosure: ((String, [GridPosition]) -> Void)?
   
    @IBOutlet weak var gridView: GridView!
    
   
     var otherEngine : StandardEngine = StandardEngine(10,10)

    //var otherEngine = ConfigurationViewController.editorEngine
    var engine = StandardEngine.gridEngine

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
   
    }
   
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        
        otherEngine.cols = otherEngine.rows
        
        let size = otherEngine.rows
        
        otherEngine.grid.jsonConfig = initialConfiguration
        
        if initialConfiguration != nil {
            otherEngine.grid = Grid(size, size, cellInitializer: otherEngine.grid.jsonInitializer)
             configName.text = self.configurationName
        } else {
            otherEngine.grid = Grid(size, size)
            configName.text = self.configurationName
        }
        gridView.size = size
        
        otherEngine.delegate = self   //?
        
        self.gridView.setNeedsDisplay()
        
        gridView.theGrid = self   //?
       
        
    
        
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

    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
       
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "PushGrid")
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["standardEngine" : otherEngine])
        nc.post(n)
        
      
        
        
        let nc1 = NotificationCenter.default
        let name1 = Notification.Name(rawValue: "NextGridUpdate")    
        let n1 = Notification(name: name1,
                             object: nil,
                             userInfo: ["standardEngine" : self])
        nc1.post(n1)
        
        
      
        
        if let newValue = configName.text,  let saveClosure = saveClosure {
            
            let size = GridSize(otherEngine.rows, otherEngine.cols)
        
                saveClosure(newValue, lazyPositions(size).filter { return  self[$0.row, $0.col].isAlive })
            //self.navigationController?.popViewController(animated: true)
        }

      self.navigationController?.popViewController(animated: true)
    
        
    }
    
       
    
 

}

