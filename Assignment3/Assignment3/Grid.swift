//
//  Grid.swift Ana Nystedt
//
import Foundation
import UIKit 

public typealias Position = (row: Int, col: Int)
public typealias PositionSequence = [Position]

// Implement the wrap around rules
public func normalize(position: Position, to modulus: Position) -> Position {
    let modRows = modulus.row, modCols = modulus.col
    return Position(
        row: ((position.row % modRows) + modRows) % modRows,
        col: ((position.col % modCols) + modCols) % modCols
    )
}

// Provide a sequence of all positions in a range
public func positionSequence (from: Position, to: Position) -> PositionSequence {
    return (from.row ..< to.row)
        .map { row in zip( [Int](repeating: row, count: to.col - from.col), from.col ..< to.col ) }
        .flatMap { $0 }
}

/*
I assigned the explicit values, even though it is not necessary since the names are the same -  following the assignment instructions
 */
public enum CellState : String {
    case alive = "alive"
    case empty = "empty"
    case born = "born"
    case died = "died"
    

    public var isAlive: Bool {
        switch self {
        case .alive, .born: return true
        default: return false
        }
    }
    
/*
I used the switch statement following the assignment instructions (to get the points ;) I don't see the need in this case, since we are returning the rawValue.  I hope I did not misundersand the instructions.  
*/
    public func description() -> String {  
        switch self {
        case .alive:
            return rawValue
        case .empty:
            return rawValue
        case .born:
            return rawValue
        case .died:
            return rawValue
            
        }
 
 
    }
    
    
    
    public func allValues() -> [String] {
        return ["alive","empty","born","died"]
    }
    
    public func toggle(_ value:CellState)-> CellState {
        switch value {
        case .empty,  .died:
            return .alive
        case .alive, .born:
            return .empty
        }
    }
}


public struct Cell {
    var position = Position(row:0, col:0)
    var state = CellState.empty
}

public struct Grid {
    private var _cells: [[Cell]]
    fileprivate var modulus: Position { return Position(_cells.count, _cells[0].count) }
    
    // Get and Set cell states by position
    public subscript (pos: Position) -> CellState {
        get { let pos = normalize(position: pos, to: modulus); return _cells[pos.row][pos.col].state }
        set { let pos = normalize(position: pos, to: modulus); _cells[pos.row][pos.col].state = newValue }
    }
    
    // Allow access to the sequence of positions
    public let positions: PositionSequence
    
    // Initialize _cells and positions
    public init(_ rows: Int, _ cols: Int, cellInitializer: (Position) -> CellState = { _, _ in .empty } ) {
        _cells = [[Cell]]( repeatElement( [Cell](repeatElement(Cell(), count: rows)), count: cols) )
        positions = positionSequence(from: Position(0,0), to: Position(rows, cols))
        positions.forEach { _cells[$0.row][$0.col].position = $0; self[$0] = cellInitializer($0) }
    }
    
    private static let offsets: [Position] = [
        (row: -1, col:  -1), (row: -1, col:  0), (row: -1, col:  1),
        (row:  0, col:  -1),                     (row:  0, col:  1),
        (row:  1, col:  -1), (row:  1, col:  0), (row:  1, col:  1)
    ]
    private func neighbors(of position: Position) -> [CellState] {
        return Grid.offsets.map {
            let neighbor = normalize(position: Position(
                row: (position.row + $0.row),
                col: (position.col + $0.col)
            ), to: modulus)
            return self[neighbor]
        }
    }
    
    private func nextState(of position: Position) -> CellState {
        switch neighbors(of: position).filter({ $0.isAlive }).count {
        case 2 where self[position].isAlive,
             3: return self[position].isAlive ? .alive : .born
        default: return self[position].isAlive ? .died  : .empty
        }
    }
    
    // Generate the next state of the grid
    public func next() -> Grid {
        var nextGrid = Grid(modulus.row, modulus.col)
        positions.forEach { nextGrid[$0] = self.nextState(of: $0) }
        return nextGrid
    }
}

public extension Grid {
    public var description: String {
        return positions
            .map { (self[$0].isAlive ? "*" : " ") + ($0.1 == self.modulus.col - 1 ? "\n" : "") }
            .joined()
    }
    public var living: [Position] { return positions.filter { return  self[$0].isAlive   } }
    public var dead  : [Position] { return positions.filter { return !self[$0].isAlive   } }
    public var alive : [Position] { return positions.filter { return  self[$0] == .alive } }
    public var born  : [Position] { return positions.filter { return  self[$0] == .born  } }
    public var died  : [Position] { return positions.filter { return  self[$0] == .died  } }
    public var empty : [Position] { return positions.filter { return  self[$0] == .empty } }
}

