import SwiftUI

@main
struct iTunesApp: App {
    
    @State var songsStore = SongStore()
    @State var videosStore = VideoStore()
    @State var favourites = FavouritesStore()
    @State var users = UserPresetsStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(songsStore)
                .environment(videosStore)
                .environment(favourites)
                .environment(users)
        }
    }
}
