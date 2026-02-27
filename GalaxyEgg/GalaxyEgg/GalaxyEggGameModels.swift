//
//  GalaxyEggGameModels.swift
//  GalaxyEgg
//
//  Created by Assistant on 10/10/25.
//

import UIKit
import AVFoundation

struct GalaxyEggSpaceElementModel: Hashable {
    let GalaxyEggIdentifier: String
    let GalaxyEggDisplayName: String
    let GalaxyEggDetail: String
    let GalaxyEggSymbol: String
}

struct GalaxyEggSpinOutcomeModel {
    let GalaxyEggPlanet: String
    let GalaxyEggEvent: String
    let GalaxyEggCivilization: String
    let GalaxyEggResultElement: GalaxyEggSpaceElementModel
    let GalaxyEggIsNewDiscovery: Bool
    let GalaxyEggReward: Int
}

struct GalaxyEggBonusSpinOutcome {
    let GalaxyEggSymbol1: String
    let GalaxyEggSymbol2: String
    let GalaxyEggSymbol3: String
    let GalaxyEggIsWin: Bool
    let GalaxyEggReward: Int
}

class GalaxyEggComboRepository {
    private let GalaxyEggCombos: [String: GalaxyEggSpaceElementModel]
    private let GalaxyEggIdentifierLookup: [String: GalaxyEggSpaceElementModel]

