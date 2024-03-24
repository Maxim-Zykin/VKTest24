//
//  VisualizationCell.swift
//  VKTest24
//
//  Created by Максим Зыкин on 23.03.2024.
//

import UIKit

class VisualizationCell: UICollectionViewCell {
    
    static let cellID = "VisualizationCell"
    
    @IBOutlet weak var labelName: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.layer.cornerRadius = contentView.frame.size.width / 4
        contentView.clipsToBounds = true
        contentView.layer.borderColor = CGColor(gray: 0.5, alpha: 0.5)
        contentView.layer.borderWidth = 1.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        labelName.sizeToFit()
        labelName.center = contentView.center
    }
    
    override func prepareForReuse() {
        contentView.backgroundColor = .white
        labelName.text = ""
    }
    
    func configureCell(person: Person) {
        labelName.text = person.name
        contentView.backgroundColor = person.healthy ? .green : .red
    }
}
