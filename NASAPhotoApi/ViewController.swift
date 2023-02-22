//
//  ViewController.swift
//  NASAPhotoApi
//
//  Created by Lore P on 21/02/2023.
//

import UIKit

class ViewController: UIViewController {
    // APIController
    private let nasaAPIController = NASAAPIController()
    
    // Activity indicator
    var spinner = UIActivityIndicatorView(style: .large)

    
    private let imageView: UIImageView = {
        
        let imageView                                                    = UIImageView()
        imageView.contentMode                                            = .scaleAspectFit
        imageView.layer.cornerRadius                                     = 50
        imageView.clipsToBounds                                          = true
        imageView.heightAnchor.constraint(equalToConstant: 400).isActive = true

        return imageView
    }()
    
    private let descriptionContainerView: UIView = {
        
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private var descriptionLabel: UILabel = {
        
        let label           = UILabel()
        label.numberOfLines = 0
        
        return label
    }()

    private var copyrightLabel: UILabel = {
        
        let label  = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        
        return label
    }()

    private let verticalStackView = UIStackView()
    
    private let scrollView = UIScrollView()
    

    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(spinner)
        spinnerContraints()
        spinner.startAnimating()
        
        setupInterface()
        
        Task {
            do {
                let decodedModel = try await nasaAPIController.fetchItems()
                updateUI(with: decodedModel)
                
            } catch {
                updateUI(with: error)
            }
        }
    }
    
    fileprivate func setupInterface() {
        
        title = "Loading..."
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(verticalStackView)
        
        
        configureVerticalStackView()
    }
    
    func updateUI(with model: NasaPhotoInfo) {
        
        Task {
            do {
                let image = try await nasaAPIController.fetchImage(from: model.url)
    
                title                             = model.title
                imageView.image                   = image
                descriptionLabel.text             = model.description
                copyrightLabel.text               = model.copyright
                descriptionContainerView.isHidden = false
                
                spinner.stopAnimating()
                spinner.removeFromSuperview()
                
            } catch {
                updateUI(with: error)
                
                spinner.stopAnimating()
                spinner.removeFromSuperview()
            }
        }
    }
    func updateUI(with error: Error) {
        
        title = "Error fetching photo :("
        imageView.image = UIImage(systemName: "exclamationmark.octagon")
        descriptionLabel.text = error.localizedDescription
        copyrightLabel.text = ""
    }
}



// MARK: Configure View
extension ViewController {
    func configureVerticalStackView() {
        
        verticalStackView.axis         = .vertical
        verticalStackView.spacing      = 20
        
        verticalStackView.addArrangedSubview(imageView)
        verticalStackView.addArrangedSubview(descriptionContainerView)
        descriptionContainerView.addSubview(descriptionLabel)
        descriptionContainerView.isHidden = true
        verticalStackView.addArrangedSubview(copyrightLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: descriptionContainerView.topAnchor, constant: 20).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor, constant: -20).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: -20).isActive = true
        
        addConstraints()
    }
    
    func addConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalStackViewContraints = [
            verticalStackView.topAnchor.constraint(equalTo:      scrollView.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo:  scrollView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo:   scrollView.bottomAnchor),
            verticalStackView.widthAnchor.constraint(equalTo:    scrollView.widthAnchor) // Won't work without it
        ]
   
        let scrollViewContraints = [
            scrollView.topAnchor.constraint(equalTo:      view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.leadingAnchor, constant: 35),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -35),
            scrollView.bottomAnchor.constraint(equalTo:   view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(scrollViewContraints)
        NSLayoutConstraint.activate(verticalStackViewContraints)
    }
    
    func spinnerContraints() {
        
        spinner.translatesAutoresizingMaskIntoConstraints                      = false
        spinner.widthAnchor.constraint(equalToConstant: 100).isActive          = true
        spinner.heightAnchor.constraint(equalToConstant: 100).isActive         = true
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

