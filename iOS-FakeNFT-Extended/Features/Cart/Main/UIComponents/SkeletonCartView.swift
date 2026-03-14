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

            SkeletonFooterView()
        }
        .background(Color("ypWhite"))
    }
}

// MARK: - SkeletonCartCell

struct SkeletonCartCell: View {
    var body: some View {
        HStack(spacing: 16) {
            SkeletonBlock(cornerRadius: 12)
                .frame(width: 108, height: 108)

            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 6) {
                    SkeletonBlock(cornerRadius: 4)
                        .frame(width: 100, height: 20)

                    SkeletonBlock(cornerRadius: 4)
                        .frame(width: 70, height: 12)
                }
                .frame(height: 38, alignment: .top)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Цена")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.gray.opacity(0.5))

                    SkeletonBlock(cornerRadius: 4)
                        .frame(width: 80, height: 24)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            SkeletonBlock(cornerRadius: 20, isCircle: true)
                .frame(width: 40, height: 40)
        }
    }
}

// MARK: - SkeletonFooterView

struct SkeletonFooterView: View {
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                SkeletonBlock(cornerRadius: 4)
                    .frame(width: 60, height: 18)

                HStack(spacing: 0) {
                    SkeletonBlock(cornerRadius: 4)
                        .frame(width: 80, height: 22)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            SkeletonBlock(cornerRadius: 16)
                .frame(width: 240, height: 44)
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
    }
}

// MARK: - SkeletonBlock

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

#Preview("Skeleton Cart") {
    SkeletonCartView()
}
