import Foundation
import UIKit
import TapLabel
import SnapKit
import RxSwift
import RxCocoa

class TweetCell: UITableViewCell {

    static func heightForContent(cellData: TweetCellData) -> CGFloat
    {
        let boundingRect = cellData.text.boundingRectWithSize(
            CGSizeMake(TWEET_CELL_TEXT_WIDTH, CGFloat.max),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin | NSStringDrawingOptions.UsesFontLeading,
            context: nil)

        return max(
            ceil(boundingRect.size.height) + (cellData.tweet.retweeted_status == nil ? 10 : 30) + 37,
            89 + (cellData.tweet.retweeted_status == nil ? 0 : 20) // Ensure min height
        )
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)

        self.contentView.addSubview(self.textView)
        self.contentView.addSubview(self.profileImageView)
        self.contentView.addSubview(self.userNames)
        self.contentView.addSubview(self.timeText)
        self.contentView.addSubview(self.retweetedText)
        self.contentView.addSubview(self.unreadIndicator)

        self.timeText.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-10)
        }

        self.userNames.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(68)
            make.top.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(14)
        }

        self.retweetedText.snp_makeConstraints { make in
            make.left.equalTo(self).offset(68)
            make.bottom.equalTo(self).offset(-10)
        }
    }

    let bag = DisposeBag()

    let profileImageView = ProfileImageView(frame: CGRect(x: 12, y: 13, width: 48, height: 48))
    let textView = TweetTextView()
    let timeText = TimestampView()
    let userNames = UserNames()
    let retweetedText = RetweetedText()
    let unreadIndicator = UnreadIndicator(frame: CGRect(x: 0, y: 0, width: 15, height: 15))

    var cellData: TweetCellData?
    var markReadTimer: Timer?
    var unreadIndicatorDisposable: Disposable?

    override func prepareForReuse() {
        self.unreadIndicatorDisposable?.dispose()
        self.unreadIndicatorDisposable = nil
        self.cancelMakeReadTimer()
    }

    func loadTweet(cellData: TweetCellData, user: User) {
        self.cellData = cellData

        self.textView.attributedText = cellData.text
        self.timeText.text = relativeTimeString(parseTwitterTimestamp(cellData.tweet.created_at))

        if let retweetedUser = cellData.tweet.retweeted_status?.user {
            self.profileImageView.frame = CGRect(x: 12, y: 33, width: 48, height: 48)
            self.profileImageView.updateImage(retweetedUser.profile_image_url)
            self.userNames.loadNames(retweetedUser.name, screenName: retweetedUser.screen_name)
            self.userNames.hidden = false
            self.retweetedText.hidden = false
        }
        else {
            self.profileImageView.frame = CGRect(x: 12, y: 13, width: 48, height: 48)
            self.profileImageView.updateImage(user.profile_image_url)
            self.userNames.hidden = true
            self.retweetedText.hidden = true
        }

        self.textView.snp_updateConstraints { make in
            make.left.equalTo(self).offset(68)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(cellData.tweet.retweeted_status == nil ? 10 : 30)
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

    // Prevent sub UIView lost background color
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.unreadIndicator.backgroundColor = BLUE
    }

    // Prevent sub UIView lost background color
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        self.unreadIndicator.backgroundColor = BLUE
    }

    // MARK: - No use
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
