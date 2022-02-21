class KMediods {
    
    var data : [CGPoint] = []
    var distances : [[CGFloat] : CGFloat] = [:]
    
    init(data : [CGPoint]) {
        self.data = data
        
        for p in data {
            distances[[p.x, p.y]] = self.cost(p)
        }
    }
    
    public func labelClusters(numClusters : Int, numIterations: Int) -> [Double] {
        var mediods : [Int] = []
        for _ in 1...numClusters {
            var randomIdx = Int.random(in: 0..<data.count)
            
            while mediods.contains(randomIdx) {
                randomIdx = Int.random(in: 0..<data.count)
            }
            
            mediods.append(randomIdx)
        }
        
        var labels : [Double] = []
        for _ in 1...numIterations {
            // labeling points
            labels = []
            for point in data {
                let distances = mediods.map { mediodIdx in
                    return KMediods.distance(data[mediodIdx],point)
                }
                let shortestIdx = distances.firstIndex(of: distances.min()!)
                labels.append(Double(shortestIdx!))
            }
            
            // use the labels + points to come up with new mediods
            mediods = []
            for clusterID in 0..<numClusters {
                
                var clusterIndices : [Int] = []
                
                let clusterID = Double(clusterID)
                for i in 0..<labels.count {
                    if clusterID == labels[i] {
                        clusterIndices.append(i)
                    }
                }
                
                var newestMediodIdx = clusterIndices[0]
                for clusterIndex in clusterIndices {
                    let clusterPoint = data[clusterIndex]
                    
                    // find the newest mediod
                    if self.fastCost(clusterPoint) < self.fastCost(data[newestMediodIdx]) {
                        newestMediodIdx = clusterIndex
                    }
                }
                mediods.append(newestMediodIdx)
            }
        }
        
        return labels.map { $0 / Double(numClusters)}
        
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
    
    public func fastCost(_ p : CGPoint) -> CGFloat {
        return self.distances[[p.x, p.y]]!
    }
    
}
