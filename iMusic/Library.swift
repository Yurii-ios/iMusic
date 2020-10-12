//
//  Library.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 10/10/2020.
//

import SwiftUI
import URLImage

struct Library: View {
    
    @State var tracks = UserDefaults.standard.savedTracks()
    @State private var showAlert = false
    @State private var track: SearchViewModel.Cell!
    
    var tabBarDelegate: MainTabBarControllerDelegate?
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button(action: {
                            self.track = self.tracks[0]
                            self.tabBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                        }, label: {
                            Image(systemName: "play.fill")                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9369474649, green: 0.3679848909, blue: 0.426604867, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9218373299, green: 0.9163574576, blue: 0.9260496497, alpha: 1)))
                                .cornerRadius(10)
                            
                        })
                        Button(action: {
                            self.tracks = UserDefaults.standard.savedTracks()
                        }, label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9369474649, green: 0.3679848909, blue: 0.426604867, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9218373299, green: 0.9163574576, blue: 0.9260496497, alpha: 1)))
                                .cornerRadius(10)
                            
                        })
                    }
                } .padding()
                .frame(height: 65)
                Divider()
                    .padding(.leading)
                    .padding(.trailing)
                Spacer()
                // realizyem fynkcujy ydalenija ja4ejki s pomos4jy ForEach kotoruj imeet funkc ydalenija onDelete
                List {
                    ForEach(tracks) { track in
                        LibraryCell(cell: track)
                            .gesture(LongPressGesture().onEnded({ _ in
                                // poly4aem dostyp k osnownomy ekrany
                                let keyWindow = UIApplication.shared.connectedScenes.filter({
                                    $0.activationState == .foregroundActive
                                }).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
                                let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
                                tabBarVC?.trackDetailView.delegate = self
                                // peredaem dannue s ja4ejki w peremennyjy
                                self.track = track
                                showAlert = true
                                self.delete(track: self.track)
                            }).simultaneously(with: TapGesture().onEnded({ _ in
                                self.track = track
                                self.tabBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                            })))
                        
                    }.onDelete(perform: delete)
                }
            }.actionSheet(isPresented: $showAlert, content: { () -> ActionSheet in
                ActionSheet(title: Text("Delete track?"), buttons: [.destructive(Text("Delete"), action: {
                    
                }), .cancel()])
            })
            
            
            .navigationBarTitle("Library")
        }
        
    }
    func delete(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.setValue(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
    
    func delete(track: SearchViewModel.Cell) {
        // poly4aem index
        let index = tracks.firstIndex(of: track)
        // proweriaem est li takoj index
        guard let myIndex = index else { return }
        // ydaliaem iz masiwa tracks danuj element
        tracks.remove(at: myIndex)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.setValue(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
}

struct LibraryCell: View {
    
    var cell: SearchViewModel.Cell
    
    var body: some View {
        HStack {
            // frejmwork dlia SwiftUI kotoruj  zagryzaet image iz url
            URLImage(URL(string: cell.iconUrlString ?? "")!)
                .frame(width: 50, height: 50)
                .cornerRadius(4)
            VStack(alignment: .leading) {
                Text(cell.trackName)
                Text(cell.artistName)
            }
        }
    }
}


struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Library()
                .previewDevice("iPhone 11")
            Library()
                .previewDevice("iPhone 11")
            Library()
                .previewDevice("iPhone 11")
            Library()
                .previewDevice("iPhone 11")
        }
    }
}

extension Library: TrackMovingDelegate {
    func moveBackForPreviousTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        
        var nextTrack: SearchViewModel.Cell
        
        if myIndex - 1 == -1 {
            nextTrack = tracks[tracks.count - 1]
        } else {
            nextTrack = tracks[myIndex - 1]
        }
        self.track = nextTrack
        return nextTrack
    }

    func moveForwardForPreviousTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        
        var nextTrack: SearchViewModel.Cell
        
        if myIndex + 1 == tracks.count {
            nextTrack = tracks[0]
        } else {
            nextTrack = tracks[myIndex + 1]
        }
        self.track = nextTrack
        return nextTrack
    }
    
    
}
