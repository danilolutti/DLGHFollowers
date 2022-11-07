//
//  User.swift
//  GHFollowers
//
//  Created by Danilo on 31/10/22.
//

import Foundation

struct User: Codable {
    var login: String
    var avatarUrl: String
    var name: String? 		//optional in github
    var location: String?   //optional in github
    var bio: String?        //optional in github
    var publicRepos: Int
    var publicGists: Int
    var htmlUrl: String
    var following: Int
    var followers: Int
    var createdAt:String
}
