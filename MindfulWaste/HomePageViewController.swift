import UIKit
import SideMenuController
import Charts
import FirebaseDatabase

class HomePageViewController : UIViewController
{


    @IBOutlet weak var pieChart: PieChartView!
    let categories = ["Fruits", "Vegetables", "Dry Goods", "Dairy", "Misc."]
    var amountArray = [0,0,0,0,0]
    
    
    var amount = 0
    var fruitsAmount = 0
    var vegetablesAmount = 0
    var dryGoodsAmount = 0
    var dairyAmount = 0
    var miscAmount = 0
    @IBOutlet weak var amountCO2e: UILabel!
    
    override func viewDidLoad() {
        pieChart.backgroundColor = UIColor.clear
        pieChart.animate(xAxisDuration: 1)
        let ref = Database.database().reference(withPath: "reports")
        ref.observe(.value, with: { snapshot in
   
            self.dairyAmount = 0
            self.fruitsAmount = 0
            self.vegetablesAmount = 0
            self.dryGoodsAmount = 0
            self.miscAmount = 0
            self.amount = 0

            
            //maybe will crash here, did not test code, *praying that it works*
            
            for child in snapshot.children
            {
                let dict = (child as! DataSnapshot).value as! NSDictionary
                if let num = (dict["dairyInformation"] as! NSDictionary)["dairyAmount"]! as? Int
                {
                    self.dairyAmount += num
                }
                if let num = (dict["fruitInformation"] as! NSDictionary)["fruitAmount"]! as? Int                {
                    self.fruitsAmount += num
                }
                if let num = (dict["vegetableInformation"] as! NSDictionary)["vegetableAmount"]! as? Int
                {
                    self.vegetablesAmount += num
                }
                if let num = (dict["dryGoodsInformation"] as! NSDictionary)["dryGoodsAmount"]! as?Int                {
                    self.dryGoodsAmount += num
                }
                if let num = (dict["miscInformation"] as! NSDictionary)["miscAmount"]! as? Int

                {
                    self.miscAmount += num
                }
                self.amount = self.dairyAmount + self.fruitsAmount + self.vegetablesAmount + self.miscAmount + self.dryGoodsAmount
                print(self.amount)
            }
            
            
            self.amountArray[0] = self.fruitsAmount
            self.amountArray[1] = self.vegetablesAmount
            self.amountArray[2] = self.dryGoodsAmount
            self.amountArray[3] = self.dairyAmount
            self.amountArray[4] = self.miscAmount
            self.setPieChart(xVals: self.amountArray, yVals: self.categories)
            self.amountCO2e.text! = "\(self.amount/5) lbs."
            
        })
    }
    
    
    @IBAction func showLiveFeed(_ sender: AnyObject) {
        sideMenuController?.performSegue(withIdentifier: "showLiveFeed", sender: nil)
    }
    
    
    func setPieChart(xVals: [Int], yVals: [String])
    {
        var dataEntries: [PieChartDataEntry] = []
        let colors1 = [UIColor.red, UIColor.green, UIColor.yellow, UIColor.lightGray, UIColor.orange]
        var setColors : [UIColor] = []
        
        for i in 0..<xVals.count {
            if xVals[i] != 0
            {
                let dataEntry = PieChartDataEntry(value: Double(xVals[i]))
                dataEntries.append(dataEntry)
                setColors.append(colors1[i])
                
            }
        }
        
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "Category")
        let chartData = PieChartData(dataSet: chartDataSet)

        chartDataSet.colors = setColors
        pieChart.chartDescription?.text! = ""

        let centerText = NSAttributedString(string: "\(amount)", attributes: [ kCTFontAttributeName as NSAttributedStringKey: UIFont(name: "Futura", size: 36)! ])
        pieChart.centerAttributedText = centerText
        pieChart.data = chartData
    }
    
    
}
