//
//  Virus.swift
//  VKTest24
//
//  Created by Максим Зыкин on 23.03.2024.
//

import Foundation

class ModelVirus {
    let queueUI: DispatchQueue
    let queueCalculation: DispatchQueue
    var scheduler: DispatchSourceTimer?
    var period: Int
    var speed: Int
    weak var collectionVC: VisualizationVC?
    var dataSource: [Person]?
    
    init() {
        queueUI = DispatchQueue.main
        queueCalculation = DispatchQueue.global()
        period = 0
        speed = 0
    }
    
    func setup(period: Int, speed: Int) {
        self.period = period
        self.speed = speed
    }
    
    func bindVC(vc: VisualizationVC) {
        collectionVC = vc
        dataSource = vc.people
    }
    
    func start() {
        guard period > 0 && speed > 0 else { return }
        scheduler = DispatchSource.makeTimerSource(flags: [], queue: queueCalculation)
        scheduler?.schedule(deadline: .now() + DispatchTimeInterval.seconds(period), repeating: Double(period))
        scheduler?.setEventHandler { [self] in
            guard let inRow = collectionVC?.cellsInRow,
                  let end = dataSource?.count
            else { return }
            var idOfInfected: [Int] = []
            for i in 0..<end  {
                if !dataSource![i].healthy {
                    idOfInfected.append(i)
                }
            }
            let idForInfection = simulateInfection(idOfInfected, inRow, end)
            idForInfection.forEach() {
                id in
                dataSource![id].healthy = false
            }
            queueUI.async {
                self.collectionVC?.updateDiffableDataSource()
            }
        }
        scheduler?.resume()
    }
    
    func simulateInfection(_ idOfInfected: [Int], _ inRow: Int, _ elements: Int) -> Set<Int> {
        var ans: Set<Int> = []
        idOfInfected.forEach() {
            id in
            ans.formUnion(fillPotentialId(id, inRow, elements))
        }
        return ans
    }
    
    func fillPotentialId(_ id: Int, _ inRow: Int, _ elements: Int) -> [Int] {
        var possible: [Int] = []
        possible.append(id - inRow)
        possible.append(id - inRow - 1)
        possible.append(id - inRow + 1)
        possible.append(id + inRow)
        possible.append(id + inRow - 1)
        possible.append(id + inRow + 1)
        possible.append(id - 1)
        possible.append(id + 1)
        possible = possible.filter() {
            idNear in
            guard idNear >= 0 && idNear < elements else { return false }
            if (id % inRow == 0 && idNear % inRow == inRow - 1)
                || (id % inRow == inRow - 1 && idNear % inRow == 0) {
                return false
            }
            return true
        }
        possible.shuffle()
        if possible.count - min(8, speed) > 0 {
            possible.removeLast(possible.count - min(8, speed))
        }
        return possible
    }
    
    func stop() {
        dataSource = nil
        collectionVC = nil
        scheduler?.cancel()
    }
}
