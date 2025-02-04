//
//  CurrencyCell.swift
//  ExchangeRates
//
//  Created by Igoryok
//

import UIKit

final class CurrencyCell: UITableViewCell {
    static let identifier = "CurrencyCell"

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        return stackView
    }()

    private lazy var symbolIcon: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        label.backgroundColor = .systemOrange
        label.textColor = .white

        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true

        return label
    }()

    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        
        return label
    }()

    private lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .label
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(with currency: String, rate: Double) {
        symbolLabel.text = currency
        rateLabel.text = "$\(String(format: "%.2f", rate))"
        symbolIcon.text = currency.currencySymbol
    }
    
    func triggerFadeTransition() {
        rateLabel.fadeTransition(1.5)
    }

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(horizontalStackView)

        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(rateLabel)

        verticalStackView.addArrangedSubview(symbolIcon)
        verticalStackView.addArrangedSubview(symbolLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            horizontalStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            symbolIcon.widthAnchor.constraint(equalToConstant: 60),
            symbolIcon.heightAnchor.constraint(equalToConstant: 40),

            symbolLabel.widthAnchor.constraint(equalToConstant: 60),

            rateLabel.trailingAnchor.constraint(equalTo: horizontalStackView.trailingAnchor, constant: -10),
        ])
    }
}
