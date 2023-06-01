//
//  CrashlyticsView.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 01/06/2023.
//

import SwiftUI

struct CrashlyticsView: View {
    
    var body: some View {
        VStack (spacing: 40){
            
            Button {
                let someString: String? = nil
                let _: String = someString!
            } label: {
                Text("Crash 1")
            }.buttonMode()

            Button {
                fatalError("Fatal error ")
            } label: {
                Text("Crash 2")
            }.buttonMode()
            
            Button {
                let someString: [String] = []
                guard !someString.isEmpty else {
                    /// Instead crash send error 
                    CrashManager.shared.sendNonFatal(error: URLError(.dataNotAllowed))
                    return
                }
                let _: String = someString[2]
            } label: {
                Text("Crash 3")
            }.buttonMode()
            
        }
        .onAppear {
            /// set user id here
            CrashManager.shared.setUserId(userId: "Dart Vader")
        }
    }
}

//                    🔱
struct CrashlyticsView_Previews: PreviewProvider {
    static var previews: some View {
        CrashlyticsView()
    }
}
