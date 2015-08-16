import Foundation
import RxSwift

func action_addAccount(account: Account) {
    sendNext(River.instance.action_addAccount, account)
}

func action_requestUpdateAccount(id: String?) {
    sendNext(River.instance.action_requestUpdateAccount, id)
}

func action_updateTweetReadState(id: Int64, isRead: Bool) {
    sendNext(River.instance.action_updateTweetReadState, (id, isRead))
}
