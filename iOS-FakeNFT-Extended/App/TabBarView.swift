import SwiftUI

struct TabBarView: View {
    @Environment(ServicesAssembly.self) private var servicesAssembly
    @State private var selectedTab: AppTab = .profile

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                NavigationStack {
                    content(for: tab)
                }
                .tabItem {
                    Image(tab.imageName)
                    Text(tab.title)
                }
                .tag(tab)
            }
        }
        .tint(.ypUBlue)
    }

    @ViewBuilder
    private func content(for tab: AppTab) -> some View {
        switch tab {
        case .profile:
            ProfileView()
        case .catalog:
            TestCatalogView()
        case .cart:
            CartView(viewModel: CartViewModel(cartService: servicesAssembly.cartService))
        }
    }
}

private enum AppTab: CaseIterable {
    case profile
    case catalog
    case cart

    var title: String {
        switch self {
        case .profile:
            "Профиль"
        case .catalog:
            "Каталог"
        case .cart:
            "Корзина"
        }
    }

    var imageName: String {
        switch self {
        case .profile:
            "profile"
        case .catalog:
            "catalog"
        case .cart:
            "cartTabItem"
        }
    }
}
