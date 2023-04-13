//
//  AssignmentsViewController.swift
//  Assignment
//
//  Created by Khalil Mhelheli on 13/4/2023.
//

import UIKit

class AssignmentsViewController: UIViewController {
    
    var assignments: [Assignment] = []
    var devloperTags: [String] = []
    
    @IBOutlet var assignmentLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    

    var questions = [Question(id: 1, title: "my program is too slow please help", tags: ["CI/CD", "ai"]), Question(id: 3, title: "my dependency injection stack trace is strange", tags: ["java", "oop"]), Question(id: 4, title: "socket.recv is freezing", tags: ["python", "react native"])]
    
    var developers = [Developer(name: "Khalil", tags: ["iOS", "Swift", "CI/CD"]), Developer(name: "Oussama", tags: ["java", "kotlin"]), Developer(name: "Fakri", tags: ["java", "react native"])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerCell()
        assignments = assignQuestionsToVolunteers(questions: questions, volunteers: developers)
        print(assignments)
        var tags = getTagsFrom(questions: questions)
        assignmentLabel.text = tags.joined(separator: ", ")
        devloperTags = getTagsFrom(developers: developers)
        print(devloperTags)
    }
    
    private func  getTagsFrom(questions: [Question]) -> [String] {
        let tags: [String] = questions.flatMap { $0.tags }
        return tags
    }
    
    private func  getTagsFrom(developers: [Developer]) -> [String] {
        let tags: [String] = developers.flatMap { $0.tags }
        return tags
    }
    
    
    /// register tableViewCel
    private func registerCell() {
        tableView.register(UINib(nibName: "AssignmentCellTableViewCell", bundle: Bundle(for: self.classForCoder)), forCellReuseIdentifier: "AssignmentCellTableViewCell")
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

extension AssignmentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentCellTableViewCell", for: indexPath) as? AssignmentCellTableViewCell else { return UITableViewCell()}
        var developerTags = getTagsFrom(Developer: developers).joined(separator: " #")
        cell.devNameLabel.text = assignments[indexPath.row].volunteer
        
        cell.tagsLabel.text = getTagsFrom(Developer: developers).joined(separator: " #")
        cell.statusImage.image = UIImage(named: "GreenDot")
        return cell
    }
    
    
}
