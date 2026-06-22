//
//  SplashViewController.swift
//  Movies
//
//  Created by Ahmed Fathy on 12/06/2026.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var splashImage: UIImageView!

    var onFinish: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: "#242A32")
        splashImage.image = UIImage(named: "popcorn 1")
        splashImage.alpha = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playAnimation()
    }

    private func playAnimation() {
        let spinDuration: CFTimeInterval = 1.4

        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 4
        rotation.duration = spinDuration
        rotation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        splashImage.layer.add(rotation, forKey: "splashSpin")

        UIView.animate(withDuration: 0.4) {
            self.splashImage.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + spinDuration + 0.2) {
            self.onFinish?()
        }
    }
}
