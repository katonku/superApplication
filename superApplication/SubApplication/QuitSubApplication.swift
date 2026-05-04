import Darwin

class QuitSubApplication: SubApplication {
    init() {
        super.init(runButton: "q",
                   menuDescription: "quit",
                   greeting: "Goodbye!")
    }
    
    override func run() {
        exit(0)
    }
}
