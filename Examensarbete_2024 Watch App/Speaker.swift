//
//  Speaker.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-03-27.
//

import Foundation
import WatchKit
import AVFoundation

class Speaker {
    let synthesizer = AVSpeechSynthesizer()

    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "sv-SE")

        synthesizer.speak(utterance)
    }
}
