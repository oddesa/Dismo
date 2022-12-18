//
//  MovieInfoViewController.swift
//  DisMo
//
//  Created by Jehnsen Hirena Kane on 17/12/22.
//

import UIKit
import AVKit
import RxSwift
import RxCocoa

class MovieInfoViewController: UIViewController {
    private lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = true
        view.isUserInteractionEnabled = true
        view.keyboardDismissMode = .onDrag
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let view = UIImageView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openYoutubeVideoPlayer))
        view.addGestureRecognizer(tapGesture)
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.clear.cgColor
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var playImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "play.circle")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .white
        view.contentMode = .scaleAspectFit
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openYoutubeVideoPlayer))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var videoTitleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20, weight: .semibold)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewsLabel: UILabel = {
        let view = UILabel()
        view.textColor = .darkGray
        view.font = .systemFont(ofSize: 16, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var overviewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var overviewTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Overview"
        view.font = .systemFont(ofSize: 20, weight: .bold)
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var overviewSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var overviewContentLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .justified
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.textColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var reviewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var reviewTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Review"
        view.font = .systemFont(ofSize: 20, weight: .bold)
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var reviewMoreLabel: UILabel = {
        let view = UILabel()
        view.text = "Read all reviews"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openReviewsPage))
        view.addGestureRecognizer(tapGesture)
        view.font = .systemFont(ofSize: 20, weight: .bold)
        view.textColor = .blue
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var reviewSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var reviewAuthorLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .semibold)
        view.textColor = .darkGray
        view.adjustsFontSizeToFitWidth = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var reviewContentLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .justified
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.textColor = .darkGray
        view.adjustsFontSizeToFitWidth = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: MovieInfoViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: MovieInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        updateUIData(viewModel.movieDetail)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupErrorObserver()
        setupTrailerResponseObserver()
        setupReviewResponseObserver()
    }
    
    private func setupErrorObserver() {
        viewModel.error.asObservable()
            .subscribe(onNext: { [weak self] error in
                if !error.isEmpty {
                    self?.popupAlert(title: "Error",
                                     message: error)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTrailerResponseObserver() {
        viewModel.trailersResponse.asObservable()
            .subscribe(onNext: { [weak self] response in
                let trailerKey = response?.officialTrailerKey
                DispatchQueue.main.async { [weak self] in
                    self?.playImageView.isHidden = !(trailerKey != nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupReviewResponseObserver() {
        viewModel.reviewResponse.asObservable()
            .subscribe(onNext: { [weak self] response in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    if let author = response?.results.first?.content {
                        self.reviewAuthorLabel.text = author
                    } else {
                        self.reviewAuthorLabel.text = "No review yet"
                    }
                    self.reviewContentLabel.text = response?.results.first?.content
                    self.scrollView.layoutSubviews()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupAudio() {
        // Prepare the audio
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
            print("Failed set category to playback")
        }
    }
    
    @objc  private func openReviewsPage() {
        self.popupAlert(title: "Hold on",
                        message: "Feature still under development")
    }
    
    @objc private func openYoutubeVideoPlayer() {
        guard let videoId = viewModel.trailersResponse.value?.officialTrailerKey else {
            return
        }
        let vc = YoutubePlayerViewController(videoId: videoId)
        self.present(vc, animated: true)
    }
    
    private func updateUIData(_ movie: MovieDetail) {
        if let posterURL = movie.posterURL {
            thumbnailImageView.sd_setImage(with: posterURL)
        } else {
            thumbnailImageView.image = UIImage(named: "img_placeholder")
        }
        videoTitleLabel.text = movie.title
        viewsLabel.text = "Rating: \(movie.rating)/10, rated by \(movie.voteCount) peoples"
        overviewContentLabel.text = movie.overview
        self.title = "Movie Info"
    }
    
    private func setupLayout() {
        view.addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: view.topAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            indicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(thumbnailImageView)
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            thumbnailImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            thumbnailImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: (view.bounds.width - 32) * (240/328))
        ])
        
        thumbnailImageView.addSubview(playImageView)
        NSLayoutConstraint.activate([
            playImageView.centerXAnchor.constraint(equalTo: thumbnailImageView.centerXAnchor),
            playImageView.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor),
            playImageView.widthAnchor.constraint(equalToConstant: 150),
            playImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        scrollView.addSubview(videoTitleLabel)
        NSLayoutConstraint.activate([
            videoTitleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 16),
            videoTitleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor),
            videoTitleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),
            videoTitleLabel.heightAnchor.constraint(equalToConstant: 40)
            
        ])
        
        scrollView.addSubview(viewsLabel)
        NSLayoutConstraint.activate([
            viewsLabel.topAnchor.constraint(equalTo: videoTitleLabel.bottomAnchor, constant: 10),
            viewsLabel.leadingAnchor.constraint(equalTo: videoTitleLabel.leadingAnchor),
            viewsLabel.trailingAnchor.constraint(equalTo: videoTitleLabel.trailingAnchor)
        ])
        
        // Setup Detail Container View
        scrollView.addSubview(overviewContainer)
        
        overviewContainer.addSubview(overviewTitleLabel)
        NSLayoutConstraint.activate([
            overviewTitleLabel.topAnchor.constraint(equalTo: overviewContainer.topAnchor, constant: 12),
            overviewTitleLabel.leadingAnchor.constraint(equalTo: overviewContainer.leadingAnchor, constant: 16),
            overviewTitleLabel.trailingAnchor.constraint(equalTo: overviewContainer.trailingAnchor, constant: -16),
        ])
        
        overviewContainer.addSubview(overviewSeparatorLine)
        NSLayoutConstraint.activate([
            overviewSeparatorLine.topAnchor.constraint(equalTo: overviewTitleLabel.bottomAnchor, constant: 12),
            overviewSeparatorLine.leadingAnchor.constraint(equalTo: overviewContainer.leadingAnchor, constant: 16),
            overviewSeparatorLine.trailingAnchor.constraint(equalTo: overviewContainer.trailingAnchor, constant: -16),
            overviewSeparatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        overviewContainer.addSubview(overviewContentLabel)
        NSLayoutConstraint.activate([
            overviewContentLabel.topAnchor.constraint(equalTo: overviewSeparatorLine.bottomAnchor, constant: 12),
            overviewContentLabel.leadingAnchor.constraint(equalTo: overviewContainer.leadingAnchor, constant: 16),
            overviewContentLabel.trailingAnchor.constraint(equalTo: overviewContainer.trailingAnchor, constant: -16),
            overviewContentLabel.bottomAnchor.constraint(equalTo: overviewContainer.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            overviewContainer.topAnchor.constraint(equalTo: viewsLabel.bottomAnchor, constant: 16),
            overviewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            overviewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            overviewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
        ])
        
        scrollView.addSubview(reviewContainer)
        
        reviewContainer.addSubview(reviewTitleLabel)
        NSLayoutConstraint.activate([
            reviewTitleLabel.topAnchor.constraint(equalTo: reviewContainer.topAnchor, constant: 12),
            reviewTitleLabel.leadingAnchor.constraint(equalTo: reviewContainer.leadingAnchor, constant: 16),
        ])
        
        reviewContainer.addSubview(reviewMoreLabel)
        NSLayoutConstraint.activate([
            reviewMoreLabel.topAnchor.constraint(equalTo: reviewContainer.topAnchor, constant: 12),
            reviewMoreLabel.trailingAnchor.constraint(equalTo: reviewContainer.trailingAnchor, constant: -16),
        ])
        
        reviewContainer.addSubview(reviewSeparatorLine)
        NSLayoutConstraint.activate([
            reviewSeparatorLine.topAnchor.constraint(equalTo: reviewContainer.topAnchor, constant: 48),
            reviewSeparatorLine.leadingAnchor.constraint(equalTo: reviewContainer.leadingAnchor, constant: 16),
            reviewSeparatorLine.trailingAnchor.constraint(equalTo: reviewContainer.trailingAnchor, constant: -16),
            reviewSeparatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        
        reviewContainer.addSubview(reviewAuthorLabel)
        NSLayoutConstraint.activate([
            reviewAuthorLabel.topAnchor.constraint(equalTo: reviewSeparatorLine.bottomAnchor, constant: 12),
            reviewAuthorLabel.leadingAnchor.constraint(equalTo: reviewContainer.leadingAnchor, constant: 16),
            reviewAuthorLabel.trailingAnchor.constraint(equalTo: reviewContainer.trailingAnchor, constant: -16),
            reviewAuthorLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        reviewContainer.addSubview(reviewContentLabel)
        NSLayoutConstraint.activate([
            reviewContentLabel.topAnchor.constraint(equalTo: reviewAuthorLabel.bottomAnchor, constant: 12),
            reviewContentLabel.leadingAnchor.constraint(equalTo: reviewContainer.leadingAnchor, constant: 16),
            reviewContentLabel.trailingAnchor.constraint(equalTo: reviewContainer.trailingAnchor, constant: -16),
            reviewContentLabel.bottomAnchor.constraint(lessThanOrEqualTo: reviewContainer.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            reviewContainer.topAnchor.constraint(equalTo: overviewContainer.bottomAnchor, constant: 16),
            reviewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            reviewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            reviewContainer.heightAnchor.constraint(equalToConstant: 450),
            reviewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
        ])
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.thumbnailImageView.layer.cornerRadius = 8
            self.overviewContainer.layer.cornerRadius = 8
            self.reviewContainer.layer.cornerRadius = 8
            self.overviewContainer.shadowedView(self.overviewContainer,
                                                offset: .init(width: 1, height: 2),
                                                radius: 3,
                                                alpha: 0.5)
            self.reviewContainer.shadowedView(self.reviewContainer,
                                                offset: .init(width: 1, height: 2),
                                                radius: 3,
                                                alpha: 0.5)
            self.view.backgroundColor = .white
        }
    }
}
