import SwiftUI

/// A picture from the animation review list, drawn and moved the same way as that list.
struct ReviewListMark: View {
    let itemID: String

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: reduceMotion)) { timeline in
            Canvas { context, size in
                guard let picture = ReviewListCatalog.picture(for: itemID) else { return }
                let time = reduceMotion ? 0 : timeline.date.timeIntervalSinceReferenceDate
                ReviewListDrawer.draw(picture, in: &context, size: size, time: time)
            }
        }
        .accessibilityHidden(true)
    }
}

private struct ReviewPicture {
    var motion: String
    var document: SVGDocument
}

private enum ReviewListCatalog {
    private static let lock = NSLock()
    private static var cache: [String: ReviewPicture] = [:]
    private static let entries: [String: String] = {
        guard let object = decoded() else { return [:] }
        return object.mapValues { $0["svg"] ?? "" }
    }()
    private static let motions: [String: String] = {
        guard let object = decoded() else { return [:] }
        return object.mapValues { $0["motion"] ?? "rest" }
    }()

    private static func decoded() -> [String: [String: String]]? {
        guard let data = Data(base64Encoded: payload) else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: [String: String]]
    }

    static func picture(for itemID: String) -> ReviewPicture? {
        lock.lock()
        defer { lock.unlock() }
        if let cached = cache[itemID] { return cached }
        guard let svg = entries[itemID], !svg.isEmpty else { return nil }
        let picture = ReviewPicture(motion: motions[itemID] ?? "rest", document: SVGDocument(svg: svg))
        cache[itemID] = picture
        return picture
    }

    /// Generated from docs/animation-review/index.html. Do not edit by hand.
    private static let payload = "eyJzaGFyayI6eyJtb3Rpb24iOiJzd2ltIiwic3ZnIjoiPHN2ZyB2aWV3Qm94PVwiMCAwIDgwIDgwXCI+PGcgY2xhc3M9XCJsaWZlIGxpZmUtd2FnXCI+PHBhdGggZD1cIk0zNiA0MiBMNCAxNiBMMjIgNDIgTDQgNjggWlwiIGZpbGw9XCIjNDU3Mzk0XCIvPjwvZz48ZWxsaXBzZSBjeD1cIjQ2XCIgY3k9XCI0MlwiIHJ4PVwiMThcIiByeT1cIjEyXCIgZmlsbD1cIiM0NTczOTRcIi8+PHBvbHlnb24gcG9pbnRzPVwiMzYsMzAgNDQsMzAgNDAsMTZcIiBmaWxsPVwiIzQ1NzM5NFwiLz48ZWxsaXBzZSBjeD1cIjQ2XCIgY3k9XCI0OFwiIHJ4PVwiMTBcIiByeT1cIjRcIiBmaWxsPVwiI2Q3ZWZmZlwiIG9wYWNpdHk9XCIwLjdcIi8+PGcgZmlsbD1cIm5vbmVcIiBzdHJva2U9XCIjMWEzMzQ0XCIgc3Ryb2tlLXdpZHRoPVwiMS42XCIgc3Ryb2tlLWxpbmVjYXA9XCJyb3VuZFwiPjxwYXRoIGQ9XCJNNDQgMzYgUTQyIDQyIDQ0IDQ4XCIvPjxwYXRoIGQ9XCJNNDcuNSAzNS41IFE0NS41IDQyIDQ3LjUgNDguNVwiLz48cGF0aCBkPVwiTTUxIDM2IFE0OSA0MiA1MSA0OFwiLz48L2c+PGNpcmNsZSBjeD1cIjU2XCIgY3k9XCIzOFwiIHI9XCIzXCIgZmlsbD1cIiNkN2VmZmZcIi8+PGNpcmNsZSBjeD1cIjU2LjlcIiBjeT1cIjM4XCIgcj1cIjEuMzVcIiBmaWxsPVwiIzE0MWY0N1wiLz48L3N2Zz4ifSwid2hhbGUiOnsibW90aW9uIjoic3dpbSIsInN2ZyI6Ijxzdmcgdmlld0JveD1cIjAgMCA4MCA4MFwiPjxnIGNsYXNzPVwibGlmZSBsaWZlLXdhZ1wiIHN0eWxlPVwidHJhbnNmb3JtLW9yaWdpbjoxMDAlIDUwJVwiPjxwYXRoIGQ9XCJNMzYgNDIgQzIyIDQyIDE0IDEyIDQgMjAgQzEgMzAgOCA0MCAxNCA0MiBDOCA0NCAxIDU0IDQgNjQgQzE0IDcyIDIyIDQyIDM2IDQyIFpcIiBmaWxsPVwiIzJlNGQ3YVwiLz48L2c+PGVsbGlwc2UgY3g9XCI0NFwiIGN5PVwiNDRcIiByeD1cIjI0XCIgcnk9XCIxNlwiIGZpbGw9XCIjMmU0ZDdhXCIvPjxjaXJjbGUgY3g9XCIzNlwiIGN5PVwiMjZcIiByPVwiM1wiIGZpbGw9XCIjZDdlZmZmXCIvPjxjaXJjbGUgY3g9XCI0NFwiIGN5PVwiMjBcIiByPVwiMlwiIGZpbGw9XCIjZDdlZmZmXCIvPjxjaXJjbGUgY3g9XCI1NlwiIGN5PVwiMzhcIiByPVwiM1wiIGZpbGw9XCIjZDdlZmZmXCIvPjxjaXJjbGUgY3g9XCI1Ni45XCIgY3k9XCIzOFwiIHI9XCIxLjM1XCIgZmlsbD1cIiMxNDFmNDdcIi8+PC9zdmc+In0sImhvcnNlIjp7Im1vdGlvbiI6InRyb3QiLCJzdmciOiI8c3ZnIHZpZXdCb3g9XCIwIDAgODAgODBcIj48ZyBjbGFzcz1cImxpZmUgbGlmZS13YWdcIiBzdHlsZT1cInRyYW5zZm9ybS1vcmlnaW46NTAlIDAlXCI+PHBhdGggZD1cIk0yNyAzOSBDMjEgNDggMTUgNTggMTQgNjggQzE3IDc1IDIzIDczIDIzIDY2IEMyMyA1NiAyNSA0OCAzMSA0MSBaXCIgZmlsbD1cIiM0NzI0MTBcIi8+PC9nPjxyZWN0IHg9XCIyNlwiIHk9XCI1NFwiIHdpZHRoPVwiNC4yXCIgaGVpZ2h0PVwiMTNcIiByeD1cIjIuMVwiIGZpbGw9XCIjOWU1NzI0XCIvPjxyZWN0IHg9XCIzMi41XCIgeT1cIjU0XCIgd2lkdGg9XCI0LjJcIiBoZWlnaHQ9XCIxM1wiIHJ4PVwiMi4xXCIgZmlsbD1cIiM5ZTU3MjRcIi8+PHJlY3QgeD1cIjQ0XCIgeT1cIjU0XCIgd2lkdGg9XCI0LjJcIiBoZWlnaHQ9XCIxM1wiIHJ4PVwiMi4xXCIgZmlsbD1cIiM5ZTU3MjRcIi8+PHJlY3QgeD1cIjUwLjVcIiB5PVwiNTRcIiB3aWR0aD1cIjQuMlwiIGhlaWdodD1cIjEzXCIgcng9XCIyLjFcIiBmaWxsPVwiIzllNTcyNFwiLz48ZWxsaXBzZSBjeD1cIjQwXCIgY3k9XCI0OFwiIHJ4PVwiMjBcIiByeT1cIjEyXCIgZmlsbD1cIiM5ZTU3MjRcIi8+PGVsbGlwc2UgY3g9XCI0MFwiIGN5PVwiNTJcIiByeD1cIjEwXCIgcnk9XCI2XCIgZmlsbD1cIiNlZGM3OTRcIi8+PHJlY3QgeD1cIjM5XCIgeT1cIjM1XCIgd2lkdGg9XCIxNVwiIGhlaWdodD1cIjRcIiByeD1cIjJcIiBmaWxsPVwiIzQ3MjQxMFwiIHRyYW5zZm9ybT1cInJvdGF0ZSgtMzYgNDYgMzcpXCIvPjxjaXJjbGUgY3g9XCI1OFwiIGN5PVwiMzhcIiByPVwiOVwiIGZpbGw9XCIjOWU1NzI0XCIvPjxwb2x5Z29uIHBvaW50cz1cIjUzLDMzIDU1LjUsMjYgNTgsMzNcIiBmaWxsPVwiIzllNTcyNFwiLz48cG9seWdvbiBwb2ludHM9XCI1OCwzMiA2MSwyNSA2NCwzMlwiIGZpbGw9XCIjOWU1NzI0XCIvPjxjaXJjbGUgY3g9XCI2MlwiIGN5PVwiMzZcIiByPVwiMlwiIGZpbGw9XCIjZDdlZmZmXCIvPjxjaXJjbGUgY3g9XCI2Mi42XCIgY3k9XCIzNlwiIHI9XCIwLjlcIiBmaWxsPVwiIzE0MWY0N1wiLz48ZWxsaXBzZSBjeD1cIjY3XCIgY3k9XCI0MVwiIHJ4PVwiMy41XCIgcnk9XCIyLjJcIiBmaWxsPVwiIzllNTcyNFwiLz48L3N2Zz4ifSwiZGlub3NhdXIiOnsibW90aW9uIjoid2FkZGxlIiwic3ZnIjoiPHN2ZyB2aWV3Qm94PVwiMCAwIDgwIDgwXCI+PGcgY2xhc3M9XCJsaWZlIGxpZmUtd2FnXCI+PHJlY3QgeD1cIjhcIiB5PVwiNDRcIiB3aWR0aD1cIjIyXCIgaGVpZ2h0PVwiNlwiIHJ4PVwiM1wiIGZpbGw9XCIjMzM5ZTY2XCIgdHJhbnNmb3JtPVwicm90YXRlKC0xOCAyMCA0NylcIi8+PC9nPjxyZWN0IHg9XCIzMFwiIHk9XCI0NFwiIHdpZHRoPVwiNC4yXCIgaGVpZ2h0PVwiMThcIiByeD1cIjIuMVwiIGZpbGw9XCIjMzM5ZTY2XCIvPjxyZWN0IHg9XCIzNlwiIHk9XCI0NFwiIHdpZHRoPVwiNC4yXCIgaGVpZ2h0PVwiMThcIiByeD1cIjIuMVwiIGZpbGw9XCIjMzM5ZTY2XCIvPjxyZWN0IHg9XCI0MlwiIHk9XCI0NFwiIHdpZHRoPVwiNC4yXCIgaGVpZ2h0PVwiMThcIiByeD1cIjIuMVwiIGZpbGw9XCIjMzM5ZTY2XCIvPjxyZWN0IHg9XCI0OFwiIHk9XCI0NFwiIHdpZHRoPVwiNC4yXCIgaGVpZ2h0PVwiMThcIiByeD1cIjIuMVwiIGZpbGw9XCIjMzM5ZTY2XCIvPjxlbGxpcHNlIGN4PVwiNDBcIiBjeT1cIjQ4XCIgcng9XCIxNlwiIHJ5PVwiMTJcIiBmaWxsPVwiIzMzOWU2NlwiLz48cmVjdCB4PVwiMzZcIiB5PVwiNDJcIiB3aWR0aD1cIjMyXCIgaGVpZ2h0PVwiOFwiIHJ4PVwiNFwiIGZpbGw9XCIjMzM5ZTY2XCIgdHJhbnNmb3JtPVwicm90YXRlKC01MCA0MCA0NilcIi8+PGVsbGlwc2UgY3g9XCI2MVwiIGN5PVwiMjJcIiByeD1cIjlcIiByeT1cIjdcIiBmaWxsPVwiIzMzOWU2NlwiLz48Y2lyY2xlIGN4PVwiNjVcIiBjeT1cIjIwXCIgcj1cIjJcIiBmaWxsPVwiI2Q3ZWZmZlwiLz48Y2lyY2xlIGN4PVwiNjUuNlwiIGN5PVwiMjBcIiByPVwiMC45XCIgZmlsbD1cIiMxNDFmNDdcIi8+PC9zdmc+In0sInBsYW5ldCI6eyJtb3Rpb24iOiJmbG9hdCIsInN2ZyI6Ijxzdmcgdmlld0JveD1cIjAgMCA4MCA4MFwiPjxlbGxpcHNlIGN4PVwiNDBcIiBjeT1cIjQwXCIgcng9XCIyOFwiIHJ5PVwiMTBcIiBmaWxsPVwibm9uZVwiIHN0cm9rZT1cIiNmZmM3MDBcIiBzdHJva2Utd2lkdGg9XCIzXCIgdHJhbnNmb3JtPVwicm90YXRlKC0xOCA0MCA0MClcIi8+PGcgY2xhc3M9XCJsaWZlIGxpZmUtc3BpblwiPjxjaXJjbGUgY3g9XCI0MFwiIGN5PVwiNDBcIiByPVwiMTRcIiBmaWxsPVwiIzczNjBkYlwiLz48Y2lyY2xlIGN4PVwiNDZcIiBjeT1cIjM4XCIgcj1cIjRcIiBmaWxsPVwiI2UyM2I2MlwiLz48L2c+PC9zdmc+In0sInN0YXIiOnsibW90aW9uIjoidHdpbmtsZSIsInN2ZyI6Ijxzdmcgdmlld0JveD1cIjAgMCA4MCA4MFwiPjxwb2x5Z29uIHBvaW50cz1cIjQwLjAsMTguMCA0NS4zLDMyLjcgNjAuOSwzMy4yIDQ4LjYsNDIuOCA1Mi45LDU3LjggNDAuMCw0OS4wIDI3LjEsNTcuOCAzMS40LDQyLjggMTkuMSwzMy4yIDM0LjcsMzIuN1wiIGZpbGw9XCIjZmZjNzAwXCIvPjwvc3ZnPiJ9LCJyb2NrZXQiOnsibW90aW9uIjoiZ2xpZGUiLCJzdmciOiI8c3ZnIHZpZXdCb3g9XCIwIDAgODAgODBcIj48cG9seWdvbiBwb2ludHM9XCI0MCwxMiA0OCwyOCAzMiwyOFwiIGZpbGw9XCIjZTIzYjYyXCIvPjxyZWN0IHg9XCIzMlwiIHk9XCIyOFwiIHdpZHRoPVwiMTZcIiBoZWlnaHQ9XCIyOFwiIHJ4PVwiM1wiIGZpbGw9XCIjZDdlZmZmXCIvPjxjaXJjbGUgY3g9XCI0MFwiIGN5PVwiNDBcIiByPVwiNFwiIGZpbGw9XCIjOGVjOGU4XCIvPjxwb2x5Z29uIHBvaW50cz1cIjMyLDQ0IDI0LDU2IDMyLDUyXCIgZmlsbD1cIiNlMjNiNjJcIi8+PHBvbHlnb24gcG9pbnRzPVwiNDgsNDQgNTYsNTYgNDgsNTJcIiBmaWxsPVwiI2UyM2I2MlwiLz48cG9seWdvbiBwb2ludHM9XCIzNSw1NiA0MCw3MCA0NSw1NlwiIGZpbGw9XCIjZmY3NTEwXCIvPjwvc3ZnPiJ9LCJzb2NjZXIgYmFsbCI6eyJtb3Rpb24iOiJyb2xsIiwic3ZnIjoiPHN2ZyB2aWV3Qm94PVwiMCAwIDgwIDgwXCI+PGcgY2xhc3M9XCJsaWZlIGxpZmUtc3BpblwiPjxkZWZzPjxjbGlwUGF0aCBpZD1cInNvY2NlcjFcIj48Y2lyY2xlIGN4PVwiNDBcIiBjeT1cIjQwXCIgcj1cIjE2XCIvPjwvY2xpcFBhdGg+PC9kZWZzPjxnIGNsaXAtcGF0aD1cInVybCgjc29jY2VyMSlcIj48Y2lyY2xlIGN4PVwiNDBcIiBjeT1cIjQwXCIgcj1cIjE2XCIgZmlsbD1cIiNmZmZcIi8+PHBvbHlnb24gcG9pbnRzPVwiNDAsMzUgNDQuNzU1MjgyNTgxNDc1NzcsMzguNDU0OTE1MDI4MTI1MjY0IDQyLjkzODkyNjI2MTQ2MjM2LDQ0LjA0NTA4NDk3MTg3NDczNiAzNy4wNjEwNzM3Mzg1Mzc2NCw0NC4wNDUwODQ5NzE4NzQ3MzYgMzUuMjQ0NzE3NDE4NTI0MjMsMzguNDU0OTE1MDI4MTI1MjY0XCIgZmlsbD1cIiMxNDFmNDdcIi8+PHBvbHlnb24gcG9pbnRzPVwiNDIuNDY4Njk4MDU5NjI4MzksMjMuNjAyMTI4NjIzNjI1MjIgNDMuOTk0NDM3MzY4NDM5NjUsMjguMjk3ODcxMzc2Mzc0NzggNDAsMzEuMiAzNi4wMDU1NjI2MzE1NjAzNSwyOC4yOTc4NzEzNzYzNzQ3OCAzNy41MzEzMDE5NDAzNzE2MSwyMy42MDIxMjg2MjM2MjUyMlwiIGZpbGw9XCIjMTQxZjQ3XCIvPjxwb2x5Z29uIHBvaW50cz1cIjU2LjM1ODE3MjA4MDI3NjY0NSwzNy4yODA2NTA0NDk1MDA0NiA1Mi4zNjM3MzQ3MTE4MzcsNDAuMTgyNzc5MDczMTI1NjkgNDguMzY5Mjk3MzQzMzk3MzUsMzcuMjgwNjUwNDQ5NTAwNDYgNDkuODk1MDM2NjUyMjA4NjEsMzIuNTg0OTA3Njk2NzUwOSA1NC44MzI0MzI3NzE0NjUzODUsMzIuNTg0OTA3Njk2NzUwOVwiIGZpbGw9XCIjMTQxZjQ3XCIvPjxwb2x5Z29uIHBvaW50cz1cIjQ3LjY0MTIwODI3OTgwMjE1LDU0LjcxNzIyMDkyNjg3NDMyIDQzLjY0Njc3MDkxMTM2MjUsNTEuODE1MDkyMzAzMjQ5MDk1IDQ1LjE3MjUxMDIyMDE3Mzc2LDQ3LjExOTM0OTU1MDQ5OTUzNSA1MC4xMDk5MDYzMzk0MzA1NCw0Ny4xMTkzNDk1NTA0OTk1MzUgNTEuNjM1NjQ1NjQ4MjQxOCw1MS44MTUwOTIzMDMyNDkwOTVcIiBmaWxsPVwiIzE0MWY0N1wiLz48cG9seWdvbiBwb2ludHM9XCIyOC4zNjQzNTQzNTE3NTgyMDUsNTEuODE1MDkyMzAzMjQ5MDk1IDI5Ljg5MDA5MzY2MDU2OTQ2Miw0Ny4xMTkzNDk1NTA0OTk1MzUgMzQuODI3NDg5Nzc5ODI2MjQsNDcuMTE5MzQ5NTUwNDk5NTM1IDM2LjM1MzIyOTA4ODYzNzUsNTEuODE1MDkyMzAzMjQ5MDk1IDMyLjM1ODc5MTcyMDE5Nzg1LDU0LjcxNzIyMDkyNjg3NDMyXCIgZmlsbD1cIiMxNDFmNDdcIi8+PHBvbHlnb24gcG9pbnRzPVwiMjUuMTY3NTY3MjI4NTM0NjE1LDMyLjU4NDkwNzY5Njc1MDg5NiAzMC4xMDQ5NjMzNDc3OTEzOSwzMi41ODQ5MDc2OTY3NTA4OTYgMzEuNjMwNzAyNjU2NjAyNjQ3LDM3LjI4MDY1MDQ0OTUwMDQ1NiAyNy42MzYyNjUyODgxNjMwMDMsNDAuMTgyNzc5MDczMTI1NjggMjMuNjQxODI3OTE5NzIzMzU4LDM3LjI4MDY1MDQ0OTUwMDQ1NlwiIGZpbGw9XCIjMTQxZjQ3XCIvPjwvZz48Y2lyY2xlIGN4PVwiNDBcIiBjeT1cIjQwXCIgcj1cIjE2XCIgZmlsbD1cIm5vbmVcIiBzdHJva2U9XCIjMTQxZjQ3XCIgc3Ryb2tlLXdpZHRoPVwiMlwiLz48L2c+PC9zdmc+In0sImJhc2tldGJhbGwiOnsibW90aW9uIjoicm9sbCIsInN2ZyI6Ijxzdmcgdmlld0JveD1cIjAgMCA4MCA4MFwiPjxnIGNsYXNzPVwibGlmZSBsaWZlLXNwaW5cIj48ZGVmcz48Y2xpcFBhdGggaWQ9XCJob29wMlwiPjxjaXJjbGUgY3g9XCI0MFwiIGN5PVwiNDBcIiByPVwiMTUuMlwiLz48L2NsaXBQYXRoPjwvZGVmcz48Y2lyY2xlIGN4PVwiNDBcIiBjeT1cIjQwXCIgcj1cIjE2XCIgZmlsbD1cIiNmZjc1MTBcIi8+PGcgY2xpcC1wYXRoPVwidXJsKCNob29wMilcIiBmaWxsPVwibm9uZVwiIHN0cm9rZT1cIiMxNDFmNDdcIiBzdHJva2Utd2lkdGg9XCIyXCI+PHBhdGggZD1cIk00MCAyNCBWNTYgTTI1IDQwIEg1NVwiLz48cGF0aCBkPVwiTTMxIDI2IFEzNSA0MCAzMSA1NFwiLz48cGF0aCBkPVwiTTQ5IDI2IFE0NSA0MCA0OSA1NFwiLz48L2c+PGNpcmNsZSBjeD1cIjQwXCIgY3k9XCI0MFwiIHI9XCIxNlwiIGZpbGw9XCJub25lXCIgc3Ryb2tlPVwiIzE0MWY0N1wiIHN0cm9rZS13aWR0aD1cIjJcIi8+PC9nPjwvc3ZnPiJ9LCJkb2ciOnsibW90aW9uIjoid2FkZGxlIiwic3ZnIjoiPHN2ZyB2aWV3Qm94PVwiMCAwIDgwIDgwXCI+PGcgY2xhc3M9XCJsaWZlIGxpZmUtd2FnXCIgc3R5bGU9XCJ0cmFuc2Zvcm0tb3JpZ2luOjEwMCUgNTAlXCI+PGcgdHJhbnNmb3JtPVwicm90YXRlKDQyIDMwIDQ3KVwiPjxyZWN0IHg9XCIxXCIgeT1cIjQ1LjVcIiB3aWR0aD1cIjI5XCIgaGVpZ2h0PVwiM1wiIHJ4PVwiMS41XCIgZmlsbD1cIiNiODdhM2RcIi8+PC9nPjwvZz48cmVjdCB4PVwiMjZcIiB5PVwiNTRcIiB3aWR0aD1cIjQuMlwiIGhlaWdodD1cIjEzXCIgcng9XCIyLjFcIiBmaWxsPVwiI2I4N2EzZFwiLz48cmVjdCB4PVwiMzIuNVwiIHk9XCI1NFwiIHdpZHRoPVwiNC4yXCIgaGVpZ2h0PVwiMTNcIiByeD1cIjIuMVwiIGZpbGw9XCIjYjg3YTNkXCIvPjxyZWN0IHg9XCI0NFwiIHk9XCI1NFwiIHdpZHRoPVwiNC4yXCIgaGVpZ2h0PVwiMTNcIiByeD1cIjIuMVwiIGZpbGw9XCIjYjg3YTNkXCIvPjxyZWN0IHg9XCI1MC41XCIgeT1cIjU0XCIgd2lkdGg9XCI0LjJcIiBoZWlnaHQ9XCIxM1wiIHJ4PVwiMi4xXCIgZmlsbD1cIiNiODdhM2RcIi8+PGVsbGlwc2UgY3g9XCI0MFwiIGN5PVwiNDhcIiByeD1cIjIwXCIgcnk9XCIxMlwiIGZpbGw9XCIjYjg3YTNkXCIvPjxlbGxpcHNlIGN4PVwiNDBcIiBjeT1cIjUyXCIgcng9XCIxMFwiIHJ5PVwiNlwiIGZpbGw9XCIjZmZmNmRiXCIvPjxjaXJjbGUgY3g9XCI1OFwiIGN5PVwiMzhcIiByPVwiOVwiIGZpbGw9XCIjYjg3YTNkXCIvPjxlbGxpcHNlIGN4PVwiNTBcIiBjeT1cIjQwXCIgcng9XCI0LjVcIiByeT1cIjlcIiBmaWxsPVwiIzhjNTUyNlwiIHRyYW5zZm9ybT1cInJvdGF0ZSgyMiA1MCA0MClcIi8+PGVsbGlwc2UgY3g9XCI1NVwiIGN5PVwiMzZcIiByeD1cIjRcIiByeT1cIjhcIiBmaWxsPVwiIzhjNTUyNlwiIHRyYW5zZm9ybT1cInJvdGF0ZSg4IDU1IDM2KVwiLz48Y2lyY2xlIGN4PVwiNjJcIiBjeT1cIjM2XCIgcj1cIjJcIiBmaWxsPVwiI2Q3ZWZmZlwiLz48Y2lyY2xlIGN4PVwiNjIuNlwiIGN5PVwiMzZcIiByPVwiMC45XCIgZmlsbD1cIiMxNDFmNDdcIi8+PGVsbGlwc2UgY3g9XCI2NVwiIGN5PVwiNDZcIiByeD1cIjEuMDVcIiByeT1cIjJcIiBmaWxsPVwiI2ZmOGZiOFwiLz48L3N2Zz4ifSwiY2F0Ijp7Im1vdGlvbiI6IndhZGRsZSIsInN2ZyI6Ijxzdmcgdmlld0JveD1cIjAgMCA4MCA4MFwiPjxnIGNsYXNzPVwibGlmZSBsaWZlLXdhZ1wiIHN0eWxlPVwidHJhbnNmb3JtLW9yaWdpbjoxMDAlIDUwJVwiPjxnIHRyYW5zZm9ybT1cInJvdGF0ZSg0MiAzMCA0NylcIj48cmVjdCB4PVwiMVwiIHk9XCI0NS41XCIgd2lkdGg9XCIyOVwiIGhlaWdodD1cIjNcIiByeD1cIjEuNVwiIGZpbGw9XCIjZjU5ZTQ3XCIvPjwvZz48L2c+PGVsbGlwc2UgY3g9XCI0MFwiIGN5PVwiNDhcIiByeD1cIjIwXCIgcnk9XCIxMlwiIGZpbGw9XCIjZjU5ZTQ3XCIvPjxlbGxpcHNlIGN4PVwiNDBcIiBjeT1cIjUyXCIgcng9XCIxMFwiIHJ5PVwiNlwiIGZpbGw9XCIjZmZmNmRiXCIvPjxjaXJjbGUgY3g9XCI1OFwiIGN5PVwiMzhcIiByPVwiOVwiIGZpbGw9XCIjZjU5ZTQ3XCIvPjxwb2x5Z29uIHBvaW50cz1cIjUyLDM0IDU2LDE4IDYwLDM0XCIgZmlsbD1cIiNmNTllNDdcIi8+PGNpcmNsZSBjeD1cIjYyXCIgY3k9XCIzNlwiIHI9XCIyXCIgZmlsbD1cIiNkN2VmZmZcIi8+PGNpcmNsZSBjeD1cIjYyLjZcIiBjeT1cIjM2XCIgcj1cIjAuOVwiIGZpbGw9XCIjMTQxZjQ3XCIvPjwvc3ZnPiJ9LCJtb25rZXkiOnsibW90aW9uIjoid2FkZGxlIiwic3ZnIjoiPHN2ZyB2aWV3Qm94PVwiMCAwIDgwIDgwXCI+PGcgY2xhc3M9XCJsaWZlIGxpZmUtd2FnXCIgc3R5bGU9XCJ0cmFuc2Zvcm0tb3JpZ2luOjEwMCUgNDAlXCI+PHBhdGggZD1cIk0zMCA1OCBDMTggNjQgOCA1NiAxMiA0NiBDMTggNTQgMjQgNTYgMzAgNTQgWlwiIGZpbGw9XCIjOGM1NjJlXCIvPjwvZz48cmVjdCB4PVwiMjJcIiB5PVwiNDJcIiB3aWR0aD1cIjhcIiBoZWlnaHQ9XCIyNFwiIHJ4PVwiNFwiIGZpbGw9XCIjOGM1NjJlXCIgdHJhbnNmb3JtPVwicm90YXRlKC0yNiAyNiA0NClcIi8+PHJlY3QgeD1cIjUwXCIgeT1cIjQyXCIgd2lkdGg9XCI4XCIgaGVpZ2h0PVwiMjRcIiByeD1cIjRcIiBmaWxsPVwiIzhjNTYyZVwiIHRyYW5zZm9ybT1cInJvdGF0ZSgyMiA1NCA0NClcIi8+PGVsbGlwc2UgY3g9XCI0MFwiIGN5PVwiNTBcIiByeD1cIjE1XCIgcnk9XCIxNlwiIGZpbGw9XCIjOGM1NjJlXCIvPjxlbGxpcHNlIGN4PVwiNDBcIiBjeT1cIjU0XCIgcng9XCI3XCIgcnk9XCI4XCIgZmlsbD1cIiNmMmNjYTBcIi8+PGNpcmNsZSBjeD1cIjI0XCIgY3k9XCIzMlwiIHI9XCI2XCIgZmlsbD1cIiM4YzU2MmVcIi8+PGNpcmNsZSBjeD1cIjI0XCIgY3k9XCIzMlwiIHI9XCIzXCIgZmlsbD1cIiNmMmNjYTBcIi8+PGNpcmNsZSBjeD1cIjU2XCIgY3k9XCIzMlwiIHI9XCI2XCIgZmlsbD1cIiM4YzU2MmVcIi8+PGNpcmNsZSBjeD1cIjU2XCIgY3k9XCIzMlwiIHI9XCIzXCIgZmlsbD1cIiNmMmNjYTBcIi8+PGNpcmNsZSBjeD1cIjQwXCIgY3k9XCIzMFwiIHI9XCIxM1wiIGZpbGw9XCIjOGM1NjJlXCIvPjxlbGxpcHNlIGN4PVwiNDBcIiBjeT1cIjM0XCIgcng9XCI4XCIgcnk9XCI2XCIgZmlsbD1cIiNmMmNjYTBcIi8+PGNpcmNsZSBjeD1cIjM2XCIgY3k9XCIzMlwiIHI9XCIyXCIgZmlsbD1cIiNkN2VmZmZcIi8+PGNpcmNsZSBjeD1cIjM2LjZcIiBjeT1cIjMyXCIgcj1cIjAuOVwiIGZpbGw9XCIjMTQxZjQ3XCIvPjxjaXJjbGUgY3g9XCI0NFwiIGN5PVwiMzJcIiByPVwiMlwiIGZpbGw9XCIjZDdlZmZmXCIvPjxjaXJjbGUgY3g9XCI0NC42XCIgY3k9XCIzMlwiIHI9XCIwLjlcIiBmaWxsPVwiIzE0MWY0N1wiLz48L3N2Zz4ifSwicHJpbmNlc3MiOnsibW90aW9uIjoiYm9iIiwic3ZnIjoiPHN2ZyB2aWV3Qm94PVwiMCAwIDgwIDgwXCI+PHBhdGggZD1cIk0yNyAzMiBDMjUgMjIgMzAgMTUgMzkgMTUgQzQ4IDE1IDUzIDIyIDUxIDMyIEw1MiA2MiBDNTIgNzAgNDYgNzMgNDQgNjcgTDQzIDQwIEM0MiAzMyA0MCAzMSAzOSAzMyBDMzggMzEgMzYgMzMgMzUgNDAgTDM0IDY3IEMzMiA3MyAyNiA3MCAyNiA2MiBaXCIgZmlsbD1cIiNmZmU1NmJcIi8+PHJlY3QgeD1cIjMyXCIgeT1cIjM2XCIgd2lkdGg9XCIxNFwiIGhlaWdodD1cIjI0XCIgcng9XCI2XCIgZmlsbD1cIiNiOWE3ZTZcIi8+PGNpcmNsZSBjeD1cIjM5XCIgY3k9XCIzMFwiIHI9XCI4XCIgZmlsbD1cIiNmNWM3YTNcIi8+PHJlY3QgeD1cIjMwXCIgeT1cIjIwXCIgd2lkdGg9XCIxOFwiIGhlaWdodD1cIjRcIiByeD1cIjJcIiBmaWxsPVwiI2ZmYzcwMFwiLz48cG9seWdvbiBwb2ludHM9XCIzMCwyMiAzNCwxMCAzOCwyMlwiIGZpbGw9XCIjZmZjNzAwXCIvPjxwb2x5Z29uIHBvaW50cz1cIjM2LDIyIDQwLDggNDQsMjJcIiBmaWxsPVwiI2ZmYzcwMFwiLz48cG9seWdvbiBwb2ludHM9XCI0MiwyMiA0NiwxMCA1MCwyMlwiIGZpbGw9XCIjZmZjNzAwXCIvPjxjaXJjbGUgY3g9XCI0MFwiIGN5PVwiMTBcIiByPVwiMlwiIGZpbGw9XCIjZTIzYjYyXCIvPjxjaXJjbGUgY3g9XCI0M1wiIGN5PVwiMjlcIiByPVwiMlwiIGZpbGw9XCIjZDdlZmZmXCIvPjxjaXJjbGUgY3g9XCI0My42XCIgY3k9XCIyOVwiIHI9XCIwLjlcIiBmaWxsPVwiIzE0MWY0N1wiLz48L3N2Zz4ifSwiY2FzdGxlIjp7Im1vdGlvbiI6InJlc3QiLCJzdmciOiI8c3ZnIHZpZXdCb3g9XCIwIDAgODAgODBcIj48cmVjdCB4PVwiMThcIiB5PVwiMzZcIiB3aWR0aD1cIjQ0XCIgaGVpZ2h0PVwiMjhcIiBmaWxsPVwiIzhjOTNhOFwiLz48cmVjdCB4PVwiMTZcIiB5PVwiMzBcIiB3aWR0aD1cIjZcIiBoZWlnaHQ9XCI4XCIgZmlsbD1cIiM4YzkzYThcIi8+PHJlY3QgeD1cIjI2XCIgeT1cIjMwXCIgd2lkdGg9XCI2XCIgaGVpZ2h0PVwiOFwiIGZpbGw9XCIjOGM5M2E4XCIvPjxyZWN0IHg9XCI0OFwiIHk9XCIzMFwiIHdpZHRoPVwiNlwiIGhlaWdodD1cIjhcIiBmaWxsPVwiIzhjOTNhOFwiLz48cmVjdCB4PVwiNThcIiB5PVwiMzBcIiB3aWR0aD1cIjZcIiBoZWlnaHQ9XCI4XCIgZmlsbD1cIiM4YzkzYThcIi8+PHJlY3QgeD1cIjE0XCIgeT1cIjIwXCIgd2lkdGg9XCIxNFwiIGhlaWdodD1cIjE4XCIgZmlsbD1cIiM4YzkzYThcIi8+PHJlY3QgeD1cIjUyXCIgeT1cIjIwXCIgd2lkdGg9XCIxNFwiIGhlaWdodD1cIjE4XCIgZmlsbD1cIiM4YzkzYThcIi8+PHJlY3QgeD1cIjEyXCIgeT1cIjE2XCIgd2lkdGg9XCI0XCIgaGVpZ2h0PVwiNlwiIGZpbGw9XCIjOGM5M2E4XCIvPjxyZWN0IHg9XCIxOFwiIHk9XCIxNlwiIHdpZHRoPVwiNFwiIGhlaWdodD1cIjZcIiBmaWxsPVwiIzhjOTNhOFwiLz48cmVjdCB4PVwiMjRcIiB5PVwiMTZcIiB3aWR0aD1cIjRcIiBoZWlnaHQ9XCI2XCIgZmlsbD1cIiM4YzkzYThcIi8+PHJlY3QgeD1cIjUwXCIgeT1cIjE2XCIgd2lkdGg9XCI0XCIgaGVpZ2h0PVwiNlwiIGZpbGw9XCIjOGM5M2E4XCIvPjxyZWN0IHg9XCI1NlwiIHk9XCIxNlwiIHdpZHRoPVwiNFwiIGhlaWdodD1cIjZcIiBmaWxsPVwiIzhjOTNhOFwiLz48cmVjdCB4PVwiNjJcIiB5PVwiMTZcIiB3aWR0aD1cIjRcIiBoZWlnaHQ9XCI2XCIgZmlsbD1cIiM4YzkzYThcIi8+PHBvbHlnb24gcG9pbnRzPVwiMTYsMjAgMjEsMTAgMjYsMjBcIiBmaWxsPVwiI2UyM2I2MlwiLz48cG9seWdvbiBwb2ludHM9XCI1NCwyMCA1OSwxMCA2NCwyMFwiIGZpbGw9XCIjZTIzYjYyXCIvPjxwYXRoIGQ9XCJNMzYgNjQgVjUwIFE0MCA0NCA0NCA1MCBWNjQgWlwiIGZpbGw9XCIjNWM0MDMwXCIvPjxyZWN0IHg9XCIyMlwiIHk9XCI0NFwiIHdpZHRoPVwiNVwiIGhlaWdodD1cIjZcIiBmaWxsPVwiI2Q3ZWZmZlwiLz48cmVjdCB4PVwiNTNcIiB5PVwiNDRcIiB3aWR0aD1cIjVcIiBoZWlnaHQ9XCI2XCIgZmlsbD1cIiNkN2VmZmZcIi8+PHJlY3QgeD1cIjIwXCIgeT1cIjI4XCIgd2lkdGg9XCI0XCIgaGVpZ2h0PVwiNVwiIGZpbGw9XCIjZDdlZmZmXCIvPjxyZWN0IHg9XCI1NlwiIHk9XCIyOFwiIHdpZHRoPVwiNFwiIGhlaWdodD1cIjVcIiBmaWxsPVwiI2Q3ZWZmZlwiLz48L3N2Zz4ifSwiZmFpcnkiOnsibW90aW9uIjoiZmx1dHRlciIsInN2ZyI6Ijxzdmcgdmlld0JveD1cIjAgMCA4MCA4MFwiPjxnIGNsYXNzPVwibGlmZSBsaWZlLWZsYXAtbGVmdFwiIHN0eWxlPVwidHJhbnNmb3JtLW9yaWdpbjoxMDAlIDUwJVwiPjxlbGxpcHNlIGN4PVwiMjZcIiBjeT1cIjM4XCIgcng9XCIxNFwiIHJ5PVwiNS41XCIgZmlsbD1cIiNkN2VmZmZcIi8+PC9nPjxnIGNsYXNzPVwibGlmZSBsaWZlLWZsYXAtcmlnaHRcIiBzdHlsZT1cInRyYW5zZm9ybS1vcmlnaW46MCUgNTAlXCI+PGVsbGlwc2UgY3g9XCI1NFwiIGN5PVwiMzhcIiByeD1cIjE0XCIgcnk9XCI1LjVcIiBmaWxsPVwiI2I5YTdlNlwiLz48L2c+PHJlY3QgeD1cIjM2XCIgeT1cIjM0XCIgd2lkdGg9XCI4XCIgaGVpZ2h0PVwiMjJcIiByeD1cIjRcIiBmaWxsPVwiI2Y1OWViM1wiLz48Y2lyY2xlIGN4PVwiNDBcIiBjeT1cIjI4XCIgcj1cIjZcIiBmaWxsPVwiI2Y1YzdhM1wiLz48Y2lyY2xlIGN4PVwiMzcuMlwiIGN5PVwiMjcuNFwiIHI9XCIxLjI1XCIgZmlsbD1cIiNkN2VmZmZcIi8+PGNpcmNsZSBjeD1cIjM3LjU3NVwiIGN5PVwiMjcuNFwiIHI9XCIwLjU2MjVcIiBmaWxsPVwiIzE0MWY0N1wiLz48Y2lyY2xlIGN4PVwiNDIuOFwiIGN5PVwiMjcuNFwiIHI9XCIxLjI1XCIgZmlsbD1cIiNkN2VmZmZcIi8+PGNpcmNsZSBjeD1cIjQzLjE3NVwiIGN5PVwiMjcuNFwiIHI9XCIwLjU2MjVcIiBmaWxsPVwiIzE0MWY0N1wiLz48L3N2Zz4ifSwiYWlycGxhbmUiOnsibW90aW9uIjoiZ2xpZGUiLCJzdmciOiI8c3ZnIHZpZXdCb3g9XCIwIDAgODAgODBcIj48cG9seWdvbiBwb2ludHM9XCIxNiwzNiAyNCwzNiAxNCwyMFwiIGZpbGw9XCIjOGVjOGU4XCIvPjxyZWN0IHg9XCIxMFwiIHk9XCIzN1wiIHdpZHRoPVwiMTZcIiBoZWlnaHQ9XCI0XCIgcng9XCIxXCIgZmlsbD1cIiM4ZWM4ZThcIi8+PHJlY3QgeD1cIjE2XCIgeT1cIjM2XCIgd2lkdGg9XCI1MFwiIGhlaWdodD1cIjhcIiByeD1cIjRcIiBmaWxsPVwiI2Q3ZWZmZlwiLz48ZyBjbGFzcz1cImxpZmUgbGlmZS13aW5nXCIgc3R5bGU9XCJ0cmFuc2Zvcm0tb3JpZ2luOjcwJSA4MiVcIj48cG9seWdvbiBwb2ludHM9XCI0OCwzOSAzNCwyOCAyOCwzMyAzOCw0NFwiIGZpbGw9XCIjOGVjOGU4XCIvPjwvZz48Y2lyY2xlIGN4PVwiMzJcIiBjeT1cIjQwXCIgcj1cIjEuNFwiIGZpbGw9XCIjMTQxZjQ3XCIvPjxjaXJjbGUgY3g9XCIzOFwiIGN5PVwiNDBcIiByPVwiMS40XCIgZmlsbD1cIiMxNDFmNDdcIi8+PGNpcmNsZSBjeD1cIjQ0XCIgY3k9XCI0MFwiIHI9XCIxLjRcIiBmaWxsPVwiIzE0MWY0N1wiLz48Y2lyY2xlIGN4PVwiNTBcIiBjeT1cIjQwXCIgcj1cIjEuNFwiIGZpbGw9XCIjMTQxZjQ3XCIvPjwvc3ZnPiJ9LCJ0cmFpbiI6eyJtb3Rpb24iOiJkcml2ZSIsInN2ZyI6Ijxzdmcgdmlld0JveD1cIjAgMCA4MCA4MFwiPjxyZWN0IHg9XCIxNlwiIHk9XCIzNlwiIHdpZHRoPVwiNDZcIiBoZWlnaHQ9XCIxOFwiIHJ4PVwiM1wiIGZpbGw9XCIjZTIzYjYyXCIvPjxyZWN0IHg9XCI0NlwiIHk9XCIyNlwiIHdpZHRoPVwiMTRcIiBoZWlnaHQ9XCIxNFwiIHJ4PVwiMlwiIGZpbGw9XCIjMTQxZjQ3XCIvPjxjaXJjbGUgY3g9XCIyOFwiIGN5PVwiNTZcIiByPVwiNVwiIGZpbGw9XCJub25lXCIgc3Ryb2tlPVwiIzE0MWY0N1wiIHN0cm9rZS13aWR0aD1cIjJcIi8+PGNpcmNsZSBjeD1cIjQ4XCIgY3k9XCI1NlwiIHI9XCI1XCIgZmlsbD1cIm5vbmVcIiBzdHJva2U9XCIjMTQxZjQ3XCIgc3Ryb2tlLXdpZHRoPVwiMlwiLz48L3N2Zz4ifSwiY2FyIjp7Im1vdGlvbiI6ImRyaXZlIiwic3ZnIjoiPHN2ZyB2aWV3Qm94PVwiMCAwIDgwIDgwXCI+PHJlY3QgeD1cIjE0XCIgeT1cIjM4XCIgd2lkdGg9XCI1MlwiIGhlaWdodD1cIjE2XCIgcng9XCI0XCIgZmlsbD1cIiM4ZWM4ZThcIi8+PHJlY3QgeD1cIjI2XCIgeT1cIjI4XCIgd2lkdGg9XCIyNFwiIGhlaWdodD1cIjEyXCIgcng9XCIzXCIgZmlsbD1cIiNkN2VmZmZcIi8+PGNpcmNsZSBjeD1cIjI2XCIgY3k9XCI1NlwiIHI9XCI1XCIgZmlsbD1cIiMxNDFmNDdcIi8+PGNpcmNsZSBjeD1cIjU0XCIgY3k9XCI1NlwiIHI9XCI1XCIgZmlsbD1cIiMxNDFmNDdcIi8+PC9zdmc+In0sInJvYm90Ijp7Im1vdGlvbiI6IndhZGRsZSIsInN2ZyI6Ijxzdmcgdmlld0JveD1cIjAgMCA4MCA4MFwiPjxyZWN0IHg9XCIyNlwiIHk9XCIzNlwiIHdpZHRoPVwiMjhcIiBoZWlnaHQ9XCIyMlwiIHJ4PVwiNFwiIGZpbGw9XCIjOGVjOGU4XCIvPjxyZWN0IHg9XCIyOFwiIHk9XCIxOFwiIHdpZHRoPVwiMjRcIiBoZWlnaHQ9XCIxNlwiIHJ4PVwiNFwiIGZpbGw9XCIjZDdlZmZmXCIvPjxjaXJjbGUgY3g9XCIzNlwiIGN5PVwiMjZcIiByPVwiM1wiIGZpbGw9XCIjZDdlZmZmXCIvPjxjaXJjbGUgY3g9XCIzNi45XCIgY3k9XCIyNlwiIHI9XCIxLjM1XCIgZmlsbD1cIiMxNDFmNDdcIi8+PGNpcmNsZSBjeD1cIjQ4XCIgY3k9XCIyNlwiIHI9XCIzXCIgZmlsbD1cIiNkN2VmZmZcIi8+PGNpcmNsZSBjeD1cIjQ4LjlcIiBjeT1cIjI2XCIgcj1cIjEuMzVcIiBmaWxsPVwiIzE0MWY0N1wiLz48Y2lyY2xlIGN4PVwiNDBcIiBjeT1cIjEyXCIgcj1cIjNcIiBmaWxsPVwiI2ZmYzcwMFwiLz48Y2lyY2xlIGN4PVwiMzJcIiBjeT1cIjYwXCIgcj1cIjRcIiBmaWxsPVwibm9uZVwiIHN0cm9rZT1cIiMxNDFmNDdcIiBzdHJva2Utd2lkdGg9XCIyXCIvPjxjaXJjbGUgY3g9XCI1MFwiIGN5PVwiNjBcIiByPVwiNFwiIGZpbGw9XCJub25lXCIgc3Ryb2tlPVwiIzE0MWY0N1wiIHN0cm9rZS13aWR0aD1cIjJcIi8+PC9zdmc+In0sImhlcm8iOnsibW90aW9uIjoiZmxvYXQiLCJzdmciOiI8c3ZnIHZpZXdCb3g9XCIwIDAgODAgODBcIj48ZyBjbGFzcz1cImxpZmUgbGlmZS13aW5nXCI+PGVsbGlwc2UgY3g9XCIyNFwiIGN5PVwiNDZcIiByeD1cIjE0XCIgcnk9XCI2XCIgZmlsbD1cIiNlMjNiNjJcIiB0cmFuc2Zvcm09XCJyb3RhdGUoLTE2IDI0IDQ2KVwiLz48L2c+PHJlY3QgeD1cIjMyXCIgeT1cIjM2XCIgd2lkdGg9XCIxMlwiIGhlaWdodD1cIjI0XCIgcng9XCI2XCIgZmlsbD1cIiM4ZWM4ZThcIi8+PGNpcmNsZSBjeD1cIjM4XCIgY3k9XCIyNlwiIHI9XCI4XCIgZmlsbD1cIiNmNWM3YTNcIi8+PGNpcmNsZSBjeD1cIjQyXCIgY3k9XCIyNVwiIHI9XCIyXCIgZmlsbD1cIiNkN2VmZmZcIi8+PGNpcmNsZSBjeD1cIjQyLjZcIiBjeT1cIjI1XCIgcj1cIjAuOVwiIGZpbGw9XCIjMTQxZjQ3XCIvPjwvc3ZnPiJ9LCJwYWludGJydXNoIjp7Im1vdGlvbiI6InJlc3QiLCJzdmciOiI8c3ZnIHZpZXdCb3g9XCIwIDAgODAgODBcIj48cmVjdCB4PVwiMzZcIiB5PVwiNDJcIiB3aWR0aD1cIjhcIiBoZWlnaHQ9XCIyNFwiIHJ4PVwiM1wiIGZpbGw9XCIjOGM1MjI4XCIvPjxyZWN0IHg9XCIzMVwiIHk9XCIzNlwiIHdpZHRoPVwiMThcIiBoZWlnaHQ9XCI4XCIgcng9XCIyXCIgZmlsbD1cIiNjNGE1NzRcIi8+PHJlY3QgeD1cIjMyXCIgeT1cIjIxXCIgd2lkdGg9XCIxLjRcIiBoZWlnaHQ9XCIxOFwiIHJ4PVwiMC43XCIgZmlsbD1cIiNlNmQzYjBcIi8+PHJlY3QgeD1cIjM0XCIgeT1cIjIzXCIgd2lkdGg9XCIxLjRcIiBoZWlnaHQ9XCIxNlwiIHJ4PVwiMC43XCIgZmlsbD1cIiNlNmQzYjBcIi8+PHJlY3QgeD1cIjM2XCIgeT1cIjIxXCIgd2lkdGg9XCIxLjRcIiBoZWlnaHQ9XCIxOFwiIHJ4PVwiMC43XCIgZmlsbD1cIiNlNmQzYjBcIi8+PHJlY3QgeD1cIjM4XCIgeT1cIjIzXCIgd2lkdGg9XCIxLjRcIiBoZWlnaHQ9XCIxNlwiIHJ4PVwiMC43XCIgZmlsbD1cIiNlNmQzYjBcIi8+PHJlY3QgeD1cIjQwXCIgeT1cIjIxXCIgd2lkdGg9XCIxLjRcIiBoZWlnaHQ9XCIxOFwiIHJ4PVwiMC43XCIgZmlsbD1cIiNlNmQzYjBcIi8+PHJlY3QgeD1cIjQyXCIgeT1cIjIzXCIgd2lkdGg9XCIxLjRcIiBoZWlnaHQ9XCIxNlwiIHJ4PVwiMC43XCIgZmlsbD1cIiNlNmQzYjBcIi8+PHJlY3QgeD1cIjQ0XCIgeT1cIjIxXCIgd2lkdGg9XCIxLjRcIiBoZWlnaHQ9XCIxOFwiIHJ4PVwiMC43XCIgZmlsbD1cIiNlNmQzYjBcIi8+PHJlY3QgeD1cIjQ2XCIgeT1cIjIzXCIgd2lkdGg9XCIxLjRcIiBoZWlnaHQ9XCIxNlwiIHJ4PVwiMC43XCIgZmlsbD1cIiNlNmQzYjBcIi8+PC9zdmc+In0sImRydW0iOnsibW90aW9uIjoicmVzdCIsInN2ZyI6Ijxzdmcgdmlld0JveD1cIjAgMCA4MCA4MFwiPjxlbGxpcHNlIGN4PVwiNDBcIiBjeT1cIjQ4XCIgcng9XCIxOFwiIHJ5PVwiMTRcIiBmaWxsPVwiI2UyM2I2MlwiLz48ZWxsaXBzZSBjeD1cIjQwXCIgY3k9XCI0MFwiIHJ4PVwiMThcIiByeT1cIjdcIiBmaWxsPVwiI2ZmZjZkYlwiLz48cmVjdCB4PVwiNDhcIiB5PVwiMjRcIiB3aWR0aD1cIjE2XCIgaGVpZ2h0PVwiM1wiIGZpbGw9XCIjOGM1MjI4XCIgdHJhbnNmb3JtPVwicm90YXRlKC0zMCA1NiAyNSlcIi8+PC9zdmc+In0sImN1cGNha2UiOnsibW90aW9uIjoiYm9iIiwic3ZnIjoiPHN2ZyB2aWV3Qm94PVwiMCAwIDgwIDgwXCI+PHBhdGggZD1cIk0yNCA0MCBINTYgTDUwIDY2IEgzMCBaXCIgZmlsbD1cIiNmZmY2ZGJcIiBzdHJva2U9XCIjZGI5ZTU3XCIgc3Ryb2tlLXdpZHRoPVwiMS41XCIvPjxwYXRoIGQ9XCJNMzIgNDAgTDM0IDY2IE00MCA0MCBWNjYgTTQ4IDQwIEw0NiA2NlwiIHN0cm9rZT1cIiNmM2Q3YjBcIiBzdHJva2Utd2lkdGg9XCIxLjZcIi8+PGVsbGlwc2UgY3g9XCI0MFwiIGN5PVwiMzhcIiByeD1cIjE4XCIgcnk9XCIxMFwiIGZpbGw9XCIjZTIzYjYyXCIvPjxlbGxpcHNlIGN4PVwiMzNcIiBjeT1cIjM2XCIgcng9XCI4XCIgcnk9XCI2XCIgZmlsbD1cIiNmMjdhOTZcIi8+PGVsbGlwc2UgY3g9XCI0N1wiIGN5PVwiMzVcIiByeD1cIjdcIiByeT1cIjVcIiBmaWxsPVwiI2YyN2E5NlwiLz48Y2lyY2xlIGN4PVwiNDBcIiBjeT1cIjMwXCIgcj1cIjVcIiBmaWxsPVwiI2UyM2I2MlwiLz48Y2lyY2xlIGN4PVwiNDBcIiBjeT1cIjIzXCIgcj1cIjMuNVwiIGZpbGw9XCIjZmY3NTEwXCIvPjwvc3ZnPiJ9LCJidXR0ZXJmbHkiOnsibW90aW9uIjoiZmx1dHRlciIsInN2ZyI6Ijxzdmcgdmlld0JveD1cIjAgMCA4MCA4MFwiPjxnIGNsYXNzPVwibGlmZSBsaWZlLXdpbmdcIj48ZWxsaXBzZSBjeD1cIjI0XCIgY3k9XCIzNlwiIHJ4PVwiMTJcIiByeT1cIjEwXCIgZmlsbD1cIiNiOWE3ZTZcIi8+PGVsbGlwc2UgY3g9XCI1NlwiIGN5PVwiMzZcIiByeD1cIjEyXCIgcnk9XCIxMFwiIGZpbGw9XCIjZTIzYjYyXCIvPjwvZz48cmVjdCB4PVwiMzdcIiB5PVwiMjhcIiB3aWR0aD1cIjZcIiBoZWlnaHQ9XCIyOFwiIHJ4PVwiM1wiIGZpbGw9XCIjMTQxZjQ3XCIvPjwvc3ZnPiJ9LCJjb3ciOnsibW90aW9uIjoid2FkZGxlIiwic3ZnIjoiPHN2ZyB2aWV3Qm94PVwiMCAwIDgwIDgwXCI+PGcgY2xhc3M9XCJsaWZlIGxpZmUtd2FnXCI+PHJlY3QgeD1cIjEyXCIgeT1cIjQ0XCIgd2lkdGg9XCIxNlwiIGhlaWdodD1cIjZcIiByeD1cIjNcIiBmaWxsPVwiI2ZmZjZkYlwiLz48L2c+PGVsbGlwc2UgY3g9XCI0MFwiIGN5PVwiNDhcIiByeD1cIjIwXCIgcnk9XCIxMlwiIGZpbGw9XCIjZmZmNmRiXCIvPjxlbGxpcHNlIGN4PVwiNDBcIiBjeT1cIjUyXCIgcng9XCIxMFwiIHJ5PVwiNlwiIGZpbGw9XCIjZmZmNmRiXCIvPjxjaXJjbGUgY3g9XCI1OFwiIGN5PVwiMzhcIiByPVwiOVwiIGZpbGw9XCIjZmZmNmRiXCIvPjxjaXJjbGUgY3g9XCI1NlwiIGN5PVwiMzBcIiByPVwiNFwiIGZpbGw9XCIjZmZmNmRiXCIvPjxjaXJjbGUgY3g9XCI2MlwiIGN5PVwiMzZcIiByPVwiMlwiIGZpbGw9XCIjZDdlZmZmXCIvPjxjaXJjbGUgY3g9XCI2Mi42XCIgY3k9XCIzNlwiIHI9XCIwLjlcIiBmaWxsPVwiIzE0MWY0N1wiLz48Y2lyY2xlIGN4PVwiMzRcIiBjeT1cIjQ0XCIgcj1cIjRcIiBmaWxsPVwiIzJjMjQxZlwiLz48Y2lyY2xlIGN4PVwiNDhcIiBjeT1cIjQ4XCIgcj1cIjNcIiBmaWxsPVwiIzJjMjQxZlwiLz48L3N2Zz4ifSwicGlyYXRlIjp7Im1vdGlvbiI6ImJvYiIsInN2ZyI6Ijxzdmcgdmlld0JveD1cIjAgMCA4MCA4MFwiPjxyZWN0IHg9XCIzMlwiIHk9XCIzNlwiIHdpZHRoPVwiMTRcIiBoZWlnaHQ9XCIyNFwiIHJ4PVwiNlwiIGZpbGw9XCIjMTQxZjQ3XCIvPjxjaXJjbGUgY3g9XCIzOVwiIGN5PVwiMzJcIiByPVwiOFwiIGZpbGw9XCIjZjVjN2EzXCIvPjxjaXJjbGUgY3g9XCI0M1wiIGN5PVwiMzFcIiByPVwiMlwiIGZpbGw9XCIjZDdlZmZmXCIvPjxjaXJjbGUgY3g9XCI0My42XCIgY3k9XCIzMVwiIHI9XCIwLjlcIiBmaWxsPVwiIzE0MWY0N1wiLz48cGF0aCBkPVwiTTE0IDMwIEwzMCAxMiBMMzkgMjAgTDQ4IDEyIEw2NCAzMCBRMzkgMjQgMTQgMzAgWlwiIGZpbGw9XCIjMTQxZjQ3XCIgc3Ryb2tlPVwiI2ZmZlwiIHN0cm9rZS13aWR0aD1cIjEuNFwiIHN0cm9rZS1saW5lam9pbj1cInJvdW5kXCIvPjxjaXJjbGUgY3g9XCIzOVwiIGN5PVwiMThcIiByPVwiMy40XCIgZmlsbD1cIiNmZmZcIi8+PGNpcmNsZSBjeD1cIjM3LjhcIiBjeT1cIjE3LjRcIiByPVwiMC41NVwiIGZpbGw9XCIjMTQxZjQ3XCIvPjxjaXJjbGUgY3g9XCI0MC4yXCIgY3k9XCIxNy40XCIgcj1cIjAuNTVcIiBmaWxsPVwiIzE0MWY0N1wiLz48cGF0aCBkPVwiTTM3LjYgMTkuNiBRMzkgMjAuNiA0MC40IDE5LjZcIiBmaWxsPVwibm9uZVwiIHN0cm9rZT1cIiMxNDFmNDdcIiBzdHJva2Utd2lkdGg9XCIwLjVcIi8+PC9zdmc+In0sInZvbGNhbm8iOnsibW90aW9uIjoicmVzdCIsInN2ZyI6Ijxzdmcgdmlld0JveD1cIjAgMCA4MCA4MFwiPjxwb2x5Z29uIHBvaW50cz1cIjE0LDYyIDQwLDI0IDY2LDYyXCIgZmlsbD1cIiM3MzQ4MzhcIi8+PGcgY2xhc3M9XCJsaWZlIGxpZmUtc21va2VcIj48Y2lyY2xlIGN4PVwiNDBcIiBjeT1cIjIyXCIgcj1cIjVcIiBmaWxsPVwiI2ZmZjZkYlwiLz48Y2lyY2xlIGN4PVwiNDhcIiBjeT1cIjE2XCIgcj1cIjNcIiBmaWxsPVwiI2ZmZlwiLz48L2c+PC9zdmc+In0sImNsb3VkIjp7Im1vdGlvbiI6ImZsb2F0Iiwic3ZnIjoiPHN2ZyB2aWV3Qm94PVwiMCAwIDgwIDgwXCI+PGVsbGlwc2UgY3g9XCI0MFwiIGN5PVwiNDJcIiByeD1cIjIxXCIgcnk9XCIxNVwiIGZpbGw9XCIjNWE3YTlhXCIvPjxlbGxpcHNlIGN4PVwiMjZcIiBjeT1cIjQ2XCIgcng9XCIxN1wiIHJ5PVwiMTNcIiBmaWxsPVwiIzVhN2E5YVwiLz48ZWxsaXBzZSBjeD1cIjU0XCIgY3k9XCI0NlwiIHJ4PVwiMThcIiByeT1cIjEzXCIgZmlsbD1cIiM1YTdhOWFcIi8+PGVsbGlwc2UgY3g9XCI0MFwiIGN5PVwiMzRcIiByeD1cIjEzXCIgcnk9XCIxMVwiIGZpbGw9XCIjNWE3YTlhXCIvPjxlbGxpcHNlIGN4PVwiNDBcIiBjeT1cIjQyXCIgcng9XCIxOFwiIHJ5PVwiMTJcIiBmaWxsPVwiI2ZmZlwiLz48ZWxsaXBzZSBjeD1cIjI2XCIgY3k9XCI0NlwiIHJ4PVwiMTRcIiByeT1cIjEwXCIgZmlsbD1cIiNmZmZcIi8+PGVsbGlwc2UgY3g9XCI1NFwiIGN5PVwiNDZcIiByeD1cIjE1XCIgcnk9XCIxMFwiIGZpbGw9XCIjZmZmXCIvPjxlbGxpcHNlIGN4PVwiNDBcIiBjeT1cIjM0XCIgcng9XCIxMFwiIHJ5PVwiOFwiIGZpbGw9XCIjZmZmXCIvPjwvc3ZnPiJ9LCJsZWFmIjp7Im1vdGlvbiI6ImZsdXR0ZXIiLCJzdmciOiI8c3ZnIHZpZXdCb3g9XCIwIDAgODAgODBcIj48ZWxsaXBzZSBjeD1cIjQwXCIgY3k9XCI0MFwiIHJ4PVwiMTJcIiByeT1cIjIyXCIgZmlsbD1cIiMzOGE4NjFcIiB0cmFuc2Zvcm09XCJyb3RhdGUoLTIwIDQwIDQwKVwiLz48cmVjdCB4PVwiMzlcIiB5PVwiMjJcIiB3aWR0aD1cIjJcIiBoZWlnaHQ9XCIzMlwiIGZpbGw9XCIjMWY2YjNhXCIgdHJhbnNmb3JtPVwicm90YXRlKC0yMCA0MCA0MClcIi8+PHJlY3QgeD1cIjMwXCIgeT1cIjMyXCIgd2lkdGg9XCIxMlwiIGhlaWdodD1cIjJcIiBmaWxsPVwiIzFmNmIzYVwiIHRyYW5zZm9ybT1cInJvdGF0ZSgtNTAgMzYgMzMpXCIvPjxyZWN0IHg9XCI0MFwiIHk9XCI0MFwiIHdpZHRoPVwiMTJcIiBoZWlnaHQ9XCIyXCIgZmlsbD1cIiMxZjZiM2FcIiB0cmFuc2Zvcm09XCJyb3RhdGUoMTAgNDYgNDEpXCIvPjwvc3ZnPiJ9fQ=="
}

