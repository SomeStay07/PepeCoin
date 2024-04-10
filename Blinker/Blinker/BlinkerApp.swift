//
//  BlinkerApp.swift
//  Blinker
//
//  Created by Тимур Чеберда on 05.03.2024.
//

import SwiftUI

@main
struct BlinkerApp: App {
    var body: some Scene {
        WindowGroup {
            TxBlinkerView(config: .accent)
        }
    }
}
