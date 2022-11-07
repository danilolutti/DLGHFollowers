//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Danilo on 02/11/22.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let cache = NetworkManager.shared.cache //cache da usare nel download delle immagini
    let placeholderImage = UIImage(named: "avatar-placeholder")!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from urlString:String) {
        
        ///per utilizzare l'immagine in cache bisogna darle un'id univoco che nel caso dell'url è l'url stessa
        ///ns cache usa NSString per cui l'url va prima convertita
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            self.image = image ///se ho l'immagine in cache prendo quella ed esco, altrimenti la scarico
            return
        }
        
           
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self else { return } //weak self rende self optional, con questo non dobbiamo più usare l'optional
            
            ///controlli lite dato che c'è il placeholder in caso di errore
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            
            ///scrive l'immagine in cache dopo averla scaricata per la prima volta
            self.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.image = image
                print("image downloaded for url \(urlString)")
            }
            
            

        }
        
        task.resume()
        
    }
    
}
