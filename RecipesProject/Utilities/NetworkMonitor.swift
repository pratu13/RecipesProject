//
//  NetworkMonitor.swift
//  RecipesProject
//
//  Created by Pratyush on 3/17/25.
//

import Observation
import Network
import Foundation

@Observable
class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    var isConnected = true

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
