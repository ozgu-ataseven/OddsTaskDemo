//
//  OddEventDataSource.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 20.05.2025.
//

import UIKit
import Combine

final class OddEventDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private var items: [OddEvent] = []
    private let selectionSubject = PassthroughSubject<OddEvent, Never>()

    var selectionPublisher: AnyPublisher<OddEvent, Never> {
        selectionSubject.eraseToAnyPublisher()
    }

    func update(with events: [OddEvent]) {
        self.items = events
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OddEventCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: items[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let event = item(at: indexPath) else { return }
        selectionSubject.send(event)
    }
}

// MARK: - Helper
extension OddEventDataSource {
    func item(at indexPath: IndexPath) -> OddEvent? {
        guard items.indices.contains(indexPath.row) else { return nil }
        return items[indexPath.row]
    }
}
