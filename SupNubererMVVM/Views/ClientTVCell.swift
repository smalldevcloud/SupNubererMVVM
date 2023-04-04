//
//  ClientTVCell.swift
//  SupNubererMVVM
//
//  Created by cloud8 on 4.04.23.
//

import UIKit

class ClientTVCell: UITableViewCell {
    
    static let identifier = "clientsTVCell"
    
    var callButtonHandler:(()->())?
    
    @IBOutlet weak var clientName: UILabel!
    
    @IBOutlet weak var clientNumber: UILabel!

    @IBAction func callBtnPressed(_ sender: Any) {
        callButtonHandler?()
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
