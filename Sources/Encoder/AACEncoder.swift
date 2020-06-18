//
//  AACEncoder.swift
//  AnyMediaToolbox
//
//  Created by 刘栋 on 2020/6/18.
//  Copyright © 2020 anotheren.com. All rights reserved.
//

import AVFoundation

public protocol AACEncoderDelegate: class {
    
    func encoder(_ encoder: AACEncoder, didSet formatDescription: CMAudioFormatDescription)
    func encoder(_ encoder: AACEncoder, didOutput buffer: AudioAACBuffer)
    func encoder(_ encoder: AACEncoder, didCatch error: Error)
}

public final class AACEncoder {
    
    public var delegate: AACEncoderDelegate?
    
    private let lockQueue = DispatchQueue(label: "com.anotheren.AnyMediaToolbox.AACEncoder")
    
    private var fragmentBytes: [Data] = []
    
    private var converter: AVAudioConverter?
    
    private var isRunning: Bool = false
    
    public init() { }
}

extension AACEncoder {
    
    public func encode(buffer: AudioPCMBuffer) {
        lockQueue.async {
            self.slice(buffer: buffer)
        }
    }
    
    public func starRunning() {
        lockQueue.async {
            guard !self.isRunning else { return }
            self.isRunning = true
        }
    }
    
    public func stopRunning() {
        lockQueue.async {
            guard self.isRunning else { return }
            self.isRunning = false
            self.fragmentBytes.removeAll()
            self.converter?.reset()
            self.converter = nil
        }
    }
}

extension AACEncoder {
    
    private func slice(buffer: AudioPCMBuffer) {
        guard let converter = createConverter(from: buffer.format) else { return }
        
        if buffer.frameLength == 1024 {
            convert(from: buffer, converter: converter)
        } else {
            // merge data
            let dataBytes = buffer.dataBytes()
            if fragmentBytes.isEmpty {
                fragmentBytes = dataBytes
            } else {
                for channel in 0..<fragmentBytes.count {
                    fragmentBytes[channel].append(contentsOf: dataBytes[channel])
                }
            }
            
            // slice data
            let size = dataBytes[0].count / Int(buffer.frameLength)
            let totalFrames = fragmentBytes[0].count / size
            let totalBuffers = totalFrames / 1024
            guard totalBuffers > 0 else { return } // wait for more data
            
            let timeStampZero = buffer.presentationTimeStamp.seconds - Double(totalFrames)/buffer.format.sampleRate
            for index in 0..<totalBuffers {
                var sliceDataBytes: [Data] = []
                for channel in 0..<fragmentBytes.count {
                    let data = fragmentBytes[channel].subdata(in: index*1024..<(index+1)*1024)
                    sliceDataBytes.append(data)
                }
                let seconds = timeStampZero + Double(index * 1024) / buffer.format.sampleRate
                do {
                    let presentationTimeStamp = CMTime(seconds: seconds, preferredTimescale: buffer.presentationTimeStamp.timescale)
                    let pcmBuffer = try AnyAudioPCMBuffer(dataBytes: sliceDataBytes, frameLength: 1024, format: buffer.format, presentationTimeStamp: presentationTimeStamp)
                    convert(from: pcmBuffer, converter: converter)
                } catch {
                    delegate?.encoder(self, didCatch: error)
                }
            }
            
            if fragmentBytes[0].count > totalBuffers * 1024 {
                var newFragmentBytes: [Data] = []
                for channel in 0..<fragmentBytes.count {
                    let data = fragmentBytes[channel].subdata(in: totalBuffers*1024..<fragmentBytes[channel].count)
                    newFragmentBytes.append(data)
                }
                fragmentBytes = newFragmentBytes
            } else {
                fragmentBytes.removeAll()
            }
        }
    }
    
    private func convert(from pcmBuffer: AudioPCMBuffer, converter: AVAudioConverter) {
        let outputBuffer = AVAudioCompressedBuffer(format: converter.outputFormat, packetCapacity: 1, maximumPacketSize: converter.maximumOutputPacketSize)
        var error: NSError?
        converter.convert(to: outputBuffer, error: &error) { (count, status) -> AVAudioBuffer? in
            status.pointee = .haveData
            return pcmBuffer.buffer
        }
        if let error = error {
            delegate?.encoder(self, didCatch: error)
        } else {
            let aacBuffer = AnyAudioAACBuffer(buffer: outputBuffer, presentationTimeStamp: pcmBuffer.presentationTimeStamp)
            delegate?.encoder(self, didOutput: aacBuffer)
        }
    }
    
    private func createConverter(from inputFormat: AVAudioFormat) -> AVAudioConverter? {
        if let converter = converter, converter.inputFormat == inputFormat {
            return converter
        } else {
            var outDescription: AudioStreamBasicDescription = AudioStreamBasicDescription()
            outDescription.mSampleRate = 44100
            outDescription.mFormatID = kAudioFormatMPEG4AAC
            outDescription.mFormatFlags = AudioFormatFlags(MPEG4ObjectID.AAC_LC.rawValue)
            outDescription.mBytesPerPacket = 0
            outDescription.mFramesPerPacket = 1024
            outDescription.mBytesPerFrame = 0
            outDescription.mChannelsPerFrame = inputFormat.channelCount
            outDescription.mBitsPerChannel = 0
            outDescription.mReserved = 0
            
            guard let outputFormat = AVAudioFormat(streamDescription: &outDescription) else {
                return nil
            }
            
            guard let converter = AVAudioConverter(from: inputFormat, to: outputFormat) else {
                return nil
            }
            
            delegate?.encoder(self, didSet: inputFormat.formatDescription)
            fragmentBytes.removeAll()
            
            converter.bitRate = 128000 // TODO
            self.converter = converter
            return converter
        }
    }
}
