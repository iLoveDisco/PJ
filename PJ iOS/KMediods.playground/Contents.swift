import CoreGraphics
import Foundation

class KMediods {
    
    var data : [CGPoint] = []
    
    init(data : [CGPoint]) {
        self.data = data
    }
    
    public func labelClusters(numClusters : Int) -> [Int] {
        var mediods : [Int] = []
        for _ in 1...numClusters {
            var randomIdx = Int.random(in: 0..<data.count)
            
            while mediods.contains(randomIdx) {
                randomIdx = Int.random(in: 0..<data.count)
            }
            
            mediods.append(randomIdx)
        }
        
        var labels : [Int] = []
        for _ in 1...10 {
            // labeling points
            labels = []
            for point in data {
                let distances = mediods.map { mediodIdx in
                    return KMediods.distance(data[mediodIdx],point)
                }
                let shortestIdx = distances.firstIndex(of: distances.min()!)
                labels.append(shortestIdx!)
            }
            
            // use the labels + points to come up with new mediods
            mediods = []
            for clusterID in 0..<numClusters {
                
                var clusterIndices : [Int] = []
                for i in 0..<labels.count {
                    if clusterID == labels[i] {
                        clusterIndices.append(i)
                    }
                }
                
                var newestMediodIdx = clusterIndices[0]
                for clusterIndex in clusterIndices {
                    let clusterPoint = data[clusterIndex]
                    
                    // find the newest mediod
                    if self.cost(clusterPoint) < self.cost(data[newestMediodIdx]) {
                        newestMediodIdx = clusterIndex
                    }
                }
                mediods.append(newestMediodIdx)
            }
        }
        return labels
    }
    
    public static func distance(_ p1 : CGPoint, _ p2 : CGPoint) -> CGFloat{
        return sqrt(pow(p1.x - p2.x,2) + pow(p1.y - p2.y, 2))
    }
    
    public func cost(_ p : CGPoint) -> CGFloat{
        var sum = 0.0
        for dataPoint in data {
            sum = sum + KMediods.distance(p, dataPoint)
        }
        return sum
    }
    
}


struct RandomNumberGeneratorWithSeed: RandomNumberGenerator {
    init(seed: Int) {
        srand48(seed)
    }
    
    func next() -> UInt64 {
        return withUnsafeBytes(of: drand48()) { bytes in
            bytes.load(as: UInt64.self)
        }
    }
}
var gen = RandomNumberGeneratorWithSeed(seed:28)
let numPoints = 100
var data : [CGPoint] = []
for _ in 1...numPoints / 2 {
    let randNum1 = CGFloat.random(in: 1..<40,using: &gen)
    let randNum2 = CGFloat.random(in: 1..<40,using: &gen)
    data.append(CGPoint(x: randNum1, y: randNum2))
}

for _ in 1...numPoints / 2 {
    let randNum1 = CGFloat.random(in: 60..<100,using: &gen)
    let randNum2 = CGFloat.random(in: 60..<100,using: &gen)
    data.append(CGPoint(x: randNum1, y: randNum2))
}

let km = KMediods(data: data)

km.labelClusters(numClusters: 2).count
