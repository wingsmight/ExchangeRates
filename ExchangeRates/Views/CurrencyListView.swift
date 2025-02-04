//
//  CurrencyListView.swift
//  ExchangeRates
//
//  Created by Igoryok
//  

import UIKit

final class CurrencyListView: UIView {
    let refreshControl = UIRefreshControl()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.refreshControl = refreshControl
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
