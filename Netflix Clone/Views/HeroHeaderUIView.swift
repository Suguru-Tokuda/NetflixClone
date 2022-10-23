//
//  HeroHeaderUIView.swift
//  Netflix Clone
//
//  Created by Suguru on 10/19/22.
//

import UIKit

class HeroHeaderUIView: UIView {
    
    private var titleDisplayed: Title?
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false // so that the constrainsts set in the class is used
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false // so that the constrainsts set in the class is used
        button.layer.cornerRadius = 5
        return button
    }()

    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)

        playButton.addTarget(self, action: #selector(handlePlayBtnTapped), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(handleDownloadBtnTapped), for: .touchUpInside)

        applyConstraints()
    }
    
    private func applyConstraints() {
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    public func configure(with model: Title) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterPath ?? "")") else { return }
        heroImageView.sd_setImage(with: url)
        self.titleDisplayed = model
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func handleDownloadBtnTapped() {
        guard let title = titleDisplayed else { return }
        
        DataPersistenceManager.shared.downloadTitle(width: title) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                print("Downloaded to Database")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func handlePlayBtnTapped() {
        guard let title = titleDisplayed else { return }
        NotificationCenter.default.post(
            name: NSNotification.Name("preview"),
            object: nil,
            userInfo: ["title": title ]
        )
    }
}
