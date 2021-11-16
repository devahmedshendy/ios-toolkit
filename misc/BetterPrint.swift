/*
 * This a functions shadowing the Swift.print function for better logging
 * 
 * source: https://stackoverflow.com/a/59576554/4538920
 */

public func print(_ items: String..., filename: String = #file, function : String = #function, line: Int = #line, separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        let pretty = "\(URL(fileURLWithPath: filename).lastPathComponent) [#\(line)] \(function)\n\t-> "
        let output = items.map { "\($0)" }.joined(separator: separator)
        Swift.print(pretty+output, terminator: terminator)
    
    #else
        Swift.print("RELEASE MODE")
    #endif
}

// Support dictionary and array printing
public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        let output = items.map { "\($0)" }.joined(separator: separator)
        Swift.print(output, terminator: terminator)
    
    #else
        Swift.print("RELEASE MODE")
    #endif
}