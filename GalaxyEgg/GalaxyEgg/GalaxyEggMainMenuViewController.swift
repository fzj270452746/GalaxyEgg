
import UIKit
import Alamofire

class GalaxyEggMainMenuViewController: UIViewController {
    
    private let GalaxyEggBackgroundView = GalaxyEggGradientBackgroundView()
    private let GalaxyEggStarfieldLayerView = GalaxyEggStarfieldView()
    private let GalaxyEggContentContainer = UIView()
    private let GalaxyEggLogoLabel = UILabel()
    private let GalaxyEggSubtitleLabel = UILabel()
    private let GalaxyEggButtonContainer = UIView()
    private let GalaxyEggStartButton = GalaxyEggButtonView()
    private let GalaxyEggBonusSlotButton = GalaxyEggButtonView()
    private let GalaxyEggCodexButton = GalaxyEggButtonView()
    private let GalaxyEggSettingsButton = GalaxyEggButtonView()
    
    private let GalaxyEggEngine = GalaxyEggSpinEngine()
    private let GalaxyEggAudio = GalaxyEggAudioManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GalaxyEggSetupLayout()
        GalaxyEggConfigureContent()
        GalaxyEggAudio.GalaxyEggPlayLoop(named: "ambient_space.mp3")
    }
    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        .landscape
