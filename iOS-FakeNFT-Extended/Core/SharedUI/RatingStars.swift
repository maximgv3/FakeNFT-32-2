import SwiftUI

struct RatingStars: View {
    
    let rating: Int
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { index in
                star(isFilled: index < rating)
            }
        }
        .frame(width: 68, height: 12)
    }

    private func star(isFilled: Bool) -> some View {
        Image(systemName: "star.fill")
            .resizable()
            .frame(width: 12, height: 12)
            .foregroundStyle(isFilled ? Color.ypUYellow : Color.ypLightGrey)
    }
}

#Preview {
    RatingStars(rating: 3)
}
