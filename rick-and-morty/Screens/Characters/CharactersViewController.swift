//
//  ViewController.swift
//  training
//
//  Created by Anvar Kayumov on 02/12/23.
//

import UIKit
import Combine

class CharactersViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Int, RCharacter>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, RCharacter>
    static let cellID: String = "CharacterCellID"

    private let viewModel: CharactersViewModel
    private lazy var router = CharactersRouter(navigationController)

    private var cancellables = Set<AnyCancellable>()
    private var dataSource: DataSource?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewLayout.makeGridCollectionLayout(itemsInRow: 3)
        var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CharacterViewCell.self, forCellWithReuseIdentifier: Self.cellID)
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self

        return collectionView
    }()

    // MARK: - Init

    init(viewModel: CharactersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Characters"

        setupSubviews()
        setupDataSource()
        setupBindings()
        viewModel.onViewDidLoad()
    }

    // MARK: - Setup

    private func setupBindings() {
        viewModel.characterModels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] models in
                self?.applyDataSource(models)
            }
            .store(in: &cancellables)
    }

    private func setupSubviews() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - DataSource

extension CharactersViewController {
    private func setupDataSource() {
        dataSource = makeDataSource()
        collectionView.dataSource = dataSource!
    }

    private func applyDataSource(_ models: [RCharacter]) {
        var snapshot = Snapshot()
        snapshot.appendSections([1])
        snapshot.appendItems(models, toSection: 1)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, cellModel) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.cellID, for: indexPath)
            guard let cell = cell as? CharacterViewCell else { return UICollectionViewCell() }

            cell.applyModel(cellModel)

            return cell
        })

        return dataSource
    }
}

// MARK: - UICollectionViewDelegate

extension CharactersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row == viewModel.characterModels.value.count - 1 else { return }
        viewModel.fetchNextPage()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModel.characterModels.value[indexPath.row]
        router.openCharacterDetailsScreen(with: model.id)
    }
}
