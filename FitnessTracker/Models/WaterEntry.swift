import SwiftData
import Foundation

@Model
class WaterEntry{
    var date: Date
    var value: Double
    
    init(date: Date, value: Double) {
        self.date = date
        self.value = value
    }
}
