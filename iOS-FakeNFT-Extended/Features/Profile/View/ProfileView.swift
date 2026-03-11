import SwiftUI

struct ProfileView: View {

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: .zero) {
                
                HStack(alignment: .center) {
                    Image("profile_avatar_mock")
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                    Text("Name Surname")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.ypBlack)
                        .padding(.leading, 16)
                }
                
                Text("Description description description description description description description description description description description description description description description description description description description")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.ypBlack)
                    .padding(.top, 20)
                    .padding(.trailing, 2) // Extra padding to make it 18px in total (via figma)
                
                Text("Link to website")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.ypUBlue)
                    .padding(.top, 8)
                
                nftMenu
                    .padding(.top, 40)
                
                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal, 16)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.ypBlack)
                    }
                }
            }
        }
    }
    
    private var nftMenu: some View {
        VStack {
            nftMenuRow
            nftMenuRow
        }
    }
    
    private var nftMenuRow: some View {
        HStack(spacing: .zero) {
            Text("My NFTs")
                .font(.system(size: 17, weight: .bold))
                .padding(.vertical, 16)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 17, weight: .medium))
        }
    }
    
    private func editTapped() {
        print("Edit tapped")
    }
}

#Preview {
    ProfileView()
}
