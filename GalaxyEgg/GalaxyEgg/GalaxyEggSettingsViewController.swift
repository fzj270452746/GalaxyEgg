//
//  GalaxyEggSettingsViewController.swift
//  GalaxyEgg
//
//  Created by Assistant on 10/10/25.
//

import UIKit

class GalaxyEggSettingsViewController: UIViewController {
    
    private let GalaxyEggEngine: GalaxyEggSpinEngine
    private let GalaxyEggAudio: GalaxyEggAudioManager
    
    private let GalaxyEggBackgroundView = GalaxyEggGradientBackgroundView()
    private let GalaxyEggBackButton = GalaxyEggButtonView()
    private let GalaxyEggTitleLabel = UILabel()
    private let GalaxyEggScrollView = UIScrollView()
    private let GalaxyEggContentView = UIView()
    private let GalaxyEggStackView = UIStackView()
    private let GalaxyEggSoundLabel = UILabel()
    private let GalaxyEggSoundSwitch = UISwitch()
    private let GalaxyEggResetButton = GalaxyEggButtonView()
    private let GalaxyEggMuteStatusLabel = UILabel()
    private var GalaxyEggConfirmationView: UIView?
    
    init(engine GalaxyEggEngine: GalaxyEggSpinEngine, audioManager GalaxyEggAudio: GalaxyEggAudioManager) {
        self.GalaxyEggEngine = GalaxyEggEngine
        self.GalaxyEggAudio = GalaxyEggAudio
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GalaxyEggConfigureLayout()
        GalaxyEggConfigureContent()
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

        GalaxyEggBackButton.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggBackButton.GalaxyEggSetTitle("◀︎ Back")
        GalaxyEggBackButton.GalaxyEggContentInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        GalaxyEggBackButton.addTarget(self, action: #selector(GalaxyEggHandleClose), for: .touchUpInside)
        view.addSubview(GalaxyEggBackButton)

        GalaxyEggTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggTitleLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        GalaxyEggTitleLabel.textColor = .white
        view.addSubview(GalaxyEggTitleLabel)

        // ScrollView setup
        GalaxyEggScrollView.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggScrollView.showsVerticalScrollIndicator = true
        GalaxyEggScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(GalaxyEggScrollView)

        GalaxyEggContentView.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggScrollView.addSubview(GalaxyEggContentView)

        GalaxyEggStackView.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggStackView.axis = .vertical
        GalaxyEggStackView.alignment = .fill
        GalaxyEggStackView.spacing = 20
        GalaxyEggContentView.addSubview(GalaxyEggStackView)

        // Settings section
        let GalaxyEggSettingsSection = GalaxyEggCreateSection(title: "⚙️ Settings")

        let GalaxyEggSoundRow = UIStackView(arrangedSubviews: [GalaxyEggSoundLabel, GalaxyEggSoundSwitch])
        GalaxyEggSoundRow.axis = .horizontal
        GalaxyEggSoundRow.alignment = .center
        GalaxyEggSoundRow.spacing = 12

        GalaxyEggMuteStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggMuteStatusLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        GalaxyEggMuteStatusLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        GalaxyEggMuteStatusLabel.numberOfLines = 0

        GalaxyEggSettingsSection.addArrangedSubview(GalaxyEggSoundRow)
        GalaxyEggSettingsSection.addArrangedSubview(GalaxyEggMuteStatusLabel)
        GalaxyEggSettingsSection.addArrangedSubview(GalaxyEggResetButton)

        // Game info sections
        let GalaxyEggAboutSection = GalaxyEggCreateSection(title: "🎮 About")
        let GalaxyEggAboutText = GalaxyEggCreateTextLabel(text: "Galaxy Slot Lab is a cosmic-themed slot machine game where you explore the universe, discover new planets, and encounter various civilizations. Spin the reels to create unique combinations and build your galactic encyclopedia!")
        GalaxyEggAboutSection.addArrangedSubview(GalaxyEggAboutText)

        let GalaxyEggGameplaySection = GalaxyEggCreateSection(title: "🎯 How to Play")
        let GalaxyEggGameplayText = GalaxyEggCreateTextLabel(text: "• Exploring Slot: Spend 1 energy to spin and discover new combinations\n• Energy System: 25 max energy, auto-recovers 1 per 30 minutes\n• Purchase Energy: Spend 200 coins to instantly gain 1 energy\n• Bonus Slots: Match 3 symbols to win coins (20 free spins daily)\n• Encyclopedia: View all your discovered planets, events, and civilizations")
        GalaxyEggGameplaySection.addArrangedSubview(GalaxyEggGameplayText)

        let GalaxyEggFeaturesSection = GalaxyEggCreateSection(title: "✨ Features")
        let GalaxyEggFeaturesText = GalaxyEggCreateTextLabel(text: "• 10 unique planets with distinct characteristics\n• 4 cosmic events that shape your discoveries\n• 4 civilization types to encounter\n• Adaptive layout for all device sizes\n• Auto-save progress with persistent data\n• Beautiful space-themed animations and effects")
        GalaxyEggFeaturesSection.addArrangedSubview(GalaxyEggFeaturesText)

        GalaxyEggStackView.addArrangedSubview(GalaxyEggSettingsSection)
        GalaxyEggStackView.addArrangedSubview(GalaxyEggAboutSection)
        GalaxyEggStackView.addArrangedSubview(GalaxyEggGameplaySection)
        GalaxyEggStackView.addArrangedSubview(GalaxyEggFeaturesSection)

        NSLayoutConstraint.activate([
            GalaxyEggBackButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            GalaxyEggBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            GalaxyEggBackButton.heightAnchor.constraint(equalToConstant: 44),

            GalaxyEggTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            GalaxyEggTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            GalaxyEggScrollView.topAnchor.constraint(equalTo: GalaxyEggTitleLabel.bottomAnchor, constant: 16),
            GalaxyEggScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            GalaxyEggScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            GalaxyEggScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            GalaxyEggContentView.topAnchor.constraint(equalTo: GalaxyEggScrollView.topAnchor),
            GalaxyEggContentView.leadingAnchor.constraint(equalTo: GalaxyEggScrollView.leadingAnchor),
            GalaxyEggContentView.trailingAnchor.constraint(equalTo: GalaxyEggScrollView.trailingAnchor),
            GalaxyEggContentView.bottomAnchor.constraint(equalTo: GalaxyEggScrollView.bottomAnchor),
            GalaxyEggContentView.widthAnchor.constraint(equalTo: GalaxyEggScrollView.widthAnchor),

            GalaxyEggStackView.topAnchor.constraint(equalTo: GalaxyEggContentView.topAnchor, constant: 16),
            GalaxyEggStackView.leadingAnchor.constraint(equalTo: GalaxyEggContentView.leadingAnchor, constant: 24),
            GalaxyEggStackView.trailingAnchor.constraint(equalTo: GalaxyEggContentView.trailingAnchor, constant: -24),
            GalaxyEggStackView.bottomAnchor.constraint(equalTo: GalaxyEggContentView.bottomAnchor, constant: -24),

            GalaxyEggSoundSwitch.widthAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func GalaxyEggCreateSection(title: String) -> UIStackView {
        let section = UIStackView()
        section.axis = .vertical
        section.spacing = 12
        section.alignment = .fill

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1)

        section.addArrangedSubview(titleLabel)
        return section
    }

    private func GalaxyEggCreateTextLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.85)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }
    
    private func GalaxyEggConfigureContent() {
        GalaxyEggTitleLabel.text = "Control Room"
        GalaxyEggSoundLabel.text = "Audio Output"
        GalaxyEggSoundLabel.textColor = .white
        GalaxyEggSoundLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        GalaxyEggSoundSwitch.onTintColor = UIColor(red: 86/255, green: 212/255, blue: 255/255, alpha: 1)
        GalaxyEggSoundSwitch.isOn = !GalaxyEggAudio.GalaxyEggIsAudioMuted()
        GalaxyEggSoundSwitch.addTarget(self, action: #selector(GalaxyEggHandleSoundToggle), for: .valueChanged)
        
        GalaxyEggMuteStatusLabel.text = GalaxyEggSoundSwitch.isOn ? "Background ambience and slot effects are active." : "Audio muted. Reactivation restores ambience instantly."
        
        GalaxyEggResetButton.GalaxyEggSetTitle("Reset Progress")
        GalaxyEggResetButton.addTarget(self, action: #selector(GalaxyEggHandleReset), for: .touchUpInside)
    }
    
    @objc private func GalaxyEggHandleSoundToggle() {
        GalaxyEggAudio.GalaxyEggToggleMute()
        GalaxyEggMuteStatusLabel.text = GalaxyEggSoundSwitch.isOn ? "Background ambience and slot effects are active." : "Audio muted. Reactivation restores ambience instantly."
    }
    
    @objc private func GalaxyEggHandleReset() {
        GalaxyEggPresentConfirmation()
    }
    
    @objc private func GalaxyEggHandleClose() {
        dismiss(animated: true)
    }
    
    private func GalaxyEggPresentConfirmation() {
        let GalaxyEggOverlay = UIView(frame: view.bounds)
        GalaxyEggOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        GalaxyEggOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        let GalaxyEggCard = UIView()
        GalaxyEggCard.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggCard.backgroundColor = UIColor(white: 1, alpha: 0.1)
        GalaxyEggCard.layer.cornerRadius = 24
        GalaxyEggCard.layer.borderWidth = 1.5
        GalaxyEggCard.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        
        let GalaxyEggMessageLabel = UILabel()
        GalaxyEggMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggMessageLabel.textColor = .white
        GalaxyEggMessageLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        GalaxyEggMessageLabel.numberOfLines = 0
        GalaxyEggMessageLabel.textAlignment = .center
        GalaxyEggMessageLabel.text = "Reset all discoveries and resources?"
        
        let GalaxyEggActionStack = UIStackView()
        GalaxyEggActionStack.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggActionStack.axis = .horizontal
        GalaxyEggActionStack.spacing = 16
        GalaxyEggActionStack.distribution = .fillEqually
        
        let GalaxyEggConfirmButton = GalaxyEggButtonView()
        GalaxyEggConfirmButton.GalaxyEggSetTitle("Confirm")
        let GalaxyEggCancelButton = GalaxyEggButtonView()
        GalaxyEggCancelButton.GalaxyEggSetTitle("Cancel")
        
        GalaxyEggConfirmButton.addTarget(self, action: #selector(GalaxyEggHandleConfirmReset), for: .touchUpInside)
        GalaxyEggCancelButton.addTarget(self, action: #selector(GalaxyEggHandleCancelReset), for: .touchUpInside)
        
        GalaxyEggActionStack.addArrangedSubview(GalaxyEggConfirmButton)
        GalaxyEggActionStack.addArrangedSubview(GalaxyEggCancelButton)
        
        GalaxyEggOverlay.addSubview(GalaxyEggCard)
        GalaxyEggCard.addSubview(GalaxyEggMessageLabel)
        GalaxyEggCard.addSubview(GalaxyEggActionStack)
        view.addSubview(GalaxyEggOverlay)
        
        NSLayoutConstraint.activate([
            GalaxyEggOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            GalaxyEggOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            GalaxyEggOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            GalaxyEggOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            GalaxyEggCard.centerXAnchor.constraint(equalTo: GalaxyEggOverlay.centerXAnchor),
            GalaxyEggCard.centerYAnchor.constraint(equalTo: GalaxyEggOverlay.centerYAnchor),
            GalaxyEggCard.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            GalaxyEggMessageLabel.topAnchor.constraint(equalTo: GalaxyEggCard.topAnchor, constant: 28),
            GalaxyEggMessageLabel.leadingAnchor.constraint(equalTo: GalaxyEggCard.leadingAnchor, constant: 24),
            GalaxyEggMessageLabel.trailingAnchor.constraint(equalTo: GalaxyEggCard.trailingAnchor, constant: -24),
            
            GalaxyEggActionStack.topAnchor.constraint(equalTo: GalaxyEggMessageLabel.bottomAnchor, constant: 24),
            GalaxyEggActionStack.leadingAnchor.constraint(equalTo: GalaxyEggCard.leadingAnchor, constant: 24),
            GalaxyEggActionStack.trailingAnchor.constraint(equalTo: GalaxyEggCard.trailingAnchor, constant: -24),
            GalaxyEggActionStack.bottomAnchor.constraint(equalTo: GalaxyEggCard.bottomAnchor, constant: -24)
        ])
        
        GalaxyEggConfirmationView = GalaxyEggOverlay
    }
    
    @objc private func GalaxyEggHandleConfirmReset() {
        GalaxyEggEngine.GalaxyEggResetProgress()
        GalaxyEggConfirmationView?.removeFromSuperview()
        GalaxyEggConfirmationView = nil
    }
    
    @objc private func GalaxyEggHandleCancelReset() {
        GalaxyEggConfirmationView?.removeFromSuperview()
        GalaxyEggConfirmationView = nil
    }
}
