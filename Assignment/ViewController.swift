//
//  ViewController.swift
//  Assignment
//
//  Created by Khalil Mhelheli on 13/4/2023.
//

import UIKit

class ViewController: UIViewController {
    
    var assignments: [Assignment] = []

    @IBOutlet var assignmentLabel: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        assignments = assignQuestionsToVolunteers(questions: [Question(id: 1, title: "my program is too slow please help", tags: ["CI/CD", "ai"]), Question(id: 3, title: "my dependency injection stack trace is strange", tags: ["java", "oop"]), Question(id: 4, title: "socket.recv is freezing", tags: ["python", "react native"])], volunteers: [Developer(name: "Khalil", tags: ["iOS", "Swift", "CI/CD"]), Developer(name: "Oussama", tags: ["java", "kotlin"]), Developer(name: "Fakri", tags: ["java", "react native"])])
        print(assignments)
        assignmentLabel.text = assignments.compactMap { $0.volunteer }.joined(separator: ", ")

    }
    

    
    func assignQuestionsToVolunteers(questions: [Question], volunteers: [Developer]) -> [Assignment] {
        var assignments =  [Assignment]()
        
        // idea: tags shared between multiple volunteers get minor rating.
        // questions with tags that can be assigned to 1 volunteer only, should be assigned first
        var questionsCopy = questions
        var volunteersCopy = volunteers
        print(volunteers)
        let tags: [String] = volunteers.flatMap { $0.tags }
        print(tags)
        let mappedItems = tags.map { ($0, 1) }
        let tagRatings = Dictionary(mappedItems, uniquingKeysWith: +)
        for tag in tagRatings.sorted(by: { $0.value < $1.value }) {
            if let questionIdx = questionsCopy.firstIndex(where: { $0.tags.contains(tag.key) })
                , let volunteerIdx = volunteersCopy.firstIndex(where: { $0.tags.contains(tag.key) }) {
                assignments.append(Assignment(question: questionsCopy[questionIdx].id, volunteer: volunteersCopy[volunteerIdx].name))
                questionsCopy.remove(at: questionIdx)
                volunteersCopy.remove(at: volunteerIdx)
            }
        }
        
        return assignments
    }


}


struct Question {
    let id: Int
    let title: String
    let tags: [String]
}

struct Developer {
    let name: String
    let tags: [String]
}

struct Assignment {
    let question: Int
    let volunteer: String
}

