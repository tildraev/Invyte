//
//  FriendSystem.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/18/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FriendSystem {
    
    static let system = FriendSystem()
    
    // MARK: - Firebase references
    /** The base Firebase reference */
    let BASE_REF = FIRDatabase.database().reference()
    /* The user Firebase reference */
    let USER_REF = FIRDatabase.database().reference().child("users")
    
    /** The Firebase reference to the current user tree */
    var CURRENT_USER_REF: FIRDatabaseReference {
        let id = FIRAuth.auth()?.currentUser!.uid
        return USER_REF.child("\(id!)")
    }
    
    /** The Firebase reference to the current user's friend tree */
    var CURRENT_USER_FRIENDS_REF: FIRDatabaseReference {
        return CURRENT_USER_REF.child("Friends")
    }
    
    /** The Firebase reference to the current user's friend request tree */
    var CURRENT_USER_REQUESTS_REF: FIRDatabaseReference {
        return CURRENT_USER_REF.child("Requests")
    }
    
    /** The Firebase reference to the current user's event */
    var CURRENT_USER_EVENTS_REF: FIRDatabaseReference {
        return CURRENT_USER_REF.child("Events")
    }
    
    var CURRENT_USER_REPLY_REF: FIRDatabaseReference {
        return CURRENT_USER_REF.child("Replies")
    }
    
    /** The Firebase reference to the current user's event requests*/
    var CURRENT_USER_EVENT_REQUESTS_REF: FIRDatabaseReference {
        return CURRENT_USER_REF.child("Event Requests")
    }
    
    /** The current user's id */
    var CURRENT_USER_ID: String {
        let id = FIRAuth.auth()?.currentUser!.uid
        return id!
    }
    
    
    /** Gets the current User object for the specified user id */
    func getCurrentUser(_ completion: @escaping (User) -> Void) {
        CURRENT_USER_REF.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            let username = snapshot.childSnapshot(forPath: "Username").value as! String
            let email = snapshot.childSnapshot(forPath: "Email").value as! String
            let oneSignalID = snapshot.childSnapshot(forPath: "OneSignalID").value as! String
            let name = snapshot.childSnapshot(forPath: "Name").value as! String
            let id = snapshot.key
            completion(User(username: username, userEmail: email, userID: id, oneSignalID: oneSignalID, name: name))
        })
    }
    /** Gets the User object for the specified user id */
    func getUser(_ userID: String, completion: @escaping (User) -> Void) {
        USER_REF.child(userID).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            let username = snapshot.childSnapshot(forPath: "Username").value as! String
            let email = snapshot.childSnapshot(forPath: "Email").value as! String
            let oneSignalID = snapshot.childSnapshot(forPath: "OneSignalID").value as! String
            let name = snapshot.childSnapshot(forPath: "Name").value as! String
            let id = snapshot.key
            completion(User(username: username, userEmail: email, userID: id, oneSignalID: oneSignalID, name: name))
            }, withCancel: { (error) in
                print(error.localizedDescription)
        })
    }
    
    func getEvent(_ eventCreatorID: String, completion: @escaping (Event) -> Void) {
        USER_REF.child(eventCreatorID).observeSingleEvent(of: FIRDataEventType.value, with: { (eventSnapshot) in
            let id = eventCreatorID
            let titleAndDescription = eventSnapshot.childSnapshot(forPath: "Events").childSnapshot(forPath: eventCreatorID).value as! String
            completion(Event(creatorID: id, eventTitleAndDescription: titleAndDescription))
        })
    }
    
    func getEventsAccepted(_ eventCreatorID: String, completion: @escaping (Event) -> Void) {
        CURRENT_USER_REF.child("Events").observeSingleEvent(of: FIRDataEventType.value, with: { (eventSnapshot) in
            let id = eventCreatorID
            let titleAndDescription = eventSnapshot.childSnapshot(forPath: id).value as! String
            completion(Event(creatorID: id, eventTitleAndDescription: titleAndDescription ))
        })
    }
    
    func getReply(_ userID: String, completion: @escaping (Reply) -> Void) {
        CURRENT_USER_REF.child("Replies").observeSingleEvent(of: FIRDataEventType.value, with: { (replySnapshot) in
            let reply = replySnapshot.childSnapshot(forPath: userID).value as! String
            completion(Reply(reply: reply, personReplyingID: userID))
        })
    }
    
    
    // MARK: - Request System Functions
    
    /** Sends a friend request to the user with the specified id */
    func sendRequestToUser(_ userID: String) {
        USER_REF.child(userID).child("Requests").child(CURRENT_USER_ID).setValue("true")
    }
    
    /** Unfriends the user with the specified id */
    func removeFriend(_ userID: String) {
        CURRENT_USER_REF.child("Friends").child(userID).removeValue()
        USER_REF.child(userID).child("Friends").child(CURRENT_USER_ID).removeValue()
    }
    
    /** Accepts a friend request from the user with the specified id */
    func acceptFriendRequest(_ userID: String) {
        CURRENT_USER_REF.child("Requests").child(userID).removeValue()
        CURRENT_USER_REF.child("Friends").child(userID).setValue(true)
        USER_REF.child(userID).child("Friends").child(CURRENT_USER_ID).setValue(true)
        USER_REF.child(userID).child("Requests").child(CURRENT_USER_ID).removeValue()
    }
    
    func rejectFriendRequest(_ userID: String) {
        CURRENT_USER_REF.child("Requests").child(userID).removeValue()
    }
    
    
    
    // MARK: - All users
    /** The list of all users */
    var userList = [User]()
    /** Adds a user observer. The completion function will run every time this list changes, allowing you
     to update your UI. */
    func addUserObserver(_ update: @escaping () -> Void) {
        FriendSystem.system.USER_REF.observe(FIRDataEventType.value, with: { (snapshot) in
            self.userList.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let username = child.childSnapshot(forPath: "Username").value as! String
                let email = child.childSnapshot(forPath: "Email").value as! String
                let oneSignalID = snapshot.childSnapshot(forPath: "OneSignalID").value as! String
                let name = snapshot.childSnapshot(forPath: "Name").value as! String
                if email != FIRAuth.auth()?.currentUser?.email! {
                    self.userList.append(User(username: username, userEmail: email, userID: child.key, oneSignalID: oneSignalID, name: name))
                }
            }
            update()
        })
        
        FriendSystem.system.USER_REF.observe(FIRDataEventType.childRemoved, with: { (snapshot) in
            self.userList.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let username = child.childSnapshot(forPath: "Username").value as! String
                let email = child.childSnapshot(forPath: "Email").value as! String
                let oneSignalID = snapshot.childSnapshot(forPath: "OneSignalID").value as! String
                let name = snapshot.childSnapshot(forPath: "Name").value as! String
                if email != FIRAuth.auth()?.currentUser?.email! {
                    self.userList.append(User(username: username, userEmail: email, userID: child.key, oneSignalID: oneSignalID, name: name))
                }
            }
            update()
        })
    }
    /** Removes the user observer. This should be done when leaving the view that uses the observer. */
    func removeUserObserver() {
        USER_REF.removeAllObservers()
    }
    
    //MARK: - Replies
    var replyList = [Reply]()
    
    func addReplyObserver(_ update: @escaping () -> Void) {
        CURRENT_USER_REPLY_REF.observe(FIRDataEventType.value, with: { (snapshot) in
            self.replyList.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let id = child.key
                self.getReply(id, completion: { (reply) in
                    self.replyList.append(reply)
                    update()
                })
            }
            //If no children, run completion here instead
            if snapshot.childrenCount == 0{
                update()
            }
        })
        { (error) in
            print(error)
        }
    }
    
    func removeReplyObserver(){
        CURRENT_USER_REPLY_REF.removeAllObservers()
    }

    
    //MARK: - Events
    /**The list of all events of the current user*/
    var eventList = [Event]()
    
    func addEventRequestObserver(_ update: @escaping () -> Void) {
        CURRENT_USER_EVENT_REQUESTS_REF.observe(FIRDataEventType.value, with: { (snapshot) in
            self.eventList.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let id = child.key
                self.getEvent(id, completion: { (event) in
                //self.getEventsAccepted(id, completion: { (event) in
                    //self.eventsAcceptedList.append(event)
                    self.eventList.append(event)
                    update()
                })
            }
            //If no children, run completion here instead
            if snapshot.childrenCount == 0{
                update()
            }
            })
        { (error) in
            print(error)
        }
    }
    
    func removeEventRequestObserver(){
        CURRENT_USER_EVENT_REQUESTS_REF.removeAllObservers()
    }
    

    var eventsAcceptedList = [Event]()
    
    func addEventObserver(_ update: @escaping () -> Void) {
        //code to add observer for events user has accepted.
        self.eventsAcceptedList.removeAll()
        CURRENT_USER_EVENTS_REF.observe(FIRDataEventType.value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                self.getEventsAccepted(child.key, completion: { (event) in
                    self.eventsAcceptedList.append(event)
                    update()
                })
            }
            if snapshot.childrenCount == 0 {
                update()
            }
            }) { (error) in
                print(error)}
        
        CURRENT_USER_EVENTS_REF.observe(FIRDataEventType.childRemoved, with: { (snapshot) in
            self.eventsAcceptedList.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                self.getEventsAccepted(child.key, completion: { (event) in
                    self.eventsAcceptedList.append(event)
                    update()
                })
            }
            if snapshot.childrenCount == 0 {
                update()
            }
        }) { (error) in
            print(error)}

    }
    
    func removeEventObserver(){
        CURRENT_USER_EVENTS_REF.removeAllObservers()
    }
    
    /** Sends an event request to the user with the specified id */
    func sendEventRequestToUser(userID: String,_ event: Event) {
        USER_REF.child(userID).child("Event Requests").child(event.creatorID).setValue(event.titleAndDescription)
    }
    
    /** Removes events from the specified user */
    func removeEvent(_ userID: String) {
        CURRENT_USER_REF.child("Events").child(userID).removeValue()
    }
    
    /** Removed the event request from the user */
    func removeEventRequest(_ userID: String){
        CURRENT_USER_REF.child("Event Requests").child(userID).removeValue()
        USER_REF.child(userID).child("Replies").child(CURRENT_USER_ID).setValue("No")
    }
    
    /** Accepts an even from user with the specified ID */
    func acceptEventRequest(_ userID: String, titleAndDescription: String){
        CURRENT_USER_REF.child("Event Requests").child(userID).removeValue()
        CURRENT_USER_REF.child("Events").child(userID).setValue(titleAndDescription)
        USER_REF.child(userID).child("Replies").child(CURRENT_USER_ID).setValue("Yes")
    }
    
    // MARK: - All friends
    /** The list of all friends of the current user. */
    var friendList = [User]()
    /** Adds a friend observer. The completion function will run every time this list changes, allowing you
     to update your UI. */
    func addFriendObserver(_ update: @escaping () -> Void) {
        CURRENT_USER_FRIENDS_REF.observe(FIRDataEventType.value, with: { (snapshot) in
            self.friendList.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let id = child.key
                self.getUser(id, completion: { (user) in
                    self.friendList.append(user)
                    update()
                })
            }
            // If there are no children, run completion here instead
            if snapshot.childrenCount == 0 {
                update()
            }
        })
        
        CURRENT_USER_FRIENDS_REF.observe(FIRDataEventType.childRemoved, with: { (snapshot) in
            self.friendList.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let id = child.key
                self.getUser(id, completion: { (user) in
                    self.friendList.append(user)
                    update()
                })
            }
            // If there are no children, run completion here instead
            if snapshot.childrenCount == 0 {
                update()
            }
        })
    }
    /** Removes the friend observer. This should be done when leaving the view that uses the observer. */
    func removeFriendObserver() {
        CURRENT_USER_FRIENDS_REF.removeAllObservers()
    }
    
    
    
    // MARK: - All requests
    /** The list of all friend requests the current user has. */
    var requestList = [User]()
    /** Adds a friend request observer. The completion function will run every time this list changes, allowing you
     to update your UI. */
    func addRequestObserver(_ update: @escaping () -> Void) {
        CURRENT_USER_REQUESTS_REF.observe(FIRDataEventType.value, with: { (snapshot) in
            self.requestList.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let id = child.key
                self.getUser(id, completion: { (user) in
                    self.requestList.append(user)
                    update()
                })
            }
            // If there are no children, run completion here instead
            if snapshot.childrenCount == 0 {
                update()
            }
        })
    }
    /** Removes the friend request observer. This should be done when leaving the view that uses the observer. */
    func removeRequestObserver() {
        CURRENT_USER_REQUESTS_REF.removeAllObservers()
    }
    
}
