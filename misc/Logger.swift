import Foundation

// MARK: - Debug Prints

#if DEBUG
@inline(__always) func printDebug(_ error: Error) {
    let e = error as NSError
    log(.debug, e.debugDescription)
}
#else
@inline(__always) func printDebug(_ error: Error) {}
#endif

#if DEBUG
@inline(__always) func printDebug(_ object: Any...) {
    log(.debug, object)
}
#else
@inline(__always) func printDebug(_ object: Any...) {}
#endif

// MARK: - Error Prints

func printError(_ error: Error) {
    let e = error as NSError
    log(.error, e.debugDescription)
}

func printError(_ object: Any...) {
    log(.error, object)
}

// MARK: - Deinit Prints

// for development purposes
var shouldPrintDeinit: Bool = false

#if DEBUG
@inline(__always) func printDeinit(_ class: AnyObject) {
    if shouldPrintDeinit {
        log(.deinit, String(describing: `class`.self))
    }
}
#else
@inline(__always) func printDeinit(_ class: AnyObject) {}
#endif

// MARK: - Helpers

fileprivate func log(_ level: LogLevel, _ object: Any...) {
    print("> APOLLO", level, "-", Date())
    print(object)
}

fileprivate enum LogLevel: String, CustomStringConvertible {
    case debug = "DEBUG"
    case error = "ERROR"
    case `deinit` = "deinit"
    
    var description: String { rawValue }
}
