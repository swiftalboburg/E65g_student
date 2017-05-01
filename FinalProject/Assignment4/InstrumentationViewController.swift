//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

let finalProjectURL = "https://dl.dropboxusercontent.com/u/7544475/S65g.json"
//UITextFieldDelegate,

class InstrumentationViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var rowsStepper: UIStepper!
    
    @IBOutlet weak var rowsText: UITextField!
 
    @IBOutlet weak var refreshRate: UISlider!
    
    @IBOutlet weak var timedRefresh: UISwitch!
    
    
    @IBOutlet weak var tableViewOfConfigurations: UITableView!
    
    
    
    var engine = StandardEngine.gridEngine
    var jsonArray : NSArray?
    var jsonDictionary = [String: [[Int]]]() as Dictionary?  //[String: [[Int]]]
    
    
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
        rowsStepper.value = 1
        rowsText.text = String(Int(rowsStepper.value))
        
        let fetcher = Fetcher()
        fetcher.fetchJSON(url: URL(string:finalProjectURL)!) { (json: Any?, message: String?) in
            guard message == nil else {
                print(message ?? "nil")
                return
            }
            guard let json = json else {
                print("no json")
                return
            }
            print(json)
            //let resultString = (json as AnyObject).description
            self.jsonArray = (json as! NSArray)
            //print(self.jsonArray!)
            for var i in (0..<self.jsonArray!.count) {
                let dict = (self.jsonArray![i] as! NSDictionary)
                
                let jsonTitle = dict["title"] as! String
                let jsonContents = dict["contents"] as! [[Int]]
               
                self.jsonDictionary?[jsonTitle] = jsonContents
                i += 1
                
            }
            //let jsonTitle = self.jsonDictionary?["title"] as! String
            //let jsonContents = self.jsonDictionary?["contents"] as! [[Int]]
            //print (jsonTitle, jsonContents)
            print(self.jsonDictionary!)
            OperationQueue.main.addOperation {
               
                self.tableViewOfConfigurations.reloadData()
            }
           
            
            
            
        }
      
        
        
        
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
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.jsonDictionary != nil) {
            return self.jsonDictionary!.count
        } else {
           return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let identifier = "basicCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        
        if (self.jsonDictionary != nil) {
            let dict1 = (self.jsonArray![indexPath.item] as! NSDictionary)
            
          
            label.text = dict1["title"] as? String
            OperationQueue.main.addOperation {
                
                self.tableViewOfConfigurations.reloadData()
            }
            
        }
        return cell
        
       
    }
 
 /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
 */
   
 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
        
    }
    
    
  /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        if let indexPath = indexPath {
            let fruitValue = data[indexPath.section][indexPath.row]
            if let vc = segue.destination as? GridEditorViewController {
                vc.fruitValue = fruitValue
                vc.saveClosure = { newValue in
                    data[indexPath.section][indexPath.row] = newValue
                    self.tableView.reloadData()
                }
            }
        }
        
   */
}
