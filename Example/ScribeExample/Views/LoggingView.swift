//
//  LoggingView.swift
//  ScribeExample
//
//  Created by Kyle Begeman on 9/29/24.
//

import Scribe
import SwiftUI

struct LoggingView: View {
    
    @State private var userId: String = "12345"
    @State private var logMessage: String = "Sample log message"

    var body: some View {
        VStack(spacing: 20) {
            Text("Logging Example")
                .font(.largeTitle)
                .padding()

            // Log Info Button
            Button(action: {
                Log.info("Have I told you lately, that I love you?")
            }) {
                Text("Log Info")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            // Log Warning Button
            Button(action: {
                Log.warning(logMessage, context: ["userId": userId, "action": "warningButtonPressed"])
            }) {
                Text("Log Warning")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            // Log Error Button
            Button(action: {
                Log.error(logMessage)
            }) {
                Text("Log Error")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}
