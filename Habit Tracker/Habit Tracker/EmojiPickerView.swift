//
//  EmojiPickerView.swift
//  Habit Tracker
//
//  Created by Kurt Lane on 24/12/2022.
//

import SwiftUI

struct EmojiPickerView: View {
    @Environment(\.dismiss) var dismiss
    let emojiList: [Emoji] = Bundle.main.decode("emojiList.json")
    let columns = [
        GridItem(.adaptive(minimum: 40))
    ]
    @State private var searchText = ""
    @Binding var selectedEmoji: String
    
    var sortedEmoji: [EmojiCategory] {
        var emojisToReturn = [EmojiCategory]()
        var emojisToAdd = [Emoji]()
        var prevHeader = ""
        for emoji in emojiList {
            if prevHeader == "" {
                if searchText.isEmpty {
                    emojisToAdd.append(emoji)
                } else {
                    if emoji.description.lowercased().contains(searchText.lowercased()) {
                        emojisToAdd.append(emoji)
                    }
                }
            } else {
                if prevHeader == emoji.category {
                    if searchText.isEmpty {
                        emojisToAdd.append(emoji)
                    } else {
                        if emoji.description.lowercased().contains(searchText.lowercased()) {
                            emojisToAdd.append(emoji)
                        }
                    }
                } else {
                    if emojisToAdd.count != 0 {
                        emojisToReturn.append(EmojiCategory(id: prevHeader, emoji: emojisToAdd))
                    }
                    emojisToAdd = []
                    if searchText.isEmpty {
                        emojisToAdd.append(emoji)
                    } else {
                        if emoji.description.lowercased().contains(searchText.lowercased()) {
                            emojisToAdd.append(emoji)
                        }
                    }
                }
            }
            prevHeader = emoji.category
        }
        if emojisToAdd.count != 0 {
            emojisToReturn.append(EmojiCategory(id: prevHeader, emoji: emojisToAdd))
        }
        return emojisToReturn
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(sortedEmoji) { emojiCategory in
                        Section {
                            ForEach(emojiCategory.emoji) { emoji in
                                HStack {
                                    Text(emoji.id)
                                        .font(.largeTitle)
                                        .minimumScaleFactor(0.1)
                                }
                                .frame(height: 40, alignment: .center)
                                .onTapGesture {
                                    print(emoji.description)
                                    selectedEmoji = emoji.id
                                    dismiss()
                                }
                            }
                        } header: {
                            HStack {
                                Text(emojiCategory.id.uppercased())
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }.padding(.top)
                        }
                    }
                    //                ForEach(emojiList) { emoji in
                    //                    HStack {
                    //                        Text(emoji.id)
                    //                            .font(.largeTitle)
                    //                            .minimumScaleFactor(0.1)
                    //                    }
                    //                    .frame(width: 40, height: 40, alignment: .center)
                    //                }
                }.padding([.horizontal])
            }
        }
        .searchable(text: $searchText)
    }
//
//    var searchResults: [Emoji] {
//        if searchText.isEmpty {
//            return emojiList
//        } else {
//            return emojiList.filter { $0.description.contains(searchText) }
//        }
//    }
    
}

struct EmojiPicker_View_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPickerView(selectedEmoji: .constant(""))
    }
}
