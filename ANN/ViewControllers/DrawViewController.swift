//
//  DrawViewController.swift
//  ANN
//
//  Created by Hrvoje Baic on 30/01/17.
//

import UIKit
import Foundation

class DrawViewController: UIViewController {
    
    // MARK: - Properties -
    var presenter: DrawViewControllerDelegateProtocol!
    
    // Character box will be drawn around the character
    private var characterBox: CGRect?
    private let lineWidth: CGFloat = 10.0
    private let characterBoxThickness: CGFloat = 1.0
    private var lastPoint = CGPointZero

    // MARK: - Outlets -
    @IBOutlet weak var drawingImageView: UIImageView!
    @IBOutlet weak var characterBoxImageView: UIImageView!
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Delegate methods -
    @IBAction func okButtonPressed(sender: UIButton) {
        presenter.okButtonPressed()
    }
    @IBAction func clearButtonPressed(sender: UIButton) {
        clearCanvas()
    }
    
    // MARK: - Internal -
    internal func processImage() {
        
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
            
            if point.x < self.characterBox!.minX {
                self.updateRect(&self.characterBox!, minX: point.x - self.lineWidth - 1, maxX: nil, minY: nil, maxY: nil)
            } else if point.x > self.characterBox!.maxX {
                self.updateRect(&self.characterBox!, minX: nil, maxX: point.x + self.lineWidth + 1, minY: nil, maxY: nil)
            }
            if point.y < self.characterBox!.minY {
                self.updateRect(&self.characterBox!, minX: nil, maxX: nil, minY: point.y - self.lineWidth - 1, maxY: nil)
            } else if point.y > self.characterBox!.maxY {
                self.updateRect(&self.characterBox!, minX: nil, maxX: nil, minY: nil, maxY: point.y + self.lineWidth + 1)
            }
            
            self.lastPoint = point
        }
    }
    
    // MARK: - Helpers -
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
        
        // TODO: Animate rect to be less snappy
    }
    
    private func updateRect(inout rect: CGRect, minX: CGFloat?, maxX: CGFloat?, minY: CGFloat?, maxY: CGFloat?) {
        rect = CGRect(x: minX ?? rect.minX,
            y: minY ?? rect.minY,
            width: (maxX ?? rect.maxX) - (minX ?? rect.minX),
            height: (maxY ?? rect.maxY) - (minY ?? rect.minY))
    }
}
