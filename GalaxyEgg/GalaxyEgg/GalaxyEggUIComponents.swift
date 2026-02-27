//
//  GalaxyEggUIComponents.swift
//  GalaxyEgg
//
//  Created by Assistant on 10/10/25.
//

import UIKit

class GalaxyEggGradientBackgroundView: UIView {
    private let GalaxyEggGradientLayer = CAGradientLayer()
    private let GalaxyEggNebulaLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        GalaxyEggSetupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        GalaxyEggSetupGradient()
    }
    
    private func GalaxyEggSetupGradient() {
        GalaxyEggGradientLayer.colors = [
            UIColor(red: 12/255, green: 18/255, blue: 46/255, alpha: 1).cgColor,
            UIColor(red: 25/255, green: 33/255, blue: 72/255, alpha: 1).cgColor,
            UIColor(red: 52/255, green: 17/255, blue: 86/255, alpha: 1).cgColor
        ]
        GalaxyEggGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        GalaxyEggGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(GalaxyEggGradientLayer)
        
        GalaxyEggNebulaLayer.colors = [
            UIColor(red: 96/255, green: 59/255, blue: 196/255, alpha: 0.5).cgColor,
            UIColor(red: 24/255, green: 162/255, blue: 189/255, alpha: 0.4).cgColor,
            UIColor(red: 219/255, green: 115/255, blue: 255/255, alpha: 0.3).cgColor
        ]
        GalaxyEggNebulaLayer.locations = [0, 0.5, 1]
        GalaxyEggNebulaLayer.startPoint = CGPoint(x: 0, y: 0.5)
        GalaxyEggNebulaLayer.endPoint = CGPoint(x: 1, y: 0.5)
        GalaxyEggNebulaLayer.compositingFilter = "screenBlendMode"
        layer.addSublayer(GalaxyEggNebulaLayer)
        
        let GalaxyEggAnimation = CABasicAnimation(keyPath: "locations")
        GalaxyEggAnimation.fromValue = [0, 0.4, 1]
        GalaxyEggAnimation.toValue = [0.2, 0.6, 1]
        GalaxyEggAnimation.duration = 8
        GalaxyEggAnimation.autoreverses = true
        GalaxyEggAnimation.repeatCount = .infinity
        GalaxyEggNebulaLayer.add(GalaxyEggAnimation, forKey: "nebula")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        GalaxyEggGradientLayer.frame = bounds
        GalaxyEggNebulaLayer.frame = bounds
    }
}

class GalaxyEggStarfieldView: UIView {
    private let GalaxyEggEmitterLayer = CAEmitterLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        GalaxyEggConfigure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        GalaxyEggConfigure()
    }
    
    private func GalaxyEggConfigure() {
        GalaxyEggEmitterLayer.emitterShape = .rectangle
        GalaxyEggEmitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        GalaxyEggEmitterLayer.emitterSize = bounds.size
        GalaxyEggEmitterLayer.birthRate = 1
        GalaxyEggEmitterLayer.renderMode = .oldestFirst
        GalaxyEggEmitterLayer.zPosition = -1
        layer.addSublayer(GalaxyEggEmitterLayer)
        GalaxyEggEmitterLayer.beginTime = CACurrentMediaTime()
        GalaxyEggEmitterLayer.emitterCells = [GalaxyEggStarCell()]
    }
    
    private func GalaxyEggStarCell() -> CAEmitterCell {
        let GalaxyEggCell = CAEmitterCell()
        GalaxyEggCell.contents = UIImage(systemName: "sparkle")?.withRenderingMode(.alwaysTemplate).cgImage
        GalaxyEggCell.birthRate = 12
        GalaxyEggCell.lifetime = 12
        GalaxyEggCell.velocity = 10
        GalaxyEggCell.velocityRange = 30
        GalaxyEggCell.scale = 0.02
        GalaxyEggCell.scaleRange = 0.05
        GalaxyEggCell.alphaSpeed = -0.08
        GalaxyEggCell.color = UIColor(white: 1, alpha: 0.7).cgColor
        return GalaxyEggCell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        GalaxyEggEmitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        GalaxyEggEmitterLayer.emitterSize = bounds.size
    }
}

