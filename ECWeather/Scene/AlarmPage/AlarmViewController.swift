//
//  AlarmViewController.swift
//  ECWeather
//
//  Created by t2023-m0056 on 2023/09/25.
//

import SnapKit
import UIKit

class AlarmViewController: UIViewController {
    
    // MARK: - Properties
    private let weekdays: [String] = ["일","월","화","수","목","금","토"]
    private var headerLabelColor: UIColor? = UIColor(red: 0.00, green: 0.80, blue: 1.00, alpha: 1.00)
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "날씨 알림"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .ECWeatherColor3
        return label
    }()
    
    private let notificationSwitch: UISwitch = {
        let notificationSwitch = UISwitch()
        notificationSwitch.isOn = true
        notificationSwitch.onTintColor = .ECWeatherColor3
        notificationSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        return notificationSwitch
    }()
    
    private let timePicker: UIDatePicker = {
        let pickerView = UIDatePicker()
        pickerView.datePickerMode = .time
        pickerView.preferredDatePickerStyle = .wheels
        pickerView.locale = Locale(identifier: "en_US")
        pickerView.tintColor = .ECWeatherColor3 // TODO: - tintColor 안먹음..
        pickerView.backgroundColor = .ECWeatherColor4?.withAlphaComponent(0.3)
        return pickerView
    }()

    private let weekdaysBtnLabel: UILabel = {
        let label = UILabel()
        label.text = "요일별 알림"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .ECWeatherColor3
        return label
    }()
    
    private let weekdaysBtnStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Methods & Selectors
    private func configureUI() {
        view.backgroundColor = .white
        
        makeWeekdaysBtnStack()
        configureTableView()
        view.addSubview(titleLabel)
        view.addSubview(notificationSwitch)
        view.addSubview(timePicker)
        view.addSubview(weekdaysBtnLabel)
        view.addSubview(weekdaysBtnStack)
        view.addSubview(tableView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(25)
        }
        
        notificationSwitch.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().offset(-35)
        }
        
        timePicker.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-100)
        }
        
        weekdaysBtnLabel.snp.makeConstraints {
            $0.top.equalTo(timePicker.snp.bottom).offset(25)
            $0.leading.equalToSuperview().offset(30)
        }
        
        weekdaysBtnStack.snp.makeConstraints {
            $0.top.equalTo(weekdaysBtnLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
//            $0.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(weekdaysBtnStack.snp.bottom)
//            $0.top.equalTo(weekdaysBtnStack.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func makeWeekdaysBtnStack() {
        for day in weekdays {
            let button = UIButton(type: .custom)
            button.setTitle(day, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.backgroundColor = .ECWeatherColor4?.withAlphaComponent(0.3)
            button.addTarget(self, action: #selector(weekdaysButtonTapped), for: .touchUpInside)
            
            button.bounds = CGRect(x: 0, y: 0, width: 25, height: 50) // TODO: - 원형 만들기
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            
            weekdaysBtnStack.addArrangedSubview(button)
        }
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        tableView.separatorStyle = .none
    }
    
    @objc private func weekdaysButtonTapped(sender: UIButton) {
        if notificationSwitch.isOn {
            if sender.backgroundColor == .ECWeatherColor4?.withAlphaComponent(0.3) {
                sender.backgroundColor = .ECWeatherColor3?.withAlphaComponent(0.5)
                // TODO: - 요일 눌렀을때 이벤트 처리
            } else {
                sender.backgroundColor = .ECWeatherColor4?.withAlphaComponent(0.3)
            }
        } else {
            sender.backgroundColor = .ECWeatherColor4?.withAlphaComponent(0.3)
        }
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            timePicker.isEnabled = true
            weekdaysBtnLabel.textColor = .ECWeatherColor3
            headerLabelColor = UIColor(red: 0.00, green: 0.80, blue: 1.00, alpha: 1.00)
            tableView.reloadData()
        } else {
            timePicker.isEnabled = false
            weekdaysBtnLabel.textColor = .systemGray4
            headerLabelColor = .systemGray4
            tableView.reloadData()
           
        }
    }
}

// MARK: - TableView
extension AlarmViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
//        headerView.backgroundColor = .white
//        
        let headerLabel = UILabel()
        headerLabel.font = UIFont.boldSystemFont(ofSize: 10)
        headerLabel.textColor = headerLabelColor
        headerView.addSubview(headerLabel)
        
        if section == 0 {
            headerLabel.text = "사운드"
        } else if section == 1 {
            headerLabel.text = "알림 내용 선택"
        }

        headerLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)

        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = .black
        cell.backgroundColor = .ECWeatherColor4?.withAlphaComponent(0.3)
        cell.selectionStyle = .none


        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "알람 소리"
                cell.layer.cornerRadius = 10
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "날씨" // 현재 밖에 날씨는 ~~(맑음)입니다
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "온도" // 현재 밖에 날씨는 ~~(18)도이고 체감온도는 ~~(25)입니다.
            }
            cell.layer.cornerRadius = 10
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if notificationSwitch.isOn {
            if indexPath.section == 0 && indexPath.row == 0 {
                print("알람 소리 cell 터치 이벤트 들어옴!!")
            } else if indexPath.section == 1 && indexPath.row == 0 {
                print("날씨 cell 터치 이벤트 들어옴!! ")
            } else if indexPath.section == 1 && indexPath.row == 1 {
                print("온도 cell 터치 이벤트 들어옴!! ")
            }
        }
    }
    
}

