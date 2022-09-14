//
//  TableViewCell.swift
//  SearchFieldNetworkRequest
//
//  Created by Apple on 03/12/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var MainLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var NetworkImage: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    func setData(data: Photo){
        TitleLabel.text = "\(String(data.title))"
        MainLabel.text = data.id
        NetworkImage.downloadImageFrom(urlString: "https://farm\(data.farm).static.flickr.com/\(data.server)/\(data.id)_\(data.secret).jpg", imageMode: .scaleAspectFit)
    }
}
