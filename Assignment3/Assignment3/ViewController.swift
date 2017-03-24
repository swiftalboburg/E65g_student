//
//  ViewController.swift
//  Assignment3
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBDesignable
    class GridView: UIView {
        var theGrid = Grid(0,0)
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @IBInspectable var size : Int = 20 {
            didSet{
                theGrid = Grid(size, size)
            }
        }
        
        @IBInspectable var livingColor : UIColor  = UIColor.blue
        
        @IBInspectable var emptyColor : UIColor = UIColor.white
        
        @IBInspectable var bornColor : UIColor = UIColor.green
        
        @IBInspectable var diedColor : UIColor = UIColor.black
        
        @IBInspectable var gridColor : UIColor = UIColor.gray
        
        @IBInspectable var gridWidth : CGFloat = 0.0
        
        init() {
            super.init(frame: .zero)
        }
        
    }
    
    var oneGridView = GridView()
    
    oneGridView.livingColor = UIColor.green
    oneGridView.bornColor = UIColor.green.withAlphaComponent(0.6)
    
    oneGridView.emptyColor = UIColor.darkGray
    oneGridView.diedColor = UIColor.darkGray.withAlphaComponent(0.6)
    oneGridView.gridColor = UIColor.black
    oneGridView.gridWidth = 2.0
}

