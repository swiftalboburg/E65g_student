//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by Ana Luisa Nystedt on 4/11/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    var engine = StandardEngine.gridEngine
    
    
    
    @IBOutlet weak var bornTextField: UITextField!
    
    
    @IBOutlet weak var aliveTextField: UITextField!
    
    @IBOutlet weak var emptyTextField: UITextField!
    
    
    @IBOutlet weak var diedTextField: UITextField!
  
    
    func refreshStatistics()   {
        engine.aliveCounter = engine.aliveCounter + lazyPositions(self.engine.grid.size)
            .filter( { return  self.engine.grid[$0.row, $0.col] == .alive })
            .count
        
        engine.emptyCounter = engine.emptyCounter + lazyPositions(self.engine.grid.size)
            .filter( { return  self.engine.grid[$0.row, $0.col] == .empty })
            .count
        engine.bornCounter = engine.bornCounter + lazyPositions(self.engine.grid.size)
            .filter( { return  self.engine.grid[$0.row, $0.col] == .born })
            .count
        engine.diedCounter = engine.diedCounter + lazyPositions(self.engine.grid.size)
            .filter( { return  self.engine.grid[$0.row, $0.col] == .died })
            .count
        
        
        self.aliveTextField.text = String(engine.aliveCounter)
        self.emptyTextField.text = String(engine.emptyCounter)
        self.bornTextField.text = String(engine.bornCounter)
        self.diedTextField.text = String(engine.diedCounter)
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        refreshStatistics()
        
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "NextGridUpdate")
        nc.addObserver(
            forName: name,
            object: nil,
            queue : OperationQueue.main) { n in
                //queue: nil) { n in
                
                print("observer")
                
                
                print( self.engine.aliveCounter)
                print (lazyPositions(self.engine.grid.size)
                    .filter( { return  self.engine.grid[$0.row, $0.col] == .alive })
                    .count)
                
                self.refreshStatistics()
                
                
                
        }

        
        //aliveTextField.text = String(aliveCounter)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
    
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
