//
//  CalendarViewModel.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import RxSwift
import RxRelay

class CalendarViewModel {

    private let disposeBag = DisposeBag()
    private let memoService = MemoService.shared

    let input = Input()
    let output = Output()

    init() {
//        input.getAllMemos
//            .flatMap { [weak self] _ -> Observable<[Memo]> in
//                guard let self = self else { return Observable.empty() }
//                return self.memoService.getMemo()
//            }
//            .subscribe{ [weak self] memos in
//                self?.output.bindAllMemos.accept(memos)
//            }
//            .disposed(by: disposeBag)
        
        input.getMemoSections
            .flatMap { _ in
                return self.memoService.getMemo()
            }
            .subscribe{ [weak self] memos in
                var sections: [MemoSection] = []
                var groupedMemos = [String: [Memo]]()
                let sortedMemos = memos.sorted {
                    $0.date ?? "" < $1.date ?? ""
                }
                sortedMemos.forEach { memo in
                    let header = memo.date ?? ""
                    if groupedMemos[header] == nil {
                        groupedMemos[header] = [memo]
                    } else {
                        groupedMemos[header]?.append(memo)
                    }
                }

                for (header, memos) in groupedMemos {
                    let section = MemoSection(items: memos, header: header)
                    sections.append(section)
                }
                let sortedSections = sections.sorted {
                    $0.header < $1.header
                }
                self?.output.bindMemoSections.accept(sortedSections)
            }
            .disposed(by: disposeBag)
        
        input.getMemo
            .flatMap { id -> Observable<Memo> in
                return self.memoService.getMemo(id: id)
            }
            .subscribe(onNext: { [weak self] memo in
                self?.output.bindMemo.accept(memo)
            })
            .disposed(by: disposeBag)
        
        input.addMemo
            .subscribe(onNext: { [weak self] (content, date) in
                self?.memoService.postMemo(content: content, dateStr: date) {
                    self?.input.getMemoSections.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        input.updateMemo
            .subscribe(onNext: { [weak self] memo in
                self?.memoService.patchMemo(memo: memo) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.input.getMemoSections.onNext(())
                    }
                }
            })
            .disposed(by: disposeBag)
        
        input.deleteMemo
            .subscribe(onNext: { [weak self] id in
                self?.memoService.deleteMemo(id: id, completion: {
                    self?.input.getMemoSections.onNext(())
                })
            })
            .disposed(by: disposeBag)
        
        input.setDateString
            .flatMap { date -> Observable<String> in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy년 M월 d일 (E)"
                let dateStr = formatter.string(from: date)
                return Observable.just(dateStr)
            }
            .subscribe(onNext: { [weak self] dateStr in
                self?.output.bindDate.accept(dateStr)
            })
            .disposed(by: disposeBag)
    }
}

extension CalendarViewModel {
    struct Input {
//        var getAllMemos = PublishSubject<Void>()
        var getMemoSections = PublishSubject<Void>()
        var getMemo = PublishSubject<Int>()
        var addMemo = PublishSubject<(String, String)>()
        var updateMemo = PublishSubject<Memo>()
        var deleteMemo = PublishSubject<Int>()
        var setDateString = PublishSubject<Date>()
    }
    struct Output {
        //var bindAllMemos = PublishRelay<[Memo]>()
        var bindMemoSections = PublishRelay<[MemoSection]>()
        var bindMemo = PublishRelay<Memo>()
        var bindDate = PublishRelay<String>()
    }
}
