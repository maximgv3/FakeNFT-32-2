//
//  RatingView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 12.03.2026.
//

import SwiftUI

/// Компонент для отображения рейтинга NFT (звездочки)
struct RatingView: View {
    
    // MARK: - Properties
    
    /// Рейтинг от 1 до 5
    let rating: Int
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                starImage(for: index)
            }
        }
    }
    
    // MARK: - Private Views
    
    /// Изображение звезды (заполненная или пустая)
    private func starImage(for index: Int) -> some View {
        Image(systemName: index <= rating ? "star.fill" : "star")
            .foregroundStyle(Color("ypUYellow"))
            .font(.caption)
    }
}

// MARK: - Preview

#Preview("Rating 5") {
    RatingView(rating: 5)
        .padding()
        .background(Color("ypWhite"))
}

#Preview("Rating 3") {
    RatingView(rating: 3)
        .padding()
        .background(Color("ypWhite"))
}

#Preview("Rating 0") {
    RatingView(rating: 0)
        .padding()
        .background(Color("ypWhite"))
}
