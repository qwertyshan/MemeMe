//
//  Meme.swift
//  MemeMeVer1
//
//  Created by Shantanu Rao on 12/31/15.
//  Copyright © 2015 Shantanu Rao. All rights reserved.
//

import Foundation
import UIKit

// Structure for Meme
struct Meme {
    let textTop: String
    let textBottom: String
    let image: UIImage
    let memedImage: UIImage
}

extension Meme {
    
    // Generate an array full of static Memes for demo/test 
    static var staticMemes: [Meme] {
        
        var memeArray = [Meme]()
        
        for meme in Meme.localMemeData() {
            memeArray.append(meme)
        }
        
        return memeArray
    }
    
    static func localMemeData() -> [Meme] {
        return [
            Meme(textTop: "Tea is toxic to amphibians", textBottom: "But that's none of my business", image: UIImage(named: "kermit")!, memedImage: UIImage(named: "kermit_m")!),
            Meme(textTop: "2016,", textBottom: "2016 everywhere", image: UIImage(named: "buzz")!, memedImage: UIImage(named: "buzz_m")!),
            Meme(textTop: "If you could just not spoil The Force Awakens", textBottom: "That would be great", image: UIImage(named: "boss")!, memedImage: UIImage(named: "boss_m")!),
            Meme(textTop: "Bought a book at a used bookstore for $2.50", textBottom: "Found $5 in between 2 pages", image: UIImage(named: "kid")!, memedImage: UIImage(named: "kid_m")!),
            Meme(textTop: "Up vote me", textBottom: "I up vote you", image: UIImage(named: "leo")!, memedImage: UIImage(named: "leo_m")!),
            Meme(textTop: "My christmas tree lights are neatly put away", textBottom: "So why are they a tangled mess when I open them", image: UIImage(named: "picard")!, memedImage: UIImage(named: "picard_m")!)
        ]
    }
}