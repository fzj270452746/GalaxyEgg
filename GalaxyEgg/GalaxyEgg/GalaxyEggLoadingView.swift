//
//  GalaxyEggLoadingView.swift
//  GalaxyEgg
//
//  Created by Assistant on 10/11/25.
//

import UIKit

class GalaxyEggLoadingView: UIView {
    private let GalaxyEggSpinnerLayer = CAShapeLayer()
    private let GalaxyEggGlowLayer = CAShapeLayer()
    private let GalaxyEggParticleLayer = CAEmitterLayer()
    private let GalaxyEggTitleLabel = UILabel()
    private let GalaxyEggSubtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        GalaxyEggConfigure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        GalaxyEggConfigure()
    }

    private func GalaxyEggConfigure() {
        backgroundColor = UIColor(red: 12/255, green: 18/255, blue: 46/255, alpha: 0.95)

        let GalaxyEggCirclePath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: 40,
            startAngle: -.pi / 2,
            endAngle: .pi * 1.5,
            clockwise: true
        )

        GalaxyEggGlowLayer.path = GalaxyEggCirclePath.cgPath
        GalaxyEggGlowLayer.strokeColor = UIColor(red: 120/255, green: 84/255, blue: 255/255, alpha: 0.3).cgColor
        GalaxyEggGlowLayer.lineWidth = 12
        GalaxyEggGlowLayer.fillColor = UIColor.clear.cgColor
        GalaxyEggGlowLayer.lineCap = .round
        layer.addSublayer(GalaxyEggGlowLayer)

        GalaxyEggSpinnerLayer.path = GalaxyEggCirclePath.cgPath
        GalaxyEggSpinnerLayer.strokeColor = UIColor(red: 120/255, green: 200/255, blue: 255/255, alpha: 1).cgColor
        GalaxyEggSpinnerLayer.lineWidth = 6
        GalaxyEggSpinnerLayer.fillColor = UIColor.clear.cgColor
        GalaxyEggSpinnerLayer.lineCap = .round
        GalaxyEggSpinnerLayer.strokeEnd = 0.3
        layer.addSublayer(GalaxyEggSpinnerLayer)

        GalaxyEggParticleLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        GalaxyEggParticleLayer.emitterShape = .circle
        GalaxyEggParticleLayer.emitterSize = CGSize(width: 80, height: 80)
        GalaxyEggParticleLayer.renderMode = .additive
        layer.addSublayer(GalaxyEggParticleLayer)

        let GalaxyEggParticleCell = CAEmitterCell()
        GalaxyEggParticleCell.contents = UIImage(systemName: "sparkle")?.withRenderingMode(.alwaysTemplate).cgImage
        GalaxyEggParticleCell.birthRate = 10
        GalaxyEggParticleCell.lifetime = 2.0
        GalaxyEggParticleCell.velocity = 30
        GalaxyEggParticleCell.velocityRange = 20
        GalaxyEggParticleCell.scale = 0.1
        GalaxyEggParticleCell.scaleRange = 0.05
        GalaxyEggParticleCell.alphaSpeed = -0.5
        GalaxyEggParticleCell.color = UIColor(red: 120/255, green: 200/255, blue: 255/255, alpha: 1).cgColor
        GalaxyEggParticleCell.emissionRange = .pi * 2
        GalaxyEggParticleLayer.emitterCells = [GalaxyEggParticleCell]

        GalaxyEggTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggTitleLabel.text = "Loading Galaxy..."
        GalaxyEggTitleLabel.textColor = .white
        GalaxyEggTitleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        GalaxyEggTitleLabel.textAlignment = .center
        addSubview(GalaxyEggTitleLabel)

        GalaxyEggSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggSubtitleLabel.text = "Initializing cosmic engines"
        GalaxyEggSubtitleLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        GalaxyEggSubtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        GalaxyEggSubtitleLabel.textAlignment = .center
        addSubview(GalaxyEggSubtitleLabel)

        NSLayoutConstraint.activate([
            GalaxyEggTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            GalaxyEggTitleLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 70),

            GalaxyEggSubtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            GalaxyEggSubtitleLabel.topAnchor.constraint(equalTo: GalaxyEggTitleLabel.bottomAnchor, constant: 12)
        ])

        GalaxyEggStartAnimations()
    }

    private func GalaxyEggStartAnimations() {
        let GalaxyEggRotation = CABasicAnimation(keyPath: "transform.rotation")
        GalaxyEggRotation.fromValue = 0
        GalaxyEggRotation.toValue = CGFloat.pi * 2
        GalaxyEggRotation.duration = 1.5
        GalaxyEggRotation.repeatCount = .infinity
        GalaxyEggSpinnerLayer.add(GalaxyEggRotation, forKey: "spin")

        let GalaxyEggPulse = CABasicAnimation(keyPath: "opacity")
        GalaxyEggPulse.fromValue = 0.3
        GalaxyEggPulse.toValue = 0.6
        GalaxyEggPulse.duration = 1.0
        GalaxyEggPulse.autoreverses = true
        GalaxyEggPulse.repeatCount = .infinity
        GalaxyEggGlowLayer.add(GalaxyEggPulse, forKey: "glow")

        let GalaxyEggFadeAnimation = CABasicAnimation(keyPath: "opacity")
        GalaxyEggFadeAnimation.fromValue = 0.6
        GalaxyEggFadeAnimation.toValue = 1.0
        GalaxyEggFadeAnimation.duration = 0.8
        GalaxyEggFadeAnimation.autoreverses = true
        GalaxyEggFadeAnimation.repeatCount = .infinity
        GalaxyEggTitleLabel.layer.add(GalaxyEggFadeAnimation, forKey: "fade")
    }

    func GalaxyEggShow(in GalaxyEggView: UIView) {
        frame = GalaxyEggView.bounds
        alpha = 0
        GalaxyEggView.addSubview(self)

        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }

    func GalaxyEggHide(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            completion?()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let GalaxyEggCirclePath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: 40,
            startAngle: -.pi / 2,
            endAngle: .pi * 1.5,
            clockwise: true
        )

        GalaxyEggSpinnerLayer.path = GalaxyEggCirclePath.cgPath
        GalaxyEggGlowLayer.path = GalaxyEggCirclePath.cgPath
        GalaxyEggParticleLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
