//
//  MissionsGridView.swift
//  Moonshot
//
//  Created by Kurt Lane on 19/12/2022.
//

import SwiftUI

struct MissionsGridView: View {
    
    let mission: [Mission]
    let astronauts: [String: Astronaut]
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(mission) { mission in
                    NavigationLink {
                        //Text("Detail View")
                        MissionView(mission: mission, astronauts: astronauts)
                    } label: {
                        VStack {
                            Image(mission.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding( )
                            VStack {
                                Text(mission.displayName)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(mission.formattedLaunchDate)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(.lightBackaround)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.lightBackaround)
                        )
                    }
                }
            }
            .padding([.horizontal, .bottom])
        }
    }
}

struct MissionsGridView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        NavigationStack {
            MissionsGridView(mission: missions, astronauts: astronauts)
                .preferredColorScheme(.dark)
        }
    }
}
