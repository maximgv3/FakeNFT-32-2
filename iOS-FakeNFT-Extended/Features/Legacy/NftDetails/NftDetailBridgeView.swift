import SwiftUI

struct NftDetailBridgeView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController  // Меняем на UIViewController

    @Environment(ServicesAssembly.self) var servicesAssembly

    func makeUIViewController(context: Context) -> UIViewController {
        let assembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
        let nftInput = NftDetailInput(id: Constants.testNftId)
        
        // Безопасное приведение типа
        guard let nftViewController = assembly.build(with: nftInput) as? NftDetailViewController else {
            // Fallback на случай ошибки
            return UIViewController()
        }
        
        return nftViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Обновляет состояние указанного контроллера представления новой информацией из SwiftUI.
    }
}

private enum Constants {
    static let testNftId = "7773e33c-ec15-4230-a102-92426a3a6d5a"
}