    init() {
        var GalaxyEggMutableCombos: [String: GalaxyEggSpaceElementModel] = [:]

        // MARK: - Earth Combinations (16 total)
        GalaxyEggMutableCombos["Earth|Resources Discovered|Human"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "earth_resources_human", GalaxyEggDisplayName: "Terra Mining Colony",
            GalaxyEggDetail: "Human engineers establish vast mining operations to extract rare minerals.", GalaxyEggSymbol: "⛏️")
        GalaxyEggMutableCombos["Earth|Resources Discovered|Alien"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "earth_resources_alien", GalaxyEggDisplayName: "Xenotech Excavation",
            GalaxyEggDetail: "Alien prospectors discover advanced crystalline energy sources.", GalaxyEggSymbol: "💎")
        GalaxyEggMutableCombos["Earth|Resources Discovered|Robot"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "earth_resources_robot", GalaxyEggDisplayName: "Automated Harvest",
            GalaxyEggDetail: "AI drones efficiently extract and process planetary resources.", GalaxyEggSymbol: "🤖")
        GalaxyEggMutableCombos["Earth|Resources Discovered|Ancient"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "earth_resources_ancient", GalaxyEggDisplayName: "Lost Civilization Cache",
            GalaxyEggDetail: "Ancient ruins reveal repositories of forgotten technologies.", GalaxyEggSymbol: "🏛️")

        GalaxyEggMutableCombos["Earth|Alien Invasion|Human"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "earth_invasion_human", GalaxyEggDisplayName: "Global Defense Initiative",
            GalaxyEggDetail: "United human forces mobilize to repel the extraterrestrial threat.", GalaxyEggSymbol: "🛡️")
        GalaxyEggMutableCombos["Earth|Alien Invasion|Alien"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "earth_invasion_alien", GalaxyEggDisplayName: "Interstellar Conflict",
            GalaxyEggDetail: "Rival alien factions clash in orbit above the blue planet.", GalaxyEggSymbol: "👾")
        GalaxyEggMutableCombos["Earth|Alien Invasion|Robot"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "earth_invasion_robot", GalaxyEggDisplayName: "Synthetic Resistance",
            GalaxyEggDetail: "Autonomous war machines defend against the alien incursion.", GalaxyEggSymbol: "⚔️")
        GalaxyEggMutableCombos["Earth|Alien Invasion|Ancient"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "earth_invasion_ancient", GalaxyEggDisplayName: "Awakened Guardians",
            GalaxyEggDetail: "Dormant ancient defenses activate to protect the cradle world.", GalaxyEggSymbol: "🗿")

        GalaxyEggMutableCombos["Earth|Black Hole|Human"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "earth_blackhole_human", GalaxyEggDisplayName: "Singularity Research",
            GalaxyEggDetail: "Scientists study a micro black hole for breakthrough physics.", GalaxyEggSymbol: "🔬")
        GalaxyEggMutableCombos["Earth|Black Hole|Alien"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "earth_blackhole_alien", GalaxyEggDisplayName: "Void Gateway Opening",
            GalaxyEggDetail: "Alien technology stabilizes a portal through spacetime itself.", GalaxyEggSymbol: "🌀")
        GalaxyEggMutableCombos["Earth|Black Hole|Robot"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "earth_blackhole_robot", GalaxyEggDisplayName: "Graviton Containment",
            GalaxyEggDetail: "AI systems deploy fields to shield Earth from gravitational anomaly.", GalaxyEggSymbol: "🛡️")
        GalaxyEggMutableCombos["Earth|Black Hole|Ancient"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "earth_blackhole_ancient", GalaxyEggDisplayName: "Temporal Echoes",
            GalaxyEggDetail: "Ancient artifacts resonate with the distortion of time and space.", GalaxyEggSymbol: "⏳")

        GalaxyEggMutableCombos["Earth|Space Travel|Human"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "earth_travel_human", GalaxyEggDisplayName: "First Contact Mission",
            GalaxyEggDetail: "Humanity launches its first interstellar exploration vessel.", GalaxyEggSymbol: "🚀")
        GalaxyEggMutableCombos["Earth|Space Travel|Alien"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "earth_travel_alien", GalaxyEggDisplayName: "Diplomatic Envoy Arrival",
            GalaxyEggDetail: "Alien ambassadors descend to establish peaceful relations.", GalaxyEggSymbol: "👽")
        GalaxyEggMutableCombos["Earth|Space Travel|Robot"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "earth_travel_robot", GalaxyEggDisplayName: "Probe Network Expansion",
            GalaxyEggDetail: "Automated scouts map new routes through the solar system.", GalaxyEggSymbol: "📡")
        GalaxyEggMutableCombos["Earth|Space Travel|Ancient"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "earth_travel_ancient", GalaxyEggDisplayName: "Stargate Reactivation",
            GalaxyEggDetail: "Long-dormant ancient portals flicker back to life.", GalaxyEggSymbol: "🌟")

        // MARK: - Mars Combinations (16 total)
        GalaxyEggMutableCombos["Mars|Resources Discovered|Human"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "mars_resources_human", GalaxyEggDisplayName: "Red Planet Mining",
            GalaxyEggDetail: "Colonists strike rich deposits of rare earth elements.", GalaxyEggSymbol: "🔴")
        GalaxyEggMutableCombos["Mars|Resources Discovered|Alien"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "mars_resources_alien", GalaxyEggDisplayName: "Martian Helium-3 Rush",
            GalaxyEggDetail: "Alien traders exploit fuel reserves beneath rusty dunes.", GalaxyEggSymbol: "⛽")
        GalaxyEggMutableCombos["Mars|Resources Discovered|Robot"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "mars_resources_robot", GalaxyEggDisplayName: "Autonomous Excavation",
            GalaxyEggDetail: "Self-replicating miners tunnel deep into Martian crust.", GalaxyEggSymbol: "🤖")
        GalaxyEggMutableCombos["Mars|Resources Discovered|Ancient"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "mars_resources_ancient", GalaxyEggDisplayName: "Olympus Mons Vault",
            GalaxyEggDetail: "Ancient storages discovered within the great volcano.", GalaxyEggSymbol: "🏺")

        GalaxyEggMutableCombos["Mars|Alien Invasion|Human"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "mars_invasion_human", GalaxyEggDisplayName: "Martian Resistance",
            GalaxyEggDetail: "Colonial militia defends settlements from hostile forces.", GalaxyEggSymbol: "⚔️")
        GalaxyEggMutableCombos["Mars|Alien Invasion|Alien"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "mars_invasion_alien", GalaxyEggDisplayName: "War of Two Worlds",
            GalaxyEggDetail: "Competing alien empires battle for control of Mars.", GalaxyEggSymbol: "👾")
        GalaxyEggMutableCombos["Mars|Alien Invasion|Robot"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "mars_invasion_robot", GalaxyEggDisplayName: "Red Sentinel Uprising",
            GalaxyEggDetail: "Defense robots activate to protect Martian installations.", GalaxyEggSymbol: "🛡️")
        GalaxyEggMutableCombos["Mars|Alien Invasion|Ancient"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "mars_invasion_ancient", GalaxyEggDisplayName: "Forgotten War Machines",
            GalaxyEggDetail: "Ancient Martian weapons awaken to face new invaders.", GalaxyEggSymbol: "🗿")

        GalaxyEggMutableCombos["Mars|Black Hole|Human"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "mars_blackhole_human", GalaxyEggDisplayName: "Deimos Singularity Lab",
            GalaxyEggDetail: "Human scientists conduct risky gravity experiments.", GalaxyEggSymbol: "🔬")
        GalaxyEggMutableCombos["Mars|Black Hole|Alien"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "mars_blackhole_alien", GalaxyEggDisplayName: "Voidborn Emergence",
            GalaxyEggDetail: "Extradimensional beings slip through a tear in space.", GalaxyEggSymbol: "👁️")
        GalaxyEggMutableCombos["Mars|Black Hole|Robot"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "mars_blackhole_robot", GalaxyEggDisplayName: "Gravity Well Containment",
            GalaxyEggDetail: "AI constructs stabilize the dangerous anomaly.", GalaxyEggSymbol: "⚙️")
        GalaxyEggMutableCombos["Mars|Black Hole|Ancient"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "mars_blackhole_ancient", GalaxyEggDisplayName: "Time Rift Prophecy",
            GalaxyEggDetail: "Ancient warnings speak of this very singularity event.", GalaxyEggSymbol: "📜")

        GalaxyEggMutableCombos["Mars|Space Travel|Human"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "mars_travel_human", GalaxyEggDisplayName: "Mars Transit Hub",
            GalaxyEggDetail: "Colonists establish a major interplanetary spaceport.", GalaxyEggSymbol: "🚀")
        GalaxyEggMutableCombos["Mars|Space Travel|Alien"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "mars_travel_alien", GalaxyEggDisplayName: "Xenofleet Touchdown",
            GalaxyEggDetail: "Massive alien carrier ships land on the red plains.", GalaxyEggSymbol: "🛸")
        GalaxyEggMutableCombos["Mars|Space Travel|Robot"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "mars_travel_robot", GalaxyEggDisplayName: "Drone Constellation Deploy",
            GalaxyEggDetail: "Automated fleet establishes orbital infrastructure.", GalaxyEggSymbol: "📡")
        GalaxyEggMutableCombos["Mars|Space Travel|Ancient"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "mars_travel_ancient", GalaxyEggDisplayName: "Phobos Gate Awakening",
            GalaxyEggDetail: "Ancient portal systems on Mars's moon reactivate.", GalaxyEggSymbol: "🌙")

        // MARK: - Venus, Jupiter, and other planets (continuing pattern)
        // Venus combinations
        GalaxyEggMutableCombos["Venus|Resources Discovered|Human"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "venus_resources_human", GalaxyEggDisplayName: "Cloud City Refineries",
            GalaxyEggDetail: "Floating platforms harvest atmospheric compounds.", GalaxyEggSymbol: "☁️")
        GalaxyEggMutableCombos["Venus|Alien Invasion|Robot"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "venus_invasion_robot", GalaxyEggDisplayName: "Pressure Dome Defense",
            GalaxyEggDetail: "Heat-resistant machines guard against attackers.", GalaxyEggSymbol: "🤖")
        GalaxyEggMutableCombos["Venus|Black Hole|Ancient"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "venus_blackhole_ancient", GalaxyEggDisplayName: "Venusian Relic Singularity",
            GalaxyEggDetail: "Ancient relics stabilize a newborn singularity.", GalaxyEggSymbol: "🌋")
        GalaxyEggMutableCombos["Venus|Space Travel|Alien"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "venus_travel_alien", GalaxyEggDisplayName: "Sulfuric Skies Convoy",
            GalaxyEggDetail: "Alien vessels brave the toxic atmosphere.", GalaxyEggSymbol: "👽")

        // Jupiter combinations
        GalaxyEggMutableCombos["Jupiter|Resources Discovered|Alien"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "jupiter_resources_alien", GalaxyEggDisplayName: "Gas Giant Siphoning",
            GalaxyEggDetail: "Alien extractors harvest exotic fuel from storms.", GalaxyEggSymbol: "🌀")
        GalaxyEggMutableCombos["Jupiter|Alien Invasion|Human"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "jupiter_invasion_human", GalaxyEggDisplayName: "Galilean Moon Fortress",
            GalaxyEggDetail: "Human outposts on Jupiter's moons stand ready.", GalaxyEggSymbol: "🏰")
        GalaxyEggMutableCombos["Jupiter|Black Hole|Robot"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "jupiter_blackhole_robot", GalaxyEggDisplayName: "Storm Eye Singularity",
            GalaxyEggDetail: "AI probes investigate anomaly in the Great Red Spot.", GalaxyEggSymbol: "🌊")
        GalaxyEggMutableCombos["Jupiter|Space Travel|Alien"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "jupiter_travel_alien", GalaxyEggDisplayName: "Jovian Gateway",
            GalaxyEggDetail: "Alien pilgrims open travel gates in Jupiter's clouds.", GalaxyEggSymbol: "🛸")

        // Ice Planet combinations
        GalaxyEggMutableCombos["Ice Planet|Resources Discovered|Robot"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "ice_resources_robot", GalaxyEggDisplayName: "Cryo-Mine Breakthrough",
            GalaxyEggDetail: "Drones harvest crystalline ice for fusion fuel.", GalaxyEggSymbol: "❄️")
        GalaxyEggMutableCombos["Ice Planet|Alien Invasion|Ancient"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "ice_invasion_ancient", GalaxyEggDisplayName: "Frozen Guardians Rise",
            GalaxyEggDetail: "Ice-encased ancient warriors defend their tomb world.", GalaxyEggSymbol: "🧊")
        GalaxyEggMutableCombos["Ice Planet|Black Hole|Alien"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "ice_blackhole_alien", GalaxyEggDisplayName: "Eternal Winter Vortex",
            GalaxyEggDetail: "Aliens study how cold slows time near the singularity.", GalaxyEggSymbol: "🌨️")
        GalaxyEggMutableCombos["Ice Planet|Space Travel|Human"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "ice_travel_human", GalaxyEggDisplayName: "Arctic Waystation",
            GalaxyEggDetail: "Explorers establish refueling depot on frozen world.", GalaxyEggSymbol: "⛺")

        // Desert Planet combinations
        GalaxyEggMutableCombos["Desert Planet|Resources Discovered|Ancient"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "desert_resources_ancient", GalaxyEggDisplayName: "Spice Sands Discovery",
            GalaxyEggDetail: "Ancient deposits of priceless minerals lie beneath dunes.", GalaxyEggSymbol: "🏜️")
        GalaxyEggMutableCombos["Desert Planet|Alien Invasion|Human"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "desert_invasion_human", GalaxyEggDisplayName: "Dustfront Defense",
            GalaxyEggDetail: "Human commanders defend settlements in sandstorms.", GalaxyEggSymbol: "⚔️")
        GalaxyEggMutableCombos["Desert Planet|Black Hole|Robot"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "desert_blackhole_robot", GalaxyEggDisplayName: "Dune Singularity Probe",
            GalaxyEggDetail: "Machines investigate gravity well in wasteland.", GalaxyEggSymbol: "🤖")
        GalaxyEggMutableCombos["Desert Planet|Space Travel|Alien"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "desert_travel_alien", GalaxyEggDisplayName: "Nomad Fleet Landing",
            GalaxyEggDetail: "Desert-adapted aliens establish trading post.", GalaxyEggSymbol: "🐪")

        // Ocean Planet combinations
        GalaxyEggMutableCombos["Ocean Planet|Resources Discovered|Human"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "ocean_resources_human", GalaxyEggDisplayName: "Deep Sea Mining Op",
            GalaxyEggDetail: "Submarines extract minerals from ocean trenches.", GalaxyEggSymbol: "🌊")
        GalaxyEggMutableCombos["Ocean Planet|Alien Invasion|Alien"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "ocean_invasion_alien", GalaxyEggDisplayName: "Tidal War of Worlds",
            GalaxyEggDetail: "Aquatic species clash beneath the waves.", GalaxyEggSymbol: "🦑")
        GalaxyEggMutableCombos["Ocean Planet|Black Hole|Robot"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "ocean_blackhole_robot", GalaxyEggDisplayName: "Abyssal Vortex Shield",
            GalaxyEggDetail: "AI submarines deploy gravity dampeners.", GalaxyEggSymbol: "🌀")
        GalaxyEggMutableCombos["Ocean Planet|Space Travel|Ancient"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "ocean_travel_ancient", GalaxyEggDisplayName: "Tidal Gatekeepers",
            GalaxyEggDetail: "Ancient aquatic beings open underwater portals.", GalaxyEggSymbol: "🐋")

        // Neon Planet combinations
        GalaxyEggMutableCombos["Neon Planet|Resources Discovered|Alien"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "neon_resources_alien", GalaxyEggDisplayName: "Luminous Harvest",
            GalaxyEggDetail: "Bioluminescent fauna yield rare energy cores.", GalaxyEggSymbol: "🌈")
        GalaxyEggMutableCombos["Neon Planet|Alien Invasion|Robot"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "neon_invasion_robot", GalaxyEggDisplayName: "Prism Defense Array",
            GalaxyEggDetail: "Light-bending drones protect glowing forests.", GalaxyEggSymbol: "✨")
        GalaxyEggMutableCombos["Neon Planet|Black Hole|Human"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "neon_blackhole_human", GalaxyEggDisplayName: "Rainbow Void Research",
            GalaxyEggDetail: "Scientists study how light behaves near singularity.", GalaxyEggSymbol: "🔬")
        GalaxyEggMutableCombos["Neon Planet|Space Travel|Ancient"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "neon_travel_ancient", GalaxyEggDisplayName: "Chromatic Pathways",
            GalaxyEggDetail: "Ancient light bridges connect to distant stars.", GalaxyEggSymbol: "🌟")

        // Crystal Planet combinations
        GalaxyEggMutableCombos["Crystal Planet|Resources Discovered|Robot"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "crystal_resources_robot", GalaxyEggDisplayName: "Crystalline Core Harvest",
            GalaxyEggDetail: "Precision drones extract perfect geometric gems.", GalaxyEggSymbol: "💎")
        GalaxyEggMutableCombos["Crystal Planet|Alien Invasion|Ancient"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "crystal_invasion_ancient", GalaxyEggDisplayName: "Prism Sentinel Awakening",
            GalaxyEggDetail: "Crystal guardians emerge to defend sacred formations.", GalaxyEggSymbol: "🗿")
        GalaxyEggMutableCombos["Crystal Planet|Black Hole|Robot"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "crystal_blackhole_robot", GalaxyEggDisplayName: "Prism Firewall",
            GalaxyEggDetail: "Robotic sentries use crystals to bend spacetime.", GalaxyEggSymbol: "💠")
        GalaxyEggMutableCombos["Crystal Planet|Space Travel|Alien"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "crystal_travel_alien", GalaxyEggDisplayName: "Faceted Portal Network",
            GalaxyEggDetail: "Aliens activate crystal-based teleportation grid.", GalaxyEggSymbol: "🔷")

        // Volcanic Planet combinations
        GalaxyEggMutableCombos["Volcanic Planet|Resources Discovered|Ancient"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "volcanic_resources_ancient", GalaxyEggDisplayName: "Magma Forge Ruins",
            GalaxyEggDetail: "Ancient smelting facilities still produce metals.", GalaxyEggSymbol: "🏭")
        GalaxyEggMutableCombos["Volcanic Planet|Alien Invasion|Alien"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "volcanic_invasion_alien", GalaxyEggDisplayName: "Lava World Siege",
            GalaxyEggDetail: "Heat-resistant invaders assault the molten planet.", GalaxyEggSymbol: "🔥")
        GalaxyEggMutableCombos["Volcanic Planet|Black Hole|Human"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "volcanic_blackhole_human", GalaxyEggDisplayName: "Caldera Singularity Watch",
            GalaxyEggDetail: "Brave scientists monitor anomaly from volcano rim.", GalaxyEggSymbol: "🌋")
        GalaxyEggMutableCombos["Volcanic Planet|Space Travel|Human"] = GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: "volcanic_travel_human", GalaxyEggDisplayName: "Forgegate Armada",
            GalaxyEggDetail: "Molten launch cradles propel ships into space.", GalaxyEggSymbol: "🚀")

