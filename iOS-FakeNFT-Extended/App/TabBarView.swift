import SwiftUI

struct TabBarView: View {
    @Environment(ServicesAssembly.self) private var servicesAssembly
    @State private var selectedTab: Tab = .profile
    
    private enum Tab: Int, CaseIterable {
        case profile
        case catalog
        case cart
        case statistics
        
        var title: String {
            switch self {
            case .profile: return "Профиль"
            case .catalog: return "Каталог"
            case .cart: return "Корзина"
            case .statistics: return "Статистика"
            }
        }
        
        var imageName: String {
            switch self {
            case .profile: return "profile"
            case .catalog: return "catalog"
            case .cart: return "cartTabItem"
            case .statistics: return "statistic"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    content(for: tab)
                        .tabItem {
                            Image(tab.imageName)
                                .renderingMode(.template)
                            Text(tab.title)
                        }
                        .tag(tab)
                }
            }
            .tint(.ypUBlue)
        }
    }
    
    @ViewBuilder
    private func content(for tab: Tab) -> some View {
        switch tab {
        case .profile:
            Color.blue.overlay(Text("Профиль").foregroundColor(.white))
            
        case .catalog:
            Color.green.overlay(Text("Каталог").foregroundColor(.white))
            
        case .cart:
            CartView(
                viewModel: CartViewModel(
                    cartService: servicesAssembly.cartService
                )
            )
            
        case .statistics:
            Color.orange.overlay(Text("Статистика").foregroundColor(.white))
        }
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
