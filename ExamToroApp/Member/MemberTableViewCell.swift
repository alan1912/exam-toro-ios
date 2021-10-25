import UIKit

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    var member: Member? {
        didSet {
            nameLabel.text = member?.name
            ageLabel.text = String(member?.age ?? 0)
            genderLabel.text = Genders(key: Int(member?.gender ?? 0)).value
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