private struct SVGDocument {
    var root = SVGNode(name: "svg")
    var clips: [String: SVGNode] = [:]

    init(svg: String) {
        let parser = SVGXMLParser()
        parser.parse(svg)
        root = parser.root
        clips = parser.clips
    }
}

private final class SVGNode {
    var name: String
    var attrs: [String: String]
    var children: [SVGNode] = []

    init(name: String, attrs: [String: String] = [:]) {
        self.name = name
        self.attrs = attrs
    }
}

private final class SVGXMLParser: NSObject, XMLParserDelegate {
    var root = SVGNode(name: "svg")
    var clips: [String: SVGNode] = [:]
    private var stack: [SVGNode] = []

    func parse(_ svg: String) {
        let parser = XMLParser(data: Data(svg.utf8))
        parser.delegate = self
        parser.parse()
    }

    func parser(_ parser: XMLParser, didStartElement name: String, namespaceURI: String?, qualifiedName: String?, attributes: [String: String] = [:]) {
        stack.append(SVGNode(name: name, attrs: attributes))
    }

    func parser(_ parser: XMLParser, didEndElement name: String, namespaceURI: String?, qualifiedName: String?) {
        guard let node = stack.popLast() else { return }
        if node.name == "clipPath", let id = node.attrs["id"] {
            clips[id] = node
        }
        if let parent = stack.last {
            parent.children.append(node)
        } else {
            root = node
        }
    }
}

