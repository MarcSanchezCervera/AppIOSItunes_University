import SwiftUI

/* PANTALLA PARA AJUSTAR PREFERENCIAS DE USUARIO */

struct UserView: View {
    
    @Environment(VideoStore.self) private var iTunesStore:VideoStore
    @Environment(UserPresetsStore.self) private var userStore:UserPresetsStore

    var body: some View {
            ZStack {
                //Fondo de pantalla
                LinearGradient(
                    colors: [Color("BgBlue").opacity(0.5), Color("BgPurple").opacity(0.9)],
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()
                
                //Contenedor con los elementos de la vista
                VStack {
                    //Imagen de perfil
                    VStack(spacing: 16){
                        Text("My Profile")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .kerning(-1)
                        
                        AsyncImage(url: URL(string: userStore.user.profileImageURL)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(.white.opacity(0.25), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                        } placeholder: {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Circle()
                                        .stroke(.white.opacity(0.25), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                        }
                        
                        //Nombre de usuario
                        Text(userStore.user.username).font(Font.title)
                    }.padding(.bottom, 16)
                    
                    //Campos de selección de preferencias
                    VStack(alignment: .leading, spacing: 16){
                        Text("Search preferences").font(.title2).bold()
                        
                        OptionsDropDownView(menuTitle: "Search country", menuOptions: iTunesStore.countries, selectAction:{option in userStore.changeCountrySetting(newCountry: option)}, selectedOption: userStore.user.searchCountry)
                    
                        OptionsDropDownView(menuTitle: "Allow explicit content", menuOptions: iTunesStore.explicitOptions, selectAction:{ option in userStore.changeExplicitContentSetting(explicit: option)}, selectedOption: userStore.user.explicitContent ? "Yes" : "No")
                        
                    }.padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(24)
                    
                    Spacer()
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

#Preview {
    UserView().environment(VideoStore())
        .environment(UserPresetsStore())
}
