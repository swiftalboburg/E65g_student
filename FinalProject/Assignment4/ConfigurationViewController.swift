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
   
    
    @IBOutlet weak var configName: UITextField!
    
    var initialConfiguration : [GridPosition]?
    var configurationName: String?
    var  saveClosure: ((String, ([GridPosition])) -> Void)?
    
   
    @IBOutlet weak var gridView: GridView!
    
    static var editorEngine =  StandardEngine(10,10)
    var otherEngine = ConfigurationViewController.editorEngine
    var engine = StandardEngine.gridEngine

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
   
    }
   
    
   // var jsonInitializer : ((GridPosition) -> CellState)?
    /*{
    
        if (jsonConfig?.contains(where: { $0 == pos} ) )!{
            return .alive
        } else {
            return .empty
        }
        
    }
    
    }
    
    */
    
    override func viewWillAppear(_ animated: Bool) {
        
        otherEngine.cols = otherEngine.rows
        let size = otherEngine.rows
        
        otherEngine.grid.jsonConfig = initialConfiguration
        
        
        otherEngine.grid = Grid(size, size, cellInitializer: Grid.jsonInitializer)
        gridView.size = size
     //   engine.delegate = self   //?
        
        self.gridView.setNeedsDisplay()
        
        gridView.theGrid = self   //?
        configName.text = self.configurationName!
        
    
        
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
        engine.cols = otherEngine.cols
        engine.rows = otherEngine.rows
        engine.grid = otherEngine.grid
        
        
        if let newValue = configName.text,
            let saveClosure = saveClosure {
            saveClosure(newValue, otherEngine.grid as! ([GridPosition]))
            self.navigationController?.popViewController(animated: true)
        }

        
       
        
    }
    
       
    
 

}

