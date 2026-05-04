class UserDataProvider {
    static func getString(_ description: String) -> String {
        while true {
            print(description)
            if let line = readLine() {
                return line
            } else {
                continue
            }
        }

    }

    static func getInt(_ description: String) -> Int {
        while true {
            print(description)
            guard let input = readLine(), let number = Int(input) else {
                print("This is not a number. Try again")
                continue
            }
            return number
        }
    }
    
    static func getDouble(_ description: String) -> Double {
        while true {
            print(description)
            guard let input = readLine(), let number = Double(input) else {
                print("This is not a number. Try again")
                continue
            }
            return number
        }
    }
}
