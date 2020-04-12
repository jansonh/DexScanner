//
//  Speaker.swift
//  DexScanner
//
//  Created by Janson Hendryli on 12/04/20.
//  Copyright © 2020 Janson Hendryli. All rights reserved.
//

import Foundation
import AVFoundation

struct Speaker {
    static let speechSynthesizer = AVSpeechSynthesizer()
    
    static var isSpeaking: Bool {
        return speechSynthesizer.isSpeaking
    }
    
    // https://medium.com/@WilliamJones/text-to-speech-in-swift-in-5-lines-e6f6c6139086
    static func speakUtterance(text: String) {
        // Create an instance of AVSpeechUtterance and pass in a String to be spoken.
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
        
        // Specify the speech utterance rate.
        // 1 = speaking extremely the higher the values the slower speech patterns.
        // The default rate, AVSpeechUtteranceDefaultSpeechRate is 0.5
        speechUtterance.rate = 0.5
        
        // Specify the speech pitch multiplier.
        // The range is from 0.5 (low) to 2.0 (high). The default rate is 1.0
        speechUtterance.pitchMultiplier = 0.7
        
        // Specify the voice. It is explicitly set to English here, but it will use the device default if not specified.
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        // Pass in the urrerance to the synthesizer to actually speak.
        speechSynthesizer.speak(speechUtterance)
    }
    
    static func stopSpeaking() {
        if isSpeaking {
            speechSynthesizer.stopSpeaking(at: .word)
        }
    }
}
