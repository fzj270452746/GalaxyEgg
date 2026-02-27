

import UIKit

class GalaxyEggBonusSlotViewController: UIViewController {

    private let GalaxyEggEngine: GalaxyEggSpinEngine
    private let GalaxyEggAudio: GalaxyEggAudioManager

    private let GalaxyEggBackgroundView = GalaxyEggGradientBackgroundView()
    private let GalaxyEggBackButton = GalaxyEggButtonView()
    private let GalaxyEggCoinLabel = UILabel()
    private let GalaxyEggTitleLabel = UILabel()
    private let GalaxyEggSubtitleLabel = UILabel()
    private let GalaxyEggInstructionLabel = UILabel()
    private let GalaxyEggRemainingLabel = UILabel()

    private let GalaxyEggReelContainer = UIView()
    private var GalaxyEggReel1: GalaxyEggBonusReelView!
    private var GalaxyEggReel2: GalaxyEggBonusReelView!
    private var GalaxyEggReel3: GalaxyEggBonusReelView!

    private let GalaxyEggSpinButton = GalaxyEggButtonView()
    private let GalaxyEggResultLabel = UILabel()

    private var GalaxyEggIsSpinning = false

    init(engine GalaxyEggEngine: GalaxyEggSpinEngine, audioManager GalaxyEggAudio: GalaxyEggAudioManager) {
        self.GalaxyEggEngine = GalaxyEggEngine
        self.GalaxyEggAudio = GalaxyEggAudio
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        GalaxyEggConfigureLayout()
        GalaxyEggConfigureContent()
        GalaxyEggUpdateRemainingSpins()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscape
    }

