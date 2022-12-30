//
//  EmojiRatingView.swift
//  Bookworm
//
//  Created by Kurt Lane on 30/12/2022.
//

import SwiftUI

struct EmojiRatingView: View {
    let rating: Int16
    var body: some View {
        switch rating {
        case 1:
            return Text ("💩").font(.largeTitle)
        case 2:
            return Text ("🥹").font(.largeTitle)
        case 3:
            return Text ("😕").font(.largeTitle)
        case 4:
            return Text ("😁").font(.largeTitle)
        default:
            return Text ("😍").font(.largeTitle)
        }
    }
}

struct EmojiRatingView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiRatingView(rating: 3)
    }
}
