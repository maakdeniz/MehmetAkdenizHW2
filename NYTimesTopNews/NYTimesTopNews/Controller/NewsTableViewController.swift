//
//  NewsTableViewController.swift
//  NYTimesTopNews
//
//  Created by Mehmet Akdeniz on 16.05.2023.
//

import UIKit
import NYTimesAPI

class NewsTableViewController: UITableViewController,LoadingShowable {

    private var stories = [StoryResult]()
    
    private let apiManager = NYTimesService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
                
            
    }
    
    private func setupView() {
        self.showLoading()
        fetchStories()
        navigationItem.title = "NYTimes Top News"
        
    }
    
    private func fetchStories(){
        apiManager.fetchTopStories { [weak self] result in
            self?.hideLoading()
            switch result {
            case .success(let stories):
                DispatchQueue.main.async {
                    self?.stories = stories
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCell", for: indexPath) as! NewsTableViewCell

        let story = stories[indexPath.row]
        cell.setCellWithValuesOf(story)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = stories[indexPath.row]
        if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailVC.story = stories[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        } else {
            print("Could not instantiate DetailViewController")
        }
    }
}
