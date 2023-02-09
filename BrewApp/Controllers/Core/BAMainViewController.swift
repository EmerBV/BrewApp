//
//  BAMainViewController.swift
//  BrewApp
//
//  Created by Emerson Balahan Varona on 8/2/23.
//

import UIKit

class BAMainViewController: UIViewController {
    
    private let table: UITableView = {
        let table = UITableView()
        table.register(BABeerTableViewCell.self, forCellReuseIdentifier: BABeerTableViewCell.identifier)
        return table
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var beers: [BABeer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beers"
        view.backgroundColor = .systemBackground
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        fetchBeers()
        view.addSubview(spinner)
        spinner.center = view.center
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
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
                    self?.table.reloadData()
                    print(beers.count)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension BAMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: BABeerTableViewCell.identifier, for: indexPath) as? BABeerTableViewCell else {
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
        
        guard let beerName = beer.name ?? beer.name else {
            return
        }
        
        URLSession.shared.getBeer(with: beerName) { [weak self] result in
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

