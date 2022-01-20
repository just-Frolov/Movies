//
//  NetworkMonitor.swift
//  Movies
//
//  Created by Данил Фролов on 20.01.2022.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            print(self?.isConnected ?? "N/A")
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
