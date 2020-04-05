//
//  ViewController.swift
//  CatImages-test
//
//  Created by Henrique Ormonde on 04/04/20.
//  Copyright © 2020 Henrique Ormonde. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageOverlay: UIImageView!
    
    var catImages = [CatImage]()
    let reuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageOverlay.isUserInteractionEnabled = true
        imageOverlay.addGestureRecognizer(tapGestureRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NetworkManager.shared.getCatImages(success: { (results) in
            
            DispatchQueue.main.async {
                if let cats : [CatImage] = results?.data {
                    
                    for cat in cats {
                        let imagesOnly = cat.images?.filter( { return ($0.type?.contains("image/") ?? false) } )
                        if (imagesOnly?.count ?? 0) > 0 {
                            self.catImages.append((imagesOnly?.first)!)
                        }
                    }
                    
                    self.collectionView.reloadData()
                }
            }
            
        }) {  (error) in
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true)
            }
            
        }
    }
    

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {

        self.imageOverlay.alpha = 1
        UIView.animate(withDuration: 0.3, animations: {
            self.imageOverlay.alpha = 0
        }) { (finished) in
            if finished {
                self.imageOverlay.isHidden = true
                self.collectionView.allowsSelection = true
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout protocol
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = (collectionView.bounds.width - 24)/3.0
        let yourHeight = yourWidth

        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    
    // MARK: - UICollectionViewDataSource protocol

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.catImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CatImageCollectionViewCell
        cell.imageView.getImage(urlString: self.catImages[indexPath.item].link ?? "")

        return cell
    }

    // MARK: - UICollectionViewDelegate protocol

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.allowsSelection = false

        self.imageOverlay.getImage(urlString: self.catImages[indexPath.item].link ?? "")
        
        self.imageOverlay.alpha = 0
        self.imageOverlay.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.imageOverlay.alpha = 1
        }
    }
}