private struct SVGPaint {
    var fill: Color? = .black
    var stroke: Color?
    var strokeWidth: CGFloat = 1
    var opacity: Double = 1
    var lineCap: CGLineCap = .butt
    var lineJoin: CGLineJoin = .miter

    func merging(_ attrs: [String: String]) -> SVGPaint {
        var next = self
        if let fill = attrs["fill"] {
            next.fill = fill == "none" ? nil : Color(svgHex: fill)
        }
        if let stroke = attrs["stroke"] {
            next.stroke = stroke == "none" ? nil : Color(svgHex: stroke)
        }
        if let width = attrs["stroke-width"], let value = Double(width) {
            next.strokeWidth = CGFloat(value)
        }
        if let opacity = attrs["opacity"], let value = Double(opacity) {
            next.opacity *= value
        }
        if let cap = attrs["stroke-linecap"] {
            next.lineCap = cap == "round" ? .round : cap == "square" ? .square : .butt
        }
        if let join = attrs["stroke-linejoin"] {
            next.lineJoin = join == "round" ? .round : join == "bevel" ? .bevel : .miter
        }
        return next
    }
}

private enum ReviewListDrawer {
    static func draw(_ picture: ReviewPicture, in context: inout GraphicsContext, size: CGSize, time: TimeInterval) {
        let fit = min(size.width, size.height)
        let scale = fit / 80 * 0.86
        let pad = (fit - 80 * scale) / 2
        context.translateBy(x: pad, y: pad)
        context.scaleBy(x: scale, y: scale)
        let travel = motion(picture.motion, time: time)
        context.opacity *= travel.opacity
        context.concatenate(travel.transform)
        draw(picture.document.root, in: &context, style: SVGPaint(), time: time, clips: picture.document.clips)
    }

