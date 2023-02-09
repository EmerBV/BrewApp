//
//  BABeerCollectionViewCell.swift
//  BrewApp
//
//  Created by Emerson Balahan Varona on 8/2/23.
//

import UIKit

class BABeerCollectionViewCell: UICollectionViewCell {
    static let identifier = "BABeerCollectionViewCell"
    
    private let beerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(beerImageView)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        beerImageView.frame = contentView.bounds
    }
    
    public func configure(with model: BABeer) {
        guard let url = URL(string: "\(model.image_url)") else {
            return
        }
        
        beerImageView.sd_setImage(with: url, completed: nil)
    }
    
}

