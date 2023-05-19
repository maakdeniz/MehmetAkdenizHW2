//
//  NewsTableViewCell.swift
//  NYTimesTopNews
//
//  Created by Mehmet Akdeniz on 16.05.2023.
//

import UIKit
import NYTimesAPI
import Kingfisher

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var storyTitleLabel: UILabel!
    @IBOutlet weak var storyAbstractLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
    
    //MARK: Function Definations
    func setCellWithValuesOf(_ story: StoryResult) {
        updateUI(
                title: story.title,
                abstrack: story.byline,
                imageUrl: story.multimedia[0].url
                )
    }
    
    func setCellWithValuesOfFavorite(_ story: FavoriteStory) {
        updateUI(
                title: story.title,
                abstrack: story.abstract,
                imageUrl: story.imageUrl
                )
    }

    
    func updateUI(title: String?,abstrack: String?,imageUrl: String?){
        self.storyTitleLabel.text = title
        self.storyAbstractLabel.text = abstrack
        
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else { return }
        
        if let imageView = self.storyImageView {
            imageView.kf.setImage(with: url)
        }
    }

}
