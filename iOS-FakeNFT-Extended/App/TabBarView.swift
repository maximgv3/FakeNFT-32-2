import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Профиль
            Color.blue
                .overlay(Text("Профиль").foregroundColor(.white))
                .tabItem {
                    VStack {
                        Image("profile")
                            .renderingMode(.template)
                        Text("Профиль")
                    }
                }
                .tag(0)
            
            // Каталог
            Color.green
                .overlay(Text("Каталог").foregroundColor(.white))
                .tabItem {
                    VStack {
                        Image("catalog")
                            .renderingMode(.template)
                        Text("Каталог")
                    }
                }
                .tag(1)
            
            // Корзина
            NavigationStack {
                CartView()
            }
            .tabItem {
                VStack {
                    Image("cartTabItem")
                        .renderingMode(.template)
                    Text("Корзина")
                }
            }
            .tag(2)
            
            // Статистика
            Color.orange
                .overlay(Text("Статистика").foregroundColor(.white))
                .tabItem {
                    VStack {
                        Image("statistic")
                            .renderingMode(.template)
                        Text("Статистика")
                    }
                }
                .tag(3)
        }
        .tint(.ypUBlue)
    }
}

#Preview {
    TabBarView()
}
