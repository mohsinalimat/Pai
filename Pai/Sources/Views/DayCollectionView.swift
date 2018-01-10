//
//  DayCollectionView.swift
//  Pai
//
//  Created by Luqman Fauzi on 27/12/2017.
//  Copyright © 2017 Luqman Fauzi. All rights reserved.
//

import Foundation

internal class DayCollectionView: UICollectionView {

    let calendar = PaiCalendar.current
    var month: Month = .jan {
        didSet {
            dates = calendar.datesCountInMonth(inMonth: month)
        }
    }
    var dates: [PaiDate] = [] {
        didSet {
            reloadData()
        }
    }

    public init() {
        let layout = DayFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        register(cellWithClass: DayViewCell.self)
        backgroundColor = UIColor.white
        translatesAutoresizingMaskIntoConstraints = false
        delegate = self
        dataSource = self
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension DayCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDataSource

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withClass: DayViewCell.self, for: indexPath) else {
            fatalError("DayViewCell not found.")
        }

        let item = dates[indexPath.item]

        /// Configure date item cell by the 3 defined `DateItemStyle` values
        if let beginning = calendar.indexStartDate(inMonth: month), indexPath.item < beginning {
            cell.configure(date: item.date, style: .offsetDate)
        } else if let end = calendar.indexEndDate(inMonth: month), indexPath.item > end {
            cell.configure(date: item.date, style: .offsetDate)
        } else {
            if item.isPastDate {
                cell.configure(date: item.date, style: .pastDate)
            } else {
                cell.configure(date: item.date, style: .active)
            }
        }
        return cell
    }

    // MARK: - UICollectionViewDelegate

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dates[indexPath.item + 1]
        print("Selected day: \(item)")
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = collectionView.bounds.width / CGFloat(calendar.veryShortWeekdaySymbols.count)
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
