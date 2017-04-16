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
    
    @IBOutlet weak var rowsText: UITextField!
 
    @IBOutlet weak var refreshRate: UISlider!
    
    @IBOutlet weak var timedRefresh: UISwitch!
    
   // var engine : StandardEngine!
    
   
    
    
    @IBAction func sizeStepper(_ sender: UIStepper) {
        // engine.refreshTimer?.invalidate()
        // engine.refreshTimer = nil
        StandardEngine.gridEngine.rows = Int(sender.value)
        StandardEngine.gridEngine.cols = Int(sender.value)
        
        StandardEngine.gridEngine.grid = Grid(StandardEngine.gridEngine.rows, StandardEngine.gridEngine.rows)
        //gridView.setNeedsDisplay()
        rowsText.text = "\(Int(rowsStepper.value))"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        rowsStepper.value = 10
        rowsText.text = String(Int(rowsStepper.value))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    
    @IBAction func timedRefreshSwitchAction(_ sender: Any) {
        
        if (timedRefresh.isOn) {
           refreshRate.isEnabled = true
            }
        else {
            refreshRate.isEnabled = false
        }
        
    }
    
   
    
    

   
    
   }

