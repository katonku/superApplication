class CalculatorSubApplication: SubApplication {
    private var history = String()
    
    init() {
        super.init(runButton: "c",
                   menuDescription: "open TinyCalculator",
                   greeting: "Welcome to TinyCalculator!")
    }
    
    override func execSubApplication() -> SubApplicationExecResult {
        let menu = """
            Input a command:
            с - Calculate (+ - * /)
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
        let operation = UserDataProvider.getString("Input operation +, -, *, /")
        guard operation == "+" || operation == "-" || operation == "*" || operation == "/" else {
            print("Wrong operation")
            return
        }
        
        let firstNumber = UserDataProvider.getInt("Input first number")
        
        let secondNumber = UserDataProvider.getInt("Input second number")
        
        let expression = "\(firstNumber) \(operation) \(secondNumber)"
        print("Calculate " + expression)
        
        let result: Int
        switch operation {
        case "+":
            result = firstNumber + secondNumber
        case "-":
            result = firstNumber - secondNumber
        case "*":
            result = firstNumber * secondNumber
        case "/" where secondNumber == 0:
            print("Division by zero is forbidden")
            return
        case "/":
            result = firstNumber / secondNumber
        default:
            return
        }
        
        print("Result \(result)")
        history.append(expression + " = " + String(result))
    }
}
