import SwiftUI

/* NAVEGACIÓN ENTRE PANTALLAS DE LA APP*/

struct ContentView: View {
    //Variables de entorno
    @Environment(SongStore.self) private var songStore:SongStore
    @Environment(VideoStore.self) private var videoStore:VideoStore
    @Environment(FavouritesStore.self) private var favouritesStore:FavouritesStore
    @Environment(UserPresetsStore.self) private var userStore:UserPresetsStore
 
    var body: some View {
        TabView{
            //Pantalla de Canciones
            SearchItemsView(itemType: "songs")
                .tabItem({
                    Image(systemName: "music.note")
                        .resizable()
                    Text("Songs")
                })
    
            //Pantalla de Vídeos
            SearchItemsView(itemType: "music videos")
                .tabItem({
                    Image(systemName: "tv.music.note")
                        .resizable()
                    Text("Music Videos")
                })
            
            //Pantalla de Favoritos
            FavouritesView()
                .tabItem({
                    Image(systemName: "star")
                        .resizable()
                    Text("Favourites")
                })
            
            //Pantalla de Usuario
            UserView()
                .tabItem({
                    Image(systemName: "person.circle")
                        .resizable()
                    Text("My Profile")
                })
        }
    }
}

#Preview {
    ContentView()
        .environment(SongStore())
        .environment(VideoStore())
        .environment(FavouritesStore())
        .environment(UserPresetsStore())
}
