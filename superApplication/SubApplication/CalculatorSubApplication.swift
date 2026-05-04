private protocol MathOperation {
    static var symbol: String { get }
    var symbol: String { get }
    
    func calculate(_ firstNumber: Int, _ secondNumber: Int) -> Int?
}

extension MathOperation {
    var symbol: String {
        Self.symbol
    }
}

class SumOperation: MathOperation {
    static let symbol: String = "+"
    
    func calculate(_ firstNumber: Int, _ secondNumber: Int) -> Int? {
        firstNumber + secondNumber
    }
}

class SubOperation: MathOperation {
    static let symbol: String = "-"
    
    func calculate(_ firstNumber: Int, _ secondNumber: Int) -> Int? {
        firstNumber - secondNumber
    }
}

class MultOperation: MathOperation {
    static let symbol: String = "*"
    
    func calculate(_ firstNumber: Int, _ secondNumber: Int) -> Int? {
        firstNumber * secondNumber
    }
}

class DivOperation: MathOperation {
    static let symbol: String = "/"
    
    func calculate(_ firstNumber: Int, _ secondNumber: Int) -> Int? {
        
        guard secondNumber != 0 else {
            print("Division by zero is forbidden")
            return nil
        }
        
        return firstNumber / secondNumber
    }
}

class CalculatorSubApplication: SubApplication {
    private var history = String()
    private let operations: [String: MathOperation] = [
        SumOperation.symbol: SumOperation(),
        SubOperation.symbol: SubOperation(),
        MultOperation.symbol: MultOperation(),
        DivOperation.symbol: DivOperation()
        ]
    
    init() {
        super.init(runButton: "c",
                   menuDescription: "open TinyCalculator",
                   greeting: "Welcome to TinyCalculator!")
    }
    
    override func execSubApplication() -> SubApplicationExecResult {
        let menu = """
            Input a command:
            с - Calculate
            h - History
            q - Quit
            """
        
        let comand = UserDataProvider.getString(menu)
        
        switch comand {
            case "c":
                calculate()
            case "h":
                showHistory()
            case "q":
                print("Goodbuy!")
                return .exit
            default:
             print("Wrong action")
        }
        
        return .resume
    }
    
    private func showHistory() {
        print("History:")
        guard !history.isEmpty else {
            print("There is no calculations in history")
            return
        }
        for expression in history {
            print(expression)
        }
    }

    private func calculate() {
        var selectionString = "Input operation: "
        for symbol in operations.keys.sorted() {
            selectionString += "\(symbol), "
        }

        let operationSymbol = UserDataProvider.getString(selectionString)
        guard let operation = operations[operationSymbol] else {
            print("Wrong operation")
            return
        }
        
        let firstNumber = UserDataProvider.getInt("Input first number")
        
        let secondNumber = UserDataProvider.getInt("Input second number")
        
        let expression = "\(firstNumber) \(operation.symbol) \(secondNumber)"
        print("Calculate " + expression)
        
        let result = operation.calculate(firstNumber, secondNumber)
        
        guard let result else {
            return
        }
        
        print("Result \(result)")
        history.append(expression + " = " + String(result))
    }
}
