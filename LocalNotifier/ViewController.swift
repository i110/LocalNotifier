//
//  ViewController.swift
//  LocalNotifier
//
//  Created by Ichito Nagata on 2018/11/10.
//  Copyright © 2018年 i110. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    private var waitingNotification: Bool = false
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var notifyButton: UIButton!
    @IBOutlet weak var blinkView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var afterStepper: UIStepper!
    @IBOutlet weak var afterLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(blink), name: UIApplication.willEnterForegroundNotification, object: nil)
        blink()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @objc private func blink() {
        self.blinkView.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.autoreverse, .repeat], animations: {
            self.blinkView.backgroundColor = UIColor(red: 0, green: 0, blue: 1.0, alpha: 1.0)
        }, completion: nil)
    }

    @IBAction func didNotifyButtonTapped(_ sender: UIButton) {
        if waitingNotification {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["LocalNotifier"])
            notifyButton.setTitle("Notify", for: .normal)
            containerView.isHidden = false
            descriptionLabel.isHidden = true
            waitingNotification = false
            return
        }
        let content = UNMutableNotificationContent()
        if let title = titleTextField.text, !title.isEmpty {
            content.title = title
        }
        if let subtitle = subtitleTextField.text, !subtitle.isEmpty {
            content.subtitle = subtitle
        }
        content.body = bodyTextView.text
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(afterStepper.value), repeats: false)
        let request = UNNotificationRequest(identifier: "LocalNotifier",
                                            content: content,
                                            trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

        notifyButton.setTitle("Done", for: .normal)
        containerView.isHidden = true
        descriptionLabel.isHidden = false
        waitingNotification = true
    }

    @IBAction func didAfterStepperValueChanged(_ sender: UIStepper) {
        afterLabel.text = "\(Int(afterStepper.value)) seconds"
    }


}

