//
//  BarcodeReaderViewController.swift
//  Hinsdale South High School App
//
//  Created by Namit Sambare on 2/15/16.
//  Copyright © 2016 Hornet App Development. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import RSBarcodes

protocol BarcodeReaderProtocol: class {
    func barcodeReaderDidScanBarcode(_ barcode: AVMetadataMachineReadableCodeObject)
}

class BarcodeReaderViewController: RSCodeReaderViewController {
    weak var delegate: BarcodeReaderProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.focusMarkLayer.strokeColor = UIColor.red.cgColor
        self.cornersLayer.strokeColor = UIColor.yellow.cgColor
        
        var mutableTypes = output.availableMetadataObjectTypes
        mutableTypes = mutableTypes.filter { $0.rawValue != AVMetadataObject.ObjectType.qr.rawValue }
        self.output.metadataObjectTypes = mutableTypes
        
        self.barcodesHandler = { barcodes in
            for barcode in barcodes {
                print("Barcode found: type=" + barcode.type.rawValue + " value=" + barcode.stringValue!)

                DispatchQueue.main.async(execute: {
                    self.delegate?.barcodeReaderDidScanBarcode(barcode)
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
}
