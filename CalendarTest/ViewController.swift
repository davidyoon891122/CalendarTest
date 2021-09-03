//
//  ViewController.swift
//  CalendarTest
//
//  Created by David Yoon on 2021/09/02.
//

import UIKit

class ViewController: UIViewController {

    private var prevButton:UIButton = {
        let button = UIButton()
        button.setTitle("Prev", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(prevAction), for: .touchUpInside)
        return button
    }()
    
    
    private var displayMonthLabel:UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .red
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return button
    }()
    
    @objc func prevAction() {
        components.month = components.month! - 1
        self.calculation()
        self.collectionView.reloadData()
    }
    
    @objc func nextAction() {
        components.month = components.month! + 1
        self.calculation()
        self.collectionView.reloadData()
    }
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    let now = Date()
    var cal = Calendar.current
    let dateFormatter = DateFormatter()
    var components = DateComponents()
    var weeks:[String] = ["일","월","화","수","목","금","토"]
    var days:[String] = []
    var daysCountInMonth = 0 // 해당 월이 며칠까지 있는지
    var weekDayAdding = 0 // 시작일
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView.backgroundColor = .blue
        initView()
        
        
    }
    
    private func initView() {
        view.addSubview(prevButton)
        view.addSubview(displayMonthLabel)
        view.addSubview(nextButton)
        view.addSubview(collectionView)
        setUILayout()
        self.initCollection()
        
        dateFormatter.dateFormat = "yyyy년 M월"
        components.year = cal.component(.year, from: now)
        components.month = cal.component(.month, from: now)
        components.day = 1
        self.calculation()
    }
    
    private func calculation() {
        let firstDayOfMonth = cal.date(from: components)
        print(components)
        
        
        let firstWeekDay = cal.component(.weekday, from: firstDayOfMonth!) // 해당 수로 반환이 됩니다. 1은 일요일 ~ 7은 토요일
        daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        weekDayAdding = 2 - firstWeekDay // 이 과정을 해주는 이유는 예를 들어 2020년 4월이라 하면 4월 1일은 수요일 즉, 수요일이 달의 첫날이 됩니다.  수요일은 component의 4 이므로 CollectionView에서 앞의 3일은 비울 필요가 있으므로 인덱스가 1일부터 시작할 수 있도록 해줍니다. 그래서 2 - 4 해서 -2부터 시작하게 되어  정확히 3일 후부터 1일이 시작하게 됩니다.
        self.displayMonthLabel.text = dateFormatter.string(from: firstDayOfMonth!)
        self.days.removeAll()
        for day in weekDayAdding...daysCountInMonth {
            if day < 1 {
                self.days.append("")
            } else {
                self.days.append(String(day))
            }
        }
    }
    
    
    private func initCollection() {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "CalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "calendarCell")
        
    }
  
    
    private func setUILayout() {
        prevButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        prevButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        prevButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        prevButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        displayMonthLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        displayMonthLabel.leftAnchor.constraint(equalTo: prevButton.rightAnchor, constant: 0).isActive = true
        displayMonthLabel.rightAnchor.constraint(equalTo: nextButton.leftAnchor, constant: 0).isActive = true
        displayMonthLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        nextButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: displayMonthLabel.bottomAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        
        
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCollectionViewCell
        
        switch indexPath.section {
        case 0:
            cell.dateLabel.text = weeks[indexPath.row]
        default:
            cell.dateLabel.text = days[indexPath.row]
        }
        
        if indexPath.row % 7 == 0 { //일요일
            cell.dateLabel.textColor = .red
        } else if indexPath.row % 7 == 6 {
            cell.dateLabel.textColor = .blue
        } else {
            cell.dateLabel.textColor = .black
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7 // 요일의 수는 고정
        default:
            return self.days.count // 일의 수
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let myBoundSize:CGFloat = UIScreen.main.bounds.size.width
        let cellSize:CGFloat = myBoundSize/9
        return CGSize(width: cellSize, height: cellSize)
    }
}
