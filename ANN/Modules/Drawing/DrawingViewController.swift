//
//  DrawingViewController.swift
//  ANN
//
//  Created by user125215 on 3/26/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

final class DrawingViewController: UIViewController {
    
    // MARK: - Properties -
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate let drawingImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    fileprivate let characterBoxImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    fileprivate lazy var characterPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = .menuButton
        pickerView.tintColor = .white
        
        return pickerView
    }()
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Draw into empty area below."
        label.textAlignment = .center
        label.backgroundColor = .menuButton
        label.textColor = .white
        
        return label
    }()
    
    fileprivate let okButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(okButtonPressed), for: .touchUpInside)
        button.setTitle("OK", for: .normal)
        return button
    }()
    
    fileprivate let clearButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        button.setTitle("Clear", for: .normal)
        return button
    }()
    
    fileprivate let lineWidth: CGFloat = 10.0
    fileprivate let characterBoxThickness: CGFloat = 5.0
    fileprivate let pickerViewData = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]
    fileprivate var arrayOfPixelizedCharacters: [[Int]] = []
    fileprivate var arrayOfOutputs: [[Int]] = []
    fileprivate var lastPoint = CGPoint.zero
    fileprivate var characterBox = CGRect.zero
    var presenter: DrawingPresenterInterface!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .menuBackground
        
        setupViews()
    }
    
    // MARK: - Helpers -
    fileprivate func setupViews() {
        
        let controlButtonsStackView = UIStackView()
        let letterPickerStackView = UIStackView()
        
        view.addSubview(controlButtonsStackView)
        view.addSubview(letterPickerStackView)
        view.addSubview(titleLabel)
        view.addSubview(characterBoxImageView)
        view.addSubview(drawingImageView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: controlButtonsStackView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]|", views: controlButtonsStackView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: letterPickerStackView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]-[v1]", views: letterPickerStackView, controlButtonsStackView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: titleLabel)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]", views: titleLabel)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: characterBoxImageView)
        view.addConstraintsWithFormat(format: "V:[v0]-[v1]-[v2]", views: titleLabel, characterBoxImageView, letterPickerStackView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: drawingImageView)
        view.addConstraintsWithFormat(format: "V:[v0]-[v1]-[v2]", views: titleLabel, drawingImageView, letterPickerStackView)
        
        letterPickerStackView.addArrangedSubview(characterPickerView)
        // add control buttons to sv
        
    }
    
    
    
    fileprivate func pixelize(image: UIImage) -> [Int] {
        
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
    
    fileprivate func clearCanvas() {
        drawingImageView.image = nil
        characterBoxImageView.image = nil
        characterBox = .zero
    }
    
    fileprivate func drawLine(fromPoint: CGPoint, toPoint: CGPoint) {
        
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
        
        UIGraphicsBeginImageContext(characterBoxImageView.frame.size)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        characterBoxImageView.image?.draw(in: CGRect(x: 0, y: 0, width: characterBoxImageView.frame.width, height: characterBoxImageView.frame.height))
        
        // Draw character rect
        context.clear(characterBox)
        context.setLineWidth(characterBoxThickness)
        context.setStrokeColor(UIColor.blue.cgColor)
        context.addRect(characterBox)
        context.strokePath()
        
        characterBoxImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
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
    
    func saveCharacterPixelsAndOutput(_ pixelsArray: [Int]) {
        
        // refactor
        
        // First save character pixels
//        arrayOfPixelizedCharacters.append(pixelsArray)
//        
//        let userDefaults = UserDefaults.standard
//        userDefaults.setValue(arrayOfPixelizedCharacters, forKey: characterPixelsArrayKey)
//        
//        userDefaults.synchronize()
//        
//        // Then save the correct output for that character
//        // The array of outputs will be filled with zeroes except
//        // at the index of the selected character
//        // For example output array for B will be [0, 1, 0, 0, 0, ...]
//        var outputArrayForCharacter = Array(repeating: 0, count: pickerViewData.count)
//        
//        for index in 0..<pickerViewData.count {
//            
//            let selectedCharacterIndex = characterPickerView.selectedRow(inComponent: 0)
//            let character = pickerViewData[selectedCharacterIndex]
//            
//            if character == pickerViewData[index] {
//                outputArrayForCharacter[index] = 1
//            }
//        }
//        
//        arrayOfOutputs.append(outputArrayForCharacter)
//        userDefaults.setValue(arrayOfOutputs, forKey: characterOuputArrayKey)
//        
//        userDefaults.synchronize()
    }
    
    // MARK: - Drawing -
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Get the first touched point
        if let point = touches.first?.location(in: drawingImageView) {
            
            // Start tracking coordinates of the character
            if self.characterBox == .zero {
                self.characterBox = CGRect(x: point.x - lineWidth / 2,
                                           y: point.y - lineWidth / 2,
                                           width: lineWidth,
                                           height: lineWidth)
            }
            
            lastPoint = point
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Get the first touched point
        if let point = touches.first?.location(in: drawingImageView) {
            
            drawLine(fromPoint: lastPoint, toPoint: point)
            drawCharacterBox()
            
            // Update character box's dimensions
            if point.x < characterBox.minX {
                updateCharacterBox(&characterBox, minX: point.x - lineWidth - 1, maxX: nil, minY: nil, maxY: nil)
            } else if point.x > characterBox.maxX {
                updateCharacterBox(&characterBox, minX: nil, maxX: point.x + self.lineWidth + 1, minY: nil, maxY: nil)
            }
            if point.y < characterBox.minY {
                updateCharacterBox(&characterBox, minX: nil, maxX: nil, minY: point.y - lineWidth - 1, maxY: nil)
            } else if point.y > characterBox.maxY {
                updateCharacterBox(&characterBox, minX: nil, maxX: nil, minY: nil, maxY: point.y + lineWidth + 1)
            }
            
            lastPoint = point
        }
    }
    
    // MARK: - Button actions -
    
    func okButtonPressed() {
        
    }
    
    func clearButtonPressed() {
        
    }
}

// MARK: - Extensions -

extension DrawingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let rowTitle = pickerViewData[row]
        
        return NSAttributedString(string: rowTitle, attributes: [NSForegroundColorAttributeName:UIColor.menuBackground])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
}

extension DrawingViewController: DrawingViewInterface {
    
    internal func classifyImage() {
    }
    
    internal func processImage() {
        
        guard let croppedImage = drawingImageView.image?.cropImageWith(rect: characterBox) else {
            // error
            return
        }
        
        let size = CGSize(width: 20.0, height: 20.0)
        guard let scaledImage = croppedImage.scaleImageTo(size: size) else { return }
        
        let pixelsArray = pixelize(image: scaledImage)
        
        saveCharacterPixelsAndOutput(pixelsArray)
    }
}
