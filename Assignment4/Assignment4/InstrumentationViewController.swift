//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit




class InstrumentationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var rowsStepper: UIStepper!
    
    
    @IBOutlet weak var ColsStepper: UIStepper!
    
    
    @IBOutlet weak var rowsText: UITextField!

    @IBOutlet weak var colsText: UITextField!
 
    @IBOutlet weak var refreshRate: UISlider!
    
    
    
    @IBOutlet weak var timedRefresh: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        rowsText.text = String(rowsStepper.value)
        colsText.text = String(ColsStepper.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func rowsStepperAction(_ sender: Any) {
       // engine.refreshTimer?.invalidate()
       // engine.refreshTimer = nil
      /*  engine.grid.size = Int(sender.value)
        engine.grid = Grid(GridSize(rows: engine.grid.size, cols: engine.grid.size))
        //gridView.setNeedsDisplay()
      */
        rowsText.text = "\(Int(rowsStepper.value))"
        
        
    }
    
    @IBAction func timedRefreshSwitchAction(_ sender: Any) {
        
        if (timedRefresh.isOn) {
            
        }
    }
    
   
    
    
    @IBAction func colsStepperAction1(_ sender: Any) {
        
        rowsText.text = "\(Int(ColsStepper.value))"
       
        
    }
   
    
   }