        GalaxyEggCombos = GalaxyEggMutableCombos
        GalaxyEggIdentifierLookup = GalaxyEggMutableCombos.reduce(into: [:]) { GalaxyEggResult, GalaxyEggEntry in
            GalaxyEggResult[GalaxyEggEntry.value.GalaxyEggIdentifier] = GalaxyEggEntry.value
        }
    }
    
    func GalaxyEggSpaceElement(for GalaxyEggKey: String, fallback GalaxyEggSymbol: String) -> GalaxyEggSpaceElementModel {
        if let GalaxyEggMatch = GalaxyEggCombos[GalaxyEggKey] {
            return GalaxyEggMatch
        }
        
        return GalaxyEggSpaceElementModel(
            GalaxyEggIdentifier: GalaxyEggKey,
            GalaxyEggDisplayName: "Unknown Constellation",
            GalaxyEggDetail: "Data stream incomplete. Further explorations required.",
            GalaxyEggSymbol: GalaxyEggSymbol
        )
    }
    
    func GalaxyEggSpaceElementByIdentifier(_ GalaxyEggIdentifier: String) -> GalaxyEggSpaceElementModel? {
        GalaxyEggIdentifierLookup[GalaxyEggIdentifier]
    }
}

class GalaxyEggPersistenceController {
    private let GalaxyEggDefaults = UserDefaults.standard
    private let GalaxyEggUnlockedKey = "com.galaxyegg.unlockedElements"
    private let GalaxyEggEnergyKey = "com.galaxyegg.energy"
    private let GalaxyEggCurrencyKey = "com.galaxyegg.currency"
    private let GalaxyEggLastEnergyRecoveryKey = "com.galaxyegg.lastEnergyRecovery"
    private let GalaxyEggBonusSpinsCountKey = "com.galaxyegg.bonusSpinsCount"
    private let GalaxyEggBonusSpinsDateKey = "com.galaxyegg.bonusSpinsDate"

