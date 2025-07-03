//
//  BlogCommentTableCell.swift
//  Woloo
//
//  Created by CEPL on 05/05/25.
//

import UIKit

class BlogCommentTableCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var userImgVw: UIImageView!
    
    var objGetBlogComments = GetBlogComments()
    var baseUrl: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureBlogCommentTableCell(objGetBlogComments: GetBlogComments? ,baseUrl: String?){
        
        self.objGetBlogComments = objGetBlogComments ?? GetBlogComments()
        self.lblName.text = self.objGetBlogComments.user_name ?? ""
        self.lblComment.text = self.objGetBlogComments.comment_text ?? ""
        
        if !Utility.isEmpty(self.objGetBlogComments.user_profile_picture ?? ""){
            
            self.userImgVw.sd_setImage(with: URL(string: "\(baseUrl ?? "")\(self.objGetBlogComments.user_profile_picture ?? "")"), completed: nil)
        }
    }
    
}
