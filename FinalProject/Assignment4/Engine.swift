//
//  Engine.swift
//  Assignment4
//
//  Created by Ana Luisa Nystedt on 4/12/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import Foundation

enum sources { case file, json, none}
public protocol EngineDelegate {
    
    func engineDidUpdate(withGrid: Grid)
    
}


 protocol EngineProtocol {
    var delegate: EngineDelegate? { get set }
    var grid: GridProtocol { get set }
    var refreshRate : Double { get set }    
    var refreshTimer : Timer? { get set }
    var rows : Int { get set }
    var cols : Int { get set }
   
    var loadingFrom : sources { get set}
    var aliveCounter : Int { get set }
    var emptyCounter : Int { get set }
    var bornCounter : Int { get set }
    var diedCounter : Int { get set }
    
    init(_ rows : Int, _ columns : Int)
    func step() -> GridProtocol
    
    
}


