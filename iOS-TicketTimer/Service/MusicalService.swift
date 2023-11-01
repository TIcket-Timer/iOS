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
	func getDeadlineMusicalNotices(page: Int, size: Int) -> Observable<Response<[MusicalNotice]>> {
		let path = "/api/musicalNotices/deadline?page=\(page)&size=\(size)"
		let url = baseUrl + path
		
		let observable = Observable<Response<[MusicalNotice]>>.create { observer -> Disposable in
			
            AF.request(url, interceptor: AuthInterceptor())
                .validate(statusCode: 200..<300)
				.responseDecodable(of: Response<[MusicalNotice]>.self) { response in
					switch response.result {
					case .success(let data):
						//print("[getDeadlineMusicalNotices 성공] \(data)")
						observer.onNext(data)
						observer.onCompleted()
					case .failure(let error):
						print("[getDeadlineMusicalNotices 실패] \(error.localizedDescription)")
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
		
		let observable = Observable<Response<[MusicalNotice]>>.create { observer -> Disposable in
			
            AF.request(url, interceptor: AuthInterceptor())
                .validate(statusCode: 200..<300)
				.responseDecodable(of: Response<[MusicalNotice]>.self) { response in
					switch response.result {
					case .success(let data):
						//print("[getLatestMusicalNotices 성공] \(data)")
						observer.onNext(data)
						observer.onCompleted()
					case .failure(let error):
						print("[getLatestMusicalNotices 실패] \(error.localizedDescription)")
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
        
        let observable = Observable<Response<[Musicals]>>.create { observer -> Disposable in
            
            AF.request(url, interceptor: AuthInterceptor())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Response<[Musicals]>.self) { response in
                    switch response.result {
                    case .success(let data):
                        //print("[getLatestMusicals 성공] \(data)")
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        print("[getLatestMusicals 실패] \(error.localizedDescription)")
                        observer.onError(error)
                        observer.onCompleted()
                    }
                }
            
            return Disposables.create()
        }
        
        return observable
    }
    
    //MARK: - 인기 뮤지컬 조회
    func getPopularMusicals(platform: Platform) -> Observable<[Musicals]> {
        var urlComponents = URLComponents(string: baseUrl)
        let path = "/api/musicals/ranking"
        urlComponents?.path = path
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "site", value: platform.siteCapital),
            URLQueryItem(name: "page", value: "0"),
            URLQueryItem(name: "search", value: "10")
        ]
        
        guard let url = urlComponents?.url else {
            print("[URL: error]")
            return Observable.empty()
        }
        
        return Observable.create { observer -> Disposable in
            AF.request(url, interceptor: AuthInterceptor())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Response<[Musicals]>.self) { response in
                    switch response.result {
                    case .success(let response):
                        print("[\(response.code)] \(response.message)")
                        guard let result = response.result else { return }
                        observer.onNext(result)
                        observer.onCompleted()
                    case .failure(let error):
                        print("[인기 뮤지컬 가져오기 실패] \(error.localizedDescription)")
                        observer.onCompleted()
                    }
                }
            return Disposables.create()
        }
    }
    
    //MARK: - 공지 제목으로 검색
    func searchMusicalNotices(query: String) -> Observable<Response<[MusicalNotice]>> {
        var urlComponents = URLComponents(string: baseUrl)
        let path = "/api/musicalNotices/search"
        urlComponents?.path = path
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "page", value: "0"),
            URLQueryItem(name: "search", value: "100")
        ]
        
        guard let url = urlComponents?.url else {
            print("[URL: error]")
            return Observable.empty()
        }
        
        return Observable.create { observer -> Disposable in
            AF.request(url, interceptor: AuthInterceptor())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Response<[MusicalNotice]>.self) { response in
                    switch response.result {
                    case .success(let notices):
                        observer.onNext(notices)
                        observer.onCompleted()
                    case .failure(let error):
                        print("[searchMusicalNotices 실패] \(error.localizedDescription)")
                        observer.onCompleted()
                    }
                }
            return Disposables.create()
        }
    }
    
    //MARK: - 사이트별 뮤지컬 제목으로 검색
    func searchMusicalsWithSite(platform: Platform, query: String) -> Observable<Response<[Musicals]>> {
        var urlComponents = URLComponents(string: baseUrl)
        let path = "/api/musicals/search"
        urlComponents?.path = path
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "site", value: platform.siteCapital),
            URLQueryItem(name: "page", value: "0"),
            URLQueryItem(name: "search", value: "100")
        ]
        
        guard let url = urlComponents?.url else {
            print("[URL error]")
            return Observable.empty()
        }
        
        return Observable.create { observer -> Disposable in
            AF.request(url, interceptor: AuthInterceptor())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Response<[Musicals]>.self) { response in
                    switch response.result {
                    case .success(let musicals):
                        observer.onNext(musicals)
                        observer.onCompleted()
                    case .failure(let error):
                        print("[searchMusicalsWithSite 실패] \(error.localizedDescription)")
                        observer.onCompleted()
                    }
                }
            return Disposables.create()
        }
    }
    
    //MARK: - 모든 사이트로 뮤지컬 제목으로 검색
    func searchMusicalsWithAllSites(query: String) -> Observable<Response<[Musicals]>> {
        let interpark = searchMusicalsWithSite(platform: .interpark, query: query)
        let melon = searchMusicalsWithSite(platform: .melon, query: query)
        let yes24 = searchMusicalsWithSite(platform: .yes24, query: query)
        return Observable.zip(interpark, melon, yes24)
            .map { interparkResponse, melonResponse, yes24Response -> Response<[Musicals]> in
                
                var allMusicals: [Musicals] = []
                
                if let interparkMusicals = interparkResponse.result {
                    allMusicals.append(contentsOf: interparkMusicals)
                }
                if let melonMusicals = melonResponse.result {
                    allMusicals.append(contentsOf: melonMusicals)
                }
                if let yes24Musicals = yes24Response.result {
                    allMusicals.append(contentsOf: yes24Musicals)
                }
                
                return Response(code: interparkResponse.code, message: interparkResponse.message, result: allMusicals)
            }
    }
}
