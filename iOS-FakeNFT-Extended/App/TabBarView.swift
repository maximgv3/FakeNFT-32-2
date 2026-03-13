import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            CatalogView()
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.catalog", comment: ""),
                        image: "catalog"
                    )
                }
                .backgroundStyle(.background)
        }
    }
}
