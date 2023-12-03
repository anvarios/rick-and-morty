//
//  CharacterDetailsViewController.swift
//  training
//
//  Created by Anvar Kayumov on 04/12/23.
//

import UIKit
import Combine

final class CharacterDetailsViewController: UIViewController {

    private let viewModel: CharacterDetailsViewModel
    private var cancellables = Set<AnyCancellable>()

    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 40)

        return label
    }()

    // MARK: - Init

    init(viewModel: CharacterDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupSubviews()
        setupBindings()
        viewModel.onViewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        viewModel.cancelImageDownloading()
    }

    private func setupBindings() {
        viewModel.characterModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let model = model else { return }
                self?.setCharacter(model)
            }
            .store(in: &cancellables)
    }

    private func setCharacter(_ model: RCharacter) {
        titleLabel.text = model.name
        downloadImage(from: model.image)
    }

    private func downloadImage(from url: URL?) {
        guard let url = url else { return }

        viewModel.downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }

    private func setupSubviews() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor)
        ])
    }
}
