//
//  ViewController.swift
//  RXSStoryblokClient
//
//  Created by Medweschek Michael on 08/16/2022.
//  Copyright (c) 2022 Medweschek Michael. All rights reserved.
//

import UIKit
import RXSStoryblokClient

class TableViewController: UITableViewController {
    
    private var stories = [Story<SBBlogPost>]() {
        didSet{
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Task(){
            do{
                Storyblok.shared.configureForContentDeliveryAccess(apiKey: "3nogoFf7qI8bbvrwtaXQAQtt")

                if let response: Stories<SBBlogPost> = try await Storyblok.shared.fetchStories(applying:
                        .queryForStories()
                        .startingWith("richtext")
                ){
                    stories = response.stories
                }

            } catch (let error){
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let story = stories[indexPath.row]
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            
            content.text = story.name
            content.secondaryText = story.fullSlug
            
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = story.name
            cell.detailTextLabel?.text = story.fullSlug
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stories.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let story = stories[indexPath.row]
        var html = ""
        let outermostNode = story.content.richtext
        RichTextResolver.resolveNode(outermostNode, applyingSchema: HtmlSchema.self, into: &html)
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Richtext HTML", message: html, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }
    }
}