class GalaxyEggButtonView: UIControl {
    private let GalaxyEggGradientLayer = CAGradientLayer()
    private let GalaxyEggHighlightLayer = CALayer()
    private let GalaxyEggShineLayer = CAGradientLayer()
    private let GalaxyEggTitleLabel = UILabel()
    private let GalaxyEggIconLabel = UILabel()
    private var GalaxyEggTitleLeadingConstraint: NSLayoutConstraint?
    private var GalaxyEggTitleTrailingConstraint: NSLayoutConstraint?
    private var GalaxyEggTitleTopConstraint: NSLayoutConstraint?
    private var GalaxyEggTitleBottomConstraint: NSLayoutConstraint?

    var GalaxyEggContentInset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12) {
        didSet {
            GalaxyEggUpdateInsets()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            GalaxyEggAnimateHighlight(isHighlighted)
        }
    }

    override var isEnabled: Bool {
        didSet {
            GalaxyEggUpdateEnabledState()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        GalaxyEggConfigure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        GalaxyEggConfigure()
    }

    private func GalaxyEggConfigure() {
        layer.cornerRadius = 20
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 120/255, green: 84/255, blue: 255/255, alpha: 1).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 12
        layer.shadowOffset = CGSize(width: 0, height: 4)

        let GalaxyEggContainerLayer = CALayer()
        GalaxyEggContainerLayer.cornerRadius = 20
        GalaxyEggContainerLayer.masksToBounds = true
        layer.addSublayer(GalaxyEggContainerLayer)

        GalaxyEggGradientLayer.colors = [
            UIColor(red: 120/255, green: 84/255, blue: 255/255, alpha: 1).cgColor,
            UIColor(red: 55/255, green: 217/255, blue: 255/255, alpha: 1).cgColor
        ]
        GalaxyEggGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        GalaxyEggGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        GalaxyEggContainerLayer.addSublayer(GalaxyEggGradientLayer)

        GalaxyEggShineLayer.colors = [
            UIColor(white: 1, alpha: 0.3).cgColor,
            UIColor(white: 1, alpha: 0.0).cgColor,
            UIColor(white: 1, alpha: 0.1).cgColor
        ]
        GalaxyEggShineLayer.locations = [0, 0.5, 1]
        GalaxyEggShineLayer.startPoint = CGPoint(x: 0, y: 0)
        GalaxyEggShineLayer.endPoint = CGPoint(x: 1, y: 1)
        GalaxyEggContainerLayer.addSublayer(GalaxyEggShineLayer)

        GalaxyEggHighlightLayer.backgroundColor = UIColor(white: 1, alpha: 0.15).cgColor
        GalaxyEggHighlightLayer.cornerRadius = 20
        GalaxyEggHighlightLayer.opacity = 0
        GalaxyEggContainerLayer.addSublayer(GalaxyEggHighlightLayer)

        GalaxyEggTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        GalaxyEggTitleLabel.textColor = .white
        GalaxyEggTitleLabel.textAlignment = .center
        GalaxyEggTitleLabel.numberOfLines = 1
        GalaxyEggTitleLabel.adjustsFontSizeToFitWidth = true
        GalaxyEggTitleLabel.minimumScaleFactor = 0.5
        GalaxyEggTitleLabel.baselineAdjustment = .alignCenters
        addSubview(GalaxyEggTitleLabel)

        GalaxyEggIconLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggIconLabel.font = UIFont.systemFont(ofSize: 20)
        GalaxyEggIconLabel.textAlignment = .center
        GalaxyEggIconLabel.alpha = 0
        addSubview(GalaxyEggIconLabel)

        GalaxyEggTitleLeadingConstraint = GalaxyEggTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: GalaxyEggContentInset.left)
        GalaxyEggTitleTrailingConstraint = GalaxyEggTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -GalaxyEggContentInset.right)
        GalaxyEggTitleTopConstraint = GalaxyEggTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: GalaxyEggContentInset.top)
        GalaxyEggTitleBottomConstraint = GalaxyEggTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -GalaxyEggContentInset.bottom)

        NSLayoutConstraint.activate([
            GalaxyEggTitleLeadingConstraint,
            GalaxyEggTitleTrailingConstraint,
            GalaxyEggTitleTopConstraint,
            GalaxyEggTitleBottomConstraint,

            GalaxyEggIconLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            GalaxyEggIconLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ].compactMap { $0 })

        let GalaxyEggPulse = CABasicAnimation(keyPath: "transform.scale")
        GalaxyEggPulse.fromValue = 1.0
        GalaxyEggPulse.toValue = 1.03
        GalaxyEggPulse.duration = 2.0
        GalaxyEggPulse.autoreverses = true
        GalaxyEggPulse.repeatCount = .infinity
        GalaxyEggPulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(GalaxyEggPulse, forKey: "pulse")

        let GalaxyEggShineAnimation = CABasicAnimation(keyPath: "locations")
        GalaxyEggShineAnimation.fromValue = [0, 0.3, 0.6]
        GalaxyEggShineAnimation.toValue = [0.4, 0.7, 1.0]
        GalaxyEggShineAnimation.duration = 2.5
        GalaxyEggShineAnimation.autoreverses = true
        GalaxyEggShineAnimation.repeatCount = .infinity
        GalaxyEggShineAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        GalaxyEggShineLayer.add(GalaxyEggShineAnimation, forKey: "shine")
    }

    func GalaxyEggSetTitle(_ GalaxyEggTitle: String) {
        GalaxyEggTitleLabel.text = GalaxyEggTitle
    }

    func GalaxyEggSetIcon(_ GalaxyEggIcon: String?) {
        GalaxyEggIconLabel.text = GalaxyEggIcon
        GalaxyEggIconLabel.alpha = GalaxyEggIcon != nil ? 1 : 0
    }

    private func GalaxyEggAnimateHighlight(_ GalaxyEggHighlighted: Bool) {
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseOut]) {
            self.GalaxyEggHighlightLayer.opacity = GalaxyEggHighlighted ? 0.4 : 0
            self.transform = GalaxyEggHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
        }

        if GalaxyEggHighlighted {
            let GalaxyEggImpact = UIImpactFeedbackGenerator(style: .light)
            GalaxyEggImpact.impactOccurred()
        }
    }

    private func GalaxyEggUpdateEnabledState() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = self.isEnabled ? 1.0 : 0.5
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Auto-calculate corner radius for circular buttons
        let GalaxyEggRadius = min(bounds.width, bounds.height) / 2.0
        let GalaxyEggCornerRadius = min(GalaxyEggRadius, 20)

        layer.cornerRadius = GalaxyEggCornerRadius

        if let GalaxyEggContainerLayer = layer.sublayers?.first {
            GalaxyEggContainerLayer.frame = bounds
            GalaxyEggContainerLayer.cornerRadius = GalaxyEggCornerRadius
        }

        GalaxyEggGradientLayer.frame = bounds
        GalaxyEggShineLayer.frame = bounds
        GalaxyEggHighlightLayer.frame = bounds
        GalaxyEggHighlightLayer.cornerRadius = GalaxyEggCornerRadius
    }

    private func GalaxyEggUpdateInsets() {
        GalaxyEggTitleLeadingConstraint?.constant = GalaxyEggContentInset.left
        GalaxyEggTitleTrailingConstraint?.constant = -GalaxyEggContentInset.right
        GalaxyEggTitleTopConstraint?.constant = GalaxyEggContentInset.top
        GalaxyEggTitleBottomConstraint?.constant = -GalaxyEggContentInset.bottom
        setNeedsLayout()
    }
}

