//
//  RecipeListTableViewController.swift
//  calories
//
//  Created by Alexey Savchenko on 17.11.16.
//  Copyright © 2016 Alexey Savchenko. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation


class RecipeListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in (JSONData?["hits"].array)!{
            let unprocessedRecipe = item["recipe"]
            var ingrigientsForRecipe = [String]()
            
            let ingregients = unprocessedRecipe["ingredients"].array
            for item in ingregients!{
                ingrigientsForRecipe.append(item["text"].stringValue)
            }
            
            let localRecipe = Recipe(label: unprocessedRecipe["label"].string!,
                                     source: unprocessedRecipe["source"].string!,
                                     ingredients: ingrigientsForRecipe,
                                     URL: unprocessedRecipe["url"].string!,
                                     healthLabels: unprocessedRecipe["healthLabels"].arrayObject! as! [String],
                                     image: URL(string: unprocessedRecipe["image"].string!)!
            )
            print("\n\(localRecipe)\n")
            recipeArray.append(localRecipe)
        }
    }
    
    // MARK: PROPERTIES
    
    var JSONData: JSON?
    var recipeArray = [Recipe]()
    
    var selectedRecipeIndex: Int?
    
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipeArray.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeNameCell", for: indexPath) as! recipeListCell
        
        let imageURL = recipeArray[indexPath.row].image
        DispatchQueue.global().async {
            let imageData = try? Data(contentsOf: imageURL)
            DispatchQueue.main.async {
                cell.recipeImage.image = UIImage(data: imageData!)
                cell.recipeLabel.text = self.recipeArray[indexPath.row].label
            }
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRecipeIndex = indexPath.row
        performSegue(withIdentifier: "segueToRecipe", sender: UITableViewCell())
        print("\n \(indexPath.row) \n -------- \n \(selectedRecipeIndex) \n -------- \n \(recipeArray[selectedRecipeIndex!])")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToRecipe"{
            if let controller = segue.destination as? RecipeViewController {
                print(controller)
                controller.selectedRecipe = recipeArray[selectedRecipeIndex!]
            }
        }
    }
}
