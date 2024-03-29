//
//  FavoritesViewController.swift
//  NYTimesTopNews
//
//  Created by Mehmet Akdeniz on 18.05.2023.
//

//
//  FavoritesViewController.swift
//  NYTimesTopNews
//
//  Created by Mehmet Akdeniz on 18.05.2023.
//

import UIKit
import CoreData

class FavoritesViewController: UITableViewController {

    //MARK: Variable Definitions
    var favoriteStories: [FavoriteStory] = []
    //MARK: UI Elements
    let emptyLabel: UILabel = {
            let label = UILabel()
            label.text = "Henüz hiç haber kayıt etmediniz."
            label.textAlignment = .center
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 20)
            return label
        }()

    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteStories()
        tableView.reloadData()
        emptyLabel.isHidden = !favoriteStories.isEmpty
    }
    //MARK: Function Definations
    private func setupView() {
        tableView.backgroundView = emptyLabel
        loadFavoriteStories()
        emptyLabel.isHidden = !favoriteStories.isEmpty
    }
    
    private func loadFavoriteStories() {
        let fetchRequest: NSFetchRequest<FavoriteStory> = FavoriteStory.fetchRequest()

        do {
            favoriteStories = try CoreDataManager.shared.context.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch favorite stories: ", error)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteStories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell else {
            fatalError("Cell not found")
        }
        
        let story = favoriteStories[indexPath.row]
        cell.setCellWithValuesOfFavorite(story)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            let story = favoriteStories[indexPath.row]
            CoreDataManager.shared.context.delete(story)
            do {
                try CoreDataManager.shared.context.save()
            } catch {
                print("Failed to save after deletion: \(error)")
            }
            favoriteStories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = favoriteStories[indexPath.row]
        if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailVC.isComingFromFavorites = true
            detailVC.favoriteStory = favoriteStories[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        } else {
            print("Could not instantiate DetailViewController")
        }
    }
}




