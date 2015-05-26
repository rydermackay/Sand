//
//  Sandbox.swift
//  Sand
//
//  Created by Ryder Mackay on 2015-05-26.
//  Copyright (c) 2015 Ryder Mackay. All rights reserved.
//

import Foundation

final class Sandbox {
    
    let bufferSize: Int64 = 1024
    
    let fileHandle: NSFileHandle
    let URL: NSURL = {
        let docs = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: nil)!
        return docs.URLByAppendingPathComponent(NSUUID().UUIDString)
    }()
    
    init () {
        var error: NSError?
        NSFileManager.defaultManager().createFileAtPath(URL.path!, contents: nil, attributes: nil)
        fileHandle = NSFileHandle(forWritingToURL: URL, error: &error)!
    }
    
    func fill(bytes: Int64) {
        var written: Int64 = 0
        do {
            let length = Int(min(bufferSize, bytes - written))
            let buffer: [UInt8] = Array(count: length, repeatedValue: 0xFF)
            let data = NSData(bytes: buffer, length: buffer.count)
            fileHandle.writeData(data)  // swift lacks exception handling; oops
            written += length
        } while written < bytes
        println("wrote \(written) bytes total")
        fileHandle.synchronizeFile()
    }
    
    func fill() {
        fill(Int64.max)
    }
    
    var usage: (free: Int64, total: Int64) {
        let tmp = NSTemporaryDirectory()
        var error: NSError?
        if let attributes = NSFileManager.defaultManager().attributesOfFileSystemForPath(tmp, error: &error) {
            let total = attributes[NSFileSystemSize]!.longLongValue
            let free = attributes[NSFileSystemFreeSize]!.longLongValue
            return (free, total)
        } else {
            println("error getting attributes: \(error!)")
            return (0, 0)
        }
    }
}
