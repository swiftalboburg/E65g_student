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
    
    var engine = StandardEngine.gridEngine
    
   
    
    
    @IBAction func sizeStepper(_ sender: UIStepper) {
        // engine.refreshTimer?.invalidate()
        // engine.refreshTimer = nil
        engine.rows = Int(sender.value)
        engine.cols = Int(sender.value)
        
        engine.grid = Grid(engine.rows, engine.rows)
        //gridView.setNeedsDisplay()
        rowsText.text = "\(Int(rowsStepper.value))"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        rowsStepper.value = 10
        rowsText.text = String(Int(rowsStepper.value))
        
    }

    override func viewWillAppear(_ animated: Bool) {
        timedRefresh.isOn = false
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    @IBAction func refreshRateAction(_ sender: UISlider) {
       //engine.refreshRate = Double(sender.value)
       /* Note: I could not update it here because when I used the tab controller to switch to the Simulation tab the UISlider resets itseft to the initial value.  I used the switch event to capture the slider value
     */
    }
    
    @IBAction func timedRefreshSwitchAction(_ sender: Any) {
        
        if (timedRefresh.isOn) {
            //refreshRate.isEnabled = true
            engine.tempRate = Double(refreshRate.value)
            
            }
        else {
            engine.tempRate = 0.0
            //refreshRate.isEnabled = false
        }
        
    }
   
    
   }

