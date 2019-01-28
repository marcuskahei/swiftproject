// control the promotion view
// search bar result table view
// control the navigationBar & searchBar


import UIKit

class ViewController: UIViewController {
    
    private let reuseIdentifier = "promotionId"
    private let reuseSearchCellIdentifier = "searchId"
    var scrollingTimer = Timer()
    var dataSource = [itemCategory]()
    var filteredDataSource = [itemCategory]()

    var promotioImgArr = [promotionImages]()

    // let's avoid polluting viewDidLoad
    // {} is referred to as closure, or anon. functions
    let bearImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "bear_first"))
        // this enables autolayout for our imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        
        let attributedText = NSMutableAttributedString(string: "Join us today in our fun and games!", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18)])
        attributedText.append(NSAttributedString(string: "\n\n\nAre you ready for loads and loads of fun? Don't wait any longer! We hope to see you in our lesson soon.", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13)]))
        
        textView.attributedText = attributedText
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let containerSubview: UIView = {
        let containerSubview = UIView()
        containerSubview.backgroundColor = .red
        containerSubview.translatesAutoresizingMaskIntoConstraints = false
        return containerSubview
    }()
    
    let promotionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let promotionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        promotionView.translatesAutoresizingMaskIntoConstraints = false
        promotionView.isPagingEnabled = true
        promotionView.showsHorizontalScrollIndicator = false
        return promotionView
    }()
    
    // Trick
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = promotioImgArr.count
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .gray
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    // searchBar & navigationBar
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .blackOpaque
        searchBar.tintColor = UIColor.white
        searchBar.placeholder = "Search by name"
        searchBar.frame = CGRect(x: 10, y: 35, width: 255, height: 50)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let navbarBtn1: UIButton = {
        let navbarBtn1 = UIButton(type: .system)
        navbarBtn1.frame = CGRect(x: 0, y:0, width: 40, height: 40)
        navbarBtn1.imageView?.contentMode = .scaleAspectFit
        navbarBtn1.contentVerticalAlignment = .fill
        navbarBtn1.contentHorizontalAlignment = .fill
        navbarBtn1.setImage(UIImage(named: "selected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return navbarBtn1
    }()
    
    let navbarBtn2: UIButton = {
        let navbarBtn2 = UIButton(type: .system)
        navbarBtn2.frame = CGRect(x: 0, y:0, width: 40, height: 40)
        navbarBtn2.imageView?.contentMode = .scaleAspectFit
        navbarBtn2.contentVerticalAlignment = .fill
        navbarBtn2.contentHorizontalAlignment = .fill
        navbarBtn2.setImage(UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal) , for: .normal)
        return navbarBtn2
    }()
    
    let navBarTitleView: UIImageView = {
        let image = UIImage(named: "profile")
        let navBarTitleView = UIImageView(image: image)
        navBarTitleView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        navBarTitleView.contentMode = .scaleAspectFit
        return navBarTitleView
    }()
    
    lazy var searchTableView: UITableView = {
        let searchTableView = UITableView()
        searchTableView.backgroundColor = UIColor.black
        searchTableView.frame = CGRect(x: 0 , y: 85, width: view.frame.width, height: view.frame.height - 60)
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        return searchTableView
    }()
    
    lazy var doneBtn: UIButton = {
        let doneBtn = UIButton(type: .system)
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.setTitleColor(UIColor(red:0.30, green:0.67, blue:0.67, alpha:1.0), for: .normal)
        doneBtn.titleLabel?.font = doneBtn.titleLabel?.font.withSize(20)
        doneBtn.frame = CGRect(x: view.frame.width - 80, y: 45, width: 75, height: 30)
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        return doneBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // searchBar result table view
        searchTableView.register(SearchCell.self, forCellReuseIdentifier: reuseSearchCellIdentifier)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        // navigationBar
        setupNavigationBarItems()
        dataSource = itemCategory.getItems()
        promotioImgArr = promotionImages.getItems()
        
        // promotion
        promotionView.register(PageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        promotionView.delegate = self
        promotionView.dataSource = self
        
        // add view
        view.addSubview(containerSubview)
        setupMainViewLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollingTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(scrollCollectionView), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        scrollingTimer.invalidate()
    }
    
    private func setupMainViewLayout() {
        containerSubview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerSubview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        containerSubview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerSubview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerSubview.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive = true
        containerSubview.addSubview(promotionView)
        containerSubview.addSubview(pageControl)
        
        promotionView.bottomAnchor.constraint(equalTo: containerSubview.bottomAnchor).isActive = true
        promotionView.leftAnchor.constraint(equalTo: containerSubview.leftAnchor).isActive = true
        promotionView.rightAnchor.constraint(equalTo: containerSubview.rightAnchor).isActive = true
        promotionView.topAnchor.constraint(equalTo: containerSubview.topAnchor).isActive = true
        
        pageControl.bottomAnchor.constraint(equalTo: containerSubview.bottomAnchor).isActive = true
        pageControl.leftAnchor.constraint(equalTo: containerSubview.leftAnchor).isActive = true
        pageControl.rightAnchor.constraint(equalTo: containerSubview.rightAnchor).isActive = true
    }

}

// control the promotion view
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return promotioImgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PageCell
        
        // Configure the cell
        cell.backgroundColor = indexPath.item % 2 == 0 ? .red : .green
        if(indexPath.item == 0) {cell.backgroundColor = .gray}
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int( x / view.frame.width)
        // reactivate when scroll manually
        scrollingTimer.invalidate()
        scrollingTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(scrollCollectionView), userInfo: nil, repeats: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: containerSubview.frame.height)
    }
    
    @objc func scrollCollectionView() {
        for cell in promotionView.visibleCells {
            guard let indexPath = promotionView.indexPath(for: cell) else {return}
            let nextPath: IndexPath
            if (indexPath.row < promotioImgArr.count - 1) {
                nextPath = IndexPath.init(row: indexPath.row + 1, section: indexPath.section)
                promotionView.scrollToItem(at: nextPath, at: .right, animated: true)
            } else {
                nextPath = IndexPath.init(row: 0, section: indexPath.section)
                promotionView.scrollToItem(at: nextPath, at: .centeredHorizontally, animated: true)
            }
            pageControl.currentPage = nextPath.row
        }
    }
}


