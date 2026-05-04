enum SubApplicationExecResult {
    case exit
    case resume
}

class SubApplication {
    let runButton: String
    let menuDescription: String
    let greeting: String
    
    init(runButton: String, menuDescription: String, greeting: String) {
        self.runButton = runButton
        self.menuDescription = menuDescription
        self.greeting = greeting
    }
    
    func run() {
        print("----------------------")
        print(greeting)
        while true {
            let result = execSubApplication()
            if result == .exit {
                return
            }
            print("----------------------")
        }
    }
    
    func execSubApplication() -> SubApplicationExecResult {
        .resume
    }
}
