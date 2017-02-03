//
//  DrawViewController.swift
//  ANN
//
//  Created by Hrvoje Baic on 30/01/17.
//

import UIKit
import Foundation

class DrawViewController: UIViewController {
    
    // MARK: - Public Properties -
    var presenter: DrawViewControllerDelegateProtocol!
    
    // MARK: - Private properties -
    private let lineWidth: CGFloat = 10.0
    private let characterBoxThickness: CGFloat = 1.0
    private let pickerViewData = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]
    // TODO: Refactor these constants and view controller identifiers also
    private let characterPixelsArrayKey = "characterPixelsArrayKey"
    private let characterOuputArrayKey = "characterOuputArrayKey"
    
    private var lastPoint = CGPointZero
    private var characterBox: CGRect?
    private var arrayOfPixelizedCharacters: [[Int]] = []
    private var arrayOfOutputs: [[Int]] = []

    // MARK: - Outlets -
    @IBOutlet weak var drawingImageView: UIImageView!
    @IBOutlet weak var characterBoxImageView: UIImageView!
    @IBOutlet weak var characterPickerView: UIPickerView!
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Setup -
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Delegate methods -
    @IBAction func okButtonPressed(sender: UIButton) {
        presenter.okButtonPressed()
    }
    @IBAction func clearButtonPressed(sender: UIButton) {
        clearCanvas()
    }
    @IBAction func cancelButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Neural network -
    func createNeuralNetwork(inputData: [[Int]], outputData: [[Int]]){
        
        let neuralNetwork = NeuralNetwork(topology: [inputData[0].count, 3, outputData[0].count])
        
        neuralNetwork.trainNetwork(inputData, outputData: outputData, numberOfEpochs: 2000, learningRate: 0.5)
        //neuralNetwork.feed([[1, 1, 1, 1], [0, 0, 0, 1]])
        
        // Uncomment to print initial weights and biases
        // Note that input layer's neuron's weights and bias are default
        //        for layer in neuralNetwork.layers {
        //
        //            for neuron in layer.neurons {
        //                print("WEIGHTS: \(neuron.weights) \n")
        //                print("BIAS: \(neuron.bias) \n\n")
        //            }
        //        }
    }
    
    // MARK: - Internal -
    internal func processImage() {
        
        if let characterBox = characterBox {
            if let croppedImage = drawingImageView.image?.cropImageWithRect(characterBox) {
                
                let size = CGSize(width: 40.0, height: 40.0)
                let scaledImage = croppedImage.scaleImageToSize(size)
                let pixelsArray = pixelizeImage(scaledImage)
                
                saveCharacterPixelsAndOutput(pixelsArray)
            } else {
                // TODO: Show cropping error
            }
        } else {
            // TODO: Show charBox error
        }
    }
    
    private func pixelizeImage(image: UIImage) -> [Int] {
        
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        var pixelsArray = [Int]()
        let bytesPerRow = CGImageGetBytesPerRow(image.CGImage)
        let bytesPerPixel = (CGImageGetBitsPerPixel(image.CGImage) / 8)
        var position = 0
        for _ in 0..<Int(image.size.height) {
            for _ in 0..<Int(image.size.width) {
                let alpha = Float(data[position + 3])
                pixelsArray.append(Int(alpha / 255))
                position += Int(bytesPerPixel)
            }
            if position % Int(bytesPerRow) != 0 {
                position += (Int(bytesPerRow) - (position % Int(bytesPerRow)))
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
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        // Get the first touched point
        if let point = touches.allObjects.first?.locationInView(drawingImageView) {
            
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
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        // Get the first touched point
        if let point = touches.allObjects.first?.locationInView(drawingImageView) {

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
    func saveCharacterPixelsAndOutput(pixelsArray: [Int]) {
        
        // First save character pixels
        arrayOfPixelizedCharacters.append(pixelsArray)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(arrayOfPixelizedCharacters, forKey: characterPixelsArrayKey)
        
        
        // Then save the correct output for that character
        // The array of outputs will be filled with zeroes except
        // at the index of the selected character
        // For example output array for B will be [0, 1, 0, 0, 0, ...]
        var outputArrayForCharacter = Array(0..<pickerViewData.count)
        
        for index in 0..<pickerViewData.count {
            
            let selectedCharacterIndex = characterPickerView.selectedRowInComponent(0)
            let character = pickerViewData[selectedCharacterIndex]
            
            if character == pickerViewData[index] {
                outputArrayForCharacter[index] = 1
            }
        }
        
        arrayOfOutputs.append(outputArrayForCharacter)
        userDefaults.setValue(arrayOfOutputs, forKey: characterOuputArrayKey)
        
        userDefaults.synchronize()
    }
    
    func loadCharacterPixelsAndOutput() -> ([[Int]], [[Int]]) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let characterPixelsArray = userDefaults.arrayForKey(characterPixelsArrayKey) as [[Int]]
        let characterOutputArray = userDefaults.arrayForKey(characterOuputArrayKey) as [[Int]]
        
        return (characterPixelsArray, characterOutputArray)
    }
    
    private func drawLine(fromPoint: CGPoint, toPoint: CGPoint) {
        
        // Begin context
        UIGraphicsBeginImageContext(self.drawingImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        // Store current image (lines drawn) in context
        self.drawingImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: self.drawingImageView.frame.width, height: self.drawingImageView.frame.height))
        
        // Add new line to image
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetLineWidth(context, lineWidth)
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0)
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        CGContextStrokePath(context)
        
        // Store modified image back to imageView
        self.drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        // End context
        UIGraphicsEndImageContext()
    }
    
    private func drawCharacterBox() {
        
        UIGraphicsBeginImageContext(self.characterBoxImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        self.characterBoxImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: self.characterBoxImageView.frame.width, height: self.characterBoxImageView.frame.height))
        
        // Draw character rect
        CGContextClearRect(context, characterBox!)
        CGContextSetLineWidth(context, characterBoxThickness)
        CGContextSetStrokeColorWithColor(context, UIColor.blueColor().CGColor)
        CGContextAddRect(context, self.characterBox!)
        CGContextStrokePath(context)
        self.characterBoxImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO: Animate rect to be less snappy if possible
    }
    
    // CGRect is a struct and therefore passed by value, 
    // so the parameter must be declared as inout and passed by reference
    private func updateCharacterBox(inout rect: CGRect, minX: CGFloat?, maxX: CGFloat?, minY: CGFloat?, maxY: CGFloat?) {
        rect = CGRect(x: minX ?? rect.minX,
            y: minY ?? rect.minY,
            width: (maxX ?? rect.maxX) - (minX ?? rect.minX),
            height: (maxY ?? rect.maxY) - (minY ?? rect.minY))
    }
}

extension DrawViewController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
}

extension DrawViewController: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerViewData[row]
    }
}
