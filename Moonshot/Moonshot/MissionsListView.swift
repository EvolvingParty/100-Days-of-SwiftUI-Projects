//
//  MissionsListView.swift
//  Moonshot
//
//  Created by Kurt Lane on 19/12/2022.
//

import SwiftUI

struct MissionsListView: View {
    
    let mission: [Mission]
    let astronauts: [String: Astronaut]
    
    var body: some View {
        List {
            ForEach(mission, id: \.id) { mission in
                NavigationLink {
                    MissionView(mission: mission, astronauts: astronauts)
                } label: {
                    HStack {
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                        VStack(alignment: .leading) {
                            Text(mission.displayName)
                                .font(.system(.title2, design: .rounded).weight(.bold))
                                .foregroundColor(.white)
                            Text(mission.formattedLaunchDate)
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                }
            }.listRowBackground(Color.lightBackaround)
        }
        .scrollContentBackground(.hidden)
        .background(.darkBackground)
    }
}

struct MissionsListView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        NavigationStack {
            MissionsListView(mission: missions, astronauts: astronauts)
                .preferredColorScheme(.dark)
        }
    }
}
