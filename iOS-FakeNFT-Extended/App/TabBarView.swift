import SwiftUI

struct TabBarView: View {
    @Environment(ServicesAssembly.self) private var servicesAssembly
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
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
            
            NavigationStack {
                CartView(
                    viewModel: CartViewModel(
                        cartService: servicesAssembly.cartService
                    )
                )
            }
            .tabItem {
                VStack {
                    Image("cartTabItem")
                        .renderingMode(.template)
                    Text("Корзина")
                }
            }
            .tag(2)
            
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
    let services = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )
    
    return TabBarView()
        .environment(services)
}
