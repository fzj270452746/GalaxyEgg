//
//  GalaxyEggGameViewController.swift
//  GalaxyEgg
//
//  Created by Assistant on 10/10/25.
//

import UIKit

class GalaxyEggGameViewController: UIViewController {
    
    private let GalaxyEggEngine: GalaxyEggSpinEngine
    private let GalaxyEggAudio: GalaxyEggAudioManager
    
    private let GalaxyEggBackgroundView = GalaxyEggGradientBackgroundView()
    private let GalaxyEggStarfieldLayerView = GalaxyEggStarfieldView()
    private let GalaxyEggTopBarStack = UIStackView()
    private let GalaxyEggEnergyLabel = UILabel()
    private let GalaxyEggEnergyTimerLabel = UILabel()
    private let GalaxyEggEnergyInfoStack = UIStackView()
    private let GalaxyEggBuyEnergyButton = GalaxyEggButtonView()
    private let GalaxyEggCurrencyLabel = UILabel()
    private let GalaxyEggBackButton = GalaxyEggButtonView()
    private var GalaxyEggEnergyUpdateTimer: Timer?
    private let GalaxyEggReelStack = UIStackView()
    private let GalaxyEggPlanetReel = GalaxyEggSlotReelView()
    private let GalaxyEggEventReel = GalaxyEggSlotReelView()
    private let GalaxyEggCivilizationReel = GalaxyEggSlotReelView()
    private let GalaxyEggSpinButton = GalaxyEggButtonView()
    private let GalaxyEggResultOverlay = GalaxyEggResultOverlayView()
    private let GalaxyEggResultCard = UIView()
    private let GalaxyEggResultTitleLabel = UILabel()
    private let GalaxyEggResultDetailLabel = UILabel()
    private let GalaxyEggResultTagLabel = UILabel()
    
    private var GalaxyEggIsSpinning = false
    
    private let GalaxyEggPlanetSymbols: [String: String] = [
        "Earth": "🌍",
        "Mars": "🔴",
        "Venus": "🟡",
        "Jupiter": "🌀",
        "Ice Planet": "❄️",
        "Desert Planet": "🏜️",
        "Ocean Planet": "🌊",
        "Neon Planet": "🌈",
        "Crystal Planet": "💎",
        "Volcanic Planet": "🌋"
    ]
    
    private let GalaxyEggEventSymbols: [String: String] = [
        "Resources Discovered": "🔭",
        "Alien Invasion": "👾",
        "Black Hole": "🕳️",
        "Space Travel": "🚀"
    ]
    
    private let GalaxyEggCivilizationSymbols: [String: String] = [
        "Human": "🧑‍🚀",
        "Alien": "👽",
        "Robot": "🤖",
        "Ancient": "🏛️"
    ]
    