    func GalaxyEggSaveUnlocked(_ GalaxyEggIdentifiers: Set<String>) {
        GalaxyEggDefaults.set(Array(GalaxyEggIdentifiers), forKey: GalaxyEggUnlockedKey)
    }

    func GalaxyEggLoadUnlocked() -> Set<String> {
        let GalaxyEggArray = GalaxyEggDefaults.array(forKey: GalaxyEggUnlockedKey) as? [String] ?? []
        return Set(GalaxyEggArray)
    }

    func GalaxyEggSaveEnergy(_ GalaxyEggEnergy: Int) {
        GalaxyEggDefaults.set(GalaxyEggEnergy, forKey: GalaxyEggEnergyKey)
    }

    func GalaxyEggLoadEnergy(default GalaxyEggValue: Int) -> Int {
        guard GalaxyEggDefaults.object(forKey: GalaxyEggEnergyKey) != nil else {
            return GalaxyEggValue
        }
        return GalaxyEggDefaults.integer(forKey: GalaxyEggEnergyKey)
    }

    func GalaxyEggSaveCurrency(_ GalaxyEggCurrency: Int) {
        GalaxyEggDefaults.set(GalaxyEggCurrency, forKey: GalaxyEggCurrencyKey)
    }

    func GalaxyEggLoadCurrency(default GalaxyEggValue: Int) -> Int {
        guard GalaxyEggDefaults.object(forKey: GalaxyEggCurrencyKey) != nil else {
            return GalaxyEggValue
        }
        return GalaxyEggDefaults.integer(forKey: GalaxyEggCurrencyKey)
    }

