//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Anshul parashar on 27/07/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var messageTextfield: UITextField!
	let db = Firestore.firestore()

	var messages: [Message] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = self
		navigationItem.title = Constants.appName
		navigationItem.hidesBackButton = true

		tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil),
						   forCellReuseIdentifier: Constants.cellIdentifier)
		loadMessages()
	}

	private func loadMessages() {
		db.collection(Constants.FStore.collectionName)
			.order(by: Constants.FStore.dateField)
			.addSnapshotListener { [weak self] (querySnapshot, error) in
				var newMessages: [Message] = []
				if let error = error {
					print("Error getting documents: \(error)")
				} else {
					if let snapshotDocuments = querySnapshot?.documents {
						for document in snapshotDocuments {
							if let messageSender = document.data()[Constants.FStore.senderField] as? String,
							   let messageBody = document.data()[Constants.FStore.bodyField] as? String {
								let message = Message(sender: messageSender, body: messageBody)
								newMessages.append(message)
							}
						}

						self?.messages = newMessages
						DispatchQueue.main.async {
							self?.tableView.reloadData()
							self?.tableView.scrollToRow(
								at: IndexPath(row: newMessages.count - 1, section: 0),
								at: .bottom,
								animated: true)
						}
					}
				}
			}
	}

	@IBAction func sendPressed(_ sender: UIButton) {
		if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
			var ref: DocumentReference? = nil
			ref = db.collection(Constants.FStore.collectionName).addDocument(data: [
				Constants.FStore.senderField: messageSender,
				Constants.FStore.bodyField: messageBody,
				Constants.FStore.dateField: Date().timeIntervalSince1970
			]) { error in
				if let error = error {
					print("Error adding document: \(error)")
				} else {
					print("Document added with ID: \(ref!.documentID)")
					DispatchQueue.main.async {
						self.messageTextfield.text = ""
					}
				}
			}
		}
	}

	@IBAction func logoutButtonTapped(_ sender: Any) {
		do {
			try Auth.auth().signOut()
			navigationController?.popToRootViewController(animated: true)
		} catch let signOutError as NSError {
			print("Error signing out: %@", signOutError)
		}
	}
}

extension ChatViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? MessageCell else {
			return UITableViewCell()
		}

		let message = messages[indexPath.row]
		cell.label.text = message.body
		if message.sender == Auth.auth().currentUser?.email {
			cell.leftImageView.isHidden = true
			cell.rightImageView.isHidden = false
			cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple)
			cell.label.textColor = UIColor(named: Constants.BrandColors.purple)
		} else {
			cell.leftImageView.isHidden = false
			cell.rightImageView.isHidden = true
			cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.purple)
			cell.label.textColor = UIColor(named: Constants.BrandColors.lightPurple)
		}
		return cell
	}
}
