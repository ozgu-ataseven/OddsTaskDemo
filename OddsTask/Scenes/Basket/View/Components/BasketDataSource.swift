//
//  BasketDataSource.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 22.05.2025.
//

import UIKit

final class BasketDataSource: NSObject {

    private var items: [BasketItem] = []

    func update(with newItems: [BasketItem]) {
        self.items = newItems
    }

    func item(at indexPath: IndexPath) -> BasketItem? {
        guard items.indices.contains(indexPath.row) else { return nil }
        return items[indexPath.row]
    }

    func remove(at indexPath: IndexPath) {
        guard items.indices.contains(indexPath.row) else { return }
        items.remove(at: indexPath.row)
    }

    var data: [BasketItem] {
        return items
    }
}

extension BasketDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BasketViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let item = item(at: indexPath) {
            cell.configure(with: item)
        }
        return cell
    }
}