    func GalaxyEggSaveLastEnergyRecoveryTime(_ GalaxyEggTime: Date) {
        GalaxyEggDefaults.set(GalaxyEggTime, forKey: GalaxyEggLastEnergyRecoveryKey)
    }

    func GalaxyEggLoadLastEnergyRecoveryTime() -> Date? {
        GalaxyEggDefaults.object(forKey: GalaxyEggLastEnergyRecoveryKey) as? Date
    }

    func GalaxyEggSaveBonusSpinsCount(_ GalaxyEggCount: Int) {
        GalaxyEggDefaults.set(GalaxyEggCount, forKey: GalaxyEggBonusSpinsCountKey)
    }

    func GalaxyEggLoadBonusSpinsCount() -> Int {
        GalaxyEggDefaults.integer(forKey: GalaxyEggBonusSpinsCountKey)
    }

    func GalaxyEggSaveBonusSpinsDate(_ GalaxyEggDate: String) {
        GalaxyEggDefaults.set(GalaxyEggDate, forKey: GalaxyEggBonusSpinsDateKey)
    }

    func GalaxyEggLoadBonusSpinsDate() -> String? {
        GalaxyEggDefaults.string(forKey: GalaxyEggBonusSpinsDateKey)
    }

    func GalaxyEggReset() {
        GalaxyEggDefaults.removeObject(forKey: GalaxyEggUnlockedKey)
        GalaxyEggDefaults.removeObject(forKey: GalaxyEggEnergyKey)
        GalaxyEggDefaults.removeObject(forKey: GalaxyEggCurrencyKey)
        GalaxyEggDefaults.removeObject(forKey: GalaxyEggLastEnergyRecoveryKey)
        GalaxyEggDefaults.removeObject(forKey: GalaxyEggBonusSpinsCountKey)
        GalaxyEggDefaults.removeObject(forKey: GalaxyEggBonusSpinsDateKey)
    }
}

class GalaxyEggAudioManager {
    private var GalaxyEggPlayer: AVAudioPlayer?
    private var GalaxyEggIsMuted: Bool = false
    
    func GalaxyEggToggleMute() {
        GalaxyEggIsMuted.toggle()
        if GalaxyEggIsMuted {
            GalaxyEggPlayer?.stop()
        } else {
            GalaxyEggPlayer?.play()
        }
    }
    
    func GalaxyEggPlayLoop(named GalaxyEggName: String) {
        guard !GalaxyEggIsMuted else { return }
        guard let GalaxyEggURL = Bundle.main.url(forResource: GalaxyEggName, withExtension: nil) else { return }
        do {
            GalaxyEggPlayer = try AVAudioPlayer(contentsOf: GalaxyEggURL)
            GalaxyEggPlayer?.numberOfLoops = -1
            GalaxyEggPlayer?.prepareToPlay()
            GalaxyEggPlayer?.play()
        } catch {
            // Silently ignore missing or invalid audio during prototyping.
        }
    }
    
