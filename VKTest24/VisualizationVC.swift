//
//  VisualizationVC.swift
//  VKTest24
//
//  Created by Максим Зыкин on 23.03.2024.
//

import UIKit

class VisualizationVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    enum Section {
        case first
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Person>
    
    public lazy var dataSource = makeDataSource()
    
    var people: [Person]!
    var modelVirus: ModelVirus?
    var cellsInRow: Int = 6
    
    func makeDataSource() -> DataSource {
      let dataSource = DataSource( collectionView: collectionView, cellProvider: { (collectionView, indexPath, person) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VisualizationCell", for: indexPath) as! VisualizationCell
            cell.configureCell(person: person)
            return cell
      })
      return dataSource
    }
    
    func updateDiffableDataSource(animatingDifferences: Bool = false) {
        DispatchQueue.main.async { [self] in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Person>()
            snapshot.appendSections([.first])
            snapshot.appendItems(people)
            
            dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
           collectionView.reloadData()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        modelVirus?.stop()
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsSelection = true
        collectionView.isUserInteractionEnabled = true
        updateDiffableDataSource(animatingDifferences: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        modelVirus?.bindVC(vc: self)
        modelVirus?.start()

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let person = dataSource.itemIdentifier(for: indexPath) else { return }
        DispatchQueue.main.async {
            person.healthy = false
            self.updateDiffableDataSource()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = collectionView.bounds.width / CGFloat(cellsInRow)
        return CGSize(width: side - 10, height: side - 10)
    }
}