class GalaxyEggSlotReelView: UIView {
    private let GalaxyEggSymbolLabel = UILabel()
    private let GalaxyEggTitleLabel = UILabel()
    private let GalaxyEggGlowLayer = CALayer()
    private let GalaxyEggParticleLayer = CAEmitterLayer()
    private var GalaxyEggItems: [String] = []
    private var GalaxyEggDisplayLink: CADisplayLink?
    private var GalaxyEggSpinStartDate: Date?
    private var GalaxyEggSpinDuration: TimeInterval = 1.5
    private var GalaxyEggCompletion: (() -> Void)?
    private let GalaxyEggBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    private var GalaxyEggTargetSymbol: String?
    private var GalaxyEggSpinCount: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        GalaxyEggConfigure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        GalaxyEggConfigure()
    }

    private func GalaxyEggConfigure() {
        layer.cornerRadius = 24
        layer.borderWidth = 2.5
        layer.borderColor = UIColor(red: 120/255, green: 84/255, blue: 255/255, alpha: 0.4).cgColor
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 120/255, green: 84/255, blue: 255/255, alpha: 1).cgColor
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 15
        layer.shadowOffset = .zero
        clipsToBounds = false

        GalaxyEggGlowLayer.backgroundColor = UIColor(red: 120/255, green: 84/255, blue: 255/255, alpha: 0.3).cgColor
        GalaxyEggGlowLayer.cornerRadius = 24
        GalaxyEggGlowLayer.masksToBounds = true
        layer.insertSublayer(GalaxyEggGlowLayer, at: 0)

        let GalaxyEggPulseAnimation = CABasicAnimation(keyPath: "opacity")
        GalaxyEggPulseAnimation.fromValue = 0.3
        GalaxyEggPulseAnimation.toValue = 0.6
        GalaxyEggPulseAnimation.duration = 1.5
        GalaxyEggPulseAnimation.autoreverses = true
        GalaxyEggPulseAnimation.repeatCount = .infinity
        GalaxyEggGlowLayer.add(GalaxyEggPulseAnimation, forKey: "glow")

        GalaxyEggBlurView.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggBlurView.layer.cornerRadius = 24
        GalaxyEggBlurView.layer.masksToBounds = true
        addSubview(GalaxyEggBlurView)

        NSLayoutConstraint.activate([
            GalaxyEggBlurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            GalaxyEggBlurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            GalaxyEggBlurView.topAnchor.constraint(equalTo: topAnchor),
            GalaxyEggBlurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        GalaxyEggSymbolLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggSymbolLabel.font = UIFont.systemFont(ofSize: 72)
        GalaxyEggSymbolLabel.textAlignment = .center
        GalaxyEggSymbolLabel.textColor = .white
        GalaxyEggSymbolLabel.adjustsFontSizeToFitWidth = true
        GalaxyEggSymbolLabel.minimumScaleFactor = 0.5
        GalaxyEggSymbolLabel.layer.shadowColor = UIColor.white.cgColor
        GalaxyEggSymbolLabel.layer.shadowOpacity = 0.8
        GalaxyEggSymbolLabel.layer.shadowRadius = 8
        GalaxyEggSymbolLabel.layer.shadowOffset = .zero
        GalaxyEggBlurView.contentView.addSubview(GalaxyEggSymbolLabel)

        GalaxyEggTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        GalaxyEggTitleLabel.textColor = UIColor(red: 120/255, green: 200/255, blue: 255/255, alpha: 1)
        GalaxyEggTitleLabel.textAlignment = .center
        GalaxyEggTitleLabel.adjustsFontSizeToFitWidth = true
        GalaxyEggTitleLabel.minimumScaleFactor = 0.7
        GalaxyEggBlurView.contentView.addSubview(GalaxyEggTitleLabel)

        NSLayoutConstraint.activate([
            GalaxyEggSymbolLabel.centerXAnchor.constraint(equalTo: GalaxyEggBlurView.contentView.centerXAnchor),
            GalaxyEggSymbolLabel.centerYAnchor.constraint(equalTo: GalaxyEggBlurView.contentView.centerYAnchor, constant: -8),
            GalaxyEggSymbolLabel.widthAnchor.constraint(equalTo: GalaxyEggBlurView.contentView.widthAnchor, multiplier: 0.75),
            GalaxyEggSymbolLabel.heightAnchor.constraint(equalTo: GalaxyEggBlurView.contentView.heightAnchor, multiplier: 0.5),

            GalaxyEggTitleLabel.topAnchor.constraint(equalTo: GalaxyEggSymbolLabel.bottomAnchor, constant: 4),
            GalaxyEggTitleLabel.leadingAnchor.constraint(equalTo: GalaxyEggBlurView.contentView.leadingAnchor, constant: 8),
            GalaxyEggTitleLabel.trailingAnchor.constraint(equalTo: GalaxyEggBlurView.contentView.trailingAnchor, constant: -8),
            GalaxyEggTitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: GalaxyEggBlurView.contentView.bottomAnchor, constant: -12)
        ])

        GalaxyEggParticleLayer.emitterShape = .rectangle
        GalaxyEggParticleLayer.emitterSize = CGSize(width: 100, height: 100)
        GalaxyEggParticleLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        GalaxyEggParticleLayer.birthRate = 0
        GalaxyEggParticleLayer.renderMode = .additive
        layer.addSublayer(GalaxyEggParticleLayer)

        let GalaxyEggParticleCell = CAEmitterCell()
        GalaxyEggParticleCell.contents = UIImage(systemName: "sparkle")?.withRenderingMode(.alwaysTemplate).cgImage
        GalaxyEggParticleCell.birthRate = 15
        GalaxyEggParticleCell.lifetime = 1.0
        GalaxyEggParticleCell.velocity = 50
        GalaxyEggParticleCell.velocityRange = 30
        GalaxyEggParticleCell.scale = 0.1
        GalaxyEggParticleCell.scaleRange = 0.05
        GalaxyEggParticleCell.alphaSpeed = -1.0
        GalaxyEggParticleCell.color = UIColor(red: 120/255, green: 200/255, blue: 255/255, alpha: 1).cgColor
        GalaxyEggParticleCell.emissionRange = .pi * 2

        GalaxyEggParticleLayer.emitterCells = [GalaxyEggParticleCell]
    }

    func GalaxyEggConfigureItems(_ GalaxyEggItems: [String], title GalaxyEggTitle: String) {
        self.GalaxyEggItems = GalaxyEggItems
        GalaxyEggTitleLabel.text = GalaxyEggTitle
        GalaxyEggSymbolLabel.text = GalaxyEggItems.first
    }

    func GalaxyEggStartSpin(duration GalaxyEggDuration: TimeInterval, finalSymbol GalaxyEggFinalSymbol: String, completion GalaxyEggCompletion: (() -> Void)? = nil) {
        GalaxyEggSpinDuration = GalaxyEggDuration
        GalaxyEggSpinStartDate = Date()
        self.GalaxyEggCompletion = GalaxyEggCompletion
        GalaxyEggTargetSymbol = GalaxyEggFinalSymbol
        GalaxyEggSpinCount = 0
        GalaxyEggDisplayLink?.invalidate()

        layer.borderColor = UIColor(red: 255/255, green: 200/255, blue: 100/255, alpha: 0.8).cgColor
        let GalaxyEggImpact = UIImpactFeedbackGenerator(style: .medium)
        GalaxyEggImpact.impactOccurred()

        let GalaxyEggLink = CADisplayLink(target: self, selector: #selector(GalaxyEggHandleTick))
        GalaxyEggLink.add(to: .main, forMode: .common)
        GalaxyEggDisplayLink = GalaxyEggLink
    }

    @objc private func GalaxyEggHandleTick() {
        guard let GalaxyEggStart = GalaxyEggSpinStartDate else { return }
        let GalaxyEggElapsed = Date().timeIntervalSince(GalaxyEggStart)
        if GalaxyEggElapsed >= GalaxyEggSpinDuration {
            GalaxyEggDisplayLink?.invalidate()
            GalaxyEggDisplayLink = nil
            GalaxyEggSymbolLabel.text = GalaxyEggTargetSymbol ?? GalaxyEggItems.randomElement() ?? GalaxyEggSymbolLabel.text ?? ""
            GalaxyEggAnimateStop()
            GalaxyEggCompletion?()
            return
        }

        GalaxyEggSpinCount += 1
        if GalaxyEggSpinCount % 3 == 0, let GalaxyEggItem = GalaxyEggItems.randomElement() {
            GalaxyEggSymbolLabel.text = GalaxyEggItem
        }
        GalaxyEggAnimateSpin(elapsed: GalaxyEggElapsed)
    }

    private func GalaxyEggAnimateSpin(elapsed GalaxyEggElapsed: TimeInterval) {
        let GalaxyEggProgress = CGFloat(min(1.0, GalaxyEggElapsed / GalaxyEggSpinDuration))
        let GalaxyEggFrequency = 8.0 - (GalaxyEggProgress * 6.0)
        let GalaxyEggScale = 1.0 + 0.15 * sin(GalaxyEggProgress * .pi * GalaxyEggFrequency)
        let GalaxyEggRotation = GalaxyEggProgress * .pi * 2
        GalaxyEggSymbolLabel.transform = CGAffineTransform(scaleX: GalaxyEggScale, y: GalaxyEggScale).rotated(by: GalaxyEggRotation)
        GalaxyEggSymbolLabel.alpha = 0.7 + 0.3 * sin(GalaxyEggProgress * .pi * GalaxyEggFrequency)
    }

    private func GalaxyEggAnimateStop() {
        layer.borderColor = UIColor(red: 120/255, green: 84/255, blue: 255/255, alpha: 0.4).cgColor

        GalaxyEggParticleLayer.birthRate = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.GalaxyEggParticleLayer.birthRate = 0
        }

        let GalaxyEggImpact = UINotificationFeedbackGenerator()
        GalaxyEggImpact.notificationOccurred(.success)

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: []) {
            self.GalaxyEggSymbolLabel.transform = .identity
            self.GalaxyEggSymbolLabel.alpha = 1.0
        }

        let GalaxyEggBounce = CAKeyframeAnimation(keyPath: "transform.scale")
        GalaxyEggBounce.values = [1.0, 1.2, 0.9, 1.1, 1.0]
        GalaxyEggBounce.keyTimes = [0, 0.3, 0.5, 0.7, 1.0]
        GalaxyEggBounce.duration = 0.6
        GalaxyEggBounce.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(GalaxyEggBounce, forKey: "bounce")
    }

    func GalaxyEggDisplay(symbol GalaxyEggSymbol: String) {
        GalaxyEggSymbolLabel.text = GalaxyEggSymbol
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        GalaxyEggGlowLayer.frame = bounds
        GalaxyEggParticleLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        GalaxyEggParticleLayer.emitterSize = bounds.size
    }
}