    func GalaxyEggPlayEffect(named GalaxyEggName: String) {
        guard !GalaxyEggIsMuted else { return }
        guard let GalaxyEggURL = Bundle.main.url(forResource: GalaxyEggName, withExtension: nil) else { return }
        var GalaxyEggEffectPlayer: AVAudioPlayer?
        do {
            GalaxyEggEffectPlayer = try AVAudioPlayer(contentsOf: GalaxyEggURL)
            GalaxyEggEffectPlayer?.play()
        } catch {
            // Ignore for now.
        }
    }
    
    func GalaxyEggIsAudioMuted() -> Bool {
        GalaxyEggIsMuted
    }
}

struct GalaxyEggAdaptiveLayoutGuide {
    static func GalaxyEggPrimaryScale(for GalaxyEggBounds: CGRect) -> CGFloat {
        let GalaxyEggMinDimension = min(GalaxyEggBounds.width, GalaxyEggBounds.height)
        return max(1.0, GalaxyEggMinDimension / 375.0)
    }

    static func GalaxyEggReelHeight(for GalaxyEggBounds: CGRect) -> CGFloat {
        // Use height as base for landscape mode
        let GalaxyEggBaseHeight = GalaxyEggBounds.height
        if GalaxyEggBounds.height >= 1024 { // iPad Pro landscape
            return GalaxyEggBaseHeight * 0.28
        } else if GalaxyEggBounds.height >= 768 { // iPad landscape
            return GalaxyEggBaseHeight * 0.30
        } else { // iPhone landscape
            return GalaxyEggBaseHeight * 0.32
        }
    }

    static func GalaxyEggContentWidthRatio(for GalaxyEggTraitCollection: UITraitCollection) -> CGFloat {
        if GalaxyEggTraitCollection.horizontalSizeClass == .regular && GalaxyEggTraitCollection.verticalSizeClass == .regular {
            // iPad in landscape
            return 0.55
        }
        // iPhone in landscape or iPad in compatibility mode
        return 0.85
    }

    static func GalaxyEggSpacingScale(for GalaxyEggTraitCollection: UITraitCollection) -> CGFloat {
        if GalaxyEggTraitCollection.horizontalSizeClass == .regular && GalaxyEggTraitCollection.verticalSizeClass == .regular {
            return 1.5
        }
        return 1.0
    }

    static func GalaxyEggFontScale(for GalaxyEggTraitCollection: UITraitCollection) -> CGFloat {
        if GalaxyEggTraitCollection.horizontalSizeClass == .regular && GalaxyEggTraitCollection.verticalSizeClass == .regular {
            return 1.3
        }
        return 1.0
    }
}

class GalaxyEggSpinEngine {
    static let GalaxyEggMaxEnergy: Int = 25
    static let GalaxyEggEnergyRecoveryInterval: TimeInterval = 1800 // 30 minutes
    static let GalaxyEggEnergyPurchasePrice: Int = 200
    static let GalaxyEggDailyBonusSpins: Int = 20

    private let GalaxyEggPlanets: [String] = ["Earth", "Mars", "Venus", "Jupiter", "Ice Planet", "Desert Planet", "Ocean Planet", "Neon Planet", "Crystal Planet", "Volcanic Planet"]
    private let GalaxyEggEvents: [String] = ["Resources Discovered", "Alien Invasion", "Black Hole", "Space Travel"]
    private let GalaxyEggCivilizations: [String] = ["Human", "Alien", "Robot", "Ancient"]

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

    private let GalaxyEggRepository = GalaxyEggComboRepository()
    private let GalaxyEggPersistence = GalaxyEggPersistenceController()

    private var GalaxyEggUnlockedSet: Set<String>
    private var GalaxyEggEnergy: Int
    private var GalaxyEggCurrency: Int
    private var GalaxyEggEnergyRecoveryTimer: Timer?

    init() {
        GalaxyEggUnlockedSet = GalaxyEggPersistence.GalaxyEggLoadUnlocked()
        GalaxyEggEnergy = GalaxyEggPersistence.GalaxyEggLoadEnergy(default: 20)
        GalaxyEggCurrency = GalaxyEggPersistence.GalaxyEggLoadCurrency(default: 150)

        // Initialize recovery time if not set
        if GalaxyEggPersistence.GalaxyEggLoadLastEnergyRecoveryTime() == nil {
            GalaxyEggPersistence.GalaxyEggSaveLastEnergyRecoveryTime(Date())
        }

        GalaxyEggCheckAndRecoverEnergy()
        GalaxyEggCheckAndResetBonusSpins()
        GalaxyEggStartEnergyRecoveryTimer()
    }

    deinit {
        GalaxyEggEnergyRecoveryTimer?.invalidate()
    }