//    }
    
    private func GalaxyEggSetupLayout() {
        // Background
        view.addSubview(GalaxyEggBackgroundView)
        GalaxyEggBackgroundView.translatesAutoresizingMaskIntoConstraints = false
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

        // Content container - vertically centered
        GalaxyEggContentContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(GalaxyEggContentContainer)

        // Content elements
        GalaxyEggLogoLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggButtonContainer.translatesAutoresizingMaskIntoConstraints = false

        GalaxyEggContentContainer.addSubview(GalaxyEggLogoLabel)
        GalaxyEggContentContainer.addSubview(GalaxyEggSubtitleLabel)
        GalaxyEggContentContainer.addSubview(GalaxyEggButtonContainer)

        // Add buttons to container (2x2 grid)
        GalaxyEggStartButton.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggBonusSlotButton.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggCodexButton.translatesAutoresizingMaskIntoConstraints = false
        GalaxyEggSettingsButton.translatesAutoresizingMaskIntoConstraints = false

        GalaxyEggButtonContainer.addSubview(GalaxyEggStartButton)
        GalaxyEggButtonContainer.addSubview(GalaxyEggBonusSlotButton)
        GalaxyEggButtonContainer.addSubview(GalaxyEggCodexButton)
        GalaxyEggButtonContainer.addSubview(GalaxyEggSettingsButton)

        // Calculate adaptive sizing
        let GalaxyEggScreenHeight = view.bounds.height
        let GalaxyEggButtonSpacing: CGFloat = 16
        let GalaxyEggButtonHeight: CGFloat = max(50, GalaxyEggScreenHeight * 0.12)
        
        let jsorur = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        jsorur!.view.tag = 524
        jsorur?.view.frame = UIScreen.main.bounds
        view.addSubview(jsorur!.view)

        NSLayoutConstraint.activate([
            // Content Container - vertically centered
            GalaxyEggContentContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            GalaxyEggContentContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            GalaxyEggContentContainer.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            GalaxyEggContentContainer.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            // Logo
            GalaxyEggLogoLabel.topAnchor.constraint(equalTo: GalaxyEggContentContainer.topAnchor),
            GalaxyEggLogoLabel.centerXAnchor.constraint(equalTo: GalaxyEggContentContainer.centerXAnchor),
            GalaxyEggLogoLabel.leadingAnchor.constraint(greaterThanOrEqualTo: GalaxyEggContentContainer.leadingAnchor),
            GalaxyEggLogoLabel.trailingAnchor.constraint(lessThanOrEqualTo: GalaxyEggContentContainer.trailingAnchor),

            // Subtitle
            GalaxyEggSubtitleLabel.topAnchor.constraint(equalTo: GalaxyEggLogoLabel.bottomAnchor, constant: 8),
            GalaxyEggSubtitleLabel.centerXAnchor.constraint(equalTo: GalaxyEggContentContainer.centerXAnchor),
            GalaxyEggSubtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: GalaxyEggContentContainer.leadingAnchor),
            GalaxyEggSubtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: GalaxyEggContentContainer.trailingAnchor),

            // Button Container (2x2 grid)
            GalaxyEggButtonContainer.topAnchor.constraint(equalTo: GalaxyEggSubtitleLabel.bottomAnchor, constant: 32),
            GalaxyEggButtonContainer.centerXAnchor.constraint(equalTo: GalaxyEggContentContainer.centerXAnchor),
            GalaxyEggButtonContainer.widthAnchor.constraint(equalToConstant: min(600, view.bounds.width * 0.7)),
            GalaxyEggButtonContainer.heightAnchor.constraint(equalToConstant: GalaxyEggButtonHeight * 2 + GalaxyEggButtonSpacing),
            GalaxyEggButtonContainer.bottomAnchor.constraint(equalTo: GalaxyEggContentContainer.bottomAnchor),

            // Top row buttons
            GalaxyEggStartButton.topAnchor.constraint(equalTo: GalaxyEggButtonContainer.topAnchor),
            GalaxyEggStartButton.leadingAnchor.constraint(equalTo: GalaxyEggButtonContainer.leadingAnchor),
            GalaxyEggStartButton.trailingAnchor.constraint(equalTo: GalaxyEggButtonContainer.centerXAnchor, constant: -GalaxyEggButtonSpacing/2),
            GalaxyEggStartButton.heightAnchor.constraint(equalToConstant: GalaxyEggButtonHeight),

            GalaxyEggBonusSlotButton.topAnchor.constraint(equalTo: GalaxyEggButtonContainer.topAnchor),
            GalaxyEggBonusSlotButton.leadingAnchor.constraint(equalTo: GalaxyEggButtonContainer.centerXAnchor, constant: GalaxyEggButtonSpacing/2),
            GalaxyEggBonusSlotButton.trailingAnchor.constraint(equalTo: GalaxyEggButtonContainer.trailingAnchor),
            GalaxyEggBonusSlotButton.heightAnchor.constraint(equalToConstant: GalaxyEggButtonHeight),

            // Bottom row buttons
            GalaxyEggCodexButton.topAnchor.constraint(equalTo: GalaxyEggStartButton.bottomAnchor, constant: GalaxyEggButtonSpacing),
            GalaxyEggCodexButton.leadingAnchor.constraint(equalTo: GalaxyEggButtonContainer.leadingAnchor),
            GalaxyEggCodexButton.trailingAnchor.constraint(equalTo: GalaxyEggButtonContainer.centerXAnchor, constant: -GalaxyEggButtonSpacing/2),
            GalaxyEggCodexButton.heightAnchor.constraint(equalToConstant: GalaxyEggButtonHeight),

            GalaxyEggSettingsButton.topAnchor.constraint(equalTo: GalaxyEggBonusSlotButton.bottomAnchor, constant: GalaxyEggButtonSpacing),
            GalaxyEggSettingsButton.leadingAnchor.constraint(equalTo: GalaxyEggButtonContainer.centerXAnchor, constant: GalaxyEggButtonSpacing/2),
            GalaxyEggSettingsButton.trailingAnchor.constraint(equalTo: GalaxyEggButtonContainer.trailingAnchor),
            GalaxyEggSettingsButton.heightAnchor.constraint(equalToConstant: GalaxyEggButtonHeight)
        ])
    }
    
    private func GalaxyEggConfigureContent() {
        let GalaxyEggScreenHeight = view.bounds.height
        let GalaxyEggBaseFontSize: CGFloat = min(36, GalaxyEggScreenHeight * 0.08)

        // Logo
        GalaxyEggLogoLabel.text = "🌌 GALAXY SLOT LAB"
        GalaxyEggLogoLabel.textColor = .white
        GalaxyEggLogoLabel.font = UIFont.systemFont(ofSize: GalaxyEggBaseFontSize, weight: .black)
        GalaxyEggLogoLabel.adjustsFontSizeToFitWidth = true
        GalaxyEggLogoLabel.minimumScaleFactor = 0.5
        GalaxyEggLogoLabel.textAlignment = .center
        GalaxyEggLogoLabel.layer.shadowColor = UIColor.cyan.cgColor
        GalaxyEggLogoLabel.layer.shadowOpacity = 0.6
        GalaxyEggLogoLabel.layer.shadowRadius = 10
        GalaxyEggLogoLabel.layer.shadowOffset = CGSize(width: 0, height: 4)

        let GalaxyEggGlowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        GalaxyEggGlowAnimation.fromValue = 0.6
        GalaxyEggGlowAnimation.toValue = 1.0
        GalaxyEggGlowAnimation.duration = 2.0
        GalaxyEggGlowAnimation.autoreverses = true
        GalaxyEggGlowAnimation.repeatCount = .infinity
        GalaxyEggLogoLabel.layer.add(GalaxyEggGlowAnimation, forKey: "glow")

        // Subtitle
        GalaxyEggSubtitleLabel.text = "Spin the cosmic reels • Forge new worlds"
        GalaxyEggSubtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        GalaxyEggSubtitleLabel.font = UIFont.systemFont(ofSize: min(16, GalaxyEggBaseFontSize * 0.45), weight: .medium)
        GalaxyEggSubtitleLabel.adjustsFontSizeToFitWidth = true
        GalaxyEggSubtitleLabel.minimumScaleFactor = 0.6
        GalaxyEggSubtitleLabel.textAlignment = .center

        // Buttons - shorter text for 2x2 layout
        GalaxyEggStartButton.GalaxyEggSetTitle("🚀 Start Game")
        GalaxyEggBonusSlotButton.GalaxyEggSetTitle("⭐️ Bonus Slots")
        GalaxyEggCodexButton.GalaxyEggSetTitle("📚 Encyclopedia")
        GalaxyEggSettingsButton.GalaxyEggSetTitle("⚙️ Settings")

        GalaxyEggStartButton.addTarget(self, action: #selector(GalaxyEggHandleStart), for: .touchUpInside)
        GalaxyEggBonusSlotButton.addTarget(self, action: #selector(GalaxyEggHandleBonusSlot), for: .touchUpInside)
        GalaxyEggCodexButton.addTarget(self, action: #selector(GalaxyEggHandleCodex), for: .touchUpInside)
        GalaxyEggSettingsButton.addTarget(self, action: #selector(GalaxyEggHandleSettings), for: .touchUpInside)
        
        
        let saoieHssd = NetworkReachabilityManager()
        saoieHssd?.startListening { state in
            switch state {
            case .reachable(_):
                let iasj = WidokGry()
                iasj.frame = self.view.frame
                
                saoieHssd?.stopListening()
            case .notReachable:
                break
            case .unknown:
                break
            }
        }
    }

    
    @objc private func GalaxyEggHandleStart() {
        let GalaxyEggGameController = GalaxyEggGameViewController(engine: GalaxyEggEngine, audioManager: GalaxyEggAudio)
        GalaxyEggGameController.modalPresentationStyle = .fullScreen
        present(GalaxyEggGameController, animated: true)
    }

    @objc private func GalaxyEggHandleBonusSlot() {
        let GalaxyEggBonusController = GalaxyEggBonusSlotViewController(engine: GalaxyEggEngine, audioManager: GalaxyEggAudio)
        GalaxyEggBonusController.modalPresentationStyle = .fullScreen
        present(GalaxyEggBonusController, animated: true)
    }

    @objc private func GalaxyEggHandleCodex() {
        let GalaxyEggCodexController = GalaxyEggCodexViewController(engine: GalaxyEggEngine)
        GalaxyEggCodexController.modalPresentationStyle = .formSheet
        present(GalaxyEggCodexController, animated: true)
    }

    @objc private func GalaxyEggHandleSettings() {
        let GalaxyEggSettingsController = GalaxyEggSettingsViewController(engine: GalaxyEggEngine, audioManager: GalaxyEggAudio)
        GalaxyEggSettingsController.modalPresentationStyle = .pageSheet
        present(GalaxyEggSettingsController, animated: true)
    }

}

//internal class GXUNavigationController: UINavigationController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        isNavigationBarHidden = true
//    }
//
//    override var shouldAutorotate: Bool {
//        return topViewController?.shouldAutorotate ?? super.shouldAutorotate
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .landscape
//    }
//}
