//
//  DrawViewController.swift
//  ANN
//
//  Created by Hrvoje Baic on 30/01/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit
import Foundation

class DrawViewController: UIViewController {
    
    // MARK: - Public Properties -
    var presenter: DrawViewControllerDelegateProtocol!
    
    // MARK: - Private properties -
    fileprivate let lineWidth: CGFloat = 10.0
    fileprivate let characterBoxThickness: CGFloat = 1.0
    fileprivate let pickerViewData = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]
    // TODO: Refactor these constants and view controller identifiers also
    fileprivate let characterPixelsArrayKey = "characterPixelsArrayKey"
    fileprivate let characterOuputArrayKey = "characterOuputArrayKey"
    
    fileprivate var lastPoint = CGPoint.zero
    fileprivate var characterBox: CGRect?
    fileprivate var arrayOfPixelizedCharacters: [[Int]] = []
    fileprivate var arrayOfOutputs: [[Int]] = []

    // MARK: - Outlets -
    @IBOutlet weak var drawingImageView: UIImageView!
    @IBOutlet weak var characterBoxImageView: UIImageView!
    @IBOutlet weak var characterPickerView: UIPickerView!
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Setup -
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // MARK: - Delegate methods -
    @IBAction func okButtonPressed(_ sender: UIButton) {
        presenter.okButtonPressed()
    }
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        clearCanvas()
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Internal -
    internal func processImage() {
        
        if let characterBox = characterBox {
            if let croppedImage = drawingImageView.image?.cropImageWith(rect: characterBox) {
                
                let size = CGSize(width: 20.0, height: 20.0)
                let scaledImage = croppedImage.scaleImageTo(size: size)
                let pixelsArray = pixelizeImage(scaledImage!)
                
                saveCharacterPixelsAndOutput(pixelsArray)
            } else {
                // TODO: Show cropping error
            }
        } else {
            // TODO: Show charBox error
        }
    }
    
    internal func classifyImage() {
        
    }
    
    fileprivate func pixelizeImage(_ image: UIImage) -> [Int] {
        
        let pixelData = image.cgImage?.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        var pixelsArray = [Int]()
        let bytesPerRow = image.cgImage?.bytesPerRow
        let bytesPerPixel = ((image.cgImage?.bitsPerPixel)! / 8)
        var position = 0
        for _ in 0..<Int(image.size.height) {
            for _ in 0..<Int(image.size.width) {
                let alpha = Float(data[position + 3])
                pixelsArray.append(Int(alpha / 255))
                position += Int(bytesPerPixel)
            }
            if position % Int(bytesPerRow!) != 0 {
                position += (Int(bytesPerRow!) - (position % Int(bytesPerRow!)))
            }
        }
        return pixelsArray
    }
    
    internal func clearCanvas() {
        drawingImageView.image = nil
        characterBoxImageView.image = nil
        characterBox = nil
    }
    
    // MARK: - Drawing -
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        // Get the first touched point
        if let point = touches.first?.location(in: drawingImageView) {
            
            // Start tracking coordinates of the character
            if self.characterBox == nil {
                self.characterBox = CGRect(x: point.x - self.lineWidth / 2,
                    y: point.y - self.lineWidth / 2,
                    width: self.lineWidth,
                    height: self.lineWidth)
            }
            
            lastPoint = point
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Get the first touched point
        if let point = touches.first?.location(in: drawingImageView) {

            self.drawLine(lastPoint, toPoint: point)
            self.drawCharacterBox()
            
            // Update character box's dimensions
            if point.x < self.characterBox!.minX {
                self.updateCharacterBox(&self.characterBox!, minX: point.x - self.lineWidth - 1, maxX: nil, minY: nil, maxY: nil)
            } else if point.x > self.characterBox!.maxX {
                self.updateCharacterBox(&self.characterBox!, minX: nil, maxX: point.x + self.lineWidth + 1, minY: nil, maxY: nil)
            }
            if point.y < self.characterBox!.minY {
                self.updateCharacterBox(&self.characterBox!, minX: nil, maxX: nil, minY: point.y - self.lineWidth - 1, maxY: nil)
            } else if point.y > self.characterBox!.maxY {
                self.updateCharacterBox(&self.characterBox!, minX: nil, maxX: nil, minY: nil, maxY: point.y + self.lineWidth + 1)
            }
            
            self.lastPoint = point
        }
    }
    
    // MARK: - Helpers -
    func saveCharacterPixelsAndOutput(_ pixelsArray: [Int]) {
        
        // First save character pixels
        arrayOfPixelizedCharacters.append(pixelsArray)
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(arrayOfPixelizedCharacters, forKey: characterPixelsArrayKey)
        
        userDefaults.synchronize()
        
        // Then save the correct output for that character
        // The array of outputs will be filled with zeroes except
        // at the index of the selected character
        // For example output array for B will be [0, 1, 0, 0, 0, ...]
        var outputArrayForCharacter = Array(repeating: 0, count: pickerViewData.count)
        
        for index in 0..<pickerViewData.count {
            
            let selectedCharacterIndex = characterPickerView.selectedRow(inComponent: 0)
            let character = pickerViewData[selectedCharacterIndex]
            
            if character == pickerViewData[index] {
                outputArrayForCharacter[index] = 1
            }
        }
        
        arrayOfOutputs.append(outputArrayForCharacter)
        userDefaults.setValue(arrayOfOutputs, forKey: characterOuputArrayKey)
        
        userDefaults.synchronize()
    }
    
    fileprivate func drawLine(_ fromPoint: CGPoint, toPoint: CGPoint) {
        
        // Begin context
        UIGraphicsBeginImageContext(self.drawingImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        // Store current image (lines drawn) in context
        self.drawingImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.drawingImageView.frame.width, height: self.drawingImageView.frame.height))
        
        // Add new line to image
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        context?.setLineCap(.round)
        context?.setLineWidth(lineWidth)
        context?.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        context?.setBlendMode(.normal)
        context?.strokePath()
        
        // Store modified image back to imageView
        self.drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        // End context
        UIGraphicsEndImageContext()
    }
    
    fileprivate func drawCharacterBox() {
        
        UIGraphicsBeginImageContext(self.characterBoxImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        self.characterBoxImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.characterBoxImageView.frame.width, height: self.characterBoxImageView.frame.height))
        
        // Draw character rect
        context?.clear(characterBox!)
        context?.setLineWidth(characterBoxThickness)
        context?.setStrokeColor(UIColor.blue.cgColor)
        context?.addRect(self.characterBox!)
        context?.strokePath()
        self.characterBoxImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO: Animate rect to be less snappy if possible
    }
    
    // CGRect is a struct and therefore passed by value, 
    // so the parameter must be declared as inout and passed by reference
    fileprivate func updateCharacterBox(_ rect: inout CGRect, minX: CGFloat?, maxX: CGFloat?, minY: CGFloat?, maxY: CGFloat?) {
        rect = CGRect(x: minX ?? rect.minX,
            y: minY ?? rect.minY,
            width: (maxX ?? rect.maxX) - (minX ?? rect.minX),
            height: (maxY ?? rect.maxY) - (minY ?? rect.minY))
    }
}

extension DrawViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
}

extension DrawViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
}
