//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import UIKit
import PinLayout

class ArticleViewController: UIViewController {

    // MARK: properties
    
    private lazy var featureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        if let url = viewModel?.articleDisplayModel.imageURL {
            imageView.load(url: url)
        }
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .blue
        label.font = Theme.Font.roman25
        label.lineBreakMode = .byWordWrapping
        label.text = viewModel?.articleDisplayModel.title
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 17)
        label.lineBreakMode = .byWordWrapping
        label.text = viewModel?.articleDisplayModel.formattedDate
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = Theme.Font.roman25
        label.lineBreakMode = .byWordWrapping
        label.text = viewModel?.articleDisplayModel.description
        return label
    }()
    
    // MARK: - object lifecycle

    init(viewModel: ArticleViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard are a pain")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = .white
        createUI()
        layoutUI()
    }

    // MARK: - Private Functions
    
    private func createUI() {
        view.addSubview(featureImageView)
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(descLabel)
    }
    
    private func layoutUI() {

        featureImageView
            .pin
            .top().left().right()
            .width(of: view)
            .height(300)
        
        titleLabel
            .pin
            .below(of: featureImageView, aligned: .left)
            .marginLeft(15)
            .marginRight(15)
            .width(of: featureImageView).pinEdges()
            .marginTop(100)
            .sizeToFit(.width)

        dateLabel
            .pin
            .below(of: titleLabel, aligned: .left)
            .width(of: featureImageView).pinEdges()
            .marginTop(20)
            .sizeToFit(.width)
        
        descLabel
            .pin
            .below(of: dateLabel, aligned: .left)
            .right(to: featureImageView.edge.right)
            .marginRight(15)
            .marginTop(30)
            .sizeToFit(.width)
    }
    
    // MARK: - Private Properties
    
    var viewModel: ArticleViewModel?
}
