//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      /*  gridEngine.refreshTimer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true
        ) { (t: Timer) in
            self.grid = self.gridView.grid as! Grid
            self.grid = self.grid.next()
            self.gridView.grid = self.grid
            self.gridView.setNeedsDisplay()
        }
 */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func stepButtonAction(_ sender: Any) {
        
        
    }

}

