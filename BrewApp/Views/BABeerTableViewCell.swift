//
//  BABeerTableViewCell.swift
//  BrewApp
//
//  Created by Emerson Balahan Varona on 8/2/23.
//

import UIKit
import SDWebImage

class BABeerTableViewCell: UITableViewCell {
    
    static let identifier = "BABeerTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.80, green: 0.64, blue: 0.00, alpha: 1.00)
        return label
    }()
    
    private let beersUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        contentView.addSubview(beersUIImageView)
        contentView.addSubview(nameLabel)
        applyConstraints()
    }
    
    private func applyConstraints() {
        let beersUIImageViewConstraints = [
            beersUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            beersUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            beersUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            beersUIImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let nameLabelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: beersUIImageView.trailingAnchor, constant: 20),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(beersUIImageViewConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
    }
    
    public func configure(with model: BABeer) {
        guard let url = URL(string: "\(model.image_url)") else {
            return
        }
        
        beersUIImageView.sd_setImage(with: url, completed: nil)
        nameLabel.text = model.name
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

