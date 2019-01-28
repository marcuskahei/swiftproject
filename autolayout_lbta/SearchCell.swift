//
//  SearchCell.swift
//  autolayout_lbta
//
//  Created by marcus.man on 24/1/2019.
//  Copyright © 2019 Lets Build That App. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    let itemLabel: UILabel = {
        let itemLabel = UILabel()
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.text = "testing"
        itemLabel.frame = CGRect(x: 0, y:0, width: 40, height: 20)
        return itemLabel
    }()
    
    let itemImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "bear_first"))
        // this enables autolayout for our imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUp() {
        addSubview(itemLabel)
        addSubview(itemImageView)
        setupLayout()
    }
    
    private func setupLayout() {
        
        itemLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        itemLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        itemLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        
        itemImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        itemImageView.leftAnchor.constraint(equalTo: itemLabel.rightAnchor, constant: 20).isActive = true
        itemImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        
    }

    
}
