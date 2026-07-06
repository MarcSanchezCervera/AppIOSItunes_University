import SwiftUI

/* PANTALLA PARA VISUALIZAR LOS ELEMENTOS FAVORITOS*/

struct FavouritesView: View {
    @Environment(FavouritesStore.self)
    private var favouritesStore: FavouritesStore
    
    var body: some View {
        NavigationStack{
            ZStack {
                //Fondo de la pantalla
                LinearGradient(
                    colors: [Color("BgBlue").opacity(0.5), Color("BgPurple").opacity(0.9)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            
                //Mostrar texto si no hay resultados
                if favouritesStore.favorites.isEmpty {
                    Text("No favorites yet ⭐")
                } else {
                    // Mostrar elementos en lista
                    List {
                        ForEach(favouritesStore.favorites) { result in
                            NavigationLink(destination: ItemDetailsView(item: result)) {
                                ItemRowView(item: result)   
                            }.listRowBackground(Color.white.opacity(0.2))
                        }
                    }.scrollContentBackground(.hidden)
                    .navigationTitle("Favourites")
                }
            }
        }
    }
}
#Preview {
    FavouritesView().environment(FavouritesStore())
}
