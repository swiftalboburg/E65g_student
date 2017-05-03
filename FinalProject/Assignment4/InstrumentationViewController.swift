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
    
    
    var engine = StandardEngine.gridEngine
    var jsonArray : NSArray?
    var jsonCoordinates : [[Int]]?
    
    var jsonDictionary = [String : [GridPosition]]() //as Dictionary?  //[String: [[Int]]]
    
    
    //var data : [String:[[Int]]] = [:]
    
    @IBOutlet weak var rowsStepper: UIStepper!
    
    @IBOutlet weak var rowsText: UITextField!
 
    @IBOutlet weak var refreshRate: UISlider!
      
    
    @IBOutlet weak var timedRefresh: UISwitch!
    
    
    @IBOutlet weak var tableViewOfConfigurations: UITableView!
    
    
    
    
    
    
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
        rowsStepper.value = 0
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
            //print(json)
            //let resultString = (json as AnyObject).description
            self.jsonArray = (json  as! NSArray)
            print(self.jsonArray!)
            for var i in (0..<self.jsonArray!.count) {
                print(self.jsonArray![0])
                let dict = (self.jsonArray![i] as! NSDictionary)
                
                let jsonTitle = dict["title"] as! String
                self.jsonCoordinates = dict["contents"] as? [[Int]]
                
                
                self.jsonDictionary[jsonTitle] =  self.jsonCoordinates.map { row in
                        row.map { col in
                        return GridPosition(col[0], col[1])
                    }
                }
                i += 1
                
            }
           
            //print (jsonTitle, jsonContents)
            print(self.jsonDictionary)
            OperationQueue.main.addOperation {
               
                self.tableViewOfConfigurations.reloadData()
            }
           
            
            
            
        }
      
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        
      
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
  
    
    
    @IBAction func refreshRateAction(_ sender: UISlider) {
      // engine.tempRate = Double(sender.value)
         engine.refreshRate = Double(sender.value)
      
    }
    
   
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.jsonDictionary.isEmpty == false) {
            return self.jsonDictionary.count
        } else {
           return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let identifier = "basicCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        
        if (self.jsonDictionary.isEmpty == false) {
            
            let dictKeyCopy = Array(self.jsonDictionary.keys)
            let keyName = dictKeyCopy[indexPath.row]
            
          
            label.text = keyName
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
    
    func findMax(of: [GridPosition])-> Int {
        print(of)
        let max1 = of.map{$0.row > $0.col ? $0.row : $0.col}
            .reduce(0) { $0 > $1 ? $0 : $1 }
        
        
        return max1
    }
    
  
    
    /*
    func switchKey(_ myDict:  Dictionary, fromKey: String, toKey: String) {
        if let entry = myDict.removeValue(forKey: fromKey) {
            myDict[toKey] = entry
        }
    }
 */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = tableViewOfConfigurations.indexPathForSelectedRow
        if let indexPath = indexPath {
          
            
            let cell = tableViewOfConfigurations.cellForRow(at: indexPath)
            let label = cell?.contentView.subviews.first as! UILabel
            let selectedValue = label.text
            
            if let vc = segue.destination as? ConfigurationViewController {
                vc.initialConfiguration = self.jsonDictionary[selectedValue!]
                vc.configurationName = selectedValue
                vc.otherEngine.rows = findMax(of: vc.initialConfiguration!) * 2
                
                vc.saveClosure = {newName, value in
                    
                 
                    //let dict = (self.jsonArray![indexPath.row] as! NSDictionary)
                    
                  
                   
                   // let jsonTitle = dict["title"]
                   // let value = self.jsonDictionary[selectedValue!]
                    self.jsonDictionary.remove(at: self.jsonDictionary.index(forKey: selectedValue!)!)
                    self.jsonDictionary[newName] = value
                   
                  
                    
                    
                    
                   // self.jsonDictionary?[name] = values
                    self.tableViewOfConfigurations.reloadData()
                    
                    
                }
            }
        }
    }
}
