//
//  ViewController.swift
//  catapush-ios-swift-sdk-example
//
//  Created by Chiarotto Alessandro on 10/12/15.
//  Copyright © 2015 Catapush s.r.l. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,NSFetchedResultsControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return CatapushCoreData.managedObjectContext()
    }()

    lazy var fetchedResultsController:NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: "MessageIP")
        request.sortDescriptors = [NSSortDescriptor(key: "sentTime", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext,sectionNameKeyPath:nil,cacheName:nil)
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.perfomFetch()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var items = 0;
        if let sections = self.fetchedResultsController.sections {
                let sectionInfo = sections[section]
                items = sectionInfo.numberOfObjects
        }
        return items;
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let messageCell:MessageCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(
            Constants.View.MessageCollectionViewCellId,
            forIndexPath: indexPath) as! MessageCollectionViewCell
        let messageIP = self.fetchedResultsController.objectAtIndexPath(indexPath) as! MessageIP
        messageCell.messageTextView.text = messageIP.body
        if let previousDate = self.previousDate(messageIP, indexPath: indexPath) {
            messageCell.setTimestamp(previousDate)
        }
        return messageCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let messageIP = self.fetchedResultsController.objectAtIndexPath(indexPath) as! MessageIP
        let size = CGSizeMake(collectionView.frame.size.width,CGFloat.max)
        let showTimestamp:Bool = (self.previousDate(messageIP, indexPath: indexPath) != nil)
        let cellSize = MessageCollectionViewCell.sizeThatFits(size,text:messageIP.body,showTimestamp:showTimestamp)
        return CGSizeMake(self.collectionView.frame.size.width, cellSize.height)
    }
    
    
        
    
    // NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.collectionView.reloadData()
        for message in self.fetchedResultsController.fetchedObjects! {
            self.markMessageIPAsReadIfNeeded(message as! MessageIP)
        }
    }

    func markMessageIPAsReadIfNeeded(messageIP:MessageIP) {
        if messageIP.status.integerValue == MESSAGEIP_STATUS.MessageIP_NOT_READ.rawValue {
            messageIP.status = NSNumber(integer: MESSAGEIP_STATUS.MessageIP_READ.rawValue)
            MessageIP.sendMessageReadNotification(messageIP)

        }
    }
    
    func perfomFetch() {
        self.fetchedResultsController.delegate = self;
        do {
            try self.fetchedResultsController.performFetch()
        } catch _ {
            print("Error during fecthing results")
        }
        dispatch_async(dispatch_get_main_queue()) {
            for message in self.fetchedResultsController.fetchedObjects! {
                self.markMessageIPAsReadIfNeeded(message as! MessageIP)
            }
            self.collectionView.reloadData()
        }
    }
  
    /**
        Return previous date of message is 5 min
    
    */
    func previousDate(message:MessageIP,indexPath:NSIndexPath) -> NSDate! {
        if (indexPath.item > 0) {
            let prevIndex = NSIndexPath(forItem:indexPath.row - 1,inSection:indexPath.section)
            let prevMsg:MessageIP = self.fetchedResultsController.objectAtIndexPath(prevIndex) as! MessageIP
            let timeGap:NSTimeInterval = message.sentTime.timeIntervalSinceDate(prevMsg.sentTime)
            if timeGap/60 > 5 {
                return message.sentTime;
            } else {
                return nil
            }
        }
        return message.sentTime
    }
}

