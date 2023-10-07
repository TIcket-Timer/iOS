//
//  MusicalService.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/07.
//

import RxSwift
import Alamofire

class MusicalService {
	static let shared = MusicalService()
	
	private let baseUrl = Server.baseUrl.rawValue
	
	// MARK: - 마감 기한이 임박한 공지 조회
	func getDeadlineMusicals(page: Int, size: Int) -> Observable<Response<MusicalNotice>> {
		let path = "/api/musicalNotices/deadline?page=\(page)&size=\(size)"
		let url = baseUrl + path
		
		let observable = Observable<Response<MusicalNotice>>.create { observer -> Disposable in
			
			AF.request(url, method: .get)
				.responseDecodable(of: Response<MusicalNotice>.self) { response in
					switch response.result {
					case .success(let data):
						print("[getDeadlineMusicals 성공]")
						dump(data)
						observer.onNext(data)
						observer.onCompleted()
					case .failure(let error):
						print("[getDeadlineMusicals 실패]")
						print(error)
						observer.onError(error)
						observer.onCompleted()
					}
				}
			
			return Disposables.create()
		}
		
		return observable
	}
	
	// MARK: - 최근 등록된 공지 조회
	func getLatestMusicals(page: Int, size: Int) -> Observable<Response<MusicalNotice>> {
		let path = "/api/musicalNotices/latest?page=\(page)&size=\(size)"
		let url = baseUrl + path
		
		let observable = Observable<Response<MusicalNotice>>.create { observer -> Disposable in
			
			AF.request(url, method: .get)
				.responseDecodable(of: Response<MusicalNotice>.self) { response in
					switch response.result {
					case .success(let data):
						print("[getLatestMusicals 성공]")
						dump(data)
						observer.onNext(data)
						observer.onCompleted()
					case .failure(let error):
						print("[getLatestMusicals 실패]")
						print(error)
						observer.onError(error)
						observer.onCompleted()
					}
				}
			
			return Disposables.create()
		}
		
		return observable
	}
}
