//
//  ContentView.swift
//  SimpleGlass
//
//  Created by Lance Lin on 5/28/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isFilterEnabled = false
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Toggle("开启色彩滤镜", isOn: $isFilterEnabled)
                .onChange(of: isFilterEnabled) { newValue in
                    toggleColorFilter(enable: newValue)
                }
                .toggleStyle(SwitchToggleStyle())
                .padding()
        }
        .padding()
    }
    
    /// 调用 AppleScript，模拟点击系统设置的色彩滤镜开关
    func toggleColorFilter(enable: Bool) {
        let script = """
        -- Make sure System Settings is closed before starting
        if application "System Settings" is running then
            tell application "System Settings" to quit
            delay 0.2
        end if

        tell application "System Settings"
            activate
        end tell

        delay 0.5

        tell application "System Events"
            tell process "System Settings"
                -- Click Accessibility
                click menu item "Accessibility" of menu "View" of menu bar 1
                
                delay 0.3
                
                -- Click Display under Vision section (updated selector)
                click button 3 of group 1 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1 of window 1
                
                delay 0.3
                
                click checkbox "Color filters" of group 5 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1 of window 1
            end tell
        end tell

        -- Safely quit System Settings with error handling
        try
            if application "System Settings" is running then
                tell application "System Settings" to quit
            end if
        end try
        """

        let process = Process()
        process.launchPath = "/usr/bin/osascript"
        process.arguments = ["-e", script]
        process.launch()
        process.waitUntilExit()
    }
}

#Preview {
    ContentView()
}
