//
//  PaymentViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 23.03.2026.
//

import Foundation

@MainActor
@Observable
final class PaymentViewModel {
    
    enum State: Equatable {
        case idle
        case loading
        case success
        case error(String)
    }
    
    // MARK: - State
    
    var state: State = .idle
    var selectedMethodID: String?
    var paymentMethods: [PaymentMethod] = PaymentMethod.mock
    
    // MARK: - UI State (derived)
    
    var isLoading: Bool {
        state == .loading
    }
    
    var errorMessage: String? {
        if case let .error(message) = state {
            return message
        }
        return nil
    }
    
    var isSuccess: Bool {
        state == .success
    }
    
    var canPay: Bool {
        selectedMethodID != nil && state != .loading
    }
    
    // MARK: - Dependencies
    
    private let networkClient: NetworkClient
    
    // MARK: - Init
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - Load currencies
    
    func loadCurrencies() async {
        guard paymentMethods == PaymentMethod.mock else { return }
        
        do {
            let request = CurrenciesRequest()
            let currencies: [CurrencyResponse] = try await networkClient.send(request: request)
            
            var result: [PaymentMethod] = []
            var seen = Set<String>()
            
            for currency in currencies {
                guard !seen.contains(currency.id) else { continue }
                seen.insert(currency.id)
                
                let existing = PaymentMethod.mock.first { $0.code == currency.name }
                
                result.append(
                    PaymentMethod(
                        id: currency.id,
                        title: currency.title,
                        code: currency.name,
                        imageName: existing?.imageName ?? currency.name
                    )
                )
            }
            
            if !result.isEmpty {
                let mockOrder = PaymentMethod.mock.map { $0.id }
                paymentMethods = result.sorted { first, second in
                    guard let firstIndex = mockOrder.firstIndex(of: first.id),
                          let secondIndex = mockOrder.firstIndex(of: second.id) else {
                        return false
                    }
                    return firstIndex < secondIndex
                }
            }
            
        } catch {
            print("❌ currencies error: \(error)")
        }
    }
    
    // MARK: - Pay
    
    func pay() async {
        guard let methodID = selectedMethodID else {
            state = .error("Выберите способ оплаты")
            return
        }
        
        state = .loading
        
        do {
            let order: Order = try await networkClient.send(request: OrderRequest())
            
            guard !order.nfts.isEmpty else {
                state = .error("Корзина пуста")
                return
            }
            
            print("💰 Order contains: \(order.nfts.count) items")
            
            let paymentRequest = PaymentCurrencyRequest(currencyId: methodID)
            let paymentResponse: PaymentResponse = try await networkClient.send(request: paymentRequest)
            
            if paymentResponse.success {
                print("💰 Currency selected: \(paymentResponse.id)")
                
                let executeRequest = ExecuteOrderRequest(nfts: order.nfts)
                let _: Order = try await networkClient.send(request: executeRequest)
                
                print("✅ Order executed")
                
                let clearRequest = ClearCartRequest()
                let clearedOrder: Order = try await networkClient.send(request: clearRequest)
                
                print("🗑️ Cart cleared, orderId: \(clearedOrder.id)")
                state = .success
            } else {
                state = .error("Ошибка выбора валюты")
            }
            
        } catch let error as NetworkClientError {
            handle(error)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func retry() async {
        state = .idle
        await pay()
    }
    
    func resetError() {
        if case .error = state {
            state = .idle
        }
    }
    
    func reset() {
        state = .idle
        selectedMethodID = nil
    }
    
    private func handle(_ error: NetworkClientError) {
        switch error {
        case .parsingError:
            state = .error("Ошибка обработки ответа")
        case .urlSessionError:
            state = .error("Нет интернета")
        case .httpStatusCode(let code):
            state = .error("Ошибка сервера: \(code)")
        default:
            state = .error("Неизвестная ошибка")
        }
    }
}
