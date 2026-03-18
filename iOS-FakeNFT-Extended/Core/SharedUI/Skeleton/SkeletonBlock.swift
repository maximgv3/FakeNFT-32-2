//
//  SkeletonBlock.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 19.03.2026.
//

import SwiftUI

// MARK: - SkeletonBlock

/// Базовый компонент для создания скелетон-эффекта
struct SkeletonBlock: View {
    let cornerRadius: CGFloat
    var isCircle: Bool = false

    @State private var offsetX: CGFloat = -200

    var body: some View {
        ZStack {
            if isCircle {
                Circle()
                    .fill(Color.gray.opacity(0.3))
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.gray.opacity(0.3))
            }

            GeometryReader { geometry in
                LinearGradient(
                    colors: [
                        .clear,
                        .white.opacity(0.45),
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: geometry.size.width * 0.8)
                .offset(x: offsetX)
                .onAppear {
                    offsetX = -geometry.size.width
                    withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                        offsetX = geometry.size.width
                    }
                }
            }
        }
        .mask {
            if isCircle {
                Circle()
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
            }
        }
    }
}

// MARK: - Preview

#Preview("SkeletonBlock Rectangle") {
    SkeletonBlock(cornerRadius: 12)
        .frame(width: 100, height: 100)
        .padding()
}

#Preview("SkeletonBlock Circle") {
    SkeletonBlock(cornerRadius: 20, isCircle: true)
        .frame(width: 40, height: 40)
        .padding()
}
