//
//  MovieTableViewCell.swift
//  DisMo
//
//  Created by Macbook on 16/12/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    lazy var movieCard: MovieCardView = {
        let view = MovieCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        DispatchQueue.main.async { [weak self] in
            self?.setupLayout()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        movieCard.prepareForReuse()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .white
        contentView.addSubview(movieCard)
        NSLayoutConstraint.activate([
            movieCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            movieCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            movieCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            movieCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    func setupContent(_ movie: TrendingMovieDetail) {
        movieCard.setupContent(movie)
    }
    
    func showLoadingView() {
        DispatchQueue.main.async { [weak self] in
            self?.movieCard.setupLoadingView()
        }
    }
}


