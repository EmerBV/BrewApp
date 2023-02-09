//
//  BASearchViewController.swift
//  BrewApp
//
//  Created by Emerson Balahan Varona on 8/2/23.
//

import UIKit

class BASearchViewController: UIViewController {
    
    private var beers: [BABeer] = []
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(BABeerTableViewCell.self, forCellReuseIdentifier: BABeerTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: BASearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Beer"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .label
        view.backgroundColor = .systemBackground
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        navigationItem.searchController = searchController
        
        fetchBeers()
        
        searchController.searchResultsUpdater = self
        view.addSubview(spinner)
        spinner.center = view.center
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    private func fetchBeers() {
        spinner.startAnimating()
        URLSession.shared.request(
            url: Constants.baseUrl,
            expecting: [BABeer].self
        ) { [weak self] result in
            switch result {
            case .success(let beers):
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                    self?.beers = beers
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension BASearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BABeerTableViewCell.identifier, for: indexPath) as? BABeerTableViewCell else {
            return UITableViewCell()
        }
        
        let beer = beers[indexPath.row]
        let beerName = beer.name
        let beerImageUrl = beer.image_url
        
        cell.configure(with: BABeer(name: beerName, beer_name: nil, description: nil, image_url: beerImageUrl))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let beer = beers[indexPath.row]
        
        guard let beerName = beer.beer_name ?? beer.name  else {
            return
        }
        
        URLSession.shared.searchBeer(with: beerName) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    let vc = BABeerPreviewViewController()
                    vc.configure(with: BABeerPreviewViewModel(name: beerName, image_url: beer.image_url, description: beer.description ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}

extension BASearchViewController: UISearchResultsUpdating, BASearchResultsViewControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let name = searchBar.text,
              !name.trimmingCharacters(in: .whitespaces).isEmpty,
              name.trimmingCharacters(in: .whitespaces).count >= 1,
              let resultsController = searchController.searchResultsController as? BASearchResultsViewController else {return}
        
        resultsController.delegate = self
        
        URLSession.shared.searchBeer(with: name) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let beers):
                    resultsController.beers = beers
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func searchResultsViewControllerDidTapItem(_ viewModel: BABeerPreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = BABeerPreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

