import UIKit
import CoreData

class MemberFormViewController: UIViewController {

    public var member: Member? = nil

    private let genderPickerView = UIPickerView()
    private let genders: [Genders] = [Genders(key: 0), Genders(key: 1)]
    private var gender: Genders = Genders(key: 0)

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!

    @IBAction func sendButtonAction(_ sender: Any) {
        guard let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              name.count > 0 else {
            self.presentAlert(title: NSLocalizedString("ValidNotBlankName", comment: "Please enter your name"))
            return
        }
        guard let age = ageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              age.count > 0 else {
            self.presentAlert(title: NSLocalizedString("ValidNotBlankAge", comment: "Please enter your age"))
            return
        }
        guard let gender = genderTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              gender.count > 0 else {
            self.presentAlert(title: NSLocalizedString("ValidNotBlankGender", comment: "Please enter your gender"))
            return
        }

        if let member = self.member {
            update(member: member)
        } else {
            create()
        }

        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    @objc func action() {
        view.endEditing(true)
        genderTextField.text = self.gender.value
    }

    private func setupView() {
        setupGenderPickView()

        nameTextField.placeholder = NSLocalizedString("NamePlaceholder", comment: "Please enter your name")
        ageTextField.placeholder = NSLocalizedString("AgePlaceholder", comment: "Please enter your age")
        genderTextField.placeholder = NSLocalizedString("GenderPlaceholder", comment: "Please enter your gender")

        if self.member != nil {
            navigationItem.title = NSLocalizedString("TitleEdit", comment: "Edit")
            sendBtn.setTitle(NSLocalizedString("BtnEdit", comment: "Edit"), for: .normal)
            if let member = self.member {
                nameTextField.text = member.name
                ageTextField.text = String(member.age)
                
                self.gender = Genders(key: Int(member.gender))
                genderPickerView.selectRow(self.gender.key, inComponent: 0, animated: true)
                genderTextField.text = self.gender.value
            }
        } else {
            navigationItem.title = NSLocalizedString("TitleAdd", comment: "Add")
            sendBtn.setTitle(NSLocalizedString("BtnAdd", comment: "Add"), for: .normal)
        }
    }

    private func setupGenderPickView() {
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderPickerView.backgroundColor = .white
        genderTextField.inputView = genderPickerView

        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.backgroundColor = .white
        let button = UIBarButtonItem(title: NSLocalizedString("BtnOk", comment: "Ok"), style: .plain, target: self, action: #selector(self.action))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([flexibleSpace, button], animated: true)
        toolBar.isUserInteractionEnabled = true
        genderTextField.inputAccessoryView = toolBar
    }

    private func update(member: Member) {
        member.name = nameTextField.text
        member.age = Int32(ageTextField.text ?? "") ?? 0
        member.gender = Int16(self.gender.key)
        do {
            try context.save()
        } catch {
            fatalError("Failed to fetch data: \(error)")
        }
    }
    
    private func create() {
        let member = Member(context: context)

        let myUserDefaults = UserDefaults.standard
        var seq: Int32 = 1
        if let idSeq = myUserDefaults.object(forKey: "idSeq") as? Int32 {
            seq = idSeq + 1
        }

        member.id = seq
        member.name = nameTextField.text
        member.age = Int32(ageTextField.text ?? "") ?? 0
        member.gender = Int16(self.gender.key)
        do {
            try context.save()
        } catch {
            fatalError("\(error)")
        }
    }
}

extension MemberFormViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row].value
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.gender = self.genders[row]
    }
}
