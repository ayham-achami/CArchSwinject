//  The MIT License (MIT)
//
//  Copyright (c) 2019 Community Arch
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
import CArch
import AlamofireImage

/// Объект содержащий логику отображения данных
final class MovieCell: UICollectionViewCell {
    
    // MARK: - Renderer model
    typealias ModelType = Model
    
    struct Model: UIModel {
        
        let id: Int
        let name: String
        let rating: Double
        let posterPath: String
        let releaseDate: String
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let detailsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let ratingView: UIView = {
        let view = UIImageView(image: UIImage(systemName: "star.square"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let posterEffectImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    typealias PosterEffectView = (blur: UIVisualEffectView, vibrancy: UIVisualEffectView)
    
    private let effectView: PosterEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.contentView.addSubview(vibrancyView)
        
        return (blurEffectView, vibrancyView)
    }()
    
    private let posterBaseURL: URL = {
        .init(string: "https://image.tmdb.org/t/p/w1280")!
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rendering()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        rendering()
    }
    
    // MARK: - Public methods
    func set(content: ModelType) {
        nameLabel.text = content.name
        dateLabel.text = content.releaseDate
        posterImageView.af.setImage(withURL: posterBaseURL.appending(path: content.posterPath))
        posterEffectImageView.af.setImage(withURL: posterBaseURL.appending(path: content.posterPath))
    }
    
    func rendering() {
        backgroundColor = .clear
        clipsToBounds = true
        layer.cornerRadius = 12
        
        addSubview(posterImageView)
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ])
        
        addSubview(posterEffectImageView)
        NSLayoutConstraint.activate([
            posterEffectImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            posterEffectImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterEffectImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterEffectImageView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            effectView.vibrancy.topAnchor.constraint(equalTo: effectView.blur.topAnchor),
            effectView.vibrancy.bottomAnchor.constraint(equalTo: effectView.blur.bottomAnchor),
            effectView.vibrancy.leadingAnchor.constraint(equalTo: effectView.blur.leadingAnchor),
            effectView.vibrancy.trailingAnchor.constraint(equalTo: effectView.blur.trailingAnchor)
        ])
        
        posterEffectImageView.addSubview(effectView.blur)
        NSLayoutConstraint.activate([
            effectView.blur.topAnchor.constraint(equalTo: posterEffectImageView.topAnchor),
            effectView.blur.bottomAnchor.constraint(equalTo: posterEffectImageView.bottomAnchor),
            effectView.blur.leadingAnchor.constraint(equalTo: posterEffectImageView.leadingAnchor),
            effectView.blur.trailingAnchor.constraint(equalTo: posterEffectImageView.trailingAnchor)
        ])
        
        labelsStackView.addArrangedSubview(nameLabel)
        labelsStackView.addArrangedSubview(dateLabel)
        
        detailsStackView.addArrangedSubview(labelsStackView)
        detailsStackView.addArrangedSubview(ratingView)
        
        effectView.vibrancy.contentView.addSubview(detailsStackView)
        NSLayoutConstraint.activate([
            detailsStackView.topAnchor.constraint(equalTo: effectView.vibrancy.topAnchor, constant: 8),
            detailsStackView.bottomAnchor.constraint(equalTo: effectView.vibrancy.bottomAnchor, constant: -8),
            detailsStackView.leadingAnchor.constraint(equalTo: effectView.vibrancy.leadingAnchor, constant: 8),
            detailsStackView.trailingAnchor.constraint(equalTo: effectView.vibrancy.trailingAnchor, constant: -8)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.af.cancelImageRequest()
    }
}

// MARK: - Renderer + IBAction
private extension MoviesRenderer {}

// MARK: - Private methods
extension MovieCell: UIRendererPreview {
    
    static func preview() -> Self {
        let preview = Self.init(frame: .zero)
        preview.set(content: .init(id: 0,
                                   name: "John Wick: Chapter 4",
                                   rating: 3.8,
                                   posterPath: "vZloFAK7NmvMGKE7VkF5UHaz0I.jpg",
                                   releaseDate: "03/24/2023"))
        return preview
    }
}

#Preview(String(describing: MovieCell.self), traits: .fixedLayout(width: 150, height: 250)) {
    MovieCell.preview()
}
