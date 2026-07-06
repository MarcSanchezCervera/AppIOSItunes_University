import SwiftUI

/* SELECTOR DROPDOWN*/

struct OptionsDropDownView: View {
    
    let menuTitle: String
    let menuOptions: [String]
    let selectAction: (String) -> Void
    
    var selectedOption: String
        
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            //Título del campo
            Text(menuTitle)
                .font(.headline)
            
            //Listado de opciones
            Menu {
                ForEach(menuOptions, id: \.self) { option in
                    Button(action: {
                        selectAction(option)
                    }) {
                        Text(option)
                    }
                }
            } label: {
                HStack {
                    Text(selectedOption.isEmpty ? "Select…" : selectedOption)
                        .foregroundColor(.primary)
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: 350)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    
    OptionsDropDownView(
        menuTitle: "Genre",
        menuOptions: ["All", "Pop", "Rock", "Jazz", "Electronic"],
        selectAction: { value in
            print(value)
        },
        selectedOption: "Hola"
    )
}
