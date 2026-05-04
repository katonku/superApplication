class TicTacToeSubApplication: SubApplication {
    private var field = PlayField(size: 0)
    
    init() {
        super.init(runButton: "ttt",
                   menuDescription: "open TicTacToe",
                   greeting: "Welcome to TicTacToe!")
    }
    
    override func execSubApplication() -> SubApplicationExecResult {
        let nameOne = getUserNickName("Input player 1 nickname")
        let playerOne = Player(name: nameOne, sign: Symbols.x)
        
        let nameTwo = getUserNickName("Input player 2 nickname")
        let playerTwo = Player(name: nameTwo, sign: Symbols.o)
        
        let fieldSize = getFieldSize()
        field = PlayField(size: fieldSize)
        
        field.printToConsole()
        
        print(
            """
            Let's play begines!
            -------------------
            """)
        
        while true {
            makeStep(playerOne)
            field.printToConsole()
            if field.isWin() {
                print("\(playerOne.name) is a WINNER")
                break
            }
            if field.isGameFinished {
                print("The game is over")
                break
            }
            makeStep(playerTwo)
            field.printToConsole()
            if field.isWin() {
                print("\(playerTwo.name) is a WINNER")
                break
            }
            if field.isGameFinished {
                print("The game is over")
                break
            }
        }
        
        let newGameChoose = UserDataProvider.getString("Intup 'y' for new game")
        return newGameChoose == "y" ? .resume : .exit
    }
    
    func getUserNickName(_ description: String) -> String {
        var name = String()
        while name.isEmpty {
            name = UserDataProvider.getString(description)
            guard !name.isEmpty else {
                print("Nickname can not be empty")
                continue
            }
        }
        return name
    }
    
    func getFieldSize() -> Int {
        while true {
            let minSize = 2
            let maxSize = 6
            let size = UserDataProvider.getInt("Enter playfield size in \(minSize) and \(maxSize):")
            guard size >= minSize && size <= maxSize
            else {
                print("Size is incorrect. Try again.")
                continue
            }
            return size
        }
    }
    
    private func makeStep(_ player: Player) {
        while true {
            print("\(player.name), your turn!")
            let line = UserDataProvider.getInt("Intup line number")
            let column = UserDataProvider.getInt("Intup column number")
            let result = field.set(symbol: player.sign, line: line, column: column)
            
            switch result {
            case .wrongLine:
                print("Wrong line numebr. Try in 1 and \(field.size)")
                continue
            case .wrongColumn:
                print("Wrong column number. Try in 1 and \(field.size)")
                continue
            case .cellIsNotEpmty:
                print("The cell is not empty. Try another cell")
                continue
            case .success:
                return
            }
        }
    }
}

enum Symbols: String {
    case empty = " "
    case x = "X"
    case o = "O"
}

enum SetFieldValueResult {
    case wrongLine
    case wrongColumn
    case cellIsNotEpmty
    case success
}

private struct Player {
    let name: String
    let sign: Symbols
}

private struct PlayField {
    private var field: [[Symbols]]
    var size: Int { get { field.count } }
    
    var isGameFinished: Bool {
        for i in 0..<field.count {
            for j in 0..<field.count {
                if field[i][j] == .empty {
                    return false
                }
            }
        }
        return true
    }
    
    init(size: Int) {
        field = [[Symbols]]()
        for _ in 0..<size {
            var line: [Symbols] = []
            for _ in 0..<size {
                line.append(.empty)
            }
            field.append(line)
        }
    }
    
    func printToConsole() {
        print("Now the playfield is like that: ")
        for i in 0...(field.count * 2  + 1) {
            let isEvenLine = i % 2 == 0 ? true : false
            for j in 0...(field.count * 2 + 1) {
                let isEvenElement = j % 2 == 0 ? true : false
                let havePrintRowNumber = i == 0 && isEvenElement
                let havePrintLineNumber = j == 0 && i > 0 && isEvenLine
                let lineArrayIndex = i / 2 - 1
                let rowArrayIndex = j / 2 - 1
                if isEvenLine {
                    if havePrintRowNumber {
                        print(j / 2, terminator: "")
                    } else if havePrintLineNumber {
                        print(i / 2, terminator: "")
                    } else if isEvenElement {
                        print(field[lineArrayIndex][rowArrayIndex].rawValue, terminator: "")
                    } else {
                        print("|", terminator: "")
                    }
                } else {
                    print("-", terminator: "")
                }
            }
            print("\n", terminator: "")
        }
    }

    subscript(line: Int, column: Int) -> Symbols? {
        guard line > 0, line < field.count,
              column > 0, column < field.count
        else { return nil }
        
        let lineIndex = line - 1
        let columnIndex = line - 1
        
        return field[lineIndex][columnIndex]
    }
    
    mutating func set(symbol: Symbols, line: Int, column: Int) -> SetFieldValueResult {
        guard line > 0, line <= field.count else { return .wrongLine }
        guard column > 0, column <= field.count else { return .wrongColumn }
        let lineIndex = line - 1
        let columnIndex = column - 1
        
        guard field[lineIndex][columnIndex] == .empty else {
            return .cellIsNotEpmty
        }
        
        field[lineIndex][columnIndex] = symbol
        return .success
    }

    private func isWinOnRow() -> Bool {
        for i in 0..<field.count {
            let firstSymbol = field[i][0]
            if firstSymbol != .empty {
                for j in 1..<field.count {
                    if field[i][j] != firstSymbol {
                        return false
                    }
                }
                return true
            }
        }
        return false
    }

    private func isWinOnColumn() -> Bool {
        for i in 0..<field.count {
            let firstSymbol = field[i][0]
            if firstSymbol != .empty {
                for j in 1..<field.count {
                    if field[j][i] != firstSymbol {
                        return false
                    }
                }
                return true
            }
        }
        return false
    }

    private func isWinOnMainDiagonal() -> Bool {
        let firstSymbol = field[0][0]
        if firstSymbol != .empty {
            for i in 1..<field.count {
                if field[i][i] != firstSymbol {
                    return false
                }
            }
            return true
        }
        return false
    }

    private func isWinOnSubDiagonal() -> Bool {
        let firstSymbol = field[0][field.count - 1]
        if firstSymbol != .empty {
            for i in 1..<field.count {
                if field[i][field.count - i - 1] != firstSymbol {
                    return false
                }
            }
            return true
        }
        return false
    }

    func isWin() -> Bool {
        return isWinOnRow()
        || isWinOnColumn()
        || isWinOnMainDiagonal()
        || isWinOnSubDiagonal()
    }
}
