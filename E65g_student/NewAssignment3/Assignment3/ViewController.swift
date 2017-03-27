//
//  ViewController.swift
//  Assignment3
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stepButton: UIButton!
    
   
    @IBOutlet weak var gridStoryboard: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func stepButtonAction(_ sender: Any) {
       gridStoryboard.theGrid = gridStoryboard.theGrid.next()
       gridStoryboard.setNeedsDisplay()
        
        
        
    }
    
}

