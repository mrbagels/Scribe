//
//  Log.swift
//  Scribe
//
//  Created by Kyle Begeman on 9/29/24.
//

import Foundation

/**
 A static logging utility that provides methods for recording log messages with various levels of severity.

 `Log` uses a single `LogStrategy` to process and output log messages. It allows customization through its
 `LogConfig` to enable or disable logging and to set the minimum log level. The struct provides convenience
 methods for logging errors, warnings, and informational messages. Log messages include context information
 such as the source file, function name, and line number to aid in debugging.

 - Note: This struct is designed for global use and does not support instance-based configurations.
 */
public struct Log {
    
    /// The logging strategy used to process and output log messages.
    private static let strategy: LogStrategy = DefaultLogStrategy()
    
    /// The global configuration for logging behavior, such as enabling/disabling logging and setting the log level.
    public static let configuration: LogConfig = LogConfig()
    
    /// A Boolean indicating whether logging is currently enabled based on the global configuration.
    private static var isLoggerEnabled: Bool {
        return configuration.isEnabled
    }
    
    /**
     Logs a message with the specified log level and context information.
     
     This method captures the log message, log level, and optional context, and processes them using the
     configured `LogStrategy`. It only logs the message if logging is enabled and the specified log level meets
     the minimum threshold set in the configuration.
     
     - Parameters:
        - level: The severity level of the log (e.g., debug, info, warning, error).
        - tag: An optional tag to prepend to the log message. If `nil`, the log level's label is used.
        - message: A message to be logged, of type `Any` for JSON and other support.
        - context: A dictionary of additional context to include with the log message. Defaults to `nil`.
        - separator: A string used to join the log message components. Defaults to a single space `" "`.
        - file: The name of the source file where the log call was made. Automatically captured using `#file`.
        - function: The name of the function where the log call was made. Automatically captured using `#function`.
        - line: The line number in the source file where the log call was made. Automatically captured using `#line`.
     */
    public static func send(
        level: LogLevel,
        tag: String?,
        _ message: String,
        context: [String: Any]? = nil,
        separator: String = " ",
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        guard isLoggerEnabled, shouldLog(for: level) else { return }
        
        let messages = message
        let output = messages.map { "\($0)" }.joined(separator: separator)
        let logTag = tag ?? level.label
        let category = formatLocation(file: file, function: function, line: line)
        
        strategy.log(
            message: "\(logTag)\n\(output)",
            level: level,
            category: category,
            file: file,
            function: function,
            line: line,
            context: context ?? [:]
        )
    }
    
    // MARK: - Private Methods
    
    /**
     Sends a log message with the specified level and context information.
     
     This method is a utility function used internally by the convenience logging methods (`error`, `warning`, `info`).
     It processes the log message using the configured `LogStrategy`, only if logging is enabled and the specified log
     level meets the minimum threshold set in the configuration.
     
     - Parameters:
        - level: The severity level of the log (e.g., debug, info, warning, error).
        - message: A message to be logged, of type `Any` for JSON and other support.
        - context: A dictionary of additional context to include with the log message. Defaults to `nil`.
        - separator: A string used to join the log message components. Defaults to a single space `" "`.
        - file: The name of the source file where the log call was made. Automatically captured using `#file`.
        - function: The name of the function where the log call was made. Automatically captured using `#function`.
        - line: The line number in the source file where the log call was made. Automatically captured using `#line`.
     */
    private static func log(
        level: LogLevel,
        message: String,
        context: [String: Any]? = nil,
        separator: String = " ",
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        guard isLoggerEnabled, shouldLog(for: level) else { return }

        let category = formatLocation(file: file, function: function, line: line)

        // Use the strategy to log the message.
        strategy.log(
            message: message,
            level: level,
            category: category,
            file: file,
            function: function,
            line: line,
            context: context ?? [:]
        )
    }
    
    /**
     Determines if the provided log level meets the minimum level set in the configuration.
     
     - Parameter level: The log level to evaluate.
     - Returns: `true` if the log level is greater than or equal to the minimum configured log level; otherwise, `false`.
     */
    private static func shouldLog(for level: LogLevel) -> Bool {
        return level >= configuration.logLevel
    }
    
    /**
     Formats the location of the log message for display.
     
     - Parameters:
        - file: The name of the source file where the log call was made.
        - function: The name of the function where the log call was made.
        - line: The line number in the source file where the log call was made.
     - Returns: A formatted string indicating the file, function, and line number.
     */
    private static func formatLocation(file: String, function: String, line: Int) -> String {
        let fileName = URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
        return "\(fileName).\(function):\(line)"
    }
}

// MARK: - Convenience Methods

extension Log {
    
    /**
     Logs an error-level message with optional context and context information.
     
     - Parameters:
        - message: A message to be logged, of type `Any` for JSON and other support.
        - context: A dictionary of additional context to include with the log message. Defaults to `nil`.
        - file: The name of the source file where the log call was made. Automatically captured using `#file`.
        - function: The name of the function where the log call was made. Automatically captured using `#function`.
        - line: The line number in the source file where the log call was made. Automatically captured using `#line`.
     */
    public static func error(
        _ message: String,
        context: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .error, message: message, context: context, file: file, function: function, line: line)
    }
    
    /**
     Logs a warning-level message with optional context and context information.
     
     - Parameters:
        - message: A message to be logged, of type `Any` for JSON and other support.
        - context: A dictionary of additional context to include with the log message. Defaults to `nil`.
        - file: The name of the source file where the log call was made. Automatically captured using `#file`.
        - function: The name of the function where the log call was made. Automatically captured using `#function`.
        - line: The line number in the source file where the log call was made. Automatically captured using `#line`.
     */
    public static func warning(
        _ message: String,
        context: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .warning, message: message, context: context, file: file, function: function, line: line)
    }
    
    /**
     Logs an informational message with optional context and context information.
     
     - Parameters:
        - message: A message to be logged, of type `Any` for JSON and other support.
        - context: A dictionary of additional context to include with the log message. Defaults to `nil`.
        - file: The name of the source file where the log call was made. Automatically captured using `#file`.
        - function: The name of the function where the log call was made. Automatically captured using `#function`.
        - line: The line number in the source file where the log call was made. Automatically captured using `#line`.
     */
    public static func info(
        _ message: String,
        context: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .info, message: message, context: context, file: file, function: function, line: line)
    }
}
