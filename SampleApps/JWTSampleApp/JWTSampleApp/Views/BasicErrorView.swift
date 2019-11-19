//
//  ErrorView.swift
//  JWTSampleApp
//
//  Created by Martina Stremeňová on 8/20/19.
//  Copyright © 2019 Box. All rights reserved.
//

import UIKit

final class BasicErrorView: UIView {
    // MARK: - Properties

    private lazy var errorTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 0
        label.text = "Oops"
        label.textColor = UIColor.lightGray
        return label
    }()

    private lazy var errorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()

    private lazy var errorImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "error")
        return imageView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func displayError(_ error: Error) {
        errorDescriptionLabel.text = error.localizedDescription
    }
}

private extension BasicErrorView {
    func setupView() {
        backgroundColor = .white
        setupSubviews()
    }

    func setupSubviews() {
        stackView.addArrangedSubview(errorImage)
        stackView.addArrangedSubview(errorTitleLabel)
        stackView.addArrangedSubview(errorDescriptionLabel)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
            ])
    }
}