    private func GalaxyEggConfigureLayout() {
        view.addSubview(GalaxyEggBackgroundView)
        GalaxyEggBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            GalaxyEggBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            GalaxyEggBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            GalaxyEggBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            GalaxyEggBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Back button
        GalaxyEggBackButton.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggBackButton.GalaxyEggSetTitle("◀︎ Home")
        GalaxyEggBackButton.GalaxyEggContentInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        GalaxyEggBackButton.addTarget(self, action: #selector(GalaxyEggHandleClose), for: .touchUpInside)
        view.addSubview(GalaxyEggBackButton)

        // Coin label
        GalaxyEggCoinLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggCoinLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .bold)
        GalaxyEggCoinLabel.textColor = UIColor(red: 255/255, green: 220/255, blue: 159/255, alpha: 1)
        GalaxyEggCoinLabel.textAlignment = .right
        view.addSubview(GalaxyEggCoinLabel)

        // Title
        GalaxyEggTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggTitleLabel.font = UIFont.systemFont(ofSize: 36, weight: .heavy)
        GalaxyEggTitleLabel.textColor = .white
        GalaxyEggTitleLabel.textAlignment = .center
        view.addSubview(GalaxyEggTitleLabel)

        // Subtitle
        GalaxyEggSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggSubtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        GalaxyEggSubtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        GalaxyEggSubtitleLabel.textAlignment = .center
        view.addSubview(GalaxyEggSubtitleLabel)

        // Instruction label
        GalaxyEggInstructionLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggInstructionLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        GalaxyEggInstructionLabel.textColor = UIColor(red: 255/255, green: 215/255, blue: 100/255, alpha: 1)
        GalaxyEggInstructionLabel.textAlignment = .left
        GalaxyEggInstructionLabel.numberOfLines = 0
        GalaxyEggInstructionLabel.text = "🎮 How to Play:\n\n💫 Match 3 symbols\n   to win coins!\n\n🎁 Higher rewards for\n   rarer matches\n\n⏰ 20 free spins\n   daily (resets at\n   midnight)"
        view.addSubview(GalaxyEggInstructionLabel)

        // Remaining spins
        GalaxyEggRemainingLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggRemainingLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        GalaxyEggRemainingLabel.textColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        GalaxyEggRemainingLabel.textAlignment = .center
        view.addSubview(GalaxyEggRemainingLabel)

        // Reel container
        GalaxyEggReelContainer.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggReelContainer.backgroundColor = UIColor(white: 0, alpha: 0.3)
        GalaxyEggReelContainer.layer.cornerRadius = 20
        GalaxyEggReelContainer.layer.borderWidth = 2
        GalaxyEggReelContainer.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        view.addSubview(GalaxyEggReelContainer)

        // Create reels
        let GalaxyEggReelHeight = view.bounds.height * 0.25
        GalaxyEggReel1 = GalaxyEggBonusReelView(frame: .zero)
        GalaxyEggReel2 = GalaxyEggBonusReelView(frame: .zero)
        GalaxyEggReel3 = GalaxyEggBonusReelView(frame: .zero)

        [GalaxyEggReel1, GalaxyEggReel2, GalaxyEggReel3].forEach { reel in
            reel?.translatesAutoresizingMaskIntoConstraints = false
            GalaxyEggReelContainer.addSubview(reel!)
        }

        // Result label
        GalaxyEggResultLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggResultLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        GalaxyEggResultLabel.textColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        GalaxyEggResultLabel.textAlignment = .center
        GalaxyEggResultLabel.numberOfLines = 0
        view.addSubview(GalaxyEggResultLabel)

        // Spin button
        GalaxyEggSpinButton.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggSpinButton.addTarget(self, action: #selector(GalaxyEggHandleSpin), for: .touchUpInside)
        view.addSubview(GalaxyEggSpinButton)

        let GalaxyEggReelWidth = GalaxyEggReelHeight * 0.8
        let GalaxyEggReelSpacing: CGFloat = 20

        NSLayoutConstraint.activate([
            GalaxyEggBackButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            GalaxyEggBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            GalaxyEggBackButton.heightAnchor.constraint(equalToConstant: 44),

            GalaxyEggCoinLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            GalaxyEggCoinLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),

            GalaxyEggTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            GalaxyEggTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            GalaxyEggSubtitleLabel.topAnchor.constraint(equalTo: GalaxyEggTitleLabel.bottomAnchor, constant: 4),
            GalaxyEggSubtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            GalaxyEggRemainingLabel.topAnchor.constraint(equalTo: GalaxyEggSubtitleLabel.bottomAnchor, constant: 8),
            GalaxyEggRemainingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            GalaxyEggReelContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            GalaxyEggReelContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            GalaxyEggReelContainer.heightAnchor.constraint(equalToConstant: GalaxyEggReelHeight + 40),
            GalaxyEggReelContainer.widthAnchor.constraint(equalToConstant: GalaxyEggReelWidth * 3 + GalaxyEggReelSpacing * 2 + 40),

            GalaxyEggInstructionLabel.trailingAnchor.constraint(equalTo: GalaxyEggReelContainer.leadingAnchor, constant: -30),
            GalaxyEggInstructionLabel.centerYAnchor.constraint(equalTo: GalaxyEggReelContainer.centerYAnchor),
            GalaxyEggInstructionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            GalaxyEggInstructionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 180),

            GalaxyEggReel1.leadingAnchor.constraint(equalTo: GalaxyEggReelContainer.leadingAnchor, constant: 20),
            GalaxyEggReel1.centerYAnchor.constraint(equalTo: GalaxyEggReelContainer.centerYAnchor),
            GalaxyEggReel1.widthAnchor.constraint(equalToConstant: GalaxyEggReelWidth),
            GalaxyEggReel1.heightAnchor.constraint(equalToConstant: GalaxyEggReelHeight),

            GalaxyEggReel2.leadingAnchor.constraint(equalTo: GalaxyEggReel1.trailingAnchor, constant: GalaxyEggReelSpacing),
            GalaxyEggReel2.centerYAnchor.constraint(equalTo: GalaxyEggReelContainer.centerYAnchor),
            GalaxyEggReel2.widthAnchor.constraint(equalToConstant: GalaxyEggReelWidth),
            GalaxyEggReel2.heightAnchor.constraint(equalToConstant: GalaxyEggReelHeight),

            GalaxyEggReel3.leadingAnchor.constraint(equalTo: GalaxyEggReel2.trailingAnchor, constant: GalaxyEggReelSpacing),
            GalaxyEggReel3.centerYAnchor.constraint(equalTo: GalaxyEggReelContainer.centerYAnchor),
            GalaxyEggReel3.widthAnchor.constraint(equalToConstant: GalaxyEggReelWidth),
            GalaxyEggReel3.heightAnchor.constraint(equalToConstant: GalaxyEggReelHeight),

            GalaxyEggResultLabel.topAnchor.constraint(equalTo: GalaxyEggReelContainer.bottomAnchor, constant: 24),
            GalaxyEggResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            GalaxyEggResultLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            GalaxyEggResultLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40),

            GalaxyEggSpinButton.topAnchor.constraint(equalTo: GalaxyEggResultLabel.bottomAnchor, constant: 16),
            GalaxyEggSpinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            GalaxyEggSpinButton.widthAnchor.constraint(equalToConstant: 200),
            GalaxyEggSpinButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func GalaxyEggConfigureContent() {
        GalaxyEggTitleLabel.text = "⭐️ Bonus Slots ⭐️"
        GalaxyEggSubtitleLabel.text = "Match 3 symbols to win Star Coins!"
        GalaxyEggSpinButton.GalaxyEggSetTitle("SPIN")

        GalaxyEggReel1.GalaxyEggSetSymbol("🌍")
        GalaxyEggReel2.GalaxyEggSetSymbol("🌍")
        GalaxyEggReel3.GalaxyEggSetSymbol("🌍")

        GalaxyEggUpdateCoinLabel()
    }

    private func GalaxyEggUpdateCoinLabel() {
        GalaxyEggCoinLabel.text = "Star Coins 💰 \(GalaxyEggEngine.GalaxyEggCurrentCurrency())"
    }

    private func GalaxyEggUpdateRemainingSpins() {
        let GalaxyEggRemaining = GalaxyEggEngine.GalaxyEggGetRemainingBonusSpins()
        GalaxyEggRemainingLabel.text = "Free Spins: \(GalaxyEggRemaining)/\(GalaxyEggSpinEngine.GalaxyEggDailyBonusSpins)"
        GalaxyEggSpinButton.isEnabled = GalaxyEggRemaining > 0
        GalaxyEggSpinButton.alpha = GalaxyEggRemaining > 0 ? 1.0 : 0.5
    }

    @objc private func GalaxyEggHandleSpin() {
        guard !GalaxyEggIsSpinning else { return }
        guard let GalaxyEggOutcome = GalaxyEggEngine.GalaxyEggPerformBonusSpin() else {
            GalaxyEggResultLabel.text = "No spins remaining!\nCome back tomorrow."
            return
        }

        GalaxyEggIsSpinning = true
        GalaxyEggSpinButton.isEnabled = false
        GalaxyEggResultLabel.text = ""

        // Start spinning animation
        GalaxyEggReel1.GalaxyEggStartSpinning()
        GalaxyEggReel2.GalaxyEggStartSpinning()
        GalaxyEggReel3.GalaxyEggStartSpinning()

        // Stop reels sequentially
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.GalaxyEggReel1.GalaxyEggStopSpinning(with: GalaxyEggOutcome.GalaxyEggSymbol1)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) { [weak self] in
            self?.GalaxyEggReel2.GalaxyEggStopSpinning(with: GalaxyEggOutcome.GalaxyEggSymbol2)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) { [weak self] in
            self?.GalaxyEggReel3.GalaxyEggStopSpinning(with: GalaxyEggOutcome.GalaxyEggSymbol3)
        }

        // Show result
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) { [weak self] in
            guard let self = self else { return }

            if GalaxyEggOutcome.GalaxyEggIsWin {
                self.GalaxyEggResultLabel.text = "🎉 WIN! +\(GalaxyEggOutcome.GalaxyEggReward) Star Coins! 🎉"
                self.GalaxyEggResultLabel.textColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)

                let GalaxyEggImpact = UINotificationFeedbackGenerator()
                GalaxyEggImpact.notificationOccurred(.success)
            } else {
                self.GalaxyEggResultLabel.text = "Try again!"
                self.GalaxyEggResultLabel.textColor = .white
            }

