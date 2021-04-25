//
//  ViewController.swift
//  Swiftracer-macOS
//
//  Created by Prezi on 2021. 02. 21..
//

import Cocoa
import SwiftRayTracer

class ViewController: NSViewController {
    private var renderRunner = RenderRunner()
    private var timer: Timer?
    private var timeElapsed: TimeInterval = 0
    private var timeFormatter: DateComponentsFormatter?

    @IBOutlet var actionButton: NSButton!
    @IBOutlet var timeLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderRunner.delegate = self
        
        timeFormatter = DateComponentsFormatter()
        timeFormatter?.unitsStyle = .positional
        timeFormatter?.allowedUnits = [.hour, .minute, .second]
        timeFormatter?.zeroFormattingBehavior = .pad
        timeFormatter?.collapsesLargestUnit = false
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        actionButton.isEnabled = false
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.renderRunner.runFirstWorld()
        }
        
        startTimer()
    }
    
    private func timerDidFire() {
        timeElapsed += 1
        guard let timeString = timeFormatter?.string(from: timeElapsed) else {
            return
        }
        timeLabel.stringValue = timeString
    }
    
    private func startTimer() {
        if timer != nil {
            stopTimer()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.timerDidFire()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension ViewController: RenderRunnerDelegate {
    func didFinishRunningFirstWorld(error: Error?) {
        DispatchQueue.main.async { [weak self] in
            self?.stopTimer()
            self?.actionButton.isEnabled = true
        }
    }
}
