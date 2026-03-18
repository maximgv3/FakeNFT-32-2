import SwiftUI

struct ProfileEditView: View {
    
    @State var photoUrl: URL = URL(string: "https://i.pinimg.com/736x/e2/b3/ff/e2b3ff329c3a6ce26afcd1c53d9de30a.jpg")!
    @State var nameText: String = "Максим Пупс"
    @State var descriptionText: String = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
    @State var siteText: String = "https://maxipups.com"
    
    var body: some View {
        VStack(spacing: 24) {
            photoStack
            makeBlock(header: "Имя", text: $nameText)
            makeBlock(header: "Описание", text: $descriptionText, lineLimit: 5)
            makeBlock(header: "Сайт", text: $siteText)
        }
    }
    
    private var photoStack: some View {
        Button {
            
        } label: {
            ZStack(alignment: .bottomTrailing) {
                photo
                Image(systemName: "camera.fill")
                    .resizable()
                    .foregroundStyle(.ypBlack)
                    .scaledToFit()
                    .frame(width: 12, height: 10)
                    .background(Circle()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(.ypLightGrey)
                    )
                    .offset(x:-2, y:-2)
            }
        }
        .buttonStyle(.plain)
    }
    private var photo: some View {
        AsyncImage(url: photoUrl) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Circle()
                        .foregroundStyle(.ypLightGrey)
                        .frame(width: 70, height: 70)
                    ProgressView()
                        .tint(.ypBlack)
                }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .foregroundStyle(Color.ypLightGrey)
                    .clipShape(Circle())
            case .failure:
                Image(systemName: "person.crop.circle.fill")
                               .resizable()
                               .scaledToFill()
                               .frame(width: 70, height: 70)
                               .foregroundStyle(.gray)
            @unknown default:
                Image(systemName: "person.crop.circle.fill")
                               .resizable()
                               .scaledToFill()
                               .frame(width: 70, height: 70)
                               .foregroundStyle(.gray)
            }
        }
        
    }
    
    private func makeBlock(header: String, text: Binding<String>, lineLimit: Int = 1) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(header)
                .font(.system(size: 22, weight: .bold))
            TextField("", text: text, axis: .vertical)
                .lineLimit(lineLimit, reservesSpace: true)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.ypLightGrey)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ProfileEditView()
}
