//
//  ViewController.swift
//  catapush-ios-swift-sdk-example
//
//  Created by Chiarotto Alessandro on 10/12/15.
//  Copyright © 2015 Catapush s.r.l. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController,
                      UICollectionViewDataSource,
                      UICollectionViewDelegate,
                      UICollectionViewDelegateFlowLayout,
                      NSFetchedResultsControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return CatapushCoreData.managedObjectContext()
    }()

    lazy var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult> = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MessageIP")
        request.sortDescriptors = [NSSortDescriptor(key: "sentTime", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext,sectionNameKeyPath:nil,cacheName:nil)
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.perfomFetch()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var items = 0;
        if let sections = self.fetchedResultsController.sections {
                let sectionInfo = sections[section]
                items = sectionInfo.numberOfObjects
        }
        return items;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 1
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let messageCell:MessageCollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.View.MessageCollectionViewCellId,
            for: indexPath) as! MessageCollectionViewCell
        let messageIP = self.fetchedResultsController.object(at: indexPath) as! MessageIP
        messageCell.messageTextView.text = messageIP.body
        if let previousDate = self.previousDate(messageIP, indexPath: indexPath) {
            messageCell.setTimestamp(previousDate)
        }
        return messageCell
    
    }
    
    /*
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
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
    */
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
    

        let messageIP = self.fetchedResultsController.object(at: indexPath) as! MessageIP
        let size = CGSize(width:collectionView.frame.size.width,height:CGFloat.greatestFiniteMagnitude)
        let showTimestamp:Bool = (self.previousDate(messageIP, indexPath: indexPath) != nil)
        let cellSize = MessageCollectionViewCell.sizeThatFits(size,text:messageIP.body,showTimestamp:showTimestamp)
        return CGSize(width:self.collectionView.frame.size.width,height: cellSize.height)
    }
    
    /*
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let messageIP = self.fetchedResultsController.objectAtIndexPath(indexPath) as! MessageIP
        let size = CGSize(width:collectionView.frame.size.width,height:CGFloat.max)
        let showTimestamp:Bool = (self.previousDate(messageIP, indexPath: indexPath) != nil)
        let cellSize = MessageCollectionViewCell.sizeThatFits(size,text:messageIP.body,showTimestamp:showTimestamp)
        return CGSizeMake(self.collectionView.frame.size.width, cellSize.height)
    }*/
    
    
        
    
    // NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.collectionView.reloadData()
        for message in self.fetchedResultsController.fetchedObjects! {
            self.markMessageIPAsReadIfNeeded(message as! MessageIP)
        }
    }

    func markMessageIPAsReadIfNeeded(_ messageIP:MessageIP) {
        if messageIP.status.intValue == MESSAGEIP_STATUS.MessageIP_NOT_READ.rawValue {
            messageIP.status = NSNumber(value: MESSAGEIP_STATUS.MessageIP_READ.rawValue)
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
        DispatchQueue.main.async {
            for message in self.fetchedResultsController.fetchedObjects! {
                self.markMessageIPAsReadIfNeeded(message as! MessageIP)
            }
            self.collectionView.reloadData()
        }
    }
  
    /**
        Return previous date of message is 5 min
    
    */
    func previousDate(_ message:MessageIP,indexPath:IndexPath) -> Date! {
        if (indexPath.item > 0) {
            let prevIndex = IndexPath(item: indexPath.row - 1, section: indexPath.section)
            let prevMsg:MessageIP = self.fetchedResultsController.object(at: prevIndex) as! MessageIP
            let timeGap = message.sentTime.timeIntervalSince(prevMsg.sentTime)
            // let timeGap:TimeInterval = message.sentTime.timeIntervalSinceDate(prevMsg.sentTime)
            if timeGap/60 > 5 {
                return message.sentTime;
            } else {
                return nil
            }
        }
        return message.sentTime
    }
}

