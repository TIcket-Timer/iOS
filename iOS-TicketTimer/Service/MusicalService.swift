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
	func getDeadlineMusicalNotices(page: Int, size: Int) -> Observable<Response<MusicalNotice>> {
		let path = "/api/musicalNotices/deadline?page=\(page)&size=\(size)"
		let url = baseUrl + path
		
		let observable = Observable<Response<MusicalNotice>>.create { observer -> Disposable in
			
			AF.request(url, method: .get)
				.responseDecodable(of: Response<MusicalNotice>.self) { response in
					switch response.result {
					case .success(let data):
						print("[getDeadlineMusicalNotices 성공] \(data)")
						observer.onNext(data)
						observer.onCompleted()
					case .failure(let error):
						print("[getDeadlineMusicalNotices 실패] \(error)")
						observer.onError(error)
						observer.onCompleted()
					}
				}
			
			return Disposables.create()
		}
		
		return observable
	}
	
	// MARK: - 최근 등록된 공지 조회
	func getLatestMusicalNotices(page: Int, size: Int) -> Observable<Response<[MusicalNotice]>> {
		let path = "/api/musicalNotices/latest?page=\(page)&size=\(size)"
		let url = baseUrl + path
        
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(TestToken.accessToken.rawValue)"
        ]
		
		let observable = Observable<Response<[MusicalNotice]>>.create { observer -> Disposable in
			
			AF.request(url, method: .get, headers: header)
				.responseDecodable(of: Response<[MusicalNotice]>.self) { response in
					switch response.result {
					case .success(let data):
						print("[getLatestMusicalNotices 성공] \(data)")
						observer.onNext(data)
						observer.onCompleted()
					case .failure(let error):
						print("[getLatestMusicalNotices 실패] \(error)")
						observer.onError(error)
						observer.onCompleted()
					}
				}
			
			return Disposables.create()
		}
		
		return observable
	}
    
    // MARK: - 최근 등록된 뮤지컬 정보 조회
    func getLatestMusicals(page: Int, size: Int) -> Observable<Response<[Musicals]>> {
        let path = "/api/musicals/latest?page=\(page)&size=\(size)"
        let url = baseUrl + path
        
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(TestToken.accessToken.rawValue)"
        ]
        
        let observable = Observable<Response<[Musicals]>>.create { observer -> Disposable in
            
            AF.request(url, method: .get, headers: header)
                .responseDecodable(of: Response<[Musicals]>.self) { response in
                    switch response.result {
                    case .success(let data):
                        print("[getLatestMusicals 성공] \(data)")
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        print("[getLatestMusicals 실패] \(error)")
                        observer.onError(error)
                        observer.onCompleted()
                    }
                }
            
            return Disposables.create()
        }
        
        return observable
    }
    
    //MARK: - 인기 뮤지컬 조회
    func getPopularMusicals(platform: Platform) -> Observable<Response<[Musicals]>> {
        let path = "/api/musicals/site/\(platform.site)?page=1&size=10"
        let url = baseUrl + path

        let header: HTTPHeaders = [
            "Authorization": "Bearer \(TestToken.accessToken.rawValue)"
        ]
        
        return Observable.create { observer in
            AF.request(url, headers: header)
                .responseDecodable(of: Response<[Musicals]>.self) { response in
                    switch response.result {
                    case .success(let musicals):
                        print("[getPopularMusicals 성공 - \(platform.rawValue)]")
                        observer.onNext(musicals)
                        observer.onCompleted()
                    case .failure(let error):
                        print("[getPopularMusicals 실패] \(error)")
                        observer.onError(error)
                        observer.onCompleted()
                    }
                }
            return Disposables.create()
        }
    }
}
