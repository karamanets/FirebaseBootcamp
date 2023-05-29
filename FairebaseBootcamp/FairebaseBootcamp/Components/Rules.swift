//
//  Rules.swift
//  FairebaseBootcamp
//
//  Created by Alex Karamanets on 29/05/2023.
//

import Foundation

/*
 
 rules_version = '2';
 service cloud.firestore {
   match /databases/{database}/documents {
     //user collection
     match /users/{userId} {
       //1- if auth - can read
       allow read: if request.auth != null;
       
       //2- if user id == id in firestore can write
       allow write: if request.auth.uid == userId;
       
       //3- if auth and have premium - can write
       //resource.data.is_premium -Data from firestore
       //allow write: if request.auth.uid == userId && resource.data.is_premium == true ;
       
       //4- can write (toggle is Premium) if has custom key.
       //For example where (request.resource.data) - Data from device
       //allow write: if request.resource.data.custom_key == "777"
        
        //5 - Use function
        allow write: if isPublic()
     }
     //product collection
     match /products/{productId} {
       // can read write product collection if - auth
       //allow read, write: if request.auth != null;
       
       allow read: if request.auth != null && isAdmin(request.auth.uid);
       // else
       allow create: if request.auth != null && isAdmin(request.auth.uid);
       allow update: if request.auth != null && isAdmin(request.auth.uid);
       allow delete: if false
     }
     
     //SubCollection in user (and any else) - do not inherits rules from others
     match /users/{userId}/favourite_product/{userFavoriteProductID} {
        allow read: if request.auth != null;
        allow write: if request.auth.uid == userId;
     }
     
     
     function isPublic() {
       return resource.data.is_premium == true
     }
     
     // can read if admin userId == current userId of admin
     function isAdmin(userId) {
       // Example 1
        //let admins = ["ZeY9tsoUl1Q7iI0JalTzB9Ez3MI3"];
        //return userId in admins;
        
        //Example 2 wit admins collection
        return exists(/databases/$(database)/documents/admins/$(userId));
     }
    
   }
 }

 // read
 // get - single document read
 // list - queries and collection read request

 // write
 // create - create document
 // update - edit document
 // delete - delete document
 
 */
