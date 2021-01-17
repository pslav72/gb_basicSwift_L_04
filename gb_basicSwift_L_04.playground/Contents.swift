import UIKit

let delimiter = "============================"

enum MovableObject {
    case doors(DoorsAction)
    case windows(WindowsAction)
    case trunk(TrunkAction)
    case climateControl(ClimateControl)
    
    enum DoorsAction {
            case open, close
        }
    
    enum WindowsAction {
            case open, close
        }
    
    enum TrunkAction {
          case put(Int), take(Int)
       }
    
    enum ClimateControl {
        case auto, manual, off
    }
    
}

enum FeatursSportCar {
    case Hatch(HatchAction)
    case Turbine(TurbineAction)
    
    enum HatchAction {
        case open, close
    }
    
    enum TurbineAction {
        case spin, stop
    }
    
}

enum BodyType: String {
    case liftback
    case sedan
    case SUV
    case truck
    case sportCar
}

enum NumberOfBridges: String {
    case twoBriges
    case threBridges
}

enum StateTrailer: String {
    case hooked, unhooked
}

class Car {
    let brand: String
    let year: Int
    let maxTrunkVolume: Int
    var climateControl: MovableObject.ClimateControl
    let bodyType: BodyType
    var isWindowsOpen: Bool = false
    
    private(set) var isDoorsClose: Bool = false
    private(set) var filledTrunkVolume: Int = 0
    
    init(brand: String, year: Int, maxTrunkVolume: Int, climateControl: MovableObject.ClimateControl, bodyType: BodyType) {
        self.brand = brand
        self.year = year
        self.maxTrunkVolume = maxTrunkVolume
        self.climateControl = climateControl
        self.bodyType = bodyType
    }
    
    func performAction(with object: MovableObject) {
        switch object {
        
        case let .climateControl(action):
            switch action {
            case .auto:
                climateControl = .auto
                isWindowsOpen = false
            case .off:
                climateControl = .off
                isWindowsOpen = true
            case .manual:
                climateControl = .manual
                isWindowsOpen = true
            }
            print(delimiter)
            print("Work mode clima \(climateControl)")
            print("isWindowsOpen \(isWindowsOpen)")
        
        case let .doors(action):
            isDoorsClose = action == .close
            print(delimiter)
            print("\(action) doors")
            
        case let .windows(action):
            isWindowsOpen = action == .open
            print(delimiter)
            print("\(action) windows")
        
        case let .trunk(action):
            switch action {
            case let .put(value):
                guard filledTrunkVolume + value <= maxTrunkVolume else {
                    return
                }
                filledTrunkVolume += value
            case let .take(value):
                guard filledTrunkVolume - value >= 0 else {
                    return
                }
                filledTrunkVolume -= value
                
            }
        }
    }
    
}

class TrunkCar: Car {
    
    let numberOfBridges: NumberOfBridges
    var stateTrailer: StateTrailer
    
    init(brand: String, year: Int, climateControl: MovableObject.ClimateControl, numberOfBridges: NumberOfBridges, stateTrailer: StateTrailer) {
        self.numberOfBridges = numberOfBridges
        self.stateTrailer = stateTrailer
        super.init(brand: brand, year: year, maxTrunkVolume: 0, climateControl: climateControl, bodyType: .truck)
    }
    
    func connectTrailer () {
        stateTrailer = .hooked
        print("stateTrailer \(stateTrailer)")
    }
    
    func disconnectTrailer () {
        stateTrailer = .unhooked
        print("stateTrailer \(stateTrailer)")
    }

}

class TrunkCarDecorative: TrunkCar {
    override func connectTrailer() {
        print("The trailer cannot be connected")
    }
    override func disconnectTrailer() {
        print("Trailer not connected")
    }
}

class SportСar: Car {
    
    var hatchState: FeatursSportCar.HatchAction
    private(set) var turbineAction: FeatursSportCar.TurbineAction = .stop
    
    init(brand: String, year: Int, hatchState: FeatursSportCar.HatchAction) {
        self.hatchState = hatchState
        super.init(brand: brand, year: year, maxTrunkVolume: 0, climateControl: .off, bodyType: .sportCar)
    }
    
    func turboMode () {
        turbineAction = .spin
        hatchState = .close
        print(delimiter)
        print("turbineAction \(turbineAction)")
        print("При включении турбины, закроем люк. Чтобы не задуло :)")
        print("hatchState \(hatchState)")
    }
    
    func cityMode () {
        turbineAction = .stop
        print(delimiter)
        print("turbineAction \(turbineAction)")
        print("hatchState \(hatchState)")
    }
    
}

let productionYear = Calendar.current.dateComponents([.year], from: Date()).year!

print("Создание машины от родительского класса")
let carRoot = Car(brand: "Renault", year: productionYear, maxTrunkVolume: 500, climateControl: .auto, bodyType: .sedan)

print(carRoot.brand, carRoot.year)
carRoot.performAction(with: .doors(.open))
print("isDoorsClose \(carRoot.isDoorsClose)?")
carRoot.performAction(with: .climateControl(.auto))
//print("Mode climate control \(carRoot.climateControl)")

print(delimiter)
print("Создание машины от дочернего класса TrunkCar")
var carTruck = TrunkCar(brand: "Volvo", year: productionYear, climateControl: .auto, numberOfBridges: .twoBriges, stateTrailer: .unhooked)

print(carTruck.brand, carTruck.year, carTruck.numberOfBridges)
print("Сцепка полуприцепа")
carTruck.connectTrailer()
print("Расцепка полуприцепа")
carTruck.disconnectTrailer()

print(delimiter)
print("Создание выстовочной машины от класса TrunkCar")

var trunkCarDecorative = TrunkCarDecorative(brand: "MAN", year: productionYear, climateControl: .auto, numberOfBridges: .threBridges, stateTrailer: .unhooked)

print(trunkCarDecorative.brand, trunkCarDecorative.year, trunkCarDecorative.numberOfBridges)
print("Попытка сцепки полуприцепа")
trunkCarDecorative.connectTrailer()
trunkCarDecorative.disconnectTrailer()

print(delimiter)
print("Создание SportСar")
var sportCar = SportСar(brand: "Lada", year: productionYear, hatchState: .close)
sportCar.turboMode()
sportCar.cityMode()
sportCar.hatchState = .open
sportCar.cityMode()
print("Спорт кару не нужен багажник, поэтому максимальный объем \(sportCar.maxTrunkVolume)")
