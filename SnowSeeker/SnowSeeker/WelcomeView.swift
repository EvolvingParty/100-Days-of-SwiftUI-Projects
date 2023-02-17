//
//  WelcomeView.swift
//  SnowSeeker
//
//  Created by Kurt L on 12/2/2023.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to SnowSeeker!")
                .font(.largeTitle)
            Text ("Please select a resort from the left-hand menu; swipe from the left edge to show it.")
                .foregroundColor (.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