class GalaxyEggCelebrationParticlesView: UIView {
    private let GalaxyEggEmitterLayer = CAEmitterLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        GalaxyEggConfigure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        GalaxyEggConfigure()
    }

    private func GalaxyEggConfigure() {
        isUserInteractionEnabled = false
        backgroundColor = .clear

        GalaxyEggEmitterLayer.emitterShape = .point
        GalaxyEggEmitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        GalaxyEggEmitterLayer.birthRate = 0
        GalaxyEggEmitterLayer.renderMode = .additive
        layer.addSublayer(GalaxyEggEmitterLayer)

        let GalaxyEggStarCell = GalaxyEggCreateParticleCell(color: UIColor(red: 255/255, green: 220/255, blue: 100/255, alpha: 1))
        let GalaxyEggSparkleCell = GalaxyEggCreateParticleCell(color: UIColor(red: 120/255, green: 200/255, blue: 255/255, alpha: 1))
        let GalaxyEggGlowCell = GalaxyEggCreateParticleCell(color: UIColor(red: 200/255, green: 100/255, blue: 255/255, alpha: 1))

        GalaxyEggEmitterLayer.emitterCells = [GalaxyEggStarCell, GalaxyEggSparkleCell, GalaxyEggGlowCell]
    }

    private func GalaxyEggCreateParticleCell(color GalaxyEggColor: UIColor) -> CAEmitterCell {
        let GalaxyEggCell = CAEmitterCell()
        GalaxyEggCell.contents = UIImage(systemName: "sparkle")?.withRenderingMode(.alwaysTemplate).cgImage
        GalaxyEggCell.birthRate = 20
        GalaxyEggCell.lifetime = 2.0
        GalaxyEggCell.lifetimeRange = 1.0
        GalaxyEggCell.velocity = 120
        GalaxyEggCell.velocityRange = 80
        GalaxyEggCell.emissionRange = .pi * 2
        GalaxyEggCell.scale = 0.15
        GalaxyEggCell.scaleRange = 0.1
        GalaxyEggCell.scaleSpeed = -0.05
        GalaxyEggCell.alphaSpeed = -0.5
        GalaxyEggCell.spin = 2.0
        GalaxyEggCell.spinRange = 4.0
        GalaxyEggCell.color = GalaxyEggColor.cgColor
        return GalaxyEggCell
    }

    func GalaxyEggTriggerCelebration(at GalaxyEggPoint: CGPoint? = nil) {
        if let GalaxyEggPoint = GalaxyEggPoint {
            GalaxyEggEmitterLayer.emitterPosition = GalaxyEggPoint
        } else {
            GalaxyEggEmitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        }

        GalaxyEggEmitterLayer.birthRate = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.GalaxyEggEmitterLayer.birthRate = 0
        }

        let GalaxyEggImpact = UINotificationFeedbackGenerator()
        GalaxyEggImpact.notificationOccurred(.success)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        GalaxyEggEmitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}

