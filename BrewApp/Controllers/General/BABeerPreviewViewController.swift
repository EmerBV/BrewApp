//
//  BABeerPreviewViewController.swift
//  BrewApp
//
//  Created by Emerson Balahan Varona on 8/2/23.
//

import UIKit

class BABeerPreviewViewController: UIViewController {
    
    private let beerViewUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.80, green: 0.64, blue: 0.00, alpha: 1.00)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(beerViewUIImageView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        
        configureConstraints()
    }
    
    func configureConstraints() {
        let beerViewUIImageViewConstraints = [
            beerViewUIImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            beerViewUIImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            beerViewUIImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            beerViewUIImageView.heightAnchor.constraint(equalToConstant: 200)
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: beerViewUIImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
        
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            overviewLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(beerViewUIImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
    }
    
    func configure(with model: BABeerPreviewViewModel) {
        titleLabel.text = model.name
        overviewLabel.text = model.description
        
        guard let url = URL(string: "\(model.image_url)") else {
            return
        }
        
        beerViewUIImageView.sd_setImage(with: url, completed: nil)
    }
}

