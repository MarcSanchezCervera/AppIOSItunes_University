import SwiftUI
import AVKit

/* VIEW CON LOS DETALLES DE CADA ÍTEM */

struct ItemDetailsView: View {
    let item: Item
    
    @Environment(FavouritesStore.self) private var favouritesStore:FavouritesStore
    
    @State private var player: AVPlayer?
    
    //Función para convertir la duración en string para mostrar por pantalla
    func durationConversion (millis: Int) -> String {
        let total = millis / 1000
        let min = total / 60
        let sec = total % 60
        return String(format: "%d:%02d", min, sec)
    }
    
    //Función para formatear la fecha
    func formatDate (inputDate: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        formatter.locale = .current

        guard let outputDate = isoFormatter.date(from: inputDate) else {
               return inputDate
           }

        return formatter.string(from: outputDate)
    }
    
    var body: some View {
        ScrollView {
            ZStack {
                // Fondo difuminado con la imagen del disco/album
                AsyncImage(url: URL(string: item.artworkUrl100.replacingOccurrences(of: "100x100", with: "300x300"))) { image in
                    image
                        .resizable()
                        .blur(radius: 50)
                        .saturation(1.4)
                        .opacity(0.7)
                        .ignoresSafeArea()
                } placeholder: {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                }
                
                switch item.kind {
                    case "song":
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Spacer()
                                AsyncImage(url: URL(string: item.artworkUrl100.replacingOccurrences(of: "100x100", with: "300x300"))) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(12)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 200, height: 200)
                                Spacer()
                            }.padding(.bottom, 12)
                            
                            //Detalles de la canción
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.trackName).font(Font.largeTitle).fontWeight(.bold).kerning(-1)
                                Text("\(item.artistName)")
                                    .font(Font.title2)
                                Text("Genre: \(item.primaryGenreName)")
                                
                                if let releaseDate = item.releaseDate {
                                    Text("Release: \(formatDate(inputDate: releaseDate))")
                                } else {
                                    Text("Release: Unknown")
                                }
                                
                                //Separador
                                Rectangle()
                                       .frame(height: 1)
                                       .foregroundStyle(.separator)
                                       .padding(6)
                                
                                Text("Album: \(item.collectionName ?? "No Album")")
                                
                                
                                if item.collectionExplicitness == "explicit" {
                                    HStack(spacing: 4){
                                        Text("E")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .frame(width: 20, height: 20)
                                            .background(Color.gray.opacity(0.25))
                                            .cornerRadius(4)
                                        Text("Album contains explicit content").font(.subheadline)
                                    }
                                }
                                
                                
                                Text("Duration: \(durationConversion(millis: item.trackTimeMillis ?? 0))")
                                Text("Price: \(String(format: "%.2f", item.trackPrice ?? 0)) \(item.currency)")
                                
                                
                                //Botón para añadir a favoritos
                                let isFavorite = favouritesStore.isFavorite(item: item)

                                Button {
                                    favouritesStore.toggleFavorite(item: item)
                                } label: {
                                    HStack {
                                        Image(systemName: isFavorite ? "star.fill" : "star")
                                            .foregroundColor(isFavorite ? .yellow : .black)

                                        Text(isFavorite ? "Remove from favourites" : "Add to favourites")
                                    }
                                }

                                .buttonStyle(.plain)
                            
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.ultraThinMaterial)
                            .cornerRadius(24)
                            
                            Spacer()
                        }.padding()
                    
                    case "music-video":
                    
                        let imgHeight: CGFloat = 200
                        let imgWidth = imgHeight * 16 / 9
                    
                        VStack(alignment: .leading, spacing: 8) {
                       
                                AsyncImage(url: URL(string: item.artworkUrl100.replacingOccurrences(of: "100x100", with: "500x500"))) { image in
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
                                }.padding(.bottom, 12)
                            
                            //Detalles del vídeo
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.trackName).font(Font.largeTitle).fontWeight(.bold).kerning(-1)
                                Text("\(item.artistName)")
                                    .font(Font.title2)
                                Text("Genre: \(item.primaryGenreName)")
                                
                                if let releaseDate = item.releaseDate {
                                    Text("Release: \(formatDate(inputDate: releaseDate))")
                                } else {
                                    Text("Release: Unknown")
                                }

                                //Reproductor de vídeo
                                if let player {
                                    VideoPlayer(player: player)
                                        .aspectRatio(16/9, contentMode: .fit)
                                        .frame(maxWidth: .infinity)
                                        .cornerRadius(12)
                                        .padding(.top, 16)
                                    }
                                
                                Spacer()
                                
                                let isFavorite = favouritesStore.isFavorite(item: item)

                                //Botón para añadir a favoritos
                                Button {
                                    favouritesStore.toggleFavorite(item: item)
                                } label: {
                                    HStack {
                                        Image(systemName: isFavorite ? "star.fill" : "star")
                                            .foregroundColor(isFavorite ? .yellow : .black)

                                        Text(isFavorite ? "Remove from favourites" : "Add to favourites")
                                    }
                                }

                                .buttonStyle(.plain)
                                
                                Spacer()
                                
                                }.task {
                                    if let previewString = item.previewUrl, let url = URL(string: previewString) {
                                        player = AVPlayer(url: url)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.ultraThinMaterial)
                                .cornerRadius(24)
                            
                                Spacer()

                        }.padding()
                    
                    default:
                        Text("Cannot show item")
                }
            }

        }
        }
}

#Preview {
    ItemDetailsView(item: VideoStore.dummyItem)
        .environment(FavouritesStore())
}