    init(engine GalaxyEggEngine: GalaxyEggSpinEngine, audioManager GalaxyEggAudio: GalaxyEggAudioManager) {
        self.GalaxyEggEngine = GalaxyEggEngine
        self.GalaxyEggAudio = GalaxyEggAudio
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var GalaxyEggHasPerformedInitialLayout = false

    override func viewDidLoad() {
        super.viewDidLoad()
        GalaxyEggConfigureLayout()
        GalaxyEggConfigureContent()
        GalaxyEggStartEnergyTimer()
        GalaxyEggUpdateStatusLabels()
        GalaxyEggUpdateEnergyTimer()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update timer after first layout to ensure proper display
        if !GalaxyEggHasPerformedInitialLayout {
            GalaxyEggHasPerformedInitialLayout = true
            DispatchQueue.main.async { [weak self] in
                self?.GalaxyEggUpdateEnergyTimer()
                self?.view.layoutIfNeeded()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Ensure timer is visible when view is fully displayed
        GalaxyEggUpdateEnergyTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        GalaxyEggEnergyUpdateTimer?.invalidate()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscape
    }

    private func GalaxyEggStartEnergyTimer() {
        GalaxyEggUpdateEnergyTimer()
        GalaxyEggEnergyUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.GalaxyEggUpdateEnergyTimer()
        }
    }

    private func GalaxyEggUpdateEnergyTimer() {
        let GalaxyEggTimeRemaining = GalaxyEggEngine.GalaxyEggGetTimeUntilNextEnergyRecovery()
        let GalaxyEggCurrentEnergy = GalaxyEggEngine.GalaxyEggCurrentEnergy()

        if GalaxyEggCurrentEnergy < GalaxyEggSpinEngine.GalaxyEggMaxEnergy {
            let GalaxyEggMinutes = Int(GalaxyEggTimeRemaining) / 60
            let GalaxyEggSeconds = Int(GalaxyEggTimeRemaining) % 60
            GalaxyEggEnergyTimerLabel.text = String(format: "⏱ %02d:%02d", GalaxyEggMinutes, GalaxyEggSeconds)
            GalaxyEggEnergyTimerLabel.isHidden = false
            GalaxyEggEnergyTimerLabel.alpha = 1.0
        } else {
            GalaxyEggEnergyTimerLabel.isHidden = true
        }
        GalaxyEggUpdateStatusLabels()
    }
    
    private func GalaxyEggConfigureLayout() {
        view.backgroundColor = .black
        
        GalaxyEggBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(GalaxyEggBackgroundView)
        NSLayoutConstraint.activate([
            GalaxyEggBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            GalaxyEggBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            GalaxyEggBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            GalaxyEggBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        GalaxyEggStarfieldLayerView.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggBackgroundView.addSubview(GalaxyEggStarfieldLayerView)
        NSLayoutConstraint.activate([
            GalaxyEggStarfieldLayerView.leadingAnchor.constraint(equalTo: GalaxyEggBackgroundView.leadingAnchor),
            GalaxyEggStarfieldLayerView.trailingAnchor.constraint(equalTo: GalaxyEggBackgroundView.trailingAnchor),
            GalaxyEggStarfieldLayerView.topAnchor.constraint(equalTo: GalaxyEggBackgroundView.topAnchor),
            GalaxyEggStarfieldLayerView.bottomAnchor.constraint(equalTo: GalaxyEggBackgroundView.bottomAnchor)
        ])
        
        GalaxyEggBackButton.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggBackButton.GalaxyEggSetTitle("◀︎ Home")
        GalaxyEggBackButton.addTarget(self, action: #selector(GalaxyEggHandleBack), for: .touchUpInside)
        GalaxyEggBackButton.GalaxyEggContentInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        view.addSubview(GalaxyEggBackButton)

        // Energy container with label, timer, and buy button
        let GalaxyEggEnergyContainer = UIView()
        GalaxyEggEnergyContainer.translatesAutoresizingMaskIntoConstraints = false

        // Create vertical stack for energy label and timer
        GalaxyEggEnergyInfoStack.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggEnergyInfoStack.axis = .vertical
        GalaxyEggEnergyInfoStack.spacing = 4
        GalaxyEggEnergyInfoStack.alignment = .trailing

        GalaxyEggEnergyLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggEnergyLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .bold)
        GalaxyEggEnergyLabel.textColor = UIColor(red: 135/255, green: 255/255, blue: 251/255, alpha: 1)
        GalaxyEggEnergyLabel.textAlignment = .right
        GalaxyEggEnergyLabel.numberOfLines = 1
        GalaxyEggEnergyLabel.adjustsFontSizeToFitWidth = true
        GalaxyEggEnergyLabel.minimumScaleFactor = 0.7
        GalaxyEggEnergyLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        GalaxyEggEnergyLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        GalaxyEggEnergyTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggEnergyTimerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        GalaxyEggEnergyTimerLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        GalaxyEggEnergyTimerLabel.textAlignment = .right
        GalaxyEggEnergyTimerLabel.numberOfLines = 1
        GalaxyEggEnergyTimerLabel.setContentHuggingPriority(.required, for: .horizontal)
        GalaxyEggEnergyTimerLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        GalaxyEggEnergyInfoStack.addArrangedSubview(GalaxyEggEnergyLabel)
        GalaxyEggEnergyInfoStack.addArrangedSubview(GalaxyEggEnergyTimerLabel)

        GalaxyEggBuyEnergyButton.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggBuyEnergyButton.GalaxyEggSetTitle("+")
        GalaxyEggBuyEnergyButton.GalaxyEggContentInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        GalaxyEggBuyEnergyButton.addTarget(self, action: #selector(GalaxyEggHandleBuyEnergy), for: .touchUpInside)

        GalaxyEggEnergyContainer.addSubview(GalaxyEggEnergyInfoStack)
        GalaxyEggEnergyContainer.addSubview(GalaxyEggBuyEnergyButton)

        GalaxyEggCurrencyLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggCurrencyLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .bold)
        GalaxyEggCurrencyLabel.textColor = UIColor(red: 255/255, green: 220/255, blue: 159/255, alpha: 1)
        GalaxyEggCurrencyLabel.textAlignment = .right

        GalaxyEggTopBarStack.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggTopBarStack.axis = .horizontal
        GalaxyEggTopBarStack.spacing = 20
        GalaxyEggTopBarStack.alignment = .center
        view.addSubview(GalaxyEggTopBarStack)

        GalaxyEggTopBarStack.addArrangedSubview(GalaxyEggCurrencyLabel)
        GalaxyEggTopBarStack.addArrangedSubview(GalaxyEggEnergyContainer)

        NSLayoutConstraint.activate([
            GalaxyEggEnergyInfoStack.topAnchor.constraint(equalTo: GalaxyEggEnergyContainer.topAnchor),
            GalaxyEggEnergyInfoStack.leadingAnchor.constraint(equalTo: GalaxyEggEnergyContainer.leadingAnchor),
            GalaxyEggEnergyInfoStack.bottomAnchor.constraint(equalTo: GalaxyEggEnergyContainer.bottomAnchor),

            GalaxyEggBuyEnergyButton.leadingAnchor.constraint(equalTo: GalaxyEggEnergyInfoStack.trailingAnchor, constant: 8),
            GalaxyEggBuyEnergyButton.centerYAnchor.constraint(equalTo: GalaxyEggEnergyContainer.centerYAnchor),
            GalaxyEggBuyEnergyButton.trailingAnchor.constraint(equalTo: GalaxyEggEnergyContainer.trailingAnchor),
            GalaxyEggBuyEnergyButton.heightAnchor.constraint(equalToConstant: 28),
            GalaxyEggBuyEnergyButton.widthAnchor.constraint(equalToConstant: 32)
        ])
        
        GalaxyEggReelStack.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggReelStack.axis = .horizontal
        GalaxyEggReelStack.spacing = 24
        GalaxyEggReelStack.distribution = .fillEqually
        view.addSubview(GalaxyEggReelStack)
        
        GalaxyEggReelStack.addArrangedSubview(GalaxyEggPlanetReel)
        GalaxyEggReelStack.addArrangedSubview(GalaxyEggEventReel)
        GalaxyEggReelStack.addArrangedSubview(GalaxyEggCivilizationReel)
        
        GalaxyEggSpinButton.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggSpinButton.GalaxyEggSetTitle("Pull Cosmic Lever")
        GalaxyEggSpinButton.addTarget(self, action: #selector(GalaxyEggHandleSpin), for: .touchUpInside)
        view.addSubview(GalaxyEggSpinButton)
        
        GalaxyEggResultCard.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggResultCard.backgroundColor = UIColor(white: 1, alpha: 0.08)
        GalaxyEggResultCard.layer.cornerRadius = 24
        GalaxyEggResultCard.layer.borderWidth = 1.2
        GalaxyEggResultCard.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        view.addSubview(GalaxyEggResultCard)
        GalaxyEggResultCard.isUserInteractionEnabled = false
        
        GalaxyEggResultTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggResultDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggResultTagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        GalaxyEggResultTitleLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        GalaxyEggResultTitleLabel.textColor = .white
        GalaxyEggResultTitleLabel.numberOfLines = 1
        
        GalaxyEggResultDetailLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        GalaxyEggResultDetailLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        GalaxyEggResultDetailLabel.numberOfLines = 0
        GalaxyEggResultDetailLabel.adjustsFontSizeToFitWidth = true
        GalaxyEggResultDetailLabel.minimumScaleFactor = 0.6
        GalaxyEggResultDetailLabel.lineBreakMode = .byTruncatingTail
        
        GalaxyEggResultTagLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .bold)
        GalaxyEggResultTagLabel.textColor = UIColor(red: 150/255, green: 215/255, blue: 255/255, alpha: 1)
        GalaxyEggResultTagLabel.adjustsFontSizeToFitWidth = true
        GalaxyEggResultTagLabel.minimumScaleFactor = 0.7
        
        GalaxyEggResultCard.addSubview(GalaxyEggResultTitleLabel)
        GalaxyEggResultCard.addSubview(GalaxyEggResultDetailLabel)
        GalaxyEggResultCard.addSubview(GalaxyEggResultTagLabel)
        
        let GalaxyEggIsRegularWidth = traitCollection.horizontalSizeClass == .regular
        let GalaxyEggSpacingScale = GalaxyEggAdaptiveLayoutGuide.GalaxyEggSpacingScale(for: traitCollection)
        let GalaxyEggScreenHeight = view.bounds.height
        let GalaxyEggReelHeightMultiplier: CGFloat
        let GalaxyEggButtonWidthMultiplier: CGFloat
        let GalaxyEggButtonTopSpacing: CGFloat
        let GalaxyEggReelSpacing: CGFloat

        if GalaxyEggIsRegularWidth {
            // iPad layout - more generous spacing
            GalaxyEggReelHeightMultiplier = 0.30
            GalaxyEggButtonWidthMultiplier = 0.25
            GalaxyEggButtonTopSpacing = 28 * GalaxyEggSpacingScale
            GalaxyEggReelSpacing = 28 * GalaxyEggSpacingScale
        } else {
            // iPhone layout - optimized for limited height
            if GalaxyEggScreenHeight <= 414 {
                // Smaller iPhones (SE, 8, etc)
                GalaxyEggReelHeightMultiplier = 0.35
                GalaxyEggButtonWidthMultiplier = 0.38
                GalaxyEggButtonTopSpacing = 16
                GalaxyEggReelSpacing = 18
            } else {
                // Larger iPhones
                GalaxyEggReelHeightMultiplier = 0.32
                GalaxyEggButtonWidthMultiplier = 0.35
                GalaxyEggButtonTopSpacing = 20
                GalaxyEggReelSpacing = 22
            }
        }

        GalaxyEggReelStack.spacing = GalaxyEggReelSpacing

        NSLayoutConstraint.activate([
            GalaxyEggBackButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            GalaxyEggBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            GalaxyEggBackButton.heightAnchor.constraint(equalToConstant: 44),

            GalaxyEggTopBarStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            GalaxyEggTopBarStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            GalaxyEggTopBarStack.leadingAnchor.constraint(greaterThanOrEqualTo: GalaxyEggBackButton.trailingAnchor, constant: 16),
            GalaxyEggTopBarStack.widthAnchor.constraint(lessThanOrEqualToConstant: 400),

            GalaxyEggReelStack.topAnchor.constraint(equalTo: GalaxyEggTopBarStack.bottomAnchor, constant: 20),
            GalaxyEggReelStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            GalaxyEggReelStack.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: GalaxyEggReelHeightMultiplier),
            GalaxyEggReelStack.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: GalaxyEggAdaptiveLayoutGuide.GalaxyEggContentWidthRatio(for: traitCollection)),

            GalaxyEggSpinButton.topAnchor.constraint(equalTo: GalaxyEggReelStack.bottomAnchor, constant: GalaxyEggButtonTopSpacing),
            GalaxyEggSpinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            GalaxyEggSpinButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: GalaxyEggButtonWidthMultiplier),
            GalaxyEggSpinButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),

            GalaxyEggResultCard.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            GalaxyEggResultCard.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            GalaxyEggResultCard.topAnchor.constraint(equalTo: GalaxyEggSpinButton.bottomAnchor, constant: 16),
            GalaxyEggResultCard.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            GalaxyEggResultTitleLabel.topAnchor.constraint(equalTo: GalaxyEggResultCard.topAnchor, constant: 16),
            GalaxyEggResultTitleLabel.leadingAnchor.constraint(equalTo: GalaxyEggResultCard.leadingAnchor, constant: 16),
            GalaxyEggResultTitleLabel.trailingAnchor.constraint(equalTo: GalaxyEggResultCard.trailingAnchor, constant: -16),

            GalaxyEggResultDetailLabel.topAnchor.constraint(equalTo: GalaxyEggResultTitleLabel.bottomAnchor, constant: 8),
            GalaxyEggResultDetailLabel.leadingAnchor.constraint(equalTo: GalaxyEggResultCard.leadingAnchor, constant: 16),
            GalaxyEggResultDetailLabel.trailingAnchor.constraint(equalTo: GalaxyEggResultCard.trailingAnchor, constant: -16),

            GalaxyEggResultTagLabel.topAnchor.constraint(equalTo: GalaxyEggResultDetailLabel.bottomAnchor, constant: 12),
            GalaxyEggResultTagLabel.leadingAnchor.constraint(equalTo: GalaxyEggResultCard.leadingAnchor, constant: 16),
            GalaxyEggResultTagLabel.trailingAnchor.constraint(lessThanOrEqualTo: GalaxyEggResultCard.trailingAnchor, constant: -16),
            GalaxyEggResultTagLabel.bottomAnchor.constraint(equalTo: GalaxyEggResultCard.bottomAnchor, constant: -16)
        ])
        
        view.bringSubviewToFront(GalaxyEggSpinButton)
    }
    
