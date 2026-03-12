//
//  CartCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 08.03.2026.
//

import SwiftUI

struct CartCell: View {
    let cartItem: CartItem
    let removeAction: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            
            AsyncImage(url: cartItem.imageURL) { phase in
                switch phase {
                    
                case .empty:
                    ProgressView()
                        .frame(width: 108, height: 108)
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 108, height: 108)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .clipped()
                    
                case .failure:
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 108, height: 108)
                    
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(cartItem.name)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color("ypBlack"))
                        .lineLimit(1)
                    
                    RatingView(rating: cartItem.rating)
                }
                .frame(height: 38, alignment: .top)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Цена")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(Color("ypBlack"))
                    
                    Text(cartItem.priceText)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color("ypBlack"))
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: removeAction) {
                Image("cartCross")
                    .renderingMode(.template)
                    .foregroundStyle(Color("ypBlack"))
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    Group {
        CartCell(
            cartItem: .mock1,
            removeAction: { }
        )
        .padding()
        .background(Color("ypWhite"))
    }
}

struct RatingView: View {
    let rating: Int
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundStyle(Color("ypUYellow"))
                    .font(.caption)
            }
        }
    }
}
