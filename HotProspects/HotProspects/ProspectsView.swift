//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Kurt L on 23/1/2023.
//

import CodeScanner
import SwiftUI

struct ProspectsView: View {
    @EnvironmentObject var prospects: Prospects
    enum FilterType {
        case none, contacted, uncontacted
    }
    let filter: FilterType
    @State private var isShowingScanner = false
    enum SortType {
        case name, mostRecent
    }
    @State private var sortType: SortType = SortType.name
    @State private var showinfSortTypeConfirmationDialogue = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if prospect.isContacted && filter == .none {
                            Image(systemName: "person.fill.checkmark")
                        }
                    }
                    .swipeActions {
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            Button {
                                addNotificationForProspect(prospect)
                            } label: {
                                Label("Remind Me", systemImage: "bell")
                            }
                            .tint(.purple)
                        }
                    }
                }
            }
            .confirmationDialog("Sort by", isPresented: $showinfSortTypeConfirmationDialogue) {
                Button("Name", action: {sortType = .name})
                Button("Most Recent", action: {sortType = .mostRecent})
                Button("Cancel", role: .cancel, action: {})
            }
            .navigationTitle(title)
            .toolbar {
                Button {
                    showinfSortTypeConfirmationDialogue = true
                } label: {
                    Label ("Sort", systemImage: "arrow.up.and.down.text.horizontal")
                }
                
                Button {
//                    let prospect = Prospect()
//                    prospect.name = "Paul Hudson \(Int.random(in: 25...98504))"
//                    prospect.emailAddress = "paul@hackingwithswift.com"
//                    prospect.isContacted = Bool.random()
//                    prospects.people.append(prospect)
                    isShowingScanner = true
                } label: {
                    Label ("Scan", systemImage: "qrcode.viewfinder")
                }
                
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
                    .ignoresSafeArea()
            }
        }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Hot Prospects"
        case .contacted:
            return "Contacted People"
        case .uncontacted:
            return "Uncontacted People"
        }
    }
    
    var filteredProspects: [Prospect] {
        var allProspects = prospects.people
        switch filter {
        case .none:
            allProspects = prospects.people
        case .contacted:
            allProspects = prospects.people.filter { $0.isContacted }
        case .uncontacted:
            allProspects = prospects.people.filter { !$0.isContacted }
        }
        switch sortType {case .name:
            return allProspects.sorted { $0.name < $1.name }
        case .mostRecent:
            return allProspects.sorted { $0.dateAdded > $1.dateAdded }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else {return}
            let prospect = Prospect()
            prospect.name = details[0]
            prospect.emailAddress = details[1]
//            prospects.people.append(prospect)
//            prospects.save()
            prospects.add(prospect)
        case .failure(let error):
            print("Scan failed: \(error.localizedDescription)")
        }
    }
    
    func addNotificationForProspect(_ prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name) "
            content.subtitle = "Email: \(prospect.emailAddress)"
            content.sound = UNNotificationSound.default
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("Notifications denied")
                    }
                }
            }
        }
        
    }
    
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
