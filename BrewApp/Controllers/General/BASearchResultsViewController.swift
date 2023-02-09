//
//  BASearchResultsViewController.swift
//  BrewApp
//
//  Created by Emerson Balahan Varona on 8/2/23.
//

import UIKit

protocol BASearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: BABeerPreviewViewModel)
}

class BASearchResultsViewController: UIViewController {
    
    public var beers: [BABeer] = []
    
    public weak var delegate: BASearchResultsViewControllerDelegate?
    
    public let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BABeerCollectionViewCell.self, forCellWithReuseIdentifier: BABeerCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
    
}

extension BASearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return beers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BABeerCollectionViewCell.identifier, for: indexPath) as? BABeerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let beer = beers[indexPath.row]
        let beerName = beer.name
        let beerImageUrl = beer.image_url
        
        cell.configure(with: BABeer(name: beerName, beer_name: nil, description: nil, image_url: beerImageUrl))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let beer = beers[indexPath.row]
        let beerName = beer.name ?? ""
        let beerImageUrl = beer.image_url
        let beerDescription = beer.description ?? ""
        
        URLSession.shared.getBeer(with: beerName) { [weak self] result in
            switch result {
            case .success(_):
                self?.delegate?.searchResultsViewControllerDidTapItem(BABeerPreviewViewModel(name: beerName, image_url: beerImageUrl, description: beerDescription))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}


