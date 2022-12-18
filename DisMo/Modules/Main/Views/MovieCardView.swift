//
//  MovieCardView.swift
//  DisMo
//
//  Created by Macbook on 16/12/22.
//

import UIKit
import SDWebImage

class MovieCardView: UIView {
    private lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var movieImageView: UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.clear.cgColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.textColor = .black
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewsImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ic_eye")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .black
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewsLabel: UILabel = {
        let view = UILabel()
        view.textColor = .darkGray
        view.font = .systemFont(ofSize: 12, weight: .bold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 8
        movieImageView.layer.cornerRadius = 8
        shadowedView(self, offset: .init(width: 1, height: 2), radius: 3, alpha: 0.1)
    }
    
    private func setupLayout() {
        addSubview(movieImageView)
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            movieImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            movieImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            movieImageView.widthAnchor.constraint(equalToConstant: 120),
            movieImageView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: movieImageView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
        
        addSubview(viewsImageView)
        NSLayoutConstraint.activate([
            viewsImageView.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: -26),
            viewsImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            viewsImageView.heightAnchor.constraint(equalToConstant: 10),
            viewsImageView.widthAnchor.constraint(equalToConstant: 16)
        ])
        
        addSubview(viewsLabel)
        NSLayoutConstraint.activate([
            viewsLabel.centerYAnchor.constraint(equalTo: viewsImageView.centerYAnchor),
            viewsLabel.leadingAnchor.constraint(equalTo: viewsImageView.trailingAnchor, constant: 4),
            viewsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            viewsLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func setupContent(_ movie: TrendingMovieDetail) {
        DispatchQueue.main.async {
            self.setupLayout()
            if let posterURL = movie.posterURL {
                self.movieImageView.sd_setImage(with: posterURL)
            } else {
                self.movieImageView.image = UIImage(named: "img_placeholder")
            }
            self.titleLabel.text = movie.title
            self.viewsLabel.text = "Rating: \(movie.rating)/10 "
        }
    }
    
    func setupLoadingView() {
        addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: topAnchor),
            indicatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        indicatorView.startAnimating()
    }
    
    func prepareForReuse() {
        movieImageView.image = UIImage(named: "img_placeholder")
        viewsLabel.text = ""
        titleLabel.text = ""
    }
}