            self.GalaxyEggIsSpinning = false
            self.GalaxyEggUpdateRemainingSpins()
            self.GalaxyEggUpdateCoinLabel()
        }
    }

    @objc private func GalaxyEggHandleClose() {
        dismiss(animated: true)
    }
}

// MARK: - Bonus Reel View
class GalaxyEggBonusReelView: UIView {
    private let GalaxyEggSymbolLabel = UILabel()
    private let GalaxyEggGlowLayer = CALayer()
    private var GalaxyEggSpinTimer: Timer?
    private var GalaxyEggCurrentIndex = 0

    private let GalaxyEggAllSymbols = ["🌍", "🔴", "🟡", "🌀", "❄️", "🏜️", "🌊", "🌈", "💎", "🌋"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        GalaxyEggSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        GalaxyEggSetup()
    }

    private func GalaxyEggSetup() {
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor

        // Glow layer
        GalaxyEggGlowLayer.backgroundColor = UIColor.white.withAlphaComponent(0.1).cgColor
        GalaxyEggGlowLayer.cornerRadius = 16
        layer.insertSublayer(GalaxyEggGlowLayer, at: 0)

        GalaxyEggSymbolLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggSymbolLabel.font = UIFont.systemFont(ofSize: 64)
        GalaxyEggSymbolLabel.textAlignment = .center
        addSubview(GalaxyEggSymbolLabel)

        NSLayoutConstraint.activate([
            GalaxyEggSymbolLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            GalaxyEggSymbolLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        GalaxyEggGlowLayer.frame = bounds
    }

    func GalaxyEggSetSymbol(_ GalaxyEggSymbol: String) {
        GalaxyEggSymbolLabel.text = GalaxyEggSymbol
    }

    func GalaxyEggStartSpinning() {
        GalaxyEggCurrentIndex = 0
        GalaxyEggSpinTimer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.GalaxyEggSymbolLabel.text = self.GalaxyEggAllSymbols[self.GalaxyEggCurrentIndex % self.GalaxyEggAllSymbols.count]
            self.GalaxyEggCurrentIndex += 1

            // Pulse animation
            UIView.animate(withDuration: 0.08) {
                self.GalaxyEggSymbolLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } completion: { _ in
                UIView.animate(withDuration: 0.08) {
                    self.GalaxyEggSymbolLabel.transform = .identity
                }
            }
        }
    }

    func GalaxyEggStopSpinning(with GalaxyEggFinalSymbol: String) {
        GalaxyEggSpinTimer?.invalidate()
        GalaxyEggSpinTimer = nil

        // Bounce animation
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: []) {
            self.GalaxyEggSymbolLabel.text = GalaxyEggFinalSymbol
            self.GalaxyEggSymbolLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.GalaxyEggSymbolLabel.transform = .identity
            }
        }

        // Glow effect
        let GalaxyEggGlowAnimation = CABasicAnimation(keyPath: "backgroundColor")
        GalaxyEggGlowAnimation.fromValue = UIColor.white.withAlphaComponent(0.3).cgColor
        GalaxyEggGlowAnimation.toValue = UIColor.white.withAlphaComponent(0.1).cgColor
        GalaxyEggGlowAnimation.duration = 0.5
        GalaxyEggGlowLayer.add(GalaxyEggGlowAnimation, forKey: "glow")

        let GalaxyEggImpact = UIImpactFeedbackGenerator(style: .medium)
        GalaxyEggImpact.impactOccurred()
    }
}
