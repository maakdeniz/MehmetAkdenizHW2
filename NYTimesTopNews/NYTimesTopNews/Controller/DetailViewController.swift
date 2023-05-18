//
//  DetailViewController.swift
//  NYTimesTopNews
//
//  Created by Mehmet Akdeniz on 15.05.2023.
//

import UIKit
import NYTimesAPI
import SafariServices


class DetailViewController: UIViewController,LoadingShowable {
    var story: StoryResult?
    var favoriteStory: FavoriteStory?
    var isComingFromFavorites = false
    
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    var favoriteButton: UIBarButtonItem!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showLoading()
        if let story = story {
            titleLabel.text = story.title
            descriptionLabel.text = story.abstract
            authorLabel.text = story.byline
            if let imageUrl = story.multimedia[0].url,let url = URL(string: imageUrl){
                storyImageView.kf.setImage(with: url) { result in
                    switch result {
                        
                    case .success(_):
                        self.hideLoading()
                    case .failure(_):
                        self.hideLoading()
                    }
                }
            }
        } else if let favoriteStory = favoriteStory {
            titleLabel.text = favoriteStory.title
            descriptionLabel.text = favoriteStory.abstract
            authorLabel.text = favoriteStory.byline
            if let imageUrl = favoriteStory.imageUrl, let url = URL(string: imageUrl) {
                storyImageView.kf.setImage(with: url) { result in
                    switch result {
                        
                    case .success(_):
                        self.hideLoading()
                    case .failure(_):
                        self.hideLoading()
                    }
                }
            }
        }

        navigationItem.title = "NYTimes Top News"

        favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"),
                                         style: .plain,
                                         target: self,action: #selector(addToFavorites))
        self.navigationItem.rightBarButtonItem = favoriteButton
        updateFavoriteButton()
        updateFavoriteButtonVisibility()
    }
    
    func updateFavoriteButtonVisibility() {
        if isComingFromFavorites {
            navigationItem.rightBarButtonItem = nil
        }
    }

    
    @IBAction func seeMoreButtonTapped(_ sender: Any) {
        if let urlString = story?.url ?? self.favoriteStory?.url,let url = URL(string: urlString) {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true)
        }
    }
    
    @objc func addToFavorites(_ sender: Any) {
        guard let story = story else { return }

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        if CoreDataManager.shared.isFavorite(story: story) {
            // If the story is already a favorite, prepare to delete it from favorites
            alert.title = "Favorilerden çıkar"
            alert.message = "Bu hikayeyi favorilerinizden çıkarmak istediğinizden emin misiniz?"
            alert.addAction(UIAlertAction(title: "Evet", style: .destructive, handler: { _ in
                CoreDataManager.shared.deleteFavorite(story: story)
                self.updateFavoriteButton()
            }))
        } else {
            // If the story is not a favorite, prepare to add it to favorites
            alert.title = "Favorilere ekle"
            alert.message = "Bu hikayeyi favorilerinize eklemek istediğinizden emin misiniz?"
            alert.addAction(UIAlertAction(title: "Evet", style: .default, handler: { _ in
                CoreDataManager.shared.addFavorite(story: story)
                self.updateFavoriteButton()
            }))
        }

        alert.addAction(UIAlertAction(title: "Hayır", style: .cancel, handler: nil))
        present(alert, animated: true)
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
