// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// Classic FM Synthesis audio generation.
public class FMOscillator: AKNode, AKComponent, AKToggleable {

    public static let ComponentDescription = AudioComponentDescription(generator: "fosc")

    public typealias AKAudioUnitType = InternalAU

    public private(set) var internalAU: AKAudioUnitType?

    // MARK: - Parameters

    fileprivate var waveform: AKTable?

    public static let baseFrequencyDef = AKNodeParameterDef(
        identifier: "baseFrequency",
        name: "Base Frequency (Hz)",
        address: akGetParameterAddress("FMOscillatorParameterBaseFrequency"),
        range: 0.0 ... 20_000.0,
        unit: .hertz,
        flags: .default)

    /// In cycles per second, the common denominator for the carrier and modulating frequencies.
    @Parameter public var baseFrequency: AUValue

    public static let carrierMultiplierDef = AKNodeParameterDef(
        identifier: "carrierMultiplier",
        name: "Carrier Multiplier",
        address: akGetParameterAddress("FMOscillatorParameterCarrierMultiplier"),
        range: 0.0 ... 1_000.0,
        unit: .generic,
        flags: .default)

    /// This multiplied by the baseFrequency gives the carrier frequency.
    @Parameter public var carrierMultiplier: AUValue

    public static let modulatingMultiplierDef = AKNodeParameterDef(
        identifier: "modulatingMultiplier",
        name: "Modulating Multiplier",
        address: akGetParameterAddress("FMOscillatorParameterModulatingMultiplier"),
        range: 0.0 ... 1_000.0,
        unit: .generic,
        flags: .default)

    /// This multiplied by the baseFrequency gives the modulating frequency.
    @Parameter public var modulatingMultiplier: AUValue

    public static let modulationIndexDef = AKNodeParameterDef(
        identifier: "modulationIndex",
        name: "Modulation Index",
        address: akGetParameterAddress("FMOscillatorParameterModulationIndex"),
        range: 0.0 ... 1_000.0,
        unit: .generic,
        flags: .default)

    /// This multiplied by the modulating frequency gives the modulation amplitude.
    @Parameter public var modulationIndex: AUValue

    public static let amplitudeDef = AKNodeParameterDef(
        identifier: "amplitude",
        name: "Amplitude",
        address: akGetParameterAddress("FMOscillatorParameterAmplitude"),
        range: 0.0 ... 10.0,
        unit: .generic,
        flags: .default)

    /// Output Amplitude.
    @Parameter public var amplitude: AUValue

    // MARK: - Audio Unit

    public class InternalAU: AudioUnitBase {

        public override func getParameterDefs() -> [AKNodeParameterDef] {
            [FMOscillator.baseFrequencyDef,
             FMOscillator.carrierMultiplierDef,
             FMOscillator.modulatingMultiplierDef,
             FMOscillator.modulationIndexDef,
             FMOscillator.amplitudeDef]
        }

        public override func createDSP() -> AKDSPRef {
            akCreateDSP("FMOscillatorDSP")
        }
    }

    // MARK: - Initialization

    /// Initialize this oscillator node
    ///
    /// - Parameters:
    ///   - waveform: The waveform of oscillation
    ///   - baseFrequency: In cycles per second, the common denominator for the carrier and modulating frequencies.
    ///   - carrierMultiplier: This multiplied by the baseFrequency gives the carrier frequency.
    ///   - modulatingMultiplier: This multiplied by the baseFrequency gives the modulating frequency.
    ///   - modulationIndex: This multiplied by the modulating frequency gives the modulation amplitude.
    ///   - amplitude: Output Amplitude.
    ///
    public init(
        waveform: AKTable = AKTable(.sine),
        baseFrequency: AUValue = 440.0,
        carrierMultiplier: AUValue = 1.0,
        modulatingMultiplier: AUValue = 1.0,
        modulationIndex: AUValue = 1.0,
        amplitude: AUValue = 1.0
    ) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AKAudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit

            audioUnit.setWavetable(waveform.content)

            self.waveform = waveform
            self.baseFrequency = baseFrequency
            self.carrierMultiplier = carrierMultiplier
            self.modulatingMultiplier = modulatingMultiplier
            self.modulationIndex = modulationIndex
            self.amplitude = amplitude
        }

    }
}
