import SwiftUI

/* VIEW PARA VISUALIZAR UN ELEMENTO EN LISTAS*/

struct ItemRowView: View {
    let item: Item
    @Environment(FavouritesStore.self) private var favouritesStore:FavouritesStore
    
    var body: some View {
        
        switch item.kind {
            case "song":
            HStack(spacing: 16){
                AsyncImage(url: URL(string: item.artworkUrl100)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 64, height: 64)
                
                VStack(alignment: .leading, spacing: 4){
                    Text(item.trackName).font(.headline).lineLimit(1)
                    Text("\(item.artistName) - \(item.collectionName ?? "No Album")")
                        .font(.subheadline)
                        .lineLimit(1)
                    
                    HStack(spacing: 4){
                        Image(systemName:"music.note").font(Font.system(size: 12, weight: .bold))
                        Text("Song").font(.subheadline)
                        
                        //Mostrar icono de contenido explícito, si hace falta
                        if item.trackExplicitness == "explicit" {
                            Text("E")
                                .font(.caption)
                                .fontWeight(.bold)
                                .frame(width: 20, height: 20)
                                .background(Color.gray.opacity(0.25))
                                .cornerRadius(4)
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    favouritesStore.toggleFavorite(item: item)
                } label: {
                    Image(systemName:
                            favouritesStore.isFavorite(item: item)
                          ? "star.fill"
                          : "star"
                    )
                    .foregroundColor(
                        favouritesStore.isFavorite(item: item)
                        ? .yellow
                        : .black
                    )
                }
                .buttonStyle(.plain)
            }.padding(.vertical, 8)
            
        case "music-video":
            let imgHeight: CGFloat = 64
            let imgWidth = imgHeight * 16 / 9
            
            HStack(spacing: 16){
            //Imagen del vídeo
            AsyncImage(url: URL(string: item.artworkUrl100.replacingOccurrences(of: "100x100", with: "200x200"))) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: imgWidth, height: imgHeight)
                    .clipped()
                    .cornerRadius(12)
                
            } placeholder: {
                ZStack {
                       Rectangle()
                           .fill(Color.gray.opacity(0.2))
                           .frame(width: imgWidth, height: imgHeight)
                           .cornerRadius(12)
                       ProgressView()
                   }
            }
            
            VStack(alignment: .leading, spacing: 4){
                Text(item.trackName).font(.headline).lineLimit(1)
                Text("\(item.artistName)")
                    .font(.subheadline)
                    .lineLimit(1)
                
                
                HStack(spacing: 4){
                    Image(systemName:"tv.music.note").font(Font.system(size: 12, weight: .bold))
                    Text("Music Video").font(.subheadline)
                    
                    //Mostrar icono de contenido explícito, si hace falta
                    if item.trackExplicitness == "explicit" {
                        Text("E")
                            .font(.caption)
                            .fontWeight(.bold)
                            .frame(width: 20, height: 20)
                            .background(Color.gray.opacity(0.25))
                            .cornerRadius(4)
                    }

                }
            }
                
            Spacer()
                
            Button {
                favouritesStore.toggleFavorite(item: item)
            } label: {
                Image(systemName:
                    favouritesStore.isFavorite(item: item)
                    ? "star.fill"
                    : "star"
                )
                .foregroundColor(
                    favouritesStore.isFavorite(item: item)
                    ? .yellow
                    : .black
                )
            }
            .buttonStyle(.plain)
        }.padding(.vertical, 8)
            
        default:
            Text("There was an error loading the item")
        }
    }
}

#Preview {
    ItemRowView(item: VideoStore.dummyItem).environment(FavouritesStore())
}
