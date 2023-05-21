import UIKit

class ContentView: UIViewController {
    
    var contentVM = ContentViewModel()
    let dateformatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateformatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateformatter.locale = Locale(identifier: "ja_JP")
        dateformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        // 距離データを取得する関数を呼ぶ（引数は期間）
        contentVM.get(
            fromDate: dateformatter.date(from: "2020/12/01 00:00:00")!,
            toDate: dateformatter.date(from: "2021/01/01 23:59:59")!
        )
        
        setupUI()
    }
    
    func setupUI() {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        navigationController?.navigationBar.topItem?.title = "距離"
    }
}

extension ContentView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentVM.dataSource.count == 0 ? 1 : contentVM.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if contentVM.dataSource.count == 0 {
            cell.textLabel?.text = "データがありません。"
        } else {
            let item = contentVM.dataSource[indexPath.row]
            cell.textLabel?.text = "\(dateformatter.string(from: item.datetime)) \(item.value) メートル"
        }
        
        return cell
    }
}

struct DistanceData {
    let datetime: Date
    let value: Double
}

class ContentViewModel {
    @Published var dataSource: [DistanceData] = []
    
    func get(fromDate: Date, toDate: Date) {
        // 距離データの取得処理を実装する
        // dataSourceにデータを追加する
    }
}
