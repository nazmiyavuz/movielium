//
//  Logger.swift
//  Movielium
//
//  Created by Nazmi Yavuz on 19.04.2022.
//  Copyright © 2022 Nazmi Yavuz. All rights reserved.
//

import Foundation

enum Logger {
    enum LogLevel {
        case info
        case debug
        case warning
        case error
        
        fileprivate var prefix: String {
            switch self {
            case .info: return "LOGGER.INFO 💚"
            case .debug: return "LOGGER.DEBUG 💙"
            case .warning: return "LOGGER.WARNING 🧡"
            case .error: return "LOGGER.ERROR 💔"
            }
        }
    }
    
    struct Context {
        let file, function: String
        let line: Int
        var description: String {
            return "\((file as NSString).lastPathComponent):\(line) \(function)"
        }
    }
    
    static func info(_ message: @autoclosure () -> Any, shouldLogContext: Bool = true, file: String = #file,
                     line: Int = #line, function: String = #function) {
        let context = Context(file: file, function: function, line: line)
        Logger.handleLog(level: .info, message: message(), shouldLogContext: shouldLogContext, context: context)
    }
    
    static func debug(_ message: @autoclosure () -> Any, shouldLogContext: Bool = true, file: String = #file,
                      line: Int = #line, function: String = #function) {
        let context = Context(file: file, function: function, line: line)
        Logger.handleLog(level: .debug, message: message(), shouldLogContext: shouldLogContext, context: context)
    }
    
    static func warning(_ message: @autoclosure () -> Any, shouldLogContext: Bool = true, file: String = #file,
                        line: Int = #line, function: String = #function) {
        let context = Context(file: file, function: function, line: line)
        Logger.handleLog(level: .warning, message: message(), shouldLogContext: shouldLogContext, context: context)
    }
    
    static func error(_ message: @autoclosure () -> Any, shouldLogContext: Bool = true, file: String = #file,
                      line: Int = #line, function: String = #function) {
        let context = Context(file: file, function: function, line: line)
        Logger.handleLog(level: .error, message: message(), shouldLogContext: shouldLogContext, context: context)
    }
    
    fileprivate static func handleLog(level: LogLevel, message:  @autoclosure () -> Any,
                                      shouldLogContext: Bool, context: Context) {
        let logComponents = ["[\(level.prefix)", "\(message())]"]
        
        var fullString = logComponents.joined(separator: " ")
        if shouldLogContext {
            fullString += " → \(context.description)"
        }
        #if DEBUG
        print(fullString)
        #endif
    }
}
