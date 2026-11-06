import AVFoundation
import SwiftUI

/// A short rising chime for a correct answer.
/// Plays only when in-app volume is on and the device volume is turned up.
final class CorrectAnswerChime {
    static let shared = CorrectAnswerChime()
    static let enabledDefaultsKey = "movo.soundEffectsEnabled"

    private var player: AVAudioPlayer?
    private var didConfigureSession = false

    private init() {
        player = try? AVAudioPlayer(data: Self.makeWavData())
        player?.prepareToPlay()
        player?.volume = 0.9
    }

    /// Missing key means sound is on, so a first launch still celebrates.
    static var isEnabled: Bool {
        let defaults = UserDefaults.standard
        guard defaults.object(forKey: enabledDefaultsKey) != nil else { return true }
        return defaults.bool(forKey: enabledDefaultsKey)
    }

    func playIfVolumeOn() {
        guard Self.isEnabled, let player else { return }
        let session = AVAudioSession.sharedInstance()
        do {
            if !didConfigureSession {
                try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
                didConfigureSession = true
            }
            try session.setActive(true)
        } catch {
            return
        }

        // Side-button volume at zero: stay quiet.
        guard session.outputVolume > 0.01 else { return }

        player.currentTime = 0
        player.play()
    }

    /// Two soft bell tones a major third apart. Short enough to cheer, not to linger.
    private static func makeWavData() -> Data {
        let sampleRate = 44_100
        let duration = 0.52
        let frameCount = Int(Double(sampleRate) * duration)

        struct Tone {
            let frequency: Double
            let start: Double
            let length: Double
            let gain: Double
        }

        let tones = [
            Tone(frequency: 659.25, start: 0.0, length: 0.40, gain: 0.52),
            Tone(frequency: 830.61, start: 0.10, length: 0.42, gain: 0.46)
        ]

        var pcm = [Int16]()
        pcm.reserveCapacity(frameCount)

        for index in 0..<frameCount {
            let time = Double(index) / Double(sampleRate)
            var sample = 0.0
            for tone in tones {
                let local = time - tone.start
                guard local >= 0, local < tone.length else { continue }
                let attack = min(1.0, local / 0.012)
                let release = min(1.0, (tone.length - local) / 0.04)
                let decay = exp(-5.2 * local)
                let envelope = attack * release * decay
                let fundamental = sin(2 * Double.pi * tone.frequency * local)
                let sparkle = 0.18 * sin(2 * Double.pi * tone.frequency * 2.003 * local) * exp(-6 * local)
                sample += tone.gain * envelope * (fundamental + sparkle)
            }
            let shaped = tanh(sample * 1.15)
            let clamped = max(-1.0, min(1.0, shaped))
            pcm.append(Int16(clamped * 32_000))
        }

        return wavData(samples: pcm, sampleRate: sampleRate)
    }

    private static func wavData(samples: [Int16], sampleRate: Int) -> Data {
        let dataSize = samples.count * MemoryLayout<Int16>.size
        var data = Data()
        data.append(contentsOf: [0x52, 0x49, 0x46, 0x46]) // RIFF
        appendUInt32(UInt32(36 + dataSize), to: &data)
        data.append(contentsOf: [0x57, 0x41, 0x56, 0x45]) // WAVE
        data.append(contentsOf: [0x66, 0x6D, 0x74, 0x20]) // fmt
        appendUInt32(16, to: &data)
        appendUInt16(1, to: &data) // PCM
        appendUInt16(1, to: &data) // mono
        appendUInt32(UInt32(sampleRate), to: &data)
        appendUInt32(UInt32(sampleRate * 2), to: &data)
        appendUInt16(2, to: &data)
        appendUInt16(16, to: &data)
        data.append(contentsOf: [0x64, 0x61, 0x74, 0x61]) // data
        appendUInt32(UInt32(dataSize), to: &data)
        samples.withUnsafeBufferPointer { buffer in
            guard let base = buffer.baseAddress else { return }
            data.append(UnsafeBufferPointer(start: base, count: buffer.count))
        }
        return data
    }

    private static func appendUInt16(_ value: UInt16, to data: inout Data) {
        var little = value.littleEndian
        withUnsafeBytes(of: &little) { data.append(contentsOf: $0) }
    }

    private static func appendUInt32(_ value: UInt32, to data: inout Data) {
        var little = value.littleEndian
        withUnsafeBytes(of: &little) { data.append(contentsOf: $0) }
    }
}

/// Speaker control for the correct-answer chime. Shared by Home and lessons.
struct SoundEffectsToggleButton: View {
    @AppStorage(CorrectAnswerChime.enabledDefaultsKey) private var soundOn = true
    var accent: Color = DesignSystem.Colors.skyBlue

    var body: some View {
        Button {
            soundOn.toggle()
            if soundOn {
                CorrectAnswerChime.shared.playIfVolumeOn()
            }
        } label: {
            Image(systemName: soundOn ? "speaker.wave.2.fill" : "speaker.slash.fill")
                .font(.padScaled(size: 18, weight: .bold))
                .foregroundStyle(soundOn ? accent : DesignSystem.Colors.mutedText)
                .frame(width: DesignSystem.Metrics.scaled(48), height: DesignSystem.Metrics.scaled(48))
                .background(Color.white.opacity(0.94))
                .clipShape(Circle())
                .shadow(color: DesignSystem.Colors.softCardShadow, radius: 8, y: 3)
                .symbolEffect(.bounce, value: soundOn)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Volume")
        .accessibilityValue(soundOn ? "On" : "Off")
        .accessibilityHint("Plays a chime when an answer is correct")
    }
}
