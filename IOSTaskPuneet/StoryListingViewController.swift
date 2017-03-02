//
//  StoryListingViewController.swift
//  IOSTaskPuneet
//
//  Created by Puneeth Kumar  on 09/01/17.
//  Copyright © 2017 ASM Technologies Limited. All rights reserved.
//

import UIKit
import CoreData

import AlamofireImage

class StoryListingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var listOfStory = [StoryBean]()
    var listOfAuthor = [UserBean]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "LIST OF STORIES"

        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "StoryCardTableViewCell", bundle: nil), forCellReuseIdentifier: "StoryCardTableViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150.0
        self.tableView.separatorColor = UIColor.clear
        populateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveAuthorToCoreData(userObject:AnyObject) {
        
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity = NSEntityDescription.entity(forEntityName: "Author", in: context)
        
        let userAuthor = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        userAuthor.setValue(userObject["about"], forKey: "about")
        userAuthor.setValue(userObject["id"], forKey: "id")
        userAuthor.setValue(userObject["username"], forKey: "username")
        userAuthor.setValue(userObject["followers"], forKey: "followers")
        userAuthor.setValue(userObject["following"], forKey: "following")
        userAuthor.setValue(userObject["image"], forKey: "image")
        userAuthor.setValue(userObject["url"], forKey: "url")
        userAuthor.setValue(userObject["handle"], forKey: "handle")
        userAuthor.setValue(userObject["is_following"], forKey: "is_following")
        userAuthor.setValue(userObject["createdOn"], forKey: "createdOn")

        print(userAuthor.value(forKey: "followers")!)
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    
    func getAuthorDetails (id:String) -> (Author) {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Author> = Author.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        var authorObject:Author?
        
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            
            //I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            
            //You need to convert to NSManagedObject to use 'for' loops
            for trans in searchResults as [NSManagedObject] {
                //get the key value pairs (although there may be a better way to do that ...
                authorObject = (trans as! Author)
                print("\(trans.value(forKey: "about"))")
                print((authorObject?.about)!)
            }
        } catch {
            print("Error with request: \(error)")
        }
        return authorObject!
    }
    
    func checkIsAlreadyHavingAuthorList() -> Bool {
        
        let fetchRequest: NSFetchRequest<Author> = Author.fetchRequest()
        
        do {
            //got get the results
            let searchResults = try getContext().fetch(fetchRequest)
            
            //I like to check the size of the returned results!
            print("num of results = \(searchResults.count)")
            if searchResults.count > 0 {
                print("!!!!!!!!!!!!!!!{{{{{{{{     \(searchResults.count)    }}}}")
                return true
            }else {
                return false
            }
        } catch {
            print("Error with request: \(error)")
        }
        return false
    }
    
    func populateData() {
        
        let dataFlag = self.checkIsAlreadyHavingAuthorList()
        
        //Parsing JSON data
        if let path = Bundle.main.path(forResource: "TaskData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSArray
                    //print (jsonResult)
                    for element in jsonResult {
                        let indexData = element as AnyObject
                        
                        let storyElement = StoryBean()
                        
                        if let _ = indexData["about"]! {
                            //print (val)
                            //now val is not nil and the Optional has been unwrapped, so use it
                            if dataFlag == false {
                                self.saveAuthorToCoreData(userObject: indexData)
                            }

                        }
                        if let _ = indexData["description"]! {
                            //print(val)
                            storyElement.initWith(descriptn: indexData["description"] as! String, id: indexData["id"] as! String, verb: indexData["verb"] as! String, db: indexData["db"] as! String, url: indexData["url"] as! String, si: indexData["si"] as! String, type: indexData["type"] as! String, title: indexData["title"] as! String, like_flag: indexData["like_flag"] as! Bool, likes_count: indexData["likes_count"] as! Int, comment_count: indexData["id"] as! Int)
                            
                            listOfStory.append(storyElement)
                            
                        }
                    }
                    
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    
    func followButtonDidPressed(sender:UIButton){
        print(sender.tag)
        
        //let contect = getContext()
        
        let fetchRequest: NSFetchRequest<Author> = Author.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", (listOfStory[sender.section!].db)!)
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            
            for trans in searchResults as [NSManagedObject] {
                
                if sender.tag == 1 {
                    trans.setValue(false, forKey: "is_following")
                } else {
                    trans.setValue(true, forKey: "is_following")
                }
            }
            print("saved!")
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
}


extension StoryListingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfStory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCardTableViewCell") as! StoryCardTableViewCell
        cell.selectionStyle = .none
        
        //create a UIActivityIndicatorView with the 
        let ai = UIActivityIndicatorView(frame: (cell.storyImageView?.frame)!)
        //Add the UIActivityIndicatorView as a subview on the cell
        cell.addSubview(ai)
        // Start the UIActivityIndicatorView animating
        ai.startAnimating()
        //print(listOfStory[indexPath.row].si!)
        cell.storyImageView.af_setImage(
            withURL: URL(string:listOfStory[indexPath.row].si!)!, filter: nil, imageTransition: .crossDissolve(0.5), completion: { response in
                ai.stopAnimating()
                ai.removeFromSuperview()
        })
        cell.storyTitleLabel?.text = listOfStory[indexPath.row].title
        cell.storyDescription?.text = listOfStory[indexPath.row].descriptn
        //cell.storyAuthor?.text = listOfStory[indexPath.row].db
        var authorDetails:Author?
        
        authorDetails = self.getAuthorDetails(id: listOfStory[indexPath.row].db!)
        
        cell.storyAuthor.text = authorDetails?.username
        
        if let followStatus = authorDetails?.is_following{
            if followStatus == true{
                cell.followButton.setFollowButton()
                cell.followButton.tag = 1
                
            }else{
                cell.followButton.setUnFollowButton()
                cell.followButton.tag = 0
            }
        }
        cell.followButton.section = indexPath.row
        
        cell.followButton.addTarget(self, action: #selector(followButtonDidPressed), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = StoryDetailsViewController()
        VC.storyDetails = listOfStory[indexPath.row]
        self.navigationController?.pushViewController(VC, animated: true)
    }
}
