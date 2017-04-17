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
    
    var aliveCounter = 0
    var emptyCounter = 0
    var bornCounter = 0
    var diedCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //aliveTextField.text = String(aliveCounter)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "GridUpdate")
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) { n in
                print("observer")
             
                
                self.aliveCounter = lazyPositions(self.engine.grid.size)
                 .filter( { return  self.engine.grid[$0.row, $0.col] == .alive })
                 .count
                
                self.emptyCounter = lazyPositions(self.engine.grid.size)
                    .filter( { return  self.engine.grid[$0.row, $0.col] == .empty })
                    .count
                self.bornCounter = lazyPositions(self.engine.grid.size)
                    .filter( { return  self.engine.grid[$0.row, $0.col] == .born })
                    .count
                self.diedCounter = lazyPositions(self.engine.grid.size)
                    .filter( { return  self.engine.grid[$0.row, $0.col] == .died })
                    .count
                
                
                /* lazyPositions(self.engine.grid.size).forEach {
                 switch self.engine.grid[$0.row, $0.col] {
                 case .alive: aliveCounter += 1
                 case .empty : emptyCounter += 1
                 case .born : bornCounter += 1
                 case .died : diedCounter += 1
                 }
                 */
            self.aliveTextField.text = String(self.aliveCounter)
            self.emptyTextField.text = String(self.emptyCounter)
            self.bornTextField.text = String(self.bornCounter)
            self.diedTextField.text = String(self.diedCounter)

                
        }
        
              
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
