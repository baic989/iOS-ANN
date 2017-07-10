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
    
    // Touch gesture will draw into this image view
    fileprivate let drawingImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // A box surrounding the letter
    // Initially for debug purposes but looks cool
    fileprivate let characterBoxImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.setImage(UIImage(named: "arrow-left"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // Picker view with all available letters to learn
    lazy var characterPickerView: UIPickerView = {
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
    
    // Saves the image into pixels array
    fileprivate let okButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(okButtonPressed), for: .touchUpInside)
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.menuButton, for: .normal)
        return button
    }()
    
    // Clears the drawing area
    fileprivate let clearButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(.menuButton, for: .normal)
        return button
    }()
    
    // Trains the network after processing the drawing
    var trainButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(trainButtonPressed), for: .touchUpInside)
        button.setTitle("Train", for: .normal)
        button.setTitleColor(.menuButton, for: .normal)
        return button
    }()
    
    fileprivate lazy var neuralNetwork: NeuralNetwork = {
        let neuralNetWork = NeuralNetwork(inputSize: 64, hiddenSize: 64, outputSize: 2)
        return neuralNetWork
    }()
    
    // TODO: Extract caonstants to structs
    fileprivate let characterPixelsArrayKey = "characterPixelsArrayKey"
    
    // Drawing options
    fileprivate let lineWidth: CGFloat = 35.0
    fileprivate let characterBoxThickness: CGFloat = 5.0
    fileprivate var characterBoxFrame = CGRect.zero
    
    // width x height determines the resolution of the image
    fileprivate let scaledImageSize = CGSize(width: 8.0, height: 8.0)
    
    // Picker view data source
    fileprivate let pickerViewData = ["a", "b"]
    
    // Array holding all the pixels extracted from the drawn letter
    fileprivate var characterPixelsArray: [[[Float]]]!
    
    // References a point at which screen was touched
    fileprivate var lastPoint = CGPoint.zero
    
    var presenter: DrawingPresenterInterface!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .menuBackground
        characterPixelsArray = Array(repeating: [], count: pickerViewData.count)
        setupViews()
        presenter.viewDidLoad()
    }
    
    // MARK: - Helpers -
    
    // Setup UI
    fileprivate func setupViews() {
        
        let controlButtonsStackView = UIStackView()
        controlButtonsStackView.distribution = .fillEqually
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
        controlButtonsStackView.addArrangedSubview(okButton)
        controlButtonsStackView.addArrangedSubview(clearButton)
        controlButtonsStackView.addArrangedSubview(trainButton)
    }
    
    fileprivate func clearCanvas() {
        drawingImageView.image = nil
        characterBoxImageView.image = nil
        characterBoxFrame = .zero
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
    
    // Draws a box around the letter
    fileprivate func drawCharacterBox() {
        
        UIGraphicsBeginImageContext(characterBoxImageView.frame.size)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        characterBoxImageView.image?.draw(in: CGRect(x: 0, y: 0, width: characterBoxImageView.frame.width, height: characterBoxImageView.frame.height))
        
        // Draw character rect
        context.clear(characterBoxFrame)
        context.setLineWidth(characterBoxThickness)
        context.setStrokeColor(UIColor.blue.cgColor)
        context.addRect(characterBoxFrame)
        context.strokePath()
        
        characterBoxImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        // TODO: Animate rect to be less snappy if possible
    }
    
    func saveCharacterPixels(_ pixelsArray: [Float]) {

        // Save the correct output for that character
        // The array of outputs will be filled with zeroes except
        // at the index of the selected character
        // For example output array for B will be [0, 1, 0, 0, 0, ...]
        var outputArrayForCharacter = Array(repeating: 0, count: pickerViewData.count)
        let selectedCharacterIndex = characterPickerView.selectedRow(inComponent: 0)
        outputArrayForCharacter[selectedCharacterIndex] = 1
        
        // Save character pixels to an array
        characterPixelsArray[selectedCharacterIndex].append(pixelsArray)
        
        // TODO: WTF
//        let userDefaults = UserDefaults.standard
//        userDefaults.setValue(characterPixelsArray, forKey: characterPixelsArrayKey)
//        userDefaults.synchronize()
    }
    
    fileprivate func imagePixels() -> [Int] {
        guard let croppedImage = drawingImageView.image?.cropImageWith(rect: characterBoxFrame),
              let scaledImage = croppedImage.scaleImageTo(size: scaledImageSize)
        else {
            return []
        }
        
        return presenter.pixelize(image: scaledImage)
    }
    
    // MARK: - Drawing -
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Get the first touched point
        if let point = touches.first?.location(in: drawingImageView) {
            
            // Start tracking coordinates of the character
            if characterBoxFrame == .zero {
                characterBoxFrame = CGRect(x: point.x - lineWidth / 2, y: point.y - lineWidth / 2, width: lineWidth, height: lineWidth)
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
            if point.x < characterBoxFrame.minX {
                characterBoxFrame = presenter.updated(characterBox: characterBoxFrame, minX: point.x - lineWidth - 1, maxX: nil, minY: nil, maxY: nil)
            } else if point.x > characterBoxFrame.maxX {
                characterBoxFrame = presenter.updated(characterBox: characterBoxFrame, minX: nil, maxX: point.x + self.lineWidth + 1, minY: nil, maxY: nil)
            }
            if point.y < characterBoxFrame.minY {
                characterBoxFrame = presenter.updated(characterBox: characterBoxFrame, minX: nil, maxX: nil, minY: point.y - lineWidth - 1, maxY: nil)
            } else if point.y > characterBoxFrame.maxY {
                characterBoxFrame = presenter.updated(characterBox: characterBoxFrame, minX: nil, maxX: nil, minY: nil, maxY: point.y + lineWidth + 1)
            }
            
            lastPoint = point
        }
    }
    
    // MARK: - Button actions -
    
    func okButtonPressed() {
        presenter.okButtonPressed()
    }
    
    func backButtonPressed() {
        self.presenter.didPressBackButton()
    }
    
    func clearButtonPressed() {
        clearCanvas()
    }
    
    func trainButtonPressed() {
        // check if network exists
        // if yes load and append new values
        // train and save network
        
        var outputData: [[Float]] = []
        for (index, _) in pickerViewData.enumerated() {
            var outputDataForLetter = Array<Float>(repeating: 0, count: pickerViewData.count)
            outputDataForLetter[index] = 1
            outputData.append(outputDataForLetter)
        }
        
        
        
        // Dispatch training on another thread
        DispatchQueue.global(qos: DispatchQoS.userInteractive.qosClass).async {
            for iterations in 0..<50000 {
                for (character, output) in zip(self.characterPixelsArray, outputData) {
                    for i in 0..<character.count {
                        self.neuralNetwork.trainWith(inputs: character[i], targetOutput: output)
                    }
                    
                    print("Iterations: \(iterations)")
                }
            }
        }
    }
}



// MARK: - Extensions -

//

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
        
//        if let neuralNetwork = NSKeyedUnarchiver.unarchiveObject(withFile: NeuralNetwork.ArchiveURL.path) as? NeuralNetwork {
//            let pixelsArray = imagePixels()
//            neuralNetwork.feed(pixelsArray)
//        } else {
//            print("nema")
//        }
        
        let pixelsArray = imagePixels()
        let floatingPixels = pixelsArray.map { Float($0) }
        
        print(neuralNetwork.predictFor(inputs: floatingPixels))
    }
    
    internal func processImage() {
        
        let pixelsArray = imagePixels()
        let floatingPixels = pixelsArray.map { Float($0) }
        saveCharacterPixels(floatingPixels)
        
        clearCanvas()
    }
}
