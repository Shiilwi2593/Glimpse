//
//  CustomAnnotationView.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 30/08/2024.
//

import Foundation
import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupImageView()
    }
    
    private func setupImageView() {
        frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        backgroundColor = .clear
        
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40 // Để tạo hình tròn
        imageView.image = UIImage(named: "defaultUserImage") // Hình ảnh mặc định
        addSubview(imageView)
    }
    
    func updateImage(_ image: UIImage?) {
        guard let imageView = subviews.first as? UIImageView else { return }
        imageView.image = image ?? UIImage(named: "defaultUserImage")
    }
}