extension Grid: Sequence {
    public struct SimpleGridIterator: IteratorProtocol {
        private var grid: Grid
        
        public init(grid: Grid) {
            self.grid = grid
        }
        
        public mutating func next() -> Grid? {
            grid = grid.next()
            return grid
        }
    }
    
    public struct HistoricGridIterator: IteratorProtocol {
        private class GridHistory: Equatable {
            let positions: [Position]
            let previous:  GridHistory?
            
            static func == (lhs: GridHistory, rhs: GridHistory) -> Bool {
                return lhs.positions.elementsEqual(rhs.positions, by: ==)
            }
            
            init(_ positions: [Position], _ previous: GridHistory? = nil) {
                self.positions = positions
                self.previous = previous
            }
            
            var hasCycle: Bool {
                var prev = previous
                while prev != nil {
                    if self == prev { return true }
                    prev = prev!.previous
                }
                return false
            }
        }
        
        private var grid: Grid
        private var history: GridHistory!
        
        init(grid: Grid) {
            self.grid = grid
            self.history = GridHistory(grid.living)
        }
        
        public mutating func next() -> Grid? {
            if history.hasCycle { return nil }
            let newGrid = grid.next()
            history = GridHistory(newGrid.living, history)
            grid = newGrid
            return grid
        }
    }
    
    public func makeIterator() -> HistoricGridIterator {
        return HistoricGridIterator(grid: self)
    }
}

func gliderInitializer(row: Int, col: Int) -> CellState {
    switch (row, col) {
    case (0, 1), (1, 2), (2, 0), (2, 1), (2, 2): return .alive
    default: return .empty
    }
}



@IBDesignable class GridView: UIView {
    var theGrid = Grid(0,0)
    
    
    @IBInspectable var livingColor : UIColor  = UIColor.blue
    
    @IBInspectable var emptyColor : UIColor = UIColor.white
    
    @IBInspectable var bornColor : UIColor = UIColor.green
    
    @IBInspectable var diedColor : UIColor = UIColor.black
    
    @IBInspectable var gridColor : UIColor = UIColor.gray
    
    @IBInspectable var gridWidth : CGFloat = 0.0

    @IBInspectable var size : Int = 20 {
        didSet{
            theGrid = Grid(size, size)
        }
    }
    
    override func draw(_ rect: CGRect) {
        let boardSize = CGSize(
            width: rect.size.width/CGFloat(size),
            height: rect.size.height/CGFloat(size)
        )
        let base = rect.origin
        (0 ..< size).forEach { i in
            (0 ..< size).forEach { j in
                let origin = CGPoint(
                    x: base.x + (CGFloat(j) * boardSize.width),
                    y: base.y + (CGFloat(i) * boardSize.height)
                )
                let subRect = CGRect(
                    origin: origin,
                    size: boardSize
                )
                let path = UIBezierPath(ovalIn: subRect)
               
                
                theGrid[Position(i,j)].isAlive ? livingColor.setFill() : emptyColor.setFill()
                
                path.fill()
            }
        }
        

        //create the path
        (0 ..< size+1 ).forEach {
            drawLine(
                start: CGPoint(x: CGFloat($0)/CGFloat(size) * rect.size.width, y: 0.0),
                end:   CGPoint(x: CGFloat($0)/CGFloat(size) * rect.size.width, y: rect.size.height)
            )
            
            drawLine(
                start: CGPoint(x: 0.0, y: CGFloat($0)/CGFloat(size) * rect.size.height ),
                end: CGPoint(x: rect.size.width, y: CGFloat($0)/CGFloat(size) * rect.size.height)
            )
        }
    }
    
    
    
    func drawLine(start:CGPoint, end: CGPoint) {
        let path = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        path.lineWidth = gridWidth
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        path.move(to: start)
        
        //add a point to the path at the end of the stroke
        path.addLine(to: end)
        
        //draw the stroke
        gridColor.setStroke()
        path.stroke()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = nil
    }
    
    // Updated since class
    typealias Position = (row: Int, col: Int)
    var lastTouchedPosition: Position?
    
    func process(touches: Set<UITouch>) -> Position? {
        guard touches.count == 1 else { return nil }
        let pos = convert(touch: touches.first!)
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        
        theGrid[pos] = theGrid[pos].toggle(theGrid[pos])
       // print(theGrid[pos].description())
        setNeedsDisplay()
        return pos
    }
    
    func convert(touch: UITouch) -> Position {
        let touchY = touch.location(in: self).y
        let gridHeight = frame.size.height
        let row = touchY / gridHeight * CGFloat(size)
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let col = touchX / gridWidth * CGFloat(size)
        let position = (row: Int(row), col: Int(col))
        return position
    }
    
    
    
    
}






