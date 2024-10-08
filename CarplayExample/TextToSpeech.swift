//
//  TextToSpeech.swift
//  CarplayExample
//
//  Created by pablo.rodriguez.local on 8/10/24.
//

//
//  CarPlayTTS.swift
//  CapacitorCommunityAuto
//
//  Created by pablo.rodriguez.local on 9/9/24.
//

import AVFoundation

@MainActor
class TextToSpeech: NSObject {
    
    static let shared = TextToSpeech()
    let speechSynthesizer = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        speechSynthesizer.delegate = self // Establecer el delegado
        configureAudioSession()
    }
    
    // Configurar el AVAudioSession
    func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            
            // Configura la categoría para mezclar audio, interrumpir contenido hablado y atenuar el audio de otras apps
            try audioSession.setCategory(.playback, options: [.mixWithOthers, /*.interruptSpokenAudioAndMixWithOthers,*/ .duckOthers])
            
            // Establecer el modo VoicePrompt para prompts de voz
            try audioSession.setMode(.voicePrompt)
        } catch {
            print("Error configurando la sesión de audio: \(error.localizedDescription)")
        }
    }
    
    // Activar la sesión de audio
    func activateAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            print("Sesión de audio activada")
        } catch {
            print("Error al activar la sesión de audio: \(error.localizedDescription)")
        }
    }
    
    // Desactivar la sesión de audio
    func deactivateAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
            print("Sesión de audio desactivada")
        } catch {
            print("Error al desactivar la sesión de audio: \(error.localizedDescription)")
        }
    }
    
    // Reproducir el texto utilizando TTS
    func speakText(_ text: String) {
        DispatchQueue.main.async {
            self.activateAudioSession() // Activate audio session on the main thread
            
            let speechUtterance = AVSpeechUtterance(string: text)
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
            speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
            speechUtterance.pitchMultiplier = 1.0
            
            self.speechSynthesizer.speak(speechUtterance)
        }
    }
}

// MARK: - AVSpeechSynthesizerDelegate

extension TextToSpeech: AVSpeechSynthesizerDelegate {
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("Reproducción de texto finalizada")
        DispatchQueue.main.async{
            self.deactivateAudioSession()
        }
    }
}
