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
    
//    var isExpired = false {
//        didSet {
//            self.prsentPopup()
//        }
//    }
    
    var isExpired = false {
        didSet {
            if isExpired {
                self.prsentPopup()
            }
        }
    }
    
    
    var questions = [Question(id: 1, title: "my program is too slow please help", tags: ["CI/CD", "ai"]), Question(id: 3, title: "my dependency injection stack trace is strange", tags: ["java", "oop"]), Question(id: 4, title: "socket.recv is freezing", tags: ["python", "react native"])]
    
    var developers = [Developer(name: "Khalil", tags: ["iOS", "Swift", "CI/CD"]), Developer(name: "Oussama", tags: ["java", "kotlin"]), Developer(name: "Fakri", tags: ["java", "react native"])]
    
    var optinExpiration = OptinExpiration()
    
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
        
        let dateString = "01/01/2023"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: dateString)
        
        optinExpiration.exp = date
        
        print(isExpired)
        print(optinExpiration.isExpiredOptin)
        
        isExpired = optinExpiration.isExpiredOptin
        
//        print(optinExpiration.isExpired)
//        print(optinExpiration.expiresSoon)
        print(optinExpiration.isExpiredOptin)
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
        var volunteersCopy = developers
        print(developers)
        let tags: [String] = developers.flatMap { $0.tags }
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
    
    private func prsentPopup() {
        // Register Nib
        let newViewController = PopupVc(nibName: "PopupVc", bundle: nil)
        
        // Present View "Modally"
        self.present(newViewController, animated: true, completion: nil)
    }
    
    private func calculateDaysBetweenCurrentDateAndSavedDate(savedDate: Date) -> Int? {
        let calendar = Calendar.current
        
        // Get the current date
        let currentDate = calendar.startOfDay(for: Date())
        
        // Get the saved date
        let savedDate = calendar.startOfDay(for: savedDate)
        
        // Calculate the difference in days
        let components = calendar.dateComponents([.day], from: currentDate, to: savedDate)
        return components.day
    }
}

extension AssignmentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentCellTableViewCell", for: indexPath) as? AssignmentCellTableViewCell else { return UITableViewCell()}
        var developerTags = getTagsFrom(developers: developers).joined(separator: " #")
        cell.devNameLabel.text = assignments[indexPath.row].volunteer
        
        cell.tagsLabel.text = getTagsFrom(developers: developers).joined(separator: " #")
        cell.statusImage.image = UIImage(named: "GreenDot")
        return cell
    }
    
    
}


struct OptinExpiration {
    
    /// expiration time (seconds since epoc)
    public var exp: Date?
    
    /// True if  is expired
    public var isExpired: Bool {
        guard let exp = exp else { return false }
        return Date() >= exp
    }
    
    public var expiresSoon: Bool {
        guard let exp = exp,
              let expiresSoonDate = Calendar.current.date(byAdding: .day, value: +30, to: exp) else { return false }
        print(expiresSoonDate)
        return Date() >= expiresSoonDate
        
       
    }
    
    public var isExpiredOptin: Bool {
        let days = calculateDaysBetweenCurrentDateAndSavedDate(savedDate: exp!)
        
        return days! > 30
    }
    
    
    private func calculateDaysBetweenCurrentDateAndSavedDate(savedDate: Date) -> Int? {
        let calendar = Calendar.current
            let currentDate = Date()

            // Get the start of the current day
            let currentStartOfDay = calendar.startOfDay(for: currentDate)

            // Get the start of the saved day
            let savedStartOfDay = calendar.startOfDay(for: savedDate)

            // Calculate the difference in days
            let components = calendar.dateComponents([.day], from: savedStartOfDay, to: currentStartOfDay)

            // Retrieve the number of positive days
            guard let positiveDays = components.day, positiveDays > 0 else {
                return 0 // Return 0 if the saved date is in the future or the same as the current date
            }

            return positiveDays
    }
}
