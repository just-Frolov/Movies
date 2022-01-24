//
//  NetworkMonitor.swift
//  Movies
//
//  Created by Данил Фролов on 20.01.2022.
//

import Network

final class NetworkMonitor {
    //MARK: - Static -
    static let shared = NetworkMonitor()
    
    //MARK: - Constants -
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    //MARK: - Variables -
    public private(set) var isConnected: Bool = false
    
    //MARK: - Life Cycle -
    private init() {
        monitor = NWPathMonitor()
    }
    
    //MARK: - Internal -
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
