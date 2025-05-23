//
//  OddEventDetailDataSource.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 20.05.2025.
//

import UIKit
import Combine

final class OddEventDetailDataSource: NSObject {
    private let selectionSubject = PassthroughSubject<(Outcome, String, String, String), Never>()

    var selectionPublisher: AnyPublisher<(Outcome, String, String, String), Never> {
        selectionSubject.eraseToAnyPublisher()
    }

    private var bookmakers: [Bookmaker] = []

    func update(with newData: [Bookmaker]) {
        self.bookmakers = newData
    }

    func item(at section: Int) -> Bookmaker? {
        guard bookmakers.indices.contains(section) else { return nil }
        return bookmakers[section]
    }

    var data: [Bookmaker] {
        return bookmakers
    }
}

extension OddEventDetailDataSource: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return bookmakers.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookmaker = bookmakers[indexPath.section]
        let cell: OddEventDetailCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: bookmaker)
        cell.outcomeSelectedPublisher
            .sink { [weak self] outcome, marketKey, marketTitle in
                self?.selectionSubject.send((outcome, marketKey, marketTitle, bookmaker.title))
            }
            .store(in: &cell.cancellables)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
