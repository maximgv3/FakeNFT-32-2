//
//  SkeletonCartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 14.03.2026.
//

import SwiftUI

// MARK: - SkeletonCartView

struct SkeletonCartView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Список скелетон-ячеек
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { index in
                        SkeletonCartCell()
                            .padding(.top, index == 0 ? 20 : 8)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 8)
                    }
                }
            }
            .scrollDisabled(true)
            
            // Скелетон футера
            SkeletonFooterView()
        }
        .background(Color("ypWhite"))
    }
}

// MARK: - SkeletonCartCell

struct SkeletonCartCell: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Заглушка изображения
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 108, height: 108)
                .overlay(shimmerOverlay)
            
            VStack(alignment: .leading, spacing: 8) {
                // Заглушка названия и рейтинга
                VStack(alignment: .leading, spacing: 4) {
                    // Название
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 100, height: 20)
                        .overlay(shimmerOverlay)
                    
                    // Рейтинг (5 звезд)
                    HStack(spacing: 2) {
                        ForEach(0..<5) { _ in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 12, height: 12)
                                .overlay(shimmerOverlay)
                        }
                    }
                }
                .frame(height: 38, alignment: .top)
                
                // Заглушка цены
                VStack(alignment: .leading, spacing: 2) {
                    Text("Цена")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 24)
                        .overlay(shimmerOverlay)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Заглушка кнопки удаления
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 40)
                .overlay(shimmerOverlay)
        }
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }
    
    private var shimmerOverlay: some View {
        GeometryReader { geometry in
            LinearGradient(
                colors: [
                    .clear,
                    .white.opacity(0.5),
                    .clear
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
        }
    }
}

// MARK: - SkeletonFooterView

struct SkeletonFooterView: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                // Заглушка "3 NFT"
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 18)
                    .overlay(shimmerOverlay)
                
                // Заглушка цены
                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 50, height: 22)
                        .overlay(shimmerOverlay)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 30, height: 22)
                        .overlay(shimmerOverlay)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Заглушка кнопки "К оплате"
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 240, height: 44)
                .overlay(shimmerOverlay)
        }
        .padding(.horizontal, 16)
        .frame(height: 76)
        .background(Color("ypLightGrey"))
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 12,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 12
            )
        )
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }
    
    private var shimmerOverlay: some View {
        GeometryReader { geometry in
            LinearGradient(
                colors: [
                    .clear,
                    .white.opacity(0.5),
                    .clear
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
        }
    }
}

// MARK: - Preview

#Preview("Skeleton Cart") {
    SkeletonCartView()
}
