//
//  EmojiPicker_View.swift
//  Habit Tracker
//
//  Created by Kurt Lane on 24/12/2022.
//

import SwiftUI

struct EmojiPicker_View: View {
    let emojiList: [Emoji] = Bundle.main.decode("emojiList.json")
    let columns = [
        GridItem(.adaptive(minimum: 30))
    ]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(emojiList) { emoji in
                    HStack {
                        Text(emoji.id)
                            .font(.largeTitle)
                            .minimumScaleFactor(0.1)
                    }
                    .frame(width: 40, height: 40, alignment: .center)
                }
            }
        }
    }
}

struct EmojiPicker_View_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPicker_View()
    }
}
