//

import Combine
import CoreLocation
import SwiftUI

enum ActionType: Int {
    case idle
    case editLocation
    case editAll
    case detail
    case compass
}

struct DiaryTableViewWrapper: UIViewRepresentable {
    @EnvironmentObject var diary: DiaryViewModel

    func makeUIView(context: UIViewRepresentableContext<DiaryTableViewWrapper>) -> DiaryTableView {
        let tableView = DiaryTableView()
        tableView.delegate = context.coordinator
        tableView.dataSource = context.coordinator
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.clear

        //    Settings.cellStyle = .detailed

        tableView.setAccessability(.diaryList)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100 // set to whatever your "average" cell height is

        tableView.register(
            UINib(nibName: "DetailedCell", bundle: nil),
            forCellReuseIdentifier: CellStyle.detailed.cellId)
        tableView.register(
            UINib(nibName: "CompactCell", bundle: nil),
            forCellReuseIdentifier: CellStyle.compact.cellId)

        tableView.register(
            UINib(nibName: "DetailedHeaderCell", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "header\(CellStyle.detailed.cellId)")
        tableView.register(
            UINib(nibName: "CompactHeaderCell", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "header\(CellStyle.compact.cellId)")

        tableView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return tableView
    }

    func updateUIView(_ tableView: UIViewType, context: UIViewRepresentableContext<DiaryTableViewWrapper>) {
        tableView.reloadData()
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, diary: diary)
    }

    final class Coordinator: NSObject, UITableViewDelegate, UITableViewDataSource {
        let parent: DiaryTableViewWrapper
        let diary: DiaryViewModel

        init(parent: DiaryTableViewWrapper, diary: DiaryViewModel) {
            self.parent = parent
            self.diary = diary
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            LocationPublisher.shared.startHeading()

            return diary.sections.count
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let sortableDate = diary.sections.sections[section]
            return sortableDate.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let reusableId = "\(Settings.cellStyle.cellId)"

            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: reusableId,
                for: indexPath as IndexPath)
                as? DiaryEntryTableViewCell,
                let entry = diary.sections.getEntry(index: indexPath)
            else {
                fatalError("ERROR creating cell")
            }
            if Settings.cellStyle == .compact {
                let rowCount = tableView.numberOfRows(inSection: indexPath.section)
                if rowCount > 1 {}
            }

            var rowType = RowType.all
            if indexPath.row == 0 {
                rowType = .topRow
            } else if indexPath.row == diary.sections.selectedEntries.count - 1 {
                rowType = .bottomRow
            }

            cell.setupCell(entry: entry, rowType: rowType)

            cell.setAccessability(.diaryCell, with: ["\(indexPath.row + 1)", diary.sections.selectedKey])
            return cell
        }

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let reusableId = "header\(Settings.cellStyle.cellId)"
            let diarySection = diary.sections.sections[section].sortKey

            guard let rawCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: reusableId),
                let cell = rawCell as? DiaryHeaderCell else {
                fatalError("ERROR creating compact cell")
            }
            cell.setDate(diarySection.dateFromSortedDateFormat)
            return cell
        }

        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            if Settings.cellStyle == .detailed {
                return 85
            } else {
                return 60
            }
        }

        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }

        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                print("Indexpath section \(indexPath.section) row \(indexPath.row)  ")
                if let diaryEntry = diary.sections.getEntry(index: indexPath) {
                    DispatchQueue.main.async {
                        if diaryEntry.delete() {
                            self.diary.sections.reload()
                            tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                    }

                }
            }
        }
    }
}

class DiaryTableView: UITableView {
    private var reloadDataListener: AnyCancellable?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initialize()
    }

    func initialize() {
        reloadDataListener = NotificationCenter.default.publisher(for: AppNotification.reloadData)
            .sink { [weak self] _ in
                self?.reloadData()
            }
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: TXT.reload)
        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }

    @objc func refresh(_ sender: AnyObject) {
        Caching.clearImageCache()
        db.cleanUp()
        db.clearCache()
        db.importDefault()
        reloadData()

        CLLocationCoordinate2D.clearCachedImages()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl?.endRefreshing()
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        reloadData()
    }
}