    private static func draw(_ node: SVGNode, in context: inout GraphicsContext, style: SVGPaint, time: TimeInterval, clips: [String: SVGNode]) {
        if node.name == "defs" || node.name == "clipPath" { return }
        let paint = style.merging(node.attrs)
        context.drawLayer { layer in
            if let transform = svgTransform(node.attrs["transform"]) {
                layer.concatenate(transform)
            }
            if let life = lifeName(node.attrs["class"]) {
                let box = contentBounds(node, style: paint)
                let origin = transformOrigin(node.attrs["style"], box: box)
                layer.concatenate(lifeTransform(life, time: time, origin: origin))
                layer.opacity *= lifeOpacity(life, time: time)
            }
            if let clip = clipPath(node.attrs["clip-path"], clips: clips, style: paint) {
                layer.clip(to: clip)
            }
            if let path = shape(node) {
                fill(path, paint: paint, in: &layer)
            } else {
                for child in node.children {
                    draw(child, in: &layer, style: paint, time: time, clips: clips)
                }
            }
        }
    }

    private static func fill(_ path: Path, paint: SVGPaint, in context: inout GraphicsContext) {
        if let fill = paint.fill {
            context.fill(path, with: .color(fill.opacity(paint.opacity)))
        }
        if let stroke = paint.stroke, paint.strokeWidth > 0 {
            context.stroke(
                path,
                with: .color(stroke.opacity(paint.opacity)),
                style: StrokeStyle(lineWidth: paint.strokeWidth, lineCap: paint.lineCap, lineJoin: paint.lineJoin)
            )
        }
    }

