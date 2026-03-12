import SwiftUI

struct TabBarView: View {
    
    private enum TabBarIcon {
        static let catalog = "square.stack.3d.up.fill"
        static let profile = "person.crop.circle.fill"
    }
    
    var body: some View {
        TabView {
            TestCatalogView()
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.catalog", comment: ""),
                        systemImage: TabBarIcon.catalog
                    )
                }
                .backgroundStyle(.background)
            ProfileView()
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.profile", comment: ""),
                        systemImage: TabBarIcon.profile
                    )
                }
                .backgroundStyle(.background)
        }
    }
}
