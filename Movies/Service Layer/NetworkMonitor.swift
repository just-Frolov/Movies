//
//  NetworkMonitor.swift
//  Movies
//
//  Created by Данил Фролов on 20.01.2022.
//

import Network
import Foundation

final class NetworkMonitor {
    //MARK: - Static -
    static let shared = NetworkMonitor()
    
    //MARK: - Constants -
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    //MARK: - Variables -
    internal private(set) var isConnected: Bool = false
    
    //MARK: - Life Cycle -
    private init() {
        monitor = NWPathMonitor()
    }
    
    //MARK: - Internal -
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            NotificationCenter.default.post(name: Notification.Name.networkStatusWasChanged,
                                            object: nil)
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
