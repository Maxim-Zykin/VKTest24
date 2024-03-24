//
//  ViewController.swift
//  VKTest24
//
//  Created by Максим Зыкин on 23.03.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var numberOfPerson: UITextField!
    @IBOutlet weak var infectionFactor: UITextField!
    @IBOutlet weak var period: UITextField!
    @IBOutlet weak var start: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func inputValidation() {
        if let people = Int(numberOfPerson.text ?? ""),
           let speed = Int(infectionFactor.text ?? ""),
           let time = Int(period.text ?? ""),
           people >= 0 && speed >= 0  && time >= 0 {
            start?.isEnabled = true
        } else {
            start?.isEnabled = false
        }
    }
    
    @IBAction func startButton(_ sender: Any) {
        guard let people = Int(numberOfPerson.text ?? ""),
              let speed = Int(infectionFactor.text ?? ""),
              let time = Int(period.text ?? ""),
              people >= 0 && speed >= 0  && time >= 0 else {
            inputValidation()
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VisualizationVC") as! VisualizationVC
        let dataSource = createDataSource(people)
        let modelVirus = ModelVirus()
        vc.people = dataSource
        modelVirus.setup(period: time, speed: speed)
        vc.modelVirus = modelVirus
        clearInput()
        present(vc, animated: true)
    }
    
    func createDataSource(_ people: Int) -> [Person] {
        var dataSource: [Person] = []
        for i in 0..<people {
            dataSource.append(Person(name: "\(i + 1)"))
        }
        return dataSource
    }
    
    func clearInput() {
        numberOfPerson.text?.removeAll()
        infectionFactor.text?.removeAll()
        period.text?.removeAll()
    }

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        inputValidation()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

