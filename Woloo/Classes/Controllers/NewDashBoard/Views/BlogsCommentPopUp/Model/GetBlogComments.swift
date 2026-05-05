//
//  GetBlogComments.swift
//  Woloo
//
//  Created by CEPL on 06/05/25.
//

import Foundation

class GetBlogComments: Codable{
    
    var comment_id: Int?
    var blog_id: Int?
    var user_id: Int?
    var comment_text: String? = ""
    var created_at: String? = ""
    var user_name: String? = ""
    var user_email: String? = ""
    var user_profile_picture: String? = ""
}
