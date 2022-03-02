//
//  TableViewCell.swift
//  testTask
//
//  Created by Developer on 01.03.2022.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var descpript: UILabel!
    @IBOutlet weak var imageCon: UIImageView!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var name: UILabel!
    
    var imageUrl :URL?{
        didSet{
            imageCon.image = nil
            updateUI()
        }
    }
   static var imageData : Data? = nil
    private func updateUI(){
        if let url = imageUrl{
            DispatchQueue.global(qos: .userInteractive).async{
                let conUrl = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = conUrl{
                        self.imageCon.image = UIImage.init(data: imageData)
                        TableViewCell.imageData = imageData
                    }
                }
            }
        }
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