    private static func shape(_ node: SVGNode) -> Path? {
        switch node.name {
        case "circle":
            let cx = cg(node, "cx"), cy = cg(node, "cy"), r = cg(node, "r")
            return Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2))
        case "ellipse":
            let cx = cg(node, "cx"), cy = cg(node, "cy"), rx = cg(node, "rx"), ry = cg(node, "ry")
            return Path(ellipseIn: CGRect(x: cx - rx, y: cy - ry, width: rx * 2, height: ry * 2))
        case "rect":
            let rect = CGRect(x: cg(node, "x"), y: cg(node, "y"), width: cg(node, "width"), height: cg(node, "height"))
            let radius = cg(node, "rx")
            var path = Path()
            if radius > 0 {
                path.addRoundedRect(in: rect, cornerSize: CGSize(width: radius, height: radius))
            } else {
                path.addRect(rect)
            }
            return path
        case "polygon":
            let pairs = numbers(node.attrs["points"] ?? "")
            guard pairs.count >= 2 else { return nil }
            var path = Path()
            path.move(to: CGPoint(x: pairs[0], y: pairs[1]))
            var index = 2
            while index + 1 < pairs.count {
                path.addLine(to: CGPoint(x: pairs[index], y: pairs[index + 1]))
                index += 2
            }
            path.closeSubpath()
            return path
        case "path":
            return svgPath(node.attrs["d"] ?? "")
        default:
            return nil
        }
    }

    private static func contentBounds(_ node: SVGNode, style: SVGPaint) -> CGRect {
        let paint = style.merging(node.attrs)
        if let path = shape(node) {
            let box = path.boundingRect
            guard let transform = svgTransform(node.attrs["transform"]) else { return box }
            return box.applying(transform)
        }
        var box = CGRect.null
        for child in node.children where child.name != "defs" && child.name != "clipPath" {
            box = box.union(contentBounds(child, style: paint))
        }
        if let transform = svgTransform(node.attrs["transform"]), !box.isNull {
            return box.applying(transform)
        }
        return box.isNull ? CGRect(x: 0, y: 0, width: 80, height: 80) : box
    }

    private static func cg(_ node: SVGNode, _ key: String) -> CGFloat {
        CGFloat(Double(node.attrs[key] ?? "") ?? 0)
    }

    /// Review-list travel, scaled from the 168pt stage into the 80-unit picture.
    private static func motion(_ name: String, time: TimeInterval) -> (transform: CGAffineTransform, opacity: Double) {
        let amount = pulse(time, duration: duration(name))
        let unit = 80 / 168 as CGFloat
        var dx: CGFloat = 0
        var dy: CGFloat = 0
        var angle: CGFloat = 0
        var opacity = 1.0
        switch name {
        case "flutter":
            dy = -16 * amount
            angle = -12 * amount
        case "waddle":
            dx = -8 + 16 * amount
            angle = -7 + 14 * amount
        case "trot":
            dx = 16 * amount
            dy = -6 * amount
            angle = 3 * amount
        case "hop":
            dy = -26 * amount
        case "swim":
            dx = 24 * amount
            dy = -8 * amount
            angle = 6 * amount
        case "roll":
            dx = 16 * amount
            angle = 20 * amount
        case "drive":
            dx = 22 * amount
        case "bob":
            dy = -12 * amount
        case "rest":
            dy = -4 * amount
        case "twinkle":
            dy = -8 * amount
            opacity = 1 - 0.45 * Double(amount)
        case "float":
            dy = -28 * amount
        case "glide":
            dx = 26 * amount
            dy = -12 * amount
            angle = -5 * amount
        default:
            break
        }
        let spin = CGAffineTransform(translationX: dx * unit, y: dy * unit)
            .rotated(by: angle * .pi / 180)
        let transform = CGAffineTransform(translationX: 40, y: 40)
            .concatenating(spin)
            .concatenating(CGAffineTransform(translationX: -40, y: -40))
        return (transform, opacity)
    }

    private static func duration(_ name: String) -> Double {
        switch name {
        case "flutter": return 0.85
        case "waddle": return 0.42
        case "trot": return 0.72
        case "hop": return 0.48
        case "swim": return 1.4
        case "roll": return 0.85
        case "drive": return 1.15
        case "bob": return 1.2
        case "rest": return 2
        case "twinkle": return 0.75
        case "float": return 1.7
        case "glide": return 1.45
        default: return 1
        }
    }

    private static func lifeName(_ className: String?) -> String? {
        guard let className else { return nil }
        return className.split(separator: " ").first { $0.hasPrefix("life-") }.map { String($0.dropFirst(5)) }
    }

    private static func lifeTransform(_ life: String, time: TimeInterval, origin: CGPoint) -> CGAffineTransform {
        switch life {
        case "spin":
            let turns = time / 4.5
            return rotation(CGFloat(turns.truncatingRemainder(dividingBy: 1)) * 360, around: origin)
        case "wag":
            return rotation(16 * pulse(time, duration: 0.45), around: origin)
        case "wing":
            return rotation(-18 * pulse(time, duration: 0.42), around: origin)
        case "flap-left":
            return rotation(14 + 32 * pulse(time, duration: 0.38), around: origin)
        case "flap-right":
            return rotation(-14 - 32 * pulse(time, duration: 0.38), around: origin)
        case "smoke":
            let lift = -12 * pulse(time, duration: 1.6) * (80 / 168)
            return CGAffineTransform(translationX: 0, y: lift)
        default:
            return .identity
        }
    }

    private static func lifeOpacity(_ life: String, time: TimeInterval) -> Double {
        switch life {
        case "smoke":
            return 1 - 0.65 * Double(pulse(time, duration: 1.6))
        case "blink":
            return 1 - 0.8 * Double(pulse(time, duration: 0.9))
        default:
            return 1
        }
    }

    private static func rotation(_ degrees: CGFloat, around origin: CGPoint) -> CGAffineTransform {
        CGAffineTransform(translationX: origin.x, y: origin.y)
            .rotated(by: degrees * .pi / 180)
            .translatedBy(x: -origin.x, y: -origin.y)
    }

    private static func transformOrigin(_ style: String?, box: CGRect) -> CGPoint {
        var xPercent: CGFloat = 50
        var yPercent: CGFloat = 50
        if let style, let range = style.range(of: "transform-origin:") {
            let value = style[range.upperBound...].split(separator: ";").first.map(String.init) ?? ""
            let parts = value.split { $0 == " " || $0 == "%" }.compactMap { Double($0) }
            if let first = parts.first { xPercent = CGFloat(first) }
            if parts.count > 1 { yPercent = CGFloat(parts[1]) }
        }
        return CGPoint(
            x: box.minX + box.width * xPercent / 100,
            y: box.minY + box.height * yPercent / 100
        )
    }

    private static func clipPath(_ value: String?, clips: [String: SVGNode], style: SVGPaint) -> Path? {
        guard let value, let start = value.range(of: "#"), let end = value.range(of: ")") else { return nil }
        let id = String(value[start.upperBound..<end.lowerBound])
        guard let clip = clips[id] else { return nil }
        var path = Path()
        for child in clip.children {
            if let shape = shape(child) {
                path.addPath(shape)
            }
        }
        return path
    }

    private static func pulse(_ time: TimeInterval, duration: Double) -> CGFloat {
        guard duration > 0 else { return 0 }
        let phase = time.truncatingRemainder(dividingBy: duration * 2) / duration
        let linear = phase <= 1 ? phase : 2 - phase
        let t = linear * linear * (3 - 2 * linear)
        return CGFloat(t)
    }

    private static func svgTransform(_ value: String?) -> CGAffineTransform? {
        guard let value, !value.isEmpty else { return nil }
        var result = CGAffineTransform.identity
        var found = false
        let pattern = #"(rotate|translate|scale)\(([^)]*)\)"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let ns = value as NSString
        for match in regex.matches(in: value, range: NSRange(location: 0, length: ns.length)) {
            let kind = ns.substring(with: match.range(at: 1))
            let args = numbers(ns.substring(with: match.range(at: 2)))
            let next: CGAffineTransform
            switch kind {
            case "rotate":
                let degrees = args.first ?? 0
                if args.count >= 3 {
                    next = rotation(degrees, around: CGPoint(x: args[1], y: args[2]))
                } else {
                    next = CGAffineTransform(rotationAngle: degrees * .pi / 180)
                }
            case "translate":
                next = CGAffineTransform(translationX: args.first ?? 0, y: args.count > 1 ? args[1] : 0)
            case "scale":
                let sx = args.first ?? 1
                next = CGAffineTransform(scaleX: sx, y: args.count > 1 ? args[1] : sx)
            default:
                continue
            }
            result = result.concatenating(next)
            found = true
        }
        return found ? result : nil
    }

    private static func numbers(_ text: String) -> [CGFloat] {
        var values: [CGFloat] = []
        var current = ""
        func commit() {
            if let value = Double(current) { values.append(CGFloat(value)) }
            current = ""
        }
        for character in text {
            if character == "," || character == " " || character == "\n" {
                commit()
            } else if (character == "-" || character == "+") && !current.isEmpty && !current.hasSuffix("e") && !current.hasSuffix("E") {
                commit()
                current.append(character)
            } else {
                current.append(character)
            }
        }
        commit()
        return values
    }

    private static func svgPath(_ data: String) -> Path {
        var path = Path()
        var index = data.startIndex
        var command = Character(" ")
        var current = CGPoint.zero
        var start = CGPoint.zero
        var placed = false

        func skip() {
            while index < data.endIndex, data[index] == " " || data[index] == "," || data[index] == "\n" {
                index = data.index(after: index)
            }
        }
        func number() -> CGFloat? {
            skip()
            guard index < data.endIndex, !data[index].isLetter else { return nil }
            let allowed = Set("0123456789.-+eE")
            var raw = ""
            if data[index] == "-" || data[index] == "+" {
                raw.append(data[index])
                index = data.index(after: index)
            }
            while index < data.endIndex, allowed.contains(data[index]) {
                raw.append(data[index])
                index = data.index(after: index)
            }
            return Double(raw).map { CGFloat($0) }
        }
        func shifted(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
            command.isLowercase && placed ? CGPoint(x: current.x + x, y: current.y + y) : CGPoint(x: x, y: y)
        }

        while index < data.endIndex {
            skip()
            guard index < data.endIndex else { break }
            if data[index].isLetter {
                command = data[index]
                index = data.index(after: index)
            }
            switch String(command).lowercased() {
            case "z":
                path.closeSubpath()
                current = start
                command = " "
            case "m":
                guard let x = number(), let y = number() else { return path }
                let next = shifted(x, y)
                path.move(to: next)
                current = next
                start = next
                placed = true
                command = command.isLowercase ? "l" : "L"
            case "l":
                guard let x = number(), let y = number() else { return path }
                current = shifted(x, y)
                path.addLine(to: current)
            case "h":
                guard let x = number() else { return path }
                current.x = command.isLowercase && placed ? current.x + x : x
                path.addLine(to: current)
            case "v":
                guard let y = number() else { return path }
                current.y = command.isLowercase && placed ? current.y + y : y
                path.addLine(to: current)
            case "c":
                guard let x1 = number(), let y1 = number(), let x2 = number(), let y2 = number(), let x = number(), let y = number() else { return path }
                let end = shifted(x, y)
                path.addCurve(to: end, control1: shifted(x1, y1), control2: shifted(x2, y2))
                current = end
            case "q":
                guard let cx = number(), let cy = number(), let x = number(), let y = number() else { return path }
                let end = shifted(x, y)
                path.addQuadCurve(to: end, control: shifted(cx, cy))
                current = end
            default:
                return path
            }
        }
        return path
    }
}

private extension Color {
    init?(svgHex: String) {
        var hex = svgHex.trimmingCharacters(in: .whitespaces)
        guard hex.hasPrefix("#") else { return nil }
        hex.removeFirst()
        if hex.count == 3 {
            hex = hex.map { "\($0)\($0)" }.joined()
        }
        guard hex.count == 6, let value = Int(hex, radix: 16) else { return nil }
        self.init(
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255
        )
    }
}