class GalaxyEggResultOverlayView: UIView {
    private let GalaxyEggBackdropView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    private let GalaxyEggCardView = UIView()
    private let GalaxyEggTitleLabel = UILabel()
    private let GalaxyEggSymbolLabel = UILabel()
    private let GalaxyEggDescriptionLabel = UILabel()
    private let GalaxyEggRewardLabel = UILabel()
    private let GalaxyEggCTAStack = UIStackView()
    private let GalaxyEggPrimaryButton = GalaxyEggButtonView()
    private let GalaxyEggSecondaryButton = GalaxyEggButtonView()
    private let GalaxyEggCelebrationView = GalaxyEggCelebrationParticlesView()

    var GalaxyEggPrimaryAction: (() -> Void)?
    var GalaxyEggSecondaryAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        GalaxyEggConfigure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        GalaxyEggConfigure()
    }
    
    private func GalaxyEggConfigure() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        alpha = 0
        
        GalaxyEggBackdropView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(GalaxyEggBackdropView)
        NSLayoutConstraint.activate([
            GalaxyEggBackdropView.leadingAnchor.constraint(equalTo: leadingAnchor),
            GalaxyEggBackdropView.trailingAnchor.constraint(equalTo: trailingAnchor),
            GalaxyEggBackdropView.topAnchor.constraint(equalTo: topAnchor),
            GalaxyEggBackdropView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        GalaxyEggCardView.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggCardView.backgroundColor = UIColor(white: 1, alpha: 0.08)
        GalaxyEggCardView.layer.cornerRadius = 28
        GalaxyEggCardView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        GalaxyEggCardView.layer.borderWidth = 1.5
        GalaxyEggCardView.layer.shadowColor = UIColor.purple.cgColor
        GalaxyEggCardView.layer.shadowOpacity = 0.6
        GalaxyEggCardView.layer.shadowRadius = 30
        GalaxyEggCardView.layer.shadowOffset = .zero
        GalaxyEggBackdropView.contentView.addSubview(GalaxyEggCardView)
        
        GalaxyEggTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggTitleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        GalaxyEggTitleLabel.textColor = .white
        GalaxyEggTitleLabel.textAlignment = .center
        GalaxyEggTitleLabel.numberOfLines = 0
        GalaxyEggTitleLabel.adjustsFontSizeToFitWidth = true
        GalaxyEggTitleLabel.minimumScaleFactor = 0.7
        GalaxyEggCardView.addSubview(GalaxyEggTitleLabel)
        
        GalaxyEggSymbolLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggSymbolLabel.font = UIFont.systemFont(ofSize: 72)
        GalaxyEggSymbolLabel.textAlignment = .center
        GalaxyEggCardView.addSubview(GalaxyEggSymbolLabel)
        
        GalaxyEggDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggDescriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        GalaxyEggDescriptionLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        GalaxyEggDescriptionLabel.textAlignment = .center
        GalaxyEggDescriptionLabel.numberOfLines = 0
        GalaxyEggCardView.addSubview(GalaxyEggDescriptionLabel)
        
        GalaxyEggRewardLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggRewardLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .semibold)
        GalaxyEggRewardLabel.textColor = UIColor(red: 217/255, green: 255/255, blue: 123/255, alpha: 1)
        GalaxyEggRewardLabel.textAlignment = .center
        GalaxyEggCardView.addSubview(GalaxyEggRewardLabel)
        
        GalaxyEggCTAStack.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggCTAStack.axis = .horizontal
        GalaxyEggCTAStack.spacing = 16
        GalaxyEggCTAStack.distribution = .fillEqually
        GalaxyEggCardView.addSubview(GalaxyEggCTAStack)
        
        GalaxyEggPrimaryButton.GalaxyEggSetTitle("Spin Again")
        GalaxyEggSecondaryButton.GalaxyEggSetTitle("Back to Lab")
        
        GalaxyEggPrimaryButton.addTarget(self, action: #selector(GalaxyEggHandlePrimary), for: .touchUpInside)
        GalaxyEggSecondaryButton.addTarget(self, action: #selector(GalaxyEggHandleSecondary), for: .touchUpInside)
        
        GalaxyEggCTAStack.addArrangedSubview(GalaxyEggPrimaryButton)
        GalaxyEggCTAStack.addArrangedSubview(GalaxyEggSecondaryButton)
        
        NSLayoutConstraint.activate([
            GalaxyEggCardView.centerXAnchor.constraint(equalTo: GalaxyEggBackdropView.contentView.centerXAnchor),
            GalaxyEggCardView.centerYAnchor.constraint(equalTo: GalaxyEggBackdropView.contentView.centerYAnchor),
            GalaxyEggCardView.leadingAnchor.constraint(greaterThanOrEqualTo: GalaxyEggBackdropView.contentView.leadingAnchor, constant: 40),
            GalaxyEggCardView.trailingAnchor.constraint(lessThanOrEqualTo: GalaxyEggBackdropView.contentView.trailingAnchor, constant: -40),
            GalaxyEggCardView.topAnchor.constraint(greaterThanOrEqualTo: GalaxyEggBackdropView.contentView.topAnchor, constant: 40),
            GalaxyEggCardView.bottomAnchor.constraint(lessThanOrEqualTo: GalaxyEggBackdropView.contentView.bottomAnchor, constant: -40),
            GalaxyEggCardView.widthAnchor.constraint(lessThanOrEqualToConstant: 600),
            GalaxyEggCardView.widthAnchor.constraint(greaterThanOrEqualToConstant: 320),

            GalaxyEggTitleLabel.topAnchor.constraint(equalTo: GalaxyEggCardView.topAnchor, constant: 20),
            GalaxyEggTitleLabel.leadingAnchor.constraint(equalTo: GalaxyEggCardView.leadingAnchor, constant: 20),
            GalaxyEggTitleLabel.trailingAnchor.constraint(equalTo: GalaxyEggCardView.trailingAnchor, constant: -20),

            GalaxyEggSymbolLabel.topAnchor.constraint(equalTo: GalaxyEggTitleLabel.bottomAnchor, constant: 12),
            GalaxyEggSymbolLabel.centerXAnchor.constraint(equalTo: GalaxyEggCardView.centerXAnchor),

            GalaxyEggDescriptionLabel.topAnchor.constraint(equalTo: GalaxyEggSymbolLabel.bottomAnchor, constant: 12),
            GalaxyEggDescriptionLabel.leadingAnchor.constraint(equalTo: GalaxyEggCardView.leadingAnchor, constant: 20),
            GalaxyEggDescriptionLabel.trailingAnchor.constraint(equalTo: GalaxyEggCardView.trailingAnchor, constant: -20),

            GalaxyEggRewardLabel.topAnchor.constraint(equalTo: GalaxyEggDescriptionLabel.bottomAnchor, constant: 10),
            GalaxyEggRewardLabel.leadingAnchor.constraint(equalTo: GalaxyEggCardView.leadingAnchor, constant: 20),
            GalaxyEggRewardLabel.trailingAnchor.constraint(equalTo: GalaxyEggCardView.trailingAnchor, constant: -20),

            GalaxyEggCTAStack.topAnchor.constraint(equalTo: GalaxyEggRewardLabel.bottomAnchor, constant: 20),
            GalaxyEggCTAStack.leadingAnchor.constraint(equalTo: GalaxyEggCardView.leadingAnchor, constant: 20),
            GalaxyEggCTAStack.trailingAnchor.constraint(equalTo: GalaxyEggCardView.trailingAnchor, constant: -20),
            GalaxyEggCTAStack.bottomAnchor.constraint(equalTo: GalaxyEggCardView.bottomAnchor, constant: -20)
        ])
    }
    
    func GalaxyEggPresent(in GalaxyEggView: UIView) {
        frame = GalaxyEggView.bounds
        GalaxyEggView.addSubview(self)
        GalaxyEggView.layoutIfNeeded()
        GalaxyEggCardView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)

        GalaxyEggCelebrationView.frame = bounds
        addSubview(GalaxyEggCelebrationView)
        bringSubviewToFront(GalaxyEggBackdropView)

        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       usingSpringWithDamping: 0.75,
                       initialSpringVelocity: 0.6,
                       options: [.curveEaseInOut]) {
            self.alpha = 1
            self.GalaxyEggCardView.transform = .identity
        } completion: { _ in
            self.GalaxyEggCelebrationView.GalaxyEggTriggerCelebration()
        }
    }
    
    func GalaxyEggDismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.GalaxyEggCardView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    func GalaxyEggConfigure(with GalaxyEggOutcome: GalaxyEggSpinOutcomeModel) {
        GalaxyEggTitleLabel.text = GalaxyEggOutcome.GalaxyEggIsNewDiscovery ? "New Discovery!" : "Discovery Logged"
        GalaxyEggSymbolLabel.text = GalaxyEggOutcome.GalaxyEggResultElement.GalaxyEggSymbol
        GalaxyEggDescriptionLabel.text = "\(GalaxyEggOutcome.GalaxyEggResultElement.GalaxyEggDisplayName)\n\(GalaxyEggOutcome.GalaxyEggResultElement.GalaxyEggDetail)"
        GalaxyEggRewardLabel.text = "Reward +\(GalaxyEggOutcome.GalaxyEggReward) ⭐️"
    }
    
    func GalaxyEggUpdateCTA(primary GalaxyEggTitle: String, secondary GalaxyEggSecondaryTitle: String) {
        GalaxyEggPrimaryButton.GalaxyEggSetTitle(GalaxyEggTitle)
        GalaxyEggSecondaryButton.GalaxyEggSetTitle(GalaxyEggSecondaryTitle)
    }
    
    @objc private func GalaxyEggHandlePrimary() {
        GalaxyEggDismiss()
        GalaxyEggPrimaryAction?()
    }
    
    @objc private func GalaxyEggHandleSecondary() {
        GalaxyEggDismiss()
        GalaxyEggSecondaryAction?()
    }
}