    // MARK: - Energy Recovery System
    private func GalaxyEggStartEnergyRecoveryTimer() {
        GalaxyEggEnergyRecoveryTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.GalaxyEggCheckAndRecoverEnergy()
        }
    }

    private func GalaxyEggCheckAndRecoverEnergy() {
        guard GalaxyEggEnergy < Self.GalaxyEggMaxEnergy else { return }

        let GalaxyEggNow = Date()
        guard let GalaxyEggLastRecovery = GalaxyEggPersistence.GalaxyEggLoadLastEnergyRecoveryTime() else {
            // Initialize recovery time if not set
            GalaxyEggPersistence.GalaxyEggSaveLastEnergyRecoveryTime(GalaxyEggNow)
            return
        }

        let GalaxyEggElapsedTime = GalaxyEggNow.timeIntervalSince(GalaxyEggLastRecovery)
        let GalaxyEggRecoveryCount = Int(GalaxyEggElapsedTime / Self.GalaxyEggEnergyRecoveryInterval)

        if GalaxyEggRecoveryCount > 0 {
            let GalaxyEggNewEnergy = min(GalaxyEggEnergy + GalaxyEggRecoveryCount, Self.GalaxyEggMaxEnergy)
            let GalaxyEggActualRecovered = GalaxyEggNewEnergy - GalaxyEggEnergy

            if GalaxyEggActualRecovered > 0 {
                GalaxyEggEnergy = GalaxyEggNewEnergy
                let GalaxyEggNewLastRecovery = GalaxyEggLastRecovery.addingTimeInterval(TimeInterval(GalaxyEggActualRecovered) * Self.GalaxyEggEnergyRecoveryInterval)
                GalaxyEggPersistence.GalaxyEggSaveLastEnergyRecoveryTime(GalaxyEggNewLastRecovery)
                GalaxyEggPersistence.GalaxyEggSaveEnergy(GalaxyEggEnergy)
            }
        }
    }

    func GalaxyEggGetTimeUntilNextEnergyRecovery() -> TimeInterval {
        guard GalaxyEggEnergy < Self.GalaxyEggMaxEnergy else { return 0 }

        let GalaxyEggNow = Date()
        guard let GalaxyEggLastRecovery = GalaxyEggPersistence.GalaxyEggLoadLastEnergyRecoveryTime() else {
            // If no recovery time set, initialize it now
            GalaxyEggPersistence.GalaxyEggSaveLastEnergyRecoveryTime(GalaxyEggNow)
            return Self.GalaxyEggEnergyRecoveryInterval
        }

        let GalaxyEggElapsedTime = GalaxyEggNow.timeIntervalSince(GalaxyEggLastRecovery)

        // If more than one recovery period has passed, we need to update the base time
        if GalaxyEggElapsedTime >= Self.GalaxyEggEnergyRecoveryInterval {
            let GalaxyEggRecoveryCount = Int(GalaxyEggElapsedTime / Self.GalaxyEggEnergyRecoveryInterval)
            let GalaxyEggAdjustedLastRecovery = GalaxyEggLastRecovery.addingTimeInterval(TimeInterval(GalaxyEggRecoveryCount) * Self.GalaxyEggEnergyRecoveryInterval)
            let GalaxyEggAdjustedElapsedTime = GalaxyEggNow.timeIntervalSince(GalaxyEggAdjustedLastRecovery)
            return Self.GalaxyEggEnergyRecoveryInterval - GalaxyEggAdjustedElapsedTime
        }

        return Self.GalaxyEggEnergyRecoveryInterval - GalaxyEggElapsedTime
    }

    func GalaxyEggPurchaseEnergy() -> Bool {
        guard GalaxyEggCurrency >= Self.GalaxyEggEnergyPurchasePrice else { return false }
        guard GalaxyEggEnergy < Self.GalaxyEggMaxEnergy else { return false }

        GalaxyEggCurrency -= Self.GalaxyEggEnergyPurchasePrice
        GalaxyEggEnergy = min(GalaxyEggEnergy + 1, Self.GalaxyEggMaxEnergy)

        GalaxyEggPersistence.GalaxyEggSaveCurrency(GalaxyEggCurrency)
        GalaxyEggPersistence.GalaxyEggSaveEnergy(GalaxyEggEnergy)

        // Reset recovery timer when purchasing energy
        GalaxyEggPersistence.GalaxyEggSaveLastEnergyRecoveryTime(Date())

        return true
    }

    // MARK: - Bonus Slot System
    private func GalaxyEggCheckAndResetBonusSpins() {
        let GalaxyEggTodayString = GalaxyEggGetTodayDateString()
        let GalaxyEggSavedDate = GalaxyEggPersistence.GalaxyEggLoadBonusSpinsDate()

        if GalaxyEggSavedDate != GalaxyEggTodayString {
            GalaxyEggPersistence.GalaxyEggSaveBonusSpinsCount(Self.GalaxyEggDailyBonusSpins)
            GalaxyEggPersistence.GalaxyEggSaveBonusSpinsDate(GalaxyEggTodayString)
        }
    }

    func GalaxyEggGetRemainingBonusSpins() -> Int {
        GalaxyEggCheckAndResetBonusSpins()
        return GalaxyEggPersistence.GalaxyEggLoadBonusSpinsCount()
    }

    func GalaxyEggPerformBonusSpin() -> GalaxyEggBonusSpinOutcome? {
        GalaxyEggCheckAndResetBonusSpins()
        let GalaxyEggRemaining = GalaxyEggPersistence.GalaxyEggLoadBonusSpinsCount()
        guard GalaxyEggRemaining > 0 else { return nil }

        // Use planet symbols for bonus slot
        let GalaxyEggAllSymbols = Array(GalaxyEggPlanetSymbols.values)
        let GalaxyEggSymbol1 = GalaxyEggAllSymbols.randomElement() ?? "🌍"
        let GalaxyEggSymbol2 = GalaxyEggAllSymbols.randomElement() ?? "🌍"
        let GalaxyEggSymbol3 = GalaxyEggAllSymbols.randomElement() ?? "🌍"

        var GalaxyEggReward = 0
        var GalaxyEggIsWin = false

        // Check if all three match
        if GalaxyEggSymbol1 == GalaxyEggSymbol2 && GalaxyEggSymbol2 == GalaxyEggSymbol3 {
            GalaxyEggIsWin = true
            // Different symbols have different rewards
            switch GalaxyEggSymbol1 {
            case "💎": GalaxyEggReward = 500
            case "🌈": GalaxyEggReward = 400
            case "🌀": GalaxyEggReward = 300
            case "🌋": GalaxyEggReward = 250
            case "🌊": GalaxyEggReward = 200
            case "❄️": GalaxyEggReward = 180
            case "🏜️": GalaxyEggReward = 150
            case "🟡": GalaxyEggReward = 120
            case "🔴": GalaxyEggReward = 100
            case "🌍": GalaxyEggReward = 80
            default: GalaxyEggReward = 50
            }

            GalaxyEggCurrency += GalaxyEggReward
            GalaxyEggPersistence.GalaxyEggSaveCurrency(GalaxyEggCurrency)
        }

        GalaxyEggPersistence.GalaxyEggSaveBonusSpinsCount(GalaxyEggRemaining - 1)

        return GalaxyEggBonusSpinOutcome(
            GalaxyEggSymbol1: GalaxyEggSymbol1,
            GalaxyEggSymbol2: GalaxyEggSymbol2,
            GalaxyEggSymbol3: GalaxyEggSymbol3,
            GalaxyEggIsWin: GalaxyEggIsWin,
            GalaxyEggReward: GalaxyEggReward
        )
    }

    private func GalaxyEggGetTodayDateString() -> String {
        let GalaxyEggFormatter = DateFormatter()
        GalaxyEggFormatter.dateFormat = "yyyy-MM-dd"
        return GalaxyEggFormatter.string(from: Date())
    }

    // MARK: - Main Game Spin
    func GalaxyEggPerformSpin() -> GalaxyEggSpinOutcomeModel {
        let GalaxyEggPlanet = GalaxyEggPlanets.randomElement() ?? "Earth"
        let GalaxyEggEvent = GalaxyEggEvents.randomElement() ?? "Resources Discovered"
        let GalaxyEggCivilization = GalaxyEggCivilizations.randomElement() ?? "Human"
        let GalaxyEggKey = GalaxyEggComposeKey(planet: GalaxyEggPlanet, event: GalaxyEggEvent, civilization: GalaxyEggCivilization)
        let GalaxyEggSymbol = GalaxyEggPlanetSymbols[GalaxyEggPlanet] ?? "✨"
        let GalaxyEggElement = GalaxyEggRepository.GalaxyEggSpaceElement(for: GalaxyEggKey, fallback: GalaxyEggSymbol)
        
        let GalaxyEggIsNew = !GalaxyEggUnlockedSet.contains(GalaxyEggElement.GalaxyEggIdentifier)
        if GalaxyEggIsNew {
            GalaxyEggUnlockedSet.insert(GalaxyEggElement.GalaxyEggIdentifier)
            GalaxyEggPersistence.GalaxyEggSaveUnlocked(GalaxyEggUnlockedSet)
        }
        
        GalaxyEggEnergy = max(0, GalaxyEggEnergy - 1)
        let GalaxyEggReward = GalaxyEggIsNew ? 50 : Int.random(in: 5...20)
        GalaxyEggCurrency += GalaxyEggReward
        
        GalaxyEggPersistence.GalaxyEggSaveEnergy(GalaxyEggEnergy)
        GalaxyEggPersistence.GalaxyEggSaveCurrency(GalaxyEggCurrency)
        
        return GalaxyEggSpinOutcomeModel(
            GalaxyEggPlanet: GalaxyEggPlanet,
            GalaxyEggEvent: GalaxyEggEvent,
            GalaxyEggCivilization: GalaxyEggCivilization,
            GalaxyEggResultElement: GalaxyEggElement,
            GalaxyEggIsNewDiscovery: GalaxyEggIsNew,
            GalaxyEggReward: GalaxyEggReward
        )
    }
    
    func GalaxyEggResetProgress() {
        GalaxyEggUnlockedSet.removeAll()
        GalaxyEggPersistence.GalaxyEggReset()
        GalaxyEggEnergy = 20
        GalaxyEggCurrency = 150
    }
    
    func GalaxyEggCurrentEnergy() -> Int {
        GalaxyEggEnergy
    }
    
    func GalaxyEggCurrentCurrency() -> Int {
        GalaxyEggCurrency
    }
    
    func GalaxyEggUnlockedElements() -> [GalaxyEggSpaceElementModel] {
        GalaxyEggUnlockedSet.map { GalaxyEggIdentifier in
            GalaxyEggRepository.GalaxyEggSpaceElementByIdentifier(GalaxyEggIdentifier) ??
            GalaxyEggSpaceElementModel(
                GalaxyEggIdentifier: GalaxyEggIdentifier,
                GalaxyEggDisplayName: "Uncharted Entry",
                GalaxyEggDetail: "Legacy discovery recorded without catalog metadata.",
                GalaxyEggSymbol: "✨"
            )
        }
    }
    
    func GalaxyEggPlanetsData() -> [String] {
        GalaxyEggPlanets
    }
    
    func GalaxyEggEventsData() -> [String] {
        GalaxyEggEvents
    }
    
    func GalaxyEggCivilizationsData() -> [String] {
        GalaxyEggCivilizations
    }
    
    private func GalaxyEggComposeKey(planet GalaxyEggPlanet: String, event GalaxyEggEvent: String, civilization GalaxyEggCivilization: String) -> String {
        "\(GalaxyEggPlanet)|\(GalaxyEggEvent)|\(GalaxyEggCivilization)"
    }
}
