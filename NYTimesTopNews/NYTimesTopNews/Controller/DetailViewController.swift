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
    }
    
    @IBAction func seeMoreButtonTapped(_ sender: Any) {
        if let urlString = story?.url,let url = URL(string: urlString) {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true)
        }
    }
}

