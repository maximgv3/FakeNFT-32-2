import SwiftUI

struct TabBarView: View {
    @Environment(ServicesAssembly.self) private var servicesAssembly
    @State private var selectedTab: AppTab = .profile
    @State private var cartPath = NavigationPath()
    @State private var profilePath: [ProfileView.Route] = []

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                content(for: tab)
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
            NavigationStack(path: $profilePath) {
                ProfileView(path: $profilePath)
                    .toolbar(profilePath.isEmpty ? .visible : .hidden, for: .tabBar)
            }
        case .catalog:
            NavigationStack {
                CatalogView()
            }
        case .cart:
            NavigationStack(path: $cartPath) {
                CartView(
                    viewModel: CartViewModel(cartService: servicesAssembly.cartService),
                    onOpenPayment: {
                        cartPath.append(CartRoute.payment)
                    }
                )
                .navigationDestination(for: CartRoute.self) { route in
                    switch route {
                    case .payment:
                        PaymentView(
                            networkClient: servicesAssembly.networkClient,
                            onSuccess: {
                                cartPath.append(CartRoute.success)
                            }
                        )
                    case .success:
                        PaymentSuccessView {
                            cartPath = NavigationPath()
                        }
                    }
                }
                .toolbar(cartPath.isEmpty ? .visible : .hidden, for: .tabBar)
            }
        }
    }
}

private enum CartRoute: Hashable {
    case payment
    case success
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
