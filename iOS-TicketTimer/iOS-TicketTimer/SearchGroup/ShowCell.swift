//
//  ShowCell.swift
//  iOS-TicketTimer
//
//  Created by Jinhyung Park on 2023/08/02.
//

import UIKit

class ShowCell: UICollectionViewCell {
    
    @IBOutlet weak var musicalThumbnail: UIImageView!
    @IBOutlet weak var site: UIImageView!
    @IBOutlet weak var musicalTitle: UILabel!
    @IBOutlet weak var musicalPlace: UILabel!
    @IBOutlet weak var musicalDate: UILabel!
    @IBOutlet weak var ticketing: UIButton!
    
    func configure(_ item: Data) {
        musicalThumbnail.image = UIImage(named: item.imageName)
        site.image = UIImage(named: item.interpark)
        musicalTitle.text = item.title
        musicalPlace.text = item.place
        musicalDate.text = item.date
    }
}
