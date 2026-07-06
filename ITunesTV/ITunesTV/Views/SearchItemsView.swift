import SwiftUI

/* PANTALLA PARA VISUALIZAR RESULTADOS */

struct SearchItemsView: View {
    
    @Environment(SongStore.self) private var songStore:SongStore
    @Environment(VideoStore.self) private var videoStore:VideoStore
    @Environment(FavouritesStore.self) private var favouritesStore:FavouritesStore
    @Environment(UserPresetsStore.self) private var userStore:UserPresetsStore
    
    let itemType: String
    @State private var searchInput: String = ""
    @FocusState private var searchFieldIsFocused: Bool

    var body: some View {
        NavigationStack {
            switch itemType {
                case "songs":
                    switch songStore.state{
                        case .idle:
                            ZStack {
                                //Fondo de pantalla
                                Image(itemType)
                                        .resizable()
                                        .scaledToFill()
                                        .opacity(0.3)
                                        .overlay(
                                            LinearGradient(
                                                colors: [Color("BgBlue").opacity(0.5), Color("BgPurple").opacity(0.9)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .ignoresSafeArea()
                                
                                VStack(spacing: 16){
                                    Text(itemType.capitalized).font(Font.largeTitle).fontWeight(.bold).kerning(-1)
                                    
                                    Text("Start typing to search \(itemType)!")
                                    Text("🌍 \(userStore.user.searchCountry) - 🔞 \(userStore.user.explicitContent ? "Activated" : "Deactivated")")
                                    
                                //Barra de búsqueda
                                }.searchable(
                                    text: $searchInput,
                                    prompt: "Search \(itemType)"
                                )
                                .onSubmit (of: .search) {
                                    songStore.fetchSongsWithPreferences(query: searchInput, country: userStore.user.searchCountry,
                                        explicit: userStore.user.explicitContent)
                                }
                            }
                            
                    case .loading:
                        ZStack {
                            //Fondo de pantalla
                            Image(itemType)
                                .resizable()
                                .scaledToFill()
                                .opacity(0.3)
                                .overlay(
                                    LinearGradient(
                                        colors: [Color("BgBlue").opacity(0.5), Color("BgPurple").opacity(0.9)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .ignoresSafeArea()
                            
                            //Icono de carga dinámico con texto
                            VStack(spacing: 16) {
                                Image(systemName:"hourglass")
                                    .font(.system(size: 48))
                                    .symbolEffect(.rotate.byLayer, options: .repeat(.continuous))
                                    .foregroundColor(.white)
                                Text("Loading...")
                            }
                        }
                            
                        case .loaded (let results):
                            //Fondo de pantalla
                            ZStack {
                                LinearGradient(
                                    colors: [Color("BgBlue").opacity(0.5), Color("BgPurple").opacity(0.9)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ).ignoresSafeArea()
                                
                                
                                //Listado de resultados
                                List {
                                    ForEach(results) { result in
                                        NavigationLink(destination: ItemDetailsView(item: result)) {
                                            ItemRowView(item: result)
                                            
                                        }.listRowBackground(Color.white.opacity(0.2))
                                            .onAppear{
                                               if result.trackId == results.last?.trackId {
                                                       songStore.loadNextPage()
                                               }
                                            }
                                    }
                                }.scrollContentBackground(.hidden)
                            }.navigationTitle(itemType.capitalized)
                        
                            //Barra de búsqueda
                            .searchable(
                                text: $searchInput,
                                prompt: "Search \(itemType)"
                            )
                            .onSubmit (of: .search) {
                                songStore.fetchSongsWithPreferences(query: searchInput, country: userStore.user.searchCountry,
                                    explicit: userStore.user.explicitContent)
                            }
                            
                        case .error(let message):
                            //Fondo de pantalla
                            ZStack {
                                Image(itemType)
                                    .resizable()
                                    .scaledToFill()
                                    .opacity(0.3)
                                    .overlay(
                                        LinearGradient(
                                            colors: [Color("BgBlue").opacity(0.5), Color("BgPurple").opacity(0.9)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .ignoresSafeArea()
                                
                                VStack(spacing: 16) {
                                    Image(systemName:"exclamationmark.bubble.circle")
                                        .font(.system(size: 48))
                                        .foregroundColor(.white)
                                   
                                    Text("We have an error:")
                                                    .font(.title2)
                                                    .foregroundColor(.white)
                                                    .multilineTextAlignment(.center)
                                                
                                                Text(message)
                                                    .foregroundColor(.white)
                                                    .multilineTextAlignment(.center)
                                                    .padding(.horizontal)

                               //Barra de búsqueda
                                }.searchable(
                                    text: $searchInput,
                                    prompt: "Search \(itemType)"
                                )
                                .onSubmit (of: .search) {
                                    songStore.fetchSongsWithPreferences(query: searchInput, country: userStore.user.searchCountry,
                                        explicit: userStore.user.explicitContent)
                                }
                            }
                        }
                
                case "music videos":
                    switch videoStore.state{
                    case .idle:
                                ZStack {
                                    //Fondo de pantalla
                                    Image(itemType)
                                            .resizable()
                                            .scaledToFill()
                                            .opacity(0.3)
                                            .overlay(
                                                LinearGradient(
                                                    colors: [Color("BgBlue").opacity(0.5), Color("BgPurple").opacity(0.9)],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                )
                                            )
                                            .ignoresSafeArea()
                                    
                                    VStack(spacing: 16){
                                        Text(itemType.capitalized).font(Font.largeTitle).fontWeight(.bold).kerning(-1)
                                        
                                        Text("Start typing to search \(itemType)!")
                                        Text("🌍 \(userStore.user.searchCountry) - 🔞 \(userStore.user.explicitContent ? "Activated" : "Deactivated")")
                                    
                                    //Barra de búsqueda
                                    }.searchable(
                                        text: $searchInput,
                                        prompt: "Search \(itemType)"
                                    )
                                    .onSubmit (of: .search) {
                                        videoStore.fetchVideosWithPreferences(query: searchInput, country: userStore.user.searchCountry,
                                            explicit: userStore.user.explicitContent)
                                    }
                                }
                        
                    case .loading:
                        ZStack {
                            //Fondo de pantalla
                            Image(itemType)
                                .resizable()
                                .scaledToFill()
                                .opacity(0.3)
                                .overlay(
                                    LinearGradient(
                                        colors: [Color("BgBlue").opacity(0.5), Color("BgPurple").opacity(0.9)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .ignoresSafeArea()
                            
                            //Icono de carga dinámico con texto
                            VStack(spacing: 16) {
                                Image(systemName:"hourglass")
                                    .font(.system(size: 48))
                                    .symbolEffect(.rotate.byLayer, options: .repeat(.continuous))
                                    .foregroundColor(.white)
                                Text("Loading...")
                            }.searchable(
                                text: $searchInput,
                                prompt: "Search \(itemType)"
                            )
                            .onSubmit (of: .search) {
                                videoStore.fetchVideosWithPreferences(query: searchInput, country: userStore.user.searchCountry,
                                    explicit: userStore.user.explicitContent)
                            }
                        }
                        
                    case .loaded (let results):
                        ZStack {
                            //Fondo de pantalla
                            LinearGradient(
                                colors: [Color("BgBlue").opacity(0.5), Color("BgPurple").opacity(0.9)],
                                startPoint: .top,
                                endPoint: .bottom
                            ).ignoresSafeArea()
                            
                            //Listado de resultados
                            List {
                                ForEach(results) { result in
                                    NavigationLink(destination: ItemDetailsView(item: result)) {
                                        ItemRowView(item: result)
                                    }.listRowBackground(Color.white.opacity(0.2))
                                        .onAppear{
                                           if result.trackId == results.last?.trackId {
                                                   videoStore.loadNextPage()
                                           }
                                        }
                                }
                            }.scrollContentBackground(.hidden)
                        }.navigationTitle(itemType.capitalized)
                            //Barra de búsqueda
                            .searchable(
                                text: $searchInput,
                                prompt: "Search \(itemType)"
                            )
                            .onSubmit (of: .search) {
                                videoStore.fetchVideosWithPreferences(query: searchInput, country: userStore.user.searchCountry,
                                    explicit: userStore.user.explicitContent)
                            }
                        
                    case .error(let message):
                        ZStack {
                            //Fondo de pantalla
                            Image(itemType)
                                .resizable()
                                .scaledToFill()
                                .opacity(0.3)
                                .overlay(
                                    LinearGradient(
                                        colors: [Color("BgBlue").opacity(0.5), Color("BgPurple").opacity(0.9)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .ignoresSafeArea()
                            
                            VStack(spacing: 16) {
                                Image(systemName:"exclamationmark.bubble.circle")
                                    .font(.system(size: 48))
                                    .foregroundColor(.white)
                                Text("We have an error:")
                                                .font(.title2)
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                            
                                            Text(message)
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                                .padding(.horizontal)
                            }
                        }
                    }
                
            default:
                Text("Couldn't load the screen")
            }
        }
    }
}

#Preview {
    SearchItemsView(itemType: "music videos").environment(VideoStore()).environment(FavouritesStore()).environment(SongStore()).environment(UserPresetsStore())
}