// control the navigationBar & searchBar
extension ViewController: UISearchBarDelegate {
    
    @objc func pressed(sender: UIButton!) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        backgroundBlur()
    }
    
    @objc func cancelSearch(sender: UIButton!){
        if let viewWithTag = self.view.viewWithTag(1) {
            viewWithTag.removeFromSuperview()
        }
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupNavigationBarItems () {
        setupNavBarLeftItms()
        setupNavBarRightItms()
        setupNavBarRemainingItms()
    }
    
    private func setupNavBarLeftItms () {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: navBarTitleView)
    }
    
    private func setupNavBarRightItms () {
        let searchBtn = navbarBtn1
        searchBtn.addTarget(self, action: #selector(self.pressed), for: .touchUpInside)
        
        let profileBtn = navbarBtn2
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: searchBtn) , UIBarButtonItem.init(customView: profileBtn)]
    }
    
    private func setupNavBarRemainingItms(){
        // change the background color of nav bar
        navigationController?.navigationBar.barTintColor = UIColor(red:0.23, green:0.49, blue:0.45, alpha:1.0)
    }
    
    private func backgroundBlur() {
        searchBar.delegate = self
        doneBtn.addTarget(self, action: #selector(self.cancelSearch), for: .touchUpInside)
        
        setupSearchBarViewLayout()
    }
    
    private func setupSearchBarViewLayout() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.frame = view.bounds
        
        self.view.addSubview(visualEffectView)
        
        visualEffectView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        visualEffectView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        visualEffectView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        visualEffectView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        visualEffectView.contentView.addSubview(searchBar)
        visualEffectView.contentView.addSubview(doneBtn)
        visualEffectView.contentView.addSubview(searchTableView)
        visualEffectView.alpha = 0
        visualEffectView.tag = 1

        searchBar.topAnchor.constraint(equalTo: visualEffectView.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        searchBar.leftAnchor.constraint(equalTo: visualEffectView.leftAnchor, constant: 10).isActive = true
        searchBar.widthAnchor.constraint(equalTo: visualEffectView.widthAnchor, multiplier: 0.7).isActive = true
        
        doneBtn.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        doneBtn.leftAnchor.constraint(equalTo: searchBar.rightAnchor, constant: 20).isActive = true
        
        searchTableView.centerXAnchor.constraint(equalTo: visualEffectView.centerXAnchor).isActive = true
        searchTableView.heightAnchor.constraint(equalTo: visualEffectView.heightAnchor).isActive = true
        searchTableView.widthAnchor.constraint(equalTo: visualEffectView.widthAnchor).isActive = true
        searchTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10).isActive = true
        searchTableView.leftAnchor.constraint(equalTo: visualEffectView.leftAnchor).isActive = true
        searchTableView.rightAnchor.constraint(equalTo: visualEffectView.rightAnchor).isActive = true
        
        
        UIView.animate(withDuration: 0.3) {
            visualEffectView.alpha = 0.75
        }
    }
}

// search bar result table view
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dataSource.count)
        return searchBar.text != "" ? self.filteredDataSource.count : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseSearchCellIdentifier, for: indexPath) as! SearchCell
        
        var source = searchBar.text != "" ? filteredDataSource : dataSource
        
        guard let title = source[indexPath.row].title, title != "" else{ return cell }
        guard let iconName = source[indexPath.row].icon, iconName != "" else{ return cell }
        
        
        cell.itemLabel.text = title
        cell.itemImageView.image = UIImage(named: iconName)
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredDataSource = self.dataSource.filter({ (item: itemCategory) -> Bool in
            return item.title?.lowercased().range(of: searchText.lowercased()) != nil
        })
        self.searchTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select row at indexPath: ", indexPath)
    }
}












