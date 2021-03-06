import UIKit

class DetailedReportCell: UITableViewCell
{
    
    @IBOutlet var details: UILabel!
    @IBOutlet var cellView: UIView!
    @IBOutlet weak var outlien: UIView!
    @IBOutlet var amount: UITextField!
    @IBOutlet var number: UITextField!
    
    override func awakeFromNib() {
        backgroundColor = UIColor.clear
        cellView.layer.cornerRadius = 10
        cellView.clipsToBounds = true
        outlien.layer.cornerRadius = 10
        outlien.clipsToBounds = true
    }
}
