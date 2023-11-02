//
//  Library.swift
//  myMusic
//
//  Created by QwertY on 12.03.2023.
//

import SwiftUI

struct Library: View {
    
    enum CodingKey: String {
        case tracks = "tracks"
    }
    
    @State private var tracks = UserDefaults.standard.fetchTracks(forKey: CodingKey.tracks.rawValue)
    @State private var showingAlert = false
    @State private var track: SearchViewModel.Cell?
    @State private var lastSelectedTrackIndex: Int?
    
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    var body: some View {
        NavigationView {
            VStack {
                // MARK: Play And Refresh Buttons
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button(action: {
                            guard let firstTrack = tracks.first else { return }
                            self.track = firstTrack
                            self.tabBarDelegate?.maximizeTrackDetailsView(viewModel: firstTrack)
                        }) {
                            Image(systemName: "play.fill")
                                .frame(
                                    width: geometry.size.width / 2 - 10,
                                    height: 50
                                )
                                .tint(Color.red)
                                .background(content: {
                                    Color(UIColor.systemGray6)
                                })
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            self.tracks = UserDefaults.standard.fetchTracks(forKey: CodingKey.tracks.rawValue)
                        }) {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(
                                    width: geometry.size.width / 2 - 10,
                                    height: 50
                                )
                                .tint(Color.red)
                                .background(content: {
                                    Color(UIColor.systemGray6)
                                })
                                .cornerRadius(10)
                        }
                    }
                }.padding().frame(height: 50)
                
                Divider().padding(.leading).padding(.trailing).padding(.top)

                // MARK: Tracks List
                List {
                    ForEach(tracks) { track in
                        LibraryCell(cell: track)
                            .gesture(TapGesture().onEnded{ _ in
                                let keyWindow = UIApplication.shared.getKeyWindow()
                                let tabBarViewController = keyWindow?.rootViewController as? MainTabBarController
                                tabBarViewController?.trackDetailView.delegate = self
                                self.track = track
                                self.lastSelectedTrackIndex = tracks.firstIndex(of: track)
                                tabBarDelegate?.maximizeTrackDetailsView(viewModel: track)
                            })
                            .gesture(LongPressGesture().onEnded{ _ in
                                self.track = track
                                self.showingAlert = true
                            })
                    }.onDelete(perform: delete)
                }
                .confirmationDialog("deletion", isPresented: $showingAlert, actions: {
                    Button("Delete", role: .destructive) {
                        guard let track = track else { return }
                        self.delete(track: track)
                    }
                }, message: {
                    Text("Are you sure to delete this track?")
                })
                    .listStyle(.plain)
            }
            .navigationTitle("Library")
        }
    }
    
    // MARK: Tracks Deletion
    
    private func delete(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        UserDefaults.standard.save(objects: tracks, forKey: CodingKey.tracks.rawValue) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    private func delete(track: SearchViewModel.Cell) {
        let index = tracks.firstIndex(of: track)
        guard let index = index else { return }
        tracks.remove(at: index)
        UserDefaults.standard.save(objects: tracks, forKey: CodingKey.tracks.rawValue) { error in
            if let error = error {
                print(error)
            }
        }
    }
}

// MARK: Library Track Cell

struct LibraryCell: View {
    
    var cell: SearchViewModel.Cell
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: cell.iconUrlString ?? "")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            .cornerRadius(2)
            VStack(alignment: .leading) {
                Text("\(cell.trackName)")
                Text("\(cell.artistName)")
            }
        }
    }
}

// MARK: - Tracks Navigation Delegate

extension Library: TracksNavigationDelegate {
    
    private func getTrack(isForwardTrack: Bool) -> SearchViewModel.Cell? {
        guard let index = lastSelectedTrackIndex else { return nil }
        var nextIndex: Int
        switch isForwardTrack {
        case true:
            nextIndex = index + 1
            if nextIndex == tracks.count {
                nextIndex = 0
            }
        case false:
            nextIndex = index - 1
            if nextIndex < 0 {
                nextIndex = tracks.count - 1
            }
        }
        lastSelectedTrackIndex = nextIndex
        return tracks[nextIndex]
    }
    
    func moveToPreviousTrack() -> SearchViewModel.Cell? {
        getTrack(isForwardTrack: false)
    }
    
    func moveToNextTrack() -> SearchViewModel.Cell? {
        getTrack(isForwardTrack: true)
    }
}

// MARK: Preview
struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
