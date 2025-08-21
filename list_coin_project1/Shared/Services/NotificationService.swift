//
//  NotificationService.swift
//  CryptoMarketApp
//
//  Created by Caio Zini on 22/10/23.
//  Copyright © 2023 Camila Fernandes. All rights reserved.
//

import UserNotifications
import Foundation

final class NotificationService: NSObject, ObservableObject {
    
    // MARK: - Singleton
    static let shared = NotificationService()
    
    // MARK: - Published Properties
    @Published var isAuthorized = false
    
    // MARK: - Private Properties
    private let notificationCenter = UNUserNotificationCenter.current()
    private let priceThresholds: [String: PriceThreshold] = [:]
    
    // MARK: - Private Initializer
    private override init() {
        super.init()
        notificationCenter.delegate = self
        checkAuthorizationStatus()
    }
    
    // MARK: - Authorization
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.isAuthorized = granted
            }
            
            if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
        }
    }
    
    private func checkAuthorizationStatus() {
        notificationCenter.getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    // MARK: - Price Alerts
    func schedulePriceAlert(for crypto: CryptoCurrency, targetPrice: Double, isAbove: Bool) {
        let content = UNMutableNotificationContent()
        content.title = "Alerta de Preço - \(crypto.name)"
        content.body = "\(crypto.symbol.uppercased()) atingiu $\(String(format: "%.2f", targetPrice))"
        content.sound = .default
        content.badge = 1
        
        // Create unique identifier for this alert
        let identifier = "price_alert_\(crypto.id)_\(targetPrice)_\(isAbove)"
        
        // Create trigger (check every 5 minutes)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: true)
        
        // Create request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Schedule notification
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling price alert: \(error)")
            } else {
                print("Price alert scheduled for \(crypto.name)")
            }
        }
    }
    
    func schedulePercentageChangeAlert(for crypto: CryptoCurrency, percentageChange: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Mudança Significativa - \(crypto.name)"
        
        let changeText = percentageChange >= 0 ? "subiu" : "caiu"
        let absPercentage = abs(percentageChange)
        content.body = "\(crypto.symbol.uppercased()) \(changeText) \(absPercentage, specifier: "%.2f")% em 24h"
        content.sound = .default
        content.badge = 1
        
        let identifier = "percentage_alert_\(crypto.id)_\(percentageChange)"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling percentage alert: \(error)")
            }
        }
    }
    
    // MARK: - Market Update Notifications
    func scheduleMarketUpdateNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Atualização do Mercado"
        content.body = "Novos dados de criptomoedas disponíveis"
        content.sound = .default
        
        // Schedule for every hour
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true)
        let request = UNNotificationRequest(identifier: "market_update", content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling market update: \(error)")
            }
        }
    }
    
    // MARK: - Portfolio Alerts
    func schedulePortfolioAlert(totalValue: Double, changePercentage: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Resumo do Portfólio"
        
        let changeText = changePercentage >= 0 ? "cresceu" : "diminuiu"
        let absPercentage = abs(changePercentage)
        content.body = "Seu portfólio \(changeText) \(absPercentage, specifier: "%.2f")%. Valor total: $\(String(format: "%.2f", totalValue))"
        content.sound = .default
        
        // Schedule for daily at 9 AM
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "portfolio_summary", content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling portfolio alert: \(error)")
            }
        }
    }
    
    // MARK: - Custom Alerts
    func scheduleCustomAlert(title: String, body: String, timeInterval: TimeInterval = 60) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let identifier = "custom_alert_\(UUID().uuidString)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling custom alert: \(error)")
            }
        }
    }
    
    // MARK: - Remove Notifications
    func removeAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
    }
    
    func removeNotification(withIdentifier identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])
    }
    
    // MARK: - Get Scheduled Notifications
    func getScheduledNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        notificationCenter.getPendingNotificationRequests { requests in
            completion(requests)
        }
    }
    
    func getDeliveredNotifications(completion: @escaping ([UNNotification]) -> Void) {
        notificationCenter.getDeliveredNotifications { notifications in
            completion(notifications)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension NotificationService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification tap
        let identifier = response.notification.request.identifier
        
        // Handle different notification types
        if identifier.contains("price_alert") {
            // Navigate to specific crypto detail
            print("Price alert tapped for: \(identifier)")
        } else if identifier.contains("portfolio_summary") {
            // Navigate to portfolio
            print("Portfolio summary tapped")
        }
        
        completionHandler()
    }
}

// MARK: - Price Threshold
struct PriceThreshold {
    let cryptoId: String
    let targetPrice: Double
    let isAbove: Bool
    let isEnabled: Bool
}
