import UIKit
import SnapKit
import RxSwift
import RxCocoa
import AsyncDisplayKit

class TweetCell: UITableViewCell {

    static func heightForText(text: NSAttributedString, isRetweet: Bool) -> CGFloat
    {
        let boundingRect = text.boundingRectWithSize(CGSizeMake(TWEET_CELL_TEXT_WIDTH, CGFloat.max),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin | NSStringDrawingOptions.UsesFontLeading,
            context: nil)

        return max(
            ceil(boundingRect.size.height) + (isRetweet ? 30 : 10) + 37,
            89 + (isRetweet ? 20 : 0)) // Ensure min height
    }

    let bag = DisposeBag()

    let profileImageView = ProfileImageView(frame: CGRect(x: 12, y: 12, width: 48, height: 48))
    let timeText = TimestampView()
    let userNames = UserNames()
    let retweetedText = RetweetedText()
    let unreadIndicator = UnreadIndicator(frame: CGRect(x: 0, y: 0, width: 15, height: 15))

    let textNode = TweetTextNode()

    var heightConstraint: Constraint!
    var cellData: TweetCellData?
    var markReadTimer: Timer?
    var unreadIndicatorDisposable: Disposable?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsMake(0, 72, 0, 0)

        self.contentView.addSubview(self.profileImageView)
        self.contentView.addSubview(self.userNames)
        self.contentView.addSubview(self.timeText)
        self.contentView.addSubview(self.retweetedText)
        self.contentView.addSubview(self.unreadIndicator)
        self.contentView.addSubnode(self.textNode)

        self.timeText.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-10)
        }

        self.userNames.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(72)
            make.top.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(14)
        }

        self.retweetedText.snp_makeConstraints { make in
            make.left.equalTo(self).offset(72)
            make.bottom.equalTo(self).offset(-10)
        }

        self.contentView.snp_makeConstraints { make in
            self.heightConstraint = make.height.equalTo(0).constraint
            make.width.equalTo(self)
        }
    }

    override func prepareForReuse() {
        self.unreadIndicatorDisposable?.dispose()
        self.unreadIndicatorDisposable = nil
        self.cancelMakeReadTimer()
    }

    func loadTweet(cellData: TweetCellData, user: User) {

        self.cellData = cellData

        let isRetweet = cellData.tweet.retweeted_status != nil

        if cellData.text == nil {
            cellData.text = parseTweetText(isRetweet ? cellData.tweet.retweeted_status! : cellData.tweet)
        }

        self.heightConstraint.updateOffset(TweetCell.heightForText(cellData.text!, isRetweet: isRetweet))

        self.textNode.text = cellData.text!
        self.textNode.frame = CGRect(origin: CGPoint(x: 72, y: isRetweet ? 30 : 10), size: self.textNode.calculatedSize)
        self.timeText.text = relativeTimeString(parseTwitterTimestamp(cellData.tweet.created_at))

        if let retweetedUser = cellData.tweet.retweeted_status?.user {
            self.profileImageView.frame = CGRect(x: 12, y: 32, width: 48, height: 48)
            self.profileImageView.updateImage(retweetedUser.profile_image_url)
            self.userNames.loadNames(retweetedUser.name, screenName: retweetedUser.screen_name)
            self.userNames.hidden = false
            self.retweetedText.hidden = false
        }
        else {
            self.profileImageView.frame = CGRect(x: 12, y: 12, width: 48, height: 48)
            self.profileImageView.updateImage(user.profile_image_url)
            self.userNames.hidden = true
            self.retweetedText.hidden = true
        }

        self.unreadIndicatorDisposable = cellData.tweet.rx_observe("is_read") as Observable<Bool?>
            >- subscribeNext { [weak self] isRead in
                self?.unreadIndicator.hidden = isRead!
            }
    }

    func setMakeReadTimer() {
        self.markReadTimer = Timer(duration: 1) { [unowned self] in
            action_updateTweetReadState(self.cellData!.tweet, true)
        }
    }

    func cancelMakeReadTimer() {
        self.markReadTimer = nil
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
