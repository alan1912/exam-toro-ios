import UIKit
import CoreData

class MemberViewController: UIViewController {

    private var members: [Member] = []

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var tableView: UITableView!

    @IBAction func AddButtonAction(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "memberAddVC") as? MemberFormViewController {
            self.navigationController?.pushViewController (vc, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }

    private func setupView() {
        navigationItem.title = NSLocalizedString("TitleList", comment: "List")
    }

    private func loadData() {
        getList()
        tableView.reloadData()
    }

    private func getList() {
        do {
            let results = try context.fetch(NSFetchRequest<Member>(entityName: "Member"))
            members = results
            print(members)
        } catch {
            fatalError("Failed to fetch data: \(error)")
        }
    }

    private func deleteRow(member: Member) {
        context.delete(member)
        do {
            try context.save()
        }
        catch {
            fatalError("Failed to delete data: \(error)")
        }
    }
}

extension MemberViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberTableVC", for: indexPath) as? MemberTableViewCell else {
            fatalError("The dequeued cell is not an instance of MemberTableViewCell")
        }
        cell.member = self.members[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let member = self.members[indexPath.row]
            let name = member.name ?? ""
            let alert = UIAlertController(title: NSLocalizedString("BtnDelete", comment: "Delete"), message: "Delete \(name)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("BtnCancel", comment: "Cancel"), style: .default) { action in
                alert.dismiss(animated: true)
            })
            alert.addAction(UIAlertAction(title: NSLocalizedString("BtnDelete", comment: "Delete"), style: .default) { action in
                self.deleteRow(member: member)
                self.members.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension MemberViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "memberAddVC") as? MemberFormViewController {
            let member = self.members[indexPath.row]
            vc.member = member
            self.navigationController?.pushViewController (vc, animated: true)
        }
    }
}
