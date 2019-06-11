//
//  ViewController.swift
//  TapCrackerBeta
//
//  Created by Fauzi Fauzi on 18/05/19.
//  Copyright © 2019 Fauzi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var lineView2: UIView!
    @IBOutlet weak var lineView3: UIView!
    @IBOutlet weak var lineView4: UIView!
    @IBOutlet weak var lineView5: UIView!
    @IBOutlet weak var lineView6: UIView!
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var screenCrackedView: UIView!
    @IBOutlet weak var resetButton: UIButton!
    var point = 0
    var currentDiameter: CGFloat = 0
    var audioPlayer = AVAudioPlayer()
    var audioPlayerPop = AVAudioPlayer()

    

    var isStop = true
    var tappedCount = 0
    weak var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initCracked()
        
        resetButton.layer.cornerRadius = resetButton.frame.width/2
        resetButton.alpha = 0
        
        
        //Sound init
        let sound = Bundle.main.path(forResource: "crackedglasssound", ofType: "mp3")!
        let soundPop = Bundle.main.path(forResource: "popsound", ofType: "m4a")!
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            audioPlayerPop = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPop))

        }
        catch{
            print(error)
        }
        
    }
    
    deinit {
        self.timer?.invalidate()
    }
    
    // function for every tick
    func tick() {
        point -= 2
        if (Int(currentDiameter) > 0){
            UIView.animate(withDuration: 0.03, animations: {
                self.currentDiameter -= 5
                self.tapButton.bounds = CGRect(x: 0, y: 0, width: self.currentDiameter, height: self.currentDiameter)
                self.updateRounded()
            })
        } else {
            isStop = true
            audioPlayerPop.play()
            timer?.invalidate()
            resetButton.borderColor = UIColor.black
            self.tapButton.alpha = 0
            self.showResetButton()
        }
    }
    
    // button tapped
    @IBAction func tapButton(_ sender: UIButton) {
        if isStop{
            isStop = false
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] timer in
                self?.timer = timer
                self?.tick()
            })
        }
        point += 5
        pointLabel.text = String(point)
        if(point >= 50){
            showCracked()
            isStop = true
            timer?.invalidate()
            audioPlayer.play()

        }
        
        UIView.animate(withDuration: 0.05){
            self.currentDiameter += 20
            self.tapButton.bounds = CGRect(x: 0, y: 0, width: self.currentDiameter, height: self.currentDiameter)
            self.updateRounded()
        }
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
    tapButton.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
    restart()
    }
    
    func initCracked(){
        
        currentDiameter = tapButton.bounds.width
        
        self.screenCrackedView.alpha = 0
        pointLabel.alpha = 0
        
        updateRounded()
        lineView2.transform = lineView2.transform.rotated(by: CGFloat(15))
        lineView3.transform = lineView3.transform.rotated(by: CGFloat(30))
        lineView4.transform = lineView3.transform.rotated(by: CGFloat(45))
        lineView5.transform = lineView5.transform.rotated(by: CGFloat(60))
        lineView6.transform = lineView6.transform.rotated(by: CGFloat(70))
    }
    
    func updateRounded(){
        tapButton.layer.cornerRadius = currentDiameter/2
    }
    
    func showCracked() {
        
        resetButton.borderColor = UIColor.white
        UIView.animate(withDuration: 0.2, animations: {
            self.screenCrackedView.alpha = 1
            self.lineView2.alpha = 1
            self.lineView3.alpha = 1
            self.lineView4.alpha = 1
            self.lineView5.alpha = 1
            self.lineView6.alpha = 1
        }, completion: {(finished:Bool) in
            self.showResetButton()
        })
        
    }
    
    func showResetButton(){
        sleep(10)
        UIView.animate(withDuration: 0.5, animations: {
            self.resetButton.alpha = 1
        })
        
    }
    
    func restart(){
        initCracked()
        point = 0
        currentDiameter = 100
        isStop = true
        tappedCount = 0
        resetButton.alpha = 0
        self.tapButton.alpha = 1

    }
}

extension UIView {
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}
