//
//  DeleteCartItemView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 14.03.2026.
//

import SwiftUI

struct DeleteCartItemView: View {
    let item: CartItem
    var isDeleting: Bool = false
    let onDelete: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: item.imageURL) { phase in
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

                case .failure:
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 108, height: 108)
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        }

                @unknown default:
                    EmptyView()
                }
            }

            Text("Вы уверены, что хотите удалить объект из корзины?")
                .font(.system(size: 13, weight: .regular))
                .multilineTextAlignment(.center)
                .foregroundColor(Color("ypBlack"))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 8) {
                Button(action: onDelete) {
                    ZStack {
                        Text("Удалить")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(Color("ypURed"))
                            .opacity(isDeleting ? 0 : 1)

                        if isDeleting {
                            ProgressView()
                                .tint(.white)
                        }
                    }
                    .frame(width: 140, height: 44)
                    .background(Color("ypBlack"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(isDeleting)

                Button(action: onCancel) {
                    Text("Вернуться")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(Color("ypWhite"))
                        .frame(width: 140, height: 44)
                        .background(Color("ypBlack"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(isDeleting)
            }
        }
        .frame(maxWidth: 320)
        .padding(.horizontal, 24)
    }
}

#Preview("Delete Item") {
    ZStack {
        Rectangle()
            .fill(.ultraThinMaterial)
            .ignoresSafeArea()
            .overlay(
                Color.black.opacity(0.16)
            )

        DeleteCartItemView(
            item: .mock1,
            isDeleting: false,
            onDelete: {},
            onCancel: {}
        )
    }
}
