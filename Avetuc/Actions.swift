import Foundation
import RxSwift

func action_handleOauthCallback(url: NSURL) {
    sendNext(River.instance.action_handleOauthCallback, url)
}

func action_addAccountFromWeb() {
    sendNext(River.instance.action_addAccountFromWeb, ())
}

func action_updateAccount(id: String) {
    sendNext(River.instance.action_updateAccount, id)
}

func action_selectFriend(id: Int64) {
    sendNext(River.instance.action_selectFriend, id)
}

func action_updateTweetReadState(id: Int64, isRead: Bool) {
    sendNext(River.instance.action_updateTweetReadState, (id, isRead))
}
