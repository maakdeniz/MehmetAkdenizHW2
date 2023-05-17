//
//  ViewController.swift
//  NYTimesTopNews
//
//  Created by Mehmet Akdeniz on 15.05.2023.
//

import UIKit
import NYTimesAPI
import SafariServices


class DetailViewController: UIViewController {
    var story: StoryResult?
    
    
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    var favoriteButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleLabel.text = story?.title
        descriptionLabel.text = story?.abstract
        authorLabel.text = story?.byline
        
        if let imageUrl = story?.multimedia[0].url,let url = URL(string: imageUrl) {
            storyImageView.kf.setImage(with: url)
        }
        
        navigationItem.title = "NYTimes Top News"
        
        favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"),style: .plain, target: self,action: #selector(addToFavorites))
        self.navigationItem.rightBarButtonItem = favoriteButton
        updateFavoriteButton()
    }
    
    @IBAction func seeMoreButtonTapped(_ sender: Any) {
        if let urlString = story?.url,let url = URL(string: urlString) {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true)
        }
    }
    
    @objc func addToFavorites(_ sender: Any) {
        guard let story = story else { return }
        if CoreDataManager.shared.isFavorite(story: story) {
            // If the story is already a favorite, delete it from favorites
            CoreDataManager.shared.deleteFavorite(story: story)
        } else {
            // If the story is not a favorite, add it to favorites
            CoreDataManager.shared.addFavorite(story: story)
        }
        updateFavoriteButton()
    }
    
    func updateFavoriteButton() {
        guard let story = story else { return }
        if CoreDataManager.shared.isFavorite(story: story) {
            favoriteButton.image = UIImage(systemName: "heart.fill") // Or any image you want when favorited
        } else {
            favoriteButton.image = UIImage(systemName: "heart") // Or any image you want when not favorited
        }
      }
}
