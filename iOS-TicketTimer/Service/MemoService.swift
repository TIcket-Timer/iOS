//
//  MemoService.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/11/14.
//

import RxSwift
import Alamofire

class MemoService {
    static let shared = MemoService()
    
    private let baseUrl = Server.baseUrl.rawValue
    
    func getMemo() -> Observable<[Memo]> {
        var urlComponents = URLComponents(string: baseUrl)
        let path = "/api/memos"
        urlComponents?.path = path
        
        guard let url = urlComponents?.url else {
            print("[URL error]")
            return Observable.empty()
        }
        
        return Observable.create { observer -> Disposable in
            AF.request(url, interceptor: AuthInterceptor())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Response<GetMemoResult>.self) { response in
                    switch response.result {
                    case .success(let response):
                        print("[\(response.code)] \(response.message)")
                        if response.code == 200 {
                            guard let result = response.result else { return }
                            let memos = result.memos
                            observer.onNext(memos)
                            observer.onCompleted()
                        } else {
                            observer.onCompleted()
                        }
                    case .failure(let error):
                        print("[메모 가져오기 실패] \(error.localizedDescription)")
                        observer.onCompleted()
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func getMemo(id: Int) -> Observable<Memo> {
        var urlComponents = URLComponents(string: baseUrl)
        let path = "/api/memos/\(id)"
        urlComponents?.path = path
        
        guard let url = urlComponents?.url else {
            print("[URL error]")
            return Observable.empty()
        }
        
        return Observable.create { observer -> Disposable in
            AF.request(url, interceptor: AuthInterceptor())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Response<Memo>.self) { response in
                    switch response.result {
                    case .success(let response):
                        //print("[\(response.code)] \(response.message)")
                        if response.code == 200 {
                            guard let memo = response.result else { return }
                            observer.onNext(memo)
                            observer.onCompleted()
                        } else {
                            observer.onCompleted()
                        }
                    case .failure(let error):
                        print("[아이디로 메모 가져오기 실패] \(error.localizedDescription)")
                        observer.onCompleted()
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func postMemo(content: String, dateStr: String, completion: @escaping () -> Void) {
        var urlComponents = URLComponents(string: baseUrl)
        let path = "/api/memos"
        urlComponents?.path = path
        
        guard let url = urlComponents?.url else {
            print("[URL error]")
            return
        }
                
        let body: [String: Any] = [
            "content": content,
            "date": dateStr
        ]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, interceptor: AuthInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<AddMemoResult>.self) { response in
            switch response.result {
            case .success(_):
                completion()
            case .failure(let error):
                print("[메모 등록 실패] \(error.localizedDescription)")
            }
        }
    }
    
    func deleteMemo(id: Int, completion: @escaping () -> Void) {
        var urlComponents = URLComponents(string: baseUrl)
        let path = "/api/memos/\(id)"
        urlComponents?.path = path

        guard let url = urlComponents?.url else {
            print("[URL error]")
            return
        }

        AF.request(url, method: .delete, interceptor: AuthInterceptor())
            .validate(statusCode: 200..<300)
            .response { response in
            switch response.result {
            case .success(_):
                completion()
            case .failure(let error):
                print("[메모 삭제 실패] \(error.localizedDescription)")
            }
        }
    }
    
    func patchMemo(memo: Memo, completion: @escaping () -> Void) {
        deleteMemo(id: memo.id ?? 0) { [weak self] in
            self?.postMemo(content: memo.content ?? "", dateStr: memo.date ?? "") {
                completion()
            }
        }
    }
}
