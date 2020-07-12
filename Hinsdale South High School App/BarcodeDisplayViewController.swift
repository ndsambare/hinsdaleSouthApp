//
//  BarcodeDisplayViewController.swift
//  Hinsdale South High School App
//
//  Created by Namit Sambare on 2/15/16.
//  Copyright © 2016 Hornet App Development. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import RSBarcodes

class BarcodeDisplayViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, BarcodeReaderProtocol {
    @IBOutlet weak var imageDisplayed: UIImageView!
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    fileprivate let gen = RSUnifiedCodeGenerator.shared
    fileprivate var addEditBarcodeButtonItem: UIBarButtonItem?
    fileprivate var addEditPhotoButtonItem: UIBarButtonItem?

    fileprivate let barcodeReaderIdentifier = "barcodeReader"
    fileprivate let barcodeDefaultsKey = "virtualID"
    fileprivate let barcodeParamsType = "type"
    fileprivate let barcodeParamsValue = "value"

    fileprivate let imageDefaultsKey = "image"
    fileprivate var instructionsShown = true

    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.clearBackButtonText()
        gen.fillColor = UIColor.white
        gen.strokeColor = UIColor.black

        addEditBarcodeButtonItem = UIBarButtonItem(title: "Add Barcode", style: .plain, target: self, action: #selector(displayBarcodeReader))
        navigationItem.rightBarButtonItem = addEditBarcodeButtonItem

        addEditPhotoButtonItem = UIBarButtonItem(title: "Add Photo", style: .plain, target: self, action: #selector(displayImagePicker))
        navigationItem.leftBarButtonItem = addEditPhotoButtonItem

        guard let virtualID = UserDefaults.standard.object(forKey: barcodeDefaultsKey) as? [String: String],
            let savedImageData = UserDefaults.standard.object(forKey: imageDefaultsKey) as? Data else {
                instructionsShown = false
                return
        }

        addEditBarcodeButtonItem?.title = "Edit Barcode"
        generateImageFromBarcode(virtualID)

        addEditPhotoButtonItem?.title = "Edit Photo"
        generatePhotoFromSavedImage(savedImageData)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !instructionsShown {
            let message = "The barcode on your ID represents your virtual ID. Scan the barcode and take a picture " +
            "of your card with your photo to present it to security for verification."
            let alertVC = UIAlertController(title: "Instructions", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Dismiss", style:.default, handler: nil)
            alertVC.addAction(okAction)

            present(alertVC, animated: true, completion: nil)
            instructionsShown = true
        }
    }

    @objc func displayImagePicker() {
        imagePicker =  UIImagePickerController()

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            displayNoCameraAlert()
        }
    }

    func displayNoCameraAlert() {
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)

        present(alertVC, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {            
            imageView.image = pickedImage

            if let jpegImage = UIImageJPEGRepresentation(pickedImage, 1.0) {
                let imageData = NSData(data: jpegImage) as Data
                UserDefaults.standard.set(imageData, forKey: imageDefaultsKey)
                addEditPhotoButtonItem?.title = "Edit Photo"
            }
        }
    }

    fileprivate func generatePhotoFromSavedImage(_ imageData: Data) {
        if let image = UIImage(data: imageData) {
            imageView.image = image
        }
    }

    fileprivate func generateImageFromBarcode(_ barcode: [String: String]) {
        let image: UIImage? = gen.generateCode(barcode[barcodeParamsValue]!, machineReadableCodeObjectType: barcode[barcodeParamsType]!)
        self.imageDisplayed.image = image
        self.barcodeLabel.text = barcode[barcodeParamsValue]!
    }

    @objc func displayBarcodeReader() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let barcodeReader = storyboard.instantiateViewController(withIdentifier: barcodeReaderIdentifier) as? BarcodeReaderViewController {
            barcodeReader.delegate = self
            navigationController?.pushViewController(barcodeReader, animated: true)
        }
    }

    //MARK :- BarcodeReaderProtocol
    func barcodeReaderDidScanBarcode(_ barcode: AVMetadataMachineReadableCodeObject) {
        let barcodeParams = [barcodeParamsType: barcode.type.rawValue, barcodeParamsValue: barcode.stringValue!]
        UserDefaults.standard.set(barcodeParams, forKey: barcodeDefaultsKey)
        addEditBarcodeButtonItem?.title = "Edit Barcode"
        generateImageFromBarcode(barcodeParams)
    }
}
