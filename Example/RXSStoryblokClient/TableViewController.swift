//
//  ViewController.swift
//  RXSStoryblokExample
//
//  Created by Michael Medweschek on 15.08.22.
//

import UIKit
import RXSStoryblokClient

class TableViewController: UITableViewController, StoryblokConfigurationDelegate {

    private var stories = [Story<StoryContent>]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task(){
            do{
                Storyblok.shared.configureForContentDeliveryAccess(apiKey: "3nogoFf7qI8bbvrwtaXQAQtt")
                
                if let response: Stories<StoryContent> = try await Storyblok.shared.fetchStories(applying:
                        .queryForStories()
                        .startingWith("blog")
                ){
                    stories = response.stories
                }
            } catch {
                // .. handle error
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let story = stories[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = story.name
        content.secondaryText = story.fullSlug
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stories.count
    }

}

