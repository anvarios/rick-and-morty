//
//  CharacterViewCell.swift
//  training
//
//  Created by Anvar Kayumov on 03/12/23.
//

import UIKit

final class CharacterViewCell: UICollectionViewCell {

    private let viewModel = CharacterViewCellViewModel(imageDownloader: ImageDownloader())

    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyModel(_ model: RCharacter) {
        downloadImage(from: model.image)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        viewModel.cancelImageDownloading()
    }

    private func setupSubviews() {
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    private func downloadImage(from url: URL?) {
        guard let url = url else { return }

        viewModel.downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
}
