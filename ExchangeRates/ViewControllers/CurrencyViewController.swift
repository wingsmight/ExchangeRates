//
//  CurrencyViewController.swift
//  ExchangeRates
//
//  Created by Igoryok
//

import UIKit

final class CurrencyViewController: UITableViewController {
    private let apiService = CurrencyAPIService()
    private let cacheService = CurrencyCacheService()
    private var repository: CurrencyRepository? = nil

    private let currencyView = CurrencyListView()
    private let searchController = UISearchController(searchResultsController: nil)

    private var rates: [(String, Double)] = []
    private var filteredRates: [(String, Double)] = []
    private var isSortedByNameAscending = true
    private var isSortedByRateAscending = true
    private var refreshTimer: Timer?

    deinit {
        refreshTimer?.invalidate()
    }

    override func loadView() {
        view = currencyView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        repository = CurrencyRepository(apiService: apiService, cacheService: cacheService)

        navigationItem.title = NSLocalizedString("Currency Rates", comment: "Currency rates navigation title")

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "Search navigation bar")
        searchController.hidesNavigationBarDuringPresentation = false

        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController

        definesPresentationContext = true

        let sortByNameItem = UIBarButtonItem(title: "🔤", style: .plain, target: self, action: #selector(toggleSortByName))
        let sortByRateItem = UIBarButtonItem(title: "💲", style: .plain, target: self, action: #selector(toggleSortByRate))
        navigationItem.rightBarButtonItems = [sortByRateItem, sortByNameItem]

        currencyView.tableView.dataSource = self
        currencyView.refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)

        fetchRates()
        startAutoRefresh()
    }

    @objc private func refresh(_: AnyObject) {
        fetchRates()
    }

    @objc private func toggleSortByName() {
        isSortedByNameAscending.toggle()
        filteredRates.sort { isSortedByNameAscending ? $0.0 < $1.0 : $0.0 > $1.0 }
        currencyView.tableView.reloadData()
    }

    @objc private func toggleSortByRate() {
        isSortedByRateAscending.toggle()
        filteredRates.sort { isSortedByRateAscending ? $0.1 < $1.1 : $0.1 > $1.1 }
        currencyView.tableView.reloadData()
    }

    private func fetchRates() {
        repository?.getRates { [weak self] result in
            switch result {
            case let .success(rates):
                self?.displayRates(rates)
            case let .failure(failure):
                if case let .noInternet(rates) = failure {
                    self?.displayRates(rates)
                }

                self?.showErrorAlert()
            }

            self?.currencyView.refreshControl.endRefreshing()
        }
    }

    private func displayRates(_ rates: [String: Double]) {
        self.rates = rates.sorted { $0.key < $1.key }
        filteredRates = self.rates
        currencyView.tableView.reloadData()
        updateVisibleCells()
    }

    private func updateVisibleCells() {
        DispatchQueue.main.async { [weak self] in
            for cell in self?.currencyView.tableView.visibleCells ?? [] {
                if let currencyCell = cell as? CurrencyCell {
                    currencyCell.triggerFadeTransition()
                }
            }
        }
    }

    private func showErrorAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error"),
                                      message: NSLocalizedString("Cannot load the data", comment: "No data"),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: "Retry"),
                                      style: .default)
            { [weak self] _ in
                self?.fetchRates()
            })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"),
                                      style: .cancel)
            { [weak self] _ in
                self?.currencyView.refreshControl.endRefreshing()
                UIView.animate(withDuration: 0.5, animations: {
                    self?.currencyView.tableView.contentOffset = CGPoint.zero
                })
            })

        present(alert, animated: true)
    }

    private func startAutoRefresh() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: Constants.refreshRateSeconds, repeats: true) { [weak self] _ in
            self?.fetchRates()
        }
    }
}

// MARK: - Constants

extension CurrencyViewController {
    private enum Constants {
        static let refreshRateSeconds = TimeInterval(30)
    }
}

// MARK: - UITableViewDataSource

extension CurrencyViewController {
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        filteredRates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.identifier) ?? CurrencyCell(style: .subtitle, reuseIdentifier: CurrencyCell.identifier)
        let (currency, rate) = filteredRates[indexPath.row]
        (cell as? CurrencyCell)?.configure(with: currency, rate: rate)
        return cell
    }
}

// MARK: - UISearchResultsUpdating

extension CurrencyViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredRates = rates
            currencyView.tableView.reloadData()
            return
        }

        filteredRates = rates.filter { $0.0.lowercased().contains(searchText.lowercased()) }
        currencyView.tableView.reloadData()
    }
}
