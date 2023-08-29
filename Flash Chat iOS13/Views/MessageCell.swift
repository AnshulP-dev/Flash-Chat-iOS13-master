//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Anshul parashar on 16/08/23.
//

import UIKit

class MessageCell: UITableViewCell {

	@IBOutlet weak var messageBubble: UIView!
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var rightImageView: UIImageView!
	@IBOutlet weak var leftImageView: UIImageView!

	override func awakeFromNib() {
        super.awakeFromNib()
		messageBubble.layer.cornerRadius = messageBubble.frame.height / 5
    }
}
