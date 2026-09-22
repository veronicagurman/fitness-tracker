import SwiftData
import Foundation

@Model
class SleepEntry{
    var start: Date
    var end: Date
    
    var duration: TimeInterval {
        end.timeIntervalSince(start)
    }
    
    init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }
}
