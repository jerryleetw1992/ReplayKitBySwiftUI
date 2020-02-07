//
//  ContentView.swift
//  ReplayKitBySwiftUI
//
//  Created by Jerry LEE on 2020/2/7.
//  Copyright © 2020 JerryStudio. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var isBool = false
    
    var body: some View {
        Text("Hello, World!")
            .foregroundColor(isBool ? .red : .green)
            .onTapGesture {
                self.isBool.toggle()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
