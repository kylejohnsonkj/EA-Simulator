//
//  ViewController.swift
//  EA Simulator
//
//  Created by Kyle Johnson on 11/22/17.
//  Copyright © 2017 Kyle Johnson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var fuckYou: UILabel!
    @IBOutlet weak var sponsoredByEA: UILabel!
    
    var words: [String] = []
    var index = 0
    var currentText = ""
    var confettiView: SAConfettiView!
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.delegate = self
        
        if let file = Bundle.main.path(forResource: "EA", ofType: "txt") {
            if let contents = try? String(contentsOfFile: file) {
                words = contents.components(separatedBy: [" ", "\n"])
                print(words)
            }
        }

        textView.text! = ""
        gifView.image = nil
        fuckYou.alpha = 0
        sponsoredByEA.alpha = 0
        textView.becomeFirstResponder()
        
        // preload confetti
        confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.colors = [UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
                               UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
                               UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
                               UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
                               UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)]
        confettiView.intensity = 0.8
        confettiView.type = .confetti
        UIApplication.shared.keyWindow?.addSubview(confettiView)
    }

    func textViewDidChange(_ textView: UITextView) {
        if index < words.count {
            if words[index] == "" {
                currentText += "\n\n"
            } else {
                currentText += words[index] + " "
            }
            index += 1
        } else {
            textView.isEditable = false
            gifView.image = UIImage(named: "fuck_you.gif")
            
            let screenHeight = CGFloat(UIScreen.main.bounds.height)
            UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseInOut], animations: {
                self.gifView.frame.origin.y = screenHeight / 2 - self.gifView.frame.height / 2 + (self.navigationController?.navigationBar.frame.height)! / 2
                textView.alpha = 0
            }, completion: { _ in
                self.gifView.loadGif(name: "fuck_you")
                
                self.playPartyHorn()
                
                self.confettiView.startConfetti()
                UIView.animate(withDuration: 2, animations: {
                    self.fuckYou.alpha = 1
                    self.sponsoredByEA.alpha = 1
                })
                UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
                    self.fuckYou.transform = CGAffineTransform(scaleX: 1.20, y: 1.20)
                })
            })
        }
        textView.text! = currentText
        spawn🖕()
    }
    
    func playPartyHorn() {
        let path = Bundle.main.path(forResource: "party_horn", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    func spawn🖕() {
        let screenWidth = UInt32(UIScreen.main.bounds.width)
        let randomPositionX = Int(arc4random_uniform(screenWidth))
        let randomPositionY = Int(arc4random_uniform(50))
        
        let emojiLabel = UILabel(frame: CGRect(x: randomPositionX - 20, y: randomPositionY + 10, width: 40, height: 40))
        emojiLabel.text = "🖕"
        emojiLabel.font = UIFont(name: "Helvetica", size: 40)
        UIApplication.shared.keyWindow?.addSubview(emojiLabel)
        emojiLabel.alpha = 0.5
        
        let screenHeight = CGFloat(UIScreen.main.bounds.height)
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn], animations: {
            emojiLabel.frame.origin.y += screenHeight
        }, completion: { _ in
            emojiLabel.removeFromSuperview()
        })
    }
    
}

