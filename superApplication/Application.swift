class Application {
    
    private let subApplications = [
        CalculatorSubApplication(),
        TicTacToeSubApplication(),
        QuitSubApplication()
    ]
    
    func run() {
        while true {
            let menu = createMenu()
            let command = UserDataProvider.getString(menu)
            for application in subApplications {
                if application.runButton == command {
                    application.run()
                    break
                }
            }
            print("-------------------")
        }

    }
    
    private func createMenu() -> String {
        var menu = "Input a command"
        for application in subApplications {
            menu += "\n\t\(application.runButton) - \(application.menuDescription)"
        }
        return menu
    }
    
    
}
