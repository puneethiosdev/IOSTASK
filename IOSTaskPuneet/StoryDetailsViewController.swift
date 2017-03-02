//
//  StoryDetailsViewController.swift
//  IOSTaskPuneet
//
//  Created by Puneeth Kumar  on 09/01/17.
//  Copyright © 2017 ASM Technologies Limited. All rights reserved.
//

import UIKit
import CoreData

import AlamofireImage

class StoryDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var storyDetails: StoryBean?
    var authorDetails: UserBean?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "DETAILS"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "StoryDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "StoryDetailTableViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150.0
        self.tableView.separatorColor = UIColor.clear
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func getAuthorDetails (id:String) -> (Author) {
        //create a fetch request, telling it about the entity
        let fetchrequest: NSFetchRequest<Author> = Author.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "id == %@", id)
        
        var authorObject:Author?
        
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchrequest)
            
            //I like to check the size of the returned results!
            print("num of results = \(searchResults.count)")
            
            //you need to convert to NSManagedObject to use 'for' loops
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
    
    func followButtonDidPressed(sender:UIButton) {
        print (sender.tag)
        
        let fetchRequest: NSFetchRequest<Author> = Author.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", (storyDetails?.db)!)
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            
            for trans in searchResults as [NSManagedObject] {
                
                if sender.tag == 1 {
                    trans.setValue(false, forKey: "is_following")
                } else {
                    trans.setValue(true, forKey: "is_following")
                }
            }
            print ("saved!")
            self.tableView.reloadData()
        } catch let error as NSError {
            print ("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    
    func timeStringFromUnixTime(unixTime: Double) -> String {
        
        //Convert to date
        let date = NSDate(timeIntervalSince1970: unixTime/1000)
        
        //Date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd, MMMM yyyy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let dateString = dateFormatter.string(from: date as Date)
        print("formatted date is = \(dateString)")
        return dateString
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension StoryDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoryDetailTableViewCell") as! StoryDetailTableViewCell
            cell.selectionStyle = .none
            
            //create a UIActivityIndicatorView with the
            let ai = UIActivityIndicatorView(frame: (cell.storyImageView?.frame)!)
            //Add the UIActivityIndicatorView as a subview on the cell
            cell.addSubview(ai)
            //start the UIActivityIndicatorView animating
            ai.startAnimating()
            
            cell.storyImageView.af_setImage(withURL: URL(string: (storyDetails?.si)!)!, placeholderImage: UIImage(named: ""), filter: nil, imageTransition: .crossDissolve(0.5), completion: { response in
                ai.stopAnimating()
                ai.removeFromSuperview()
            })
            
            cell.storyTitleLabel.text = storyDetails?.title
            cell.storyDescription?.text = storyDetails?.descriptn
            cell.verbLabel.text = storyDetails?.verb
            cell.likeCount.text = storyDetails?.likes_count?.description
            cell.commentCount.text = storyDetails?.comment_count?.description
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailTableViewCell") as! UserDetailTableViewCell
            cell.selectionStyle = .none
            
            var authorDetails:Author?
            
            authorDetails = self.getAuthorDetails(id: (storyDetails?.db)!)
            
            //create a UIActivityIndicatorView with the
            let ai = UIActivityIndicatorView(frame: (cell.userImageView?.frame)!)
            //Add the UIActivityIndicatorView as a subview on the cell
            cell.addSubview(ai)
            //Start the UIActivityIndicatorView animating
            ai.startAnimating()
            
            cell.userImageView.af_setImage(
                withURL: URL(string: (authorDetails?.image)!)!, placeholderImage: UIImage(named: ""), filter: nil, imageTransition: .crossDissolve(0.5), completion: { response in
                    ai.stopAnimating()
                    ai.removeFromSuperview()
            })
            
            cell.userName.text = authorDetails?.username
            cell.followerCount.text = authorDetails?.followers.description
            cell.followingCount.text = authorDetails?.following.description
            cell.handleLabel.text = authorDetails?.handle
            cell.detailTextLabel?.text = authorDetails?.description
            cell.createdDateLabel.text = self.timeStringFromUnixTime(unixTime: Double((authorDetails?.createdOn)!))
            
            if let followStatus = authorDetails?.is_following {
                if followStatus == true {
                    cell.followButton.tag = 1
                    cell.followButton.setFollowButton()
                } else {
                    cell.followButton.tag = 0
                    cell.followButton.setFollowButton()
                }
            }
            
            cell.followButton.addTarget(self, action: #selector(followButtonDidPressed), for: .touchUpInside)
            
            return cell
        }
    }
}