    private func GalaxyEggConfigureContent() {
        let GalaxyEggFontScale = GalaxyEggAdaptiveLayoutGuide.GalaxyEggFontScale(for: traitCollection)

        GalaxyEggPlanetReel.GalaxyEggConfigureItems(Array(GalaxyEggPlanetSymbols.values), title: "PLANET REEL")
        GalaxyEggEventReel.GalaxyEggConfigureItems(Array(GalaxyEggEventSymbols.values), title: "EVENT REEL")
        GalaxyEggCivilizationReel.GalaxyEggConfigureItems(Array(GalaxyEggCivilizationSymbols.values), title: "CIVILIZATION REEL")

        GalaxyEggEnergyLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 18 * GalaxyEggFontScale, weight: .bold)
        GalaxyEggCurrencyLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 18 * GalaxyEggFontScale, weight: .bold)

        GalaxyEggResultTitleLabel.font = UIFont.systemFont(ofSize: 22 * GalaxyEggFontScale, weight: .heavy)
        GalaxyEggResultDetailLabel.font = UIFont.systemFont(ofSize: 15 * GalaxyEggFontScale, weight: .medium)
        GalaxyEggResultTagLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14 * GalaxyEggFontScale, weight: .bold)

        GalaxyEggPrimeResultState()

        GalaxyEggResultOverlay.GalaxyEggPrimaryAction = { [weak self] in
            self?.GalaxyEggSpinButton.isEnabled = true
            self?.GalaxyEggIsSpinning = false
        }

        GalaxyEggResultOverlay.GalaxyEggSecondaryAction = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    private func GalaxyEggPrimeResultState() {
        GalaxyEggResultTitleLabel.text = "Awaiting Cosmic Discovery"
        GalaxyEggResultDetailLabel.text = "Pull the lever to generate a new celestial combination. Each discovery can unlock entries in your Galaxy Encyclopedia."
        GalaxyEggResultTagLabel.text = "Tip: Energy is consumed per spin. Discoveries replenish star coins."
    }
    
    private func GalaxyEggUpdateStatusLabels() {
        GalaxyEggEnergyLabel.text = "Energy ⚡️ \(GalaxyEggEngine.GalaxyEggCurrentEnergy())"
        GalaxyEggCurrencyLabel.text = "Star Coins 💰 \(GalaxyEggEngine.GalaxyEggCurrentCurrency())"
        GalaxyEggSpinButton.isEnabled = GalaxyEggEngine.GalaxyEggCurrentEnergy() > 0 && !GalaxyEggIsSpinning
        GalaxyEggSpinButton.alpha = GalaxyEggSpinButton.isEnabled ? 1.0 : 0.5

        // Force layout update to ensure timer label is visible
        GalaxyEggEnergyInfoStack.setNeedsLayout()
        GalaxyEggEnergyInfoStack.layoutIfNeeded()
    }
    
    @objc private func GalaxyEggHandleBack() {
        dismiss(animated: true)
    }
    
    @objc private func GalaxyEggHandleSpin() {
        guard !GalaxyEggIsSpinning else { return }
        guard GalaxyEggEngine.GalaxyEggCurrentEnergy() > 0 else {
            GalaxyEggResultOverlay.GalaxyEggConfigure(with: GalaxyEggSpinOutcomeModel(
                GalaxyEggPlanet: "Energy Low",
                GalaxyEggEvent: "",
                GalaxyEggCivilization: "",
                GalaxyEggResultElement: GalaxyEggSpaceElementModel(
                    GalaxyEggIdentifier: "no_energy",
                    GalaxyEggDisplayName: "Reactor Offline",
                    GalaxyEggDetail: "Recharge in settings to continue forging the stars.",
                    GalaxyEggSymbol: "🪫"
                ),
                GalaxyEggIsNewDiscovery: false,
                GalaxyEggReward: 0
            ))
            GalaxyEggResultOverlay.GalaxyEggUpdateCTA(primary: "Close", secondary: "Settings")
            GalaxyEggResultOverlay.GalaxyEggPrimaryAction = { [weak self] in
                self?.GalaxyEggIsSpinning = false
            }
            GalaxyEggResultOverlay.GalaxyEggSecondaryAction = { [weak self] in
                self?.GalaxyEggIsSpinning = false
                self?.dismiss(animated: true)
            }
            GalaxyEggResultOverlay.GalaxyEggPresent(in: view)
            return
        }
        
        GalaxyEggIsSpinning = true
        GalaxyEggSpinButton.isEnabled = false
        
        let GalaxyEggOutcome = GalaxyEggEngine.GalaxyEggPerformSpin()
        GalaxyEggAnimateReels(with: GalaxyEggOutcome)
        GalaxyEggUpdateStatusLabels()
    }
    
    private func GalaxyEggAnimateReels(with GalaxyEggOutcome: GalaxyEggSpinOutcomeModel) {
        let GalaxyEggPlanetSymbol = GalaxyEggPlanetSymbols[GalaxyEggOutcome.GalaxyEggPlanet] ?? "✨"
        let GalaxyEggEventSymbol = GalaxyEggEventSymbols[GalaxyEggOutcome.GalaxyEggEvent] ?? "✨"
        let GalaxyEggCivilizationSymbol = GalaxyEggCivilizationSymbols[GalaxyEggOutcome.GalaxyEggCivilization] ?? "✨"
        
        GalaxyEggPlanetReel.GalaxyEggStartSpin(duration: 1.6, finalSymbol: GalaxyEggPlanetSymbol)
        GalaxyEggEventReel.GalaxyEggStartSpin(duration: 1.9, finalSymbol: GalaxyEggEventSymbol)
        GalaxyEggCivilizationReel.GalaxyEggStartSpin(duration: 2.2, finalSymbol: GalaxyEggCivilizationSymbol) { [weak self] in
            self?.GalaxyEggHandleOutcomeDisplay(GalaxyEggOutcome)
        }
    }
    
    private func GalaxyEggHandleOutcomeDisplay(_ GalaxyEggOutcome: GalaxyEggSpinOutcomeModel) {
        GalaxyEggResultTitleLabel.text = GalaxyEggOutcome.GalaxyEggResultElement.GalaxyEggDisplayName
        GalaxyEggResultDetailLabel.text = GalaxyEggOutcome.GalaxyEggResultElement.GalaxyEggDetail
        GalaxyEggResultTagLabel.text = "Reward +\(GalaxyEggOutcome.GalaxyEggReward) • \(GalaxyEggOutcome.GalaxyEggIsNewDiscovery ? "New Entry Logged" : "Data Stream Updated")"
        
        GalaxyEggResultOverlay.GalaxyEggConfigure(with: GalaxyEggOutcome)
        GalaxyEggResultOverlay.GalaxyEggUpdateCTA(primary: "Spin Again", secondary: "Return Home")
        GalaxyEggResultOverlay.GalaxyEggPrimaryAction = { [weak self] in
            self?.GalaxyEggIsSpinning = false
            self?.GalaxyEggSpinButton.isEnabled = true
            self?.GalaxyEggUpdateStatusLabels()
        }
        GalaxyEggResultOverlay.GalaxyEggSecondaryAction = { [weak self] in
            self?.GalaxyEggIsSpinning = false
            self?.dismiss(animated: true)
        }
        GalaxyEggResultOverlay.GalaxyEggPresent(in: view)
    }

    @objc private func GalaxyEggHandleBuyEnergy() {
        let GalaxyEggPrice = GalaxyEggSpinEngine.GalaxyEggEnergyPurchasePrice
        let GalaxyEggCurrentCoins = GalaxyEggEngine.GalaxyEggCurrentCurrency()
        let GalaxyEggCurrentEnergy = GalaxyEggEngine.GalaxyEggCurrentEnergy()

        // Check if already at max energy
        if GalaxyEggCurrentEnergy >= GalaxyEggSpinEngine.GalaxyEggMaxEnergy {
            GalaxyEggShowAlert(title: "Energy Full", message: "Your energy is already at maximum capacity (\(GalaxyEggSpinEngine.GalaxyEggMaxEnergy)).")
            return
        }

        // Check if enough coins
        if GalaxyEggCurrentCoins < GalaxyEggPrice {
            GalaxyEggShowAlert(title: "Insufficient Coins", message: "You need \(GalaxyEggPrice) Star Coins to purchase 1 energy. Play Bonus Slots to earn more coins!")
            return
        }

        // Show confirmation dialog
        GalaxyEggShowConfirmation(
            title: "Purchase Energy?",
            message: "Spend \(GalaxyEggPrice) Star Coins to gain 1 energy point?",
            confirmText: "Buy",
            cancelText: "Cancel"
        ) { [weak self] in
            guard let self = self else { return }
            if self.GalaxyEggEngine.GalaxyEggPurchaseEnergy() {
                self.GalaxyEggUpdateStatusLabels()
                self.GalaxyEggUpdateEnergyTimer()

                let GalaxyEggImpact = UINotificationFeedbackGenerator()
                GalaxyEggImpact.notificationOccurred(.success)

                self.GalaxyEggShowAlert(title: "Purchase Successful", message: "Energy +1")
            } else {
                self.GalaxyEggShowAlert(title: "Purchase Failed", message: "Unable to complete purchase.")
            }
        }
    }

    private func GalaxyEggShowAlert(title: String, message: String) {
        let GalaxyEggOverlay = UIView(frame: view.bounds)
        GalaxyEggOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        GalaxyEggOverlay.alpha = 0

        let GalaxyEggCard = UIView()
        GalaxyEggCard.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggCard.backgroundColor = UIColor(white: 1, alpha: 0.1)
        GalaxyEggCard.layer.cornerRadius = 24
        GalaxyEggCard.layer.borderWidth = 1.5
        GalaxyEggCard.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor

        let GalaxyEggTitleLabel = UILabel()
        GalaxyEggTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggTitleLabel.text = title
        GalaxyEggTitleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        GalaxyEggTitleLabel.textColor = .white
        GalaxyEggTitleLabel.textAlignment = .center

        let GalaxyEggMessageLabel = UILabel()
        GalaxyEggMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggMessageLabel.text = message
        GalaxyEggMessageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        GalaxyEggMessageLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        GalaxyEggMessageLabel.numberOfLines = 0
        GalaxyEggMessageLabel.textAlignment = .center

        let GalaxyEggOkButton = GalaxyEggButtonView()
        GalaxyEggOkButton.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggOkButton.GalaxyEggSetTitle("OK")

        GalaxyEggOkButton.addAction(UIAction { _ in
            UIView.animate(withDuration: 0.2) {
                GalaxyEggOverlay.alpha = 0
            } completion: { _ in
                GalaxyEggOverlay.removeFromSuperview()
            }
        }, for: .touchUpInside)

        GalaxyEggCard.addSubview(GalaxyEggTitleLabel)
        GalaxyEggCard.addSubview(GalaxyEggMessageLabel)
        GalaxyEggCard.addSubview(GalaxyEggOkButton)
        GalaxyEggOverlay.addSubview(GalaxyEggCard)
        view.addSubview(GalaxyEggOverlay)

        NSLayoutConstraint.activate([
            GalaxyEggCard.centerXAnchor.constraint(equalTo: GalaxyEggOverlay.centerXAnchor),
            GalaxyEggCard.centerYAnchor.constraint(equalTo: GalaxyEggOverlay.centerYAnchor),
            GalaxyEggCard.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),

            GalaxyEggTitleLabel.topAnchor.constraint(equalTo: GalaxyEggCard.topAnchor, constant: 24),
            GalaxyEggTitleLabel.leadingAnchor.constraint(equalTo: GalaxyEggCard.leadingAnchor, constant: 24),
            GalaxyEggTitleLabel.trailingAnchor.constraint(equalTo: GalaxyEggCard.trailingAnchor, constant: -24),

            GalaxyEggMessageLabel.topAnchor.constraint(equalTo: GalaxyEggTitleLabel.bottomAnchor, constant: 16),
            GalaxyEggMessageLabel.leadingAnchor.constraint(equalTo: GalaxyEggCard.leadingAnchor, constant: 24),
            GalaxyEggMessageLabel.trailingAnchor.constraint(equalTo: GalaxyEggCard.trailingAnchor, constant: -24),

            GalaxyEggOkButton.topAnchor.constraint(equalTo: GalaxyEggMessageLabel.bottomAnchor, constant: 24),
            GalaxyEggOkButton.centerXAnchor.constraint(equalTo: GalaxyEggCard.centerXAnchor),
            GalaxyEggOkButton.widthAnchor.constraint(equalToConstant: 120),
            GalaxyEggOkButton.bottomAnchor.constraint(equalTo: GalaxyEggCard.bottomAnchor, constant: -24)
        ])

        UIView.animate(withDuration: 0.3) {
            GalaxyEggOverlay.alpha = 1
        }
    }

    private func GalaxyEggShowConfirmation(title: String, message: String, confirmText: String, cancelText: String, onConfirm: @escaping () -> Void) {
        let GalaxyEggOverlay = UIView(frame: view.bounds)
        GalaxyEggOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        GalaxyEggOverlay.alpha = 0

        let GalaxyEggCard = UIView()
        GalaxyEggCard.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggCard.backgroundColor = UIColor(white: 1, alpha: 0.1)
        GalaxyEggCard.layer.cornerRadius = 24
        GalaxyEggCard.layer.borderWidth = 1.5
        GalaxyEggCard.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor

        let GalaxyEggTitleLabel = UILabel()
        GalaxyEggTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggTitleLabel.text = title
        GalaxyEggTitleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        GalaxyEggTitleLabel.textColor = .white
        GalaxyEggTitleLabel.textAlignment = .center

        let GalaxyEggMessageLabel = UILabel()
        GalaxyEggMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggMessageLabel.text = message
        GalaxyEggMessageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        GalaxyEggMessageLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        GalaxyEggMessageLabel.numberOfLines = 0
        GalaxyEggMessageLabel.textAlignment = .center

        let GalaxyEggButtonStack = UIStackView()
        GalaxyEggButtonStack.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggButtonStack.axis = .horizontal
        GalaxyEggButtonStack.spacing = 16
        GalaxyEggButtonStack.distribution = .fillEqually

        let GalaxyEggCancelButton = GalaxyEggButtonView()
        GalaxyEggCancelButton.GalaxyEggSetTitle(cancelText)
        GalaxyEggCancelButton.addAction(UIAction { _ in
            UIView.animate(withDuration: 0.2) {
                GalaxyEggOverlay.alpha = 0
            } completion: { _ in
                GalaxyEggOverlay.removeFromSuperview()
            }
        }, for: .touchUpInside)

        let GalaxyEggConfirmButton = GalaxyEggButtonView()
        GalaxyEggConfirmButton.GalaxyEggSetTitle(confirmText)
        GalaxyEggConfirmButton.addAction(UIAction { _ in
            UIView.animate(withDuration: 0.2) {
                GalaxyEggOverlay.alpha = 0
            } completion: { _ in
                GalaxyEggOverlay.removeFromSuperview()
                onConfirm()
            }
        }, for: .touchUpInside)

        GalaxyEggButtonStack.addArrangedSubview(GalaxyEggCancelButton)
        GalaxyEggButtonStack.addArrangedSubview(GalaxyEggConfirmButton)

        GalaxyEggCard.addSubview(GalaxyEggTitleLabel)
        GalaxyEggCard.addSubview(GalaxyEggMessageLabel)
        GalaxyEggCard.addSubview(GalaxyEggButtonStack)
        GalaxyEggOverlay.addSubview(GalaxyEggCard)
        view.addSubview(GalaxyEggOverlay)

        NSLayoutConstraint.activate([
            GalaxyEggCard.centerXAnchor.constraint(equalTo: GalaxyEggOverlay.centerXAnchor),
            GalaxyEggCard.centerYAnchor.constraint(equalTo: GalaxyEggOverlay.centerYAnchor),
            GalaxyEggCard.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),

            GalaxyEggTitleLabel.topAnchor.constraint(equalTo: GalaxyEggCard.topAnchor, constant: 24),
            GalaxyEggTitleLabel.leadingAnchor.constraint(equalTo: GalaxyEggCard.leadingAnchor, constant: 24),
            GalaxyEggTitleLabel.trailingAnchor.constraint(equalTo: GalaxyEggCard.trailingAnchor, constant: -24),

            GalaxyEggMessageLabel.topAnchor.constraint(equalTo: GalaxyEggTitleLabel.bottomAnchor, constant: 16),
            GalaxyEggMessageLabel.leadingAnchor.constraint(equalTo: GalaxyEggCard.leadingAnchor, constant: 24),
            GalaxyEggMessageLabel.trailingAnchor.constraint(equalTo: GalaxyEggCard.trailingAnchor, constant: -24),

            GalaxyEggButtonStack.topAnchor.constraint(equalTo: GalaxyEggMessageLabel.bottomAnchor, constant: 24),
            GalaxyEggButtonStack.leadingAnchor.constraint(equalTo: GalaxyEggCard.leadingAnchor, constant: 24),
            GalaxyEggButtonStack.trailingAnchor.constraint(equalTo: GalaxyEggCard.trailingAnchor, constant: -24),
            GalaxyEggButtonStack.bottomAnchor.constraint(equalTo: GalaxyEggCard.bottomAnchor, constant: -24)
        ])

        UIView.animate(withDuration: 0.3) {
            GalaxyEggOverlay.alpha = 1
        }
    }
}
