import SwiftUI

/// A small moving picture of the real thing a story is about.
/// Fairy stories show fairies. Pig stories show pigs. Counting questions show that same thing.
struct StoryPicture: Equatable {
    let name: String
    let plural: String
    let motion: Motion
    let face: Face
    /// Bags, boxes, and jars hold other things. When a question counts the things inside, show those.
    let isContainer: Bool

    enum Motion: Equatable {
        /// Wings and leaves lift.
        case flutter
        /// Short side-to-side steps: ducks, dogs, crabs.
        case waddle
        /// A longer stride: horses and ponies.
        case trot
        /// A jump: rabbits, frogs, chicks.
        case hop
        /// A glide through water.
        case swim
        /// Balls and wheels turn as they move.
        case roll
        /// Vehicles slide ahead without tipping over.
        case drive
        /// A small lift for flowers, fruit, and shells.
        case bob
        /// Heavy or still things settle in place.
        case rest
        /// Stars, flames, and crystals brighten and dim.
        case twinkle
        /// Clouds, heroes, planets, and moons drift.
        case float
        /// Rockets and airplanes travel across the sky.
        case glide
    }

    enum Face: Equatable {
        case emoji(String)
        case firefly, seaStar, dewdrop, petal, bead, fern, cone, rainGauge
        case circle, square, triangle, rectangle, wheel, pearl, toucan
    }

    fileprivate init(
        name: String,
        plural: String,
        motion: Motion,
        face: Face,
        isContainer: Bool = false
    ) {
        self.name = name
        self.plural = plural
        self.motion = motion
        self.face = face
        self.isContainer = isContainer
    }
}

struct StoryCountCluster: Equatable {
    let picture: StoryPicture
    let count: Int
}

/// How the pictures are arranged so a child can see the story's numbers.
struct StoryCountScene: Equatable {
    enum Arrangement: Equatable {
        /// `shown` pictures appear, then `joining` more come in.
        case gather(shown: Int, joining: Int?)
        /// `start` pictures appear, then `leaving` of them move away.
        case depart(start: Int, leaving: Int)
        /// Equal groups, one row at a time.
        case rows(groups: Int, each: Int)
        /// Two groups side by side.
        case beside(StoryCountCluster, StoryCountCluster)
        /// A few of the story subject, gently moving. Not a counted total.
        case visit(count: Int)
    }

    let picture: StoryPicture
    let arrangement: Arrangement

    var spokenLabel: String {
        switch arrangement {
        case .gather(let shown, .some(let joining)):
            return "\(shown) \(picture.plural). \(joining) more \(picture.plural) come to join them."
        case .gather(let shown, .none):
            return "\(shown) \(picture.plural) to count."
        case .depart(let start, let leaving):
            return "\(start) \(picture.plural). \(leaving) \(picture.plural) leave."
        case .rows(let groups, let each):
            return "\(groups) groups of \(each) \(picture.plural)."
        case .beside(let left, let right):
            return "\(left.count) \(left.picture.plural) and \(right.count) \(right.picture.plural)."
        case .visit(let count):
            return count == 1 ? spoken(picture.name) : spoken(picture.plural)
        }
    }

    /// Story pages show the subject itself. When the story states a count, show that many.
    static func story(title: String, opening: String, passage: String, goals: [String] = []) -> StoryCountScene? {
        if let pictured = StoryPictureLibrary.leadGoalPicture(in: goals) {
            let count = StoryPictureLibrary.visitCount(for: pictured, in: goals.joined(separator: " "))
            return StoryCountScene(picture: pictured, arrangement: .visit(count: count))
        }
        guard let picture = StoryPictureLibrary.bestStoryPicture(title: title, opening: opening, passage: passage) else {
            return nil
        }
        if let counted = countedScene(in: passage, fallbackPicture: picture) {
            return counted
        }
        if let counted = countedScene(in: opening, fallbackPicture: picture) {
            return counted
        }
        let count = StoryPictureLibrary.visitCount(
            for: picture,
            in: "\(title) \(opening) \(passage)"
        )
        return StoryCountScene(picture: picture, arrangement: .visit(count: count))
    }

    /// A passage like "Four rocks sit near the volcano. Two sensors rest beside them."
    private static func countedScene(in text: String, fallbackPicture: StoryPicture) -> StoryCountScene? {
        let counts = StoryPictureLibrary.statedCounts(in: text)
        guard !counts.isEmpty else { return nil }
        if counts.count >= 2, counts[0].count <= 12, counts[1].count <= 12 {
            return StoryCountScene(
                picture: counts[0].picture,
                arrangement: .beside(
                    StoryCountCluster(picture: counts[0].picture, count: counts[0].count),
                    StoryCountCluster(picture: counts[1].picture, count: counts[1].count)
                )
            )
        }
        let main = counts.first { $0.picture.name == fallbackPicture.name } ?? counts[0]
        return StoryCountScene(picture: main.picture, arrangement: .gather(shown: main.count, joining: nil))
    }

    /// Math questions show the objects the words are counting, in the story's action.
    static func math(
        prompt: String,
        explanation: String?,
        title: String = "",
        opening: String = "",
        passage: String = ""
    ) -> StoryCountScene? {
        let fromPrompt = StoryPictureLibrary.pictureAsked(in: prompt)
            ?? StoryPictureLibrary.directPicture(in: prompt)
            ?? StoryPictureLibrary.countedPicture(in: prompt)
        let fromStory = StoryPictureLibrary.bestStoryPicture(title: title, opening: opening, passage: passage)
        guard var picture = fromPrompt ?? fromStory else { return nil }

        let lower = prompt.lowercased()
        if StoryPictureLibrary.mentionsSides(lower) {
            return StoryCountScene(picture: picture, arrangement: .visit(count: 1))
        }
        if StoryPictureLibrary.isLengthOrTime(lower) {
            let count = picture.name == "volcano" || picture.name == "lava" ? 1 : 2
            return StoryCountScene(picture: picture, arrangement: .visit(count: count))
        }
        if fromPrompt == nil,
           StoryPictureLibrary.isMoney(lower),
           let coin = StoryPictureLibrary.picture(named: "coin") {
            picture = coin
        }
        if StoryPictureLibrary.isCompare(lower),
           let beside = StoryPictureLibrary.beside(in: prompt) {
            return StoryCountScene(picture: beside.0.picture, arrangement: .beside(beside.0, beside.1))
        }
        if StoryPictureLibrary.isMissingNumber(lower),
           let counted = StoryPictureLibrary.missingNumberScene(in: lower, picture: picture) {
            return counted
        }
        if let equation = StoryPictureLibrary.equation(in: explanation ?? "") {
            return StoryCountScene(
                picture: picture,
                arrangement: StoryPictureLibrary.arrangement(for: equation, prompt: lower)
            )
        }
        if let total = StoryPictureLibrary.identityTotal(in: explanation ?? ""),
           (1...StoryPictureLibrary.maxObjects).contains(total) {
            return StoryCountScene(picture: picture, arrangement: .gather(shown: total, joining: nil))
        }
        if let arrangement = StoryPictureLibrary.promptArrangement(in: lower, picture: picture) {
            return StoryCountScene(picture: picture, arrangement: arrangement)
        }
        if let counted = countedAmount(in: lower, picture: picture) {
            return counted
        }
        let count = StoryPictureLibrary.visitCount(
            for: picture,
            in: "\(prompt) \(title) \(opening) \(passage)"
        )
        return StoryCountScene(picture: picture, arrangement: .visit(count: count))
    }

    /// A counting question with no equation still shows the amount the words name.
    private static func countedAmount(in lower: String, picture: StoryPicture) -> StoryCountScene? {
        let stated = StoryPictureLibrary.statedCounts(in: lower)
        guard !stated.isEmpty else { return nil }
        if stated.count >= 2,
           stated[0].picture.name == stated[1].picture.name,
           stated[0].count + stated[1].count <= StoryPictureLibrary.maxObjects,
           lower.contains(" more") || lower.contains("join") || lower.contains("another") {
            return StoryCountScene(
                picture: stated[0].picture,
                arrangement: .gather(shown: stated[0].count, joining: stated[1].count)
            )
        }
        let operation = lower.range(
            of: #"\b(more|join|joined|left|each|rows?)\b"#,
            options: .regularExpression
        ) != nil
        guard !operation, let counted = stated.first(where: { !$0.picture.isContainer }) ?? stated.first else {
            return nil
        }
        let shown = counted.picture.name == picture.name ? picture : counted.picture
        return StoryCountScene(picture: shown, arrangement: .gather(shown: counted.count, joining: nil))
    }

    private func spoken(_ word: String) -> String {
        guard let first = word.first else { return word }
        return first.uppercased() + word.dropFirst()
    }
}

// MARK: - Strip

struct StoryPictureStrip: View {
    let scene: StoryCountScene
    var accent: Color
    var rocketLaunch: RocketLaunchCue? = nil
    var habitatOverride: LessonHabitat? = nil
    /// The story says the rock is hot or glowing, so the picture uses red rock.
    var showsHotRock: Bool = false

    var body: some View {
        stage
            .padding(.horizontal, -DesignSystem.Spacing.lg)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(scene.spokenLabel)
    }

    @ViewBuilder
    private var stage: some View {
        if isRocketVisit {
            RocketLaunchScene(cue: rocketLaunch ?? .countdown)
        } else if usesVolcanoStudy {
            VolcanoStudyScene(
                erupting: scene.picture.name == "lava",
                hotRockCount: volcanoHotRocks,
                groundRockCount: volcanoGroundRocks
            )
        } else {
            ZStack(alignment: groundsPictures ? .bottom : .center) {
                LessonSkyBackdrop(habitat: habitat, anchoredToSide: habitat == .volcano)
                layout
                    .padding(.top, DesignSystem.Metrics.scaled(groundsPictures ? 12 : (isVisit ? 28 : 16)))
                    .padding(.bottom, DesignSystem.Metrics.scaled(groundsPictures ? 18 : (isVisit ? 28 : 16)))
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: groundsPictures ? .bottom : .center)
            }
            .frame(maxWidth: .infinity, minHeight: DesignSystem.Metrics.scaled(isVisit ? 210 : 148))
        }
    }

    /// One volcano, with rocks either on its slope or on the ground beside it.
    private var usesVolcanoStudy: Bool {
        switch scene.picture.name {
        case "volcano", "lava":
            return true
        case "rock", "hot rock", "stone":
            guard habitat == .volcano else { return false }
            if case .beside(let left, let right) = scene.arrangement,
               !Self.isRock(left.picture.name) || !Self.isRock(right.picture.name) {
                return false
            }
            return true
        default:
            return false
        }
    }

    private var groundsPictures: Bool {
        habitat == .ground || habitat == .volcano
    }

    private var volcanoHotRocks: Int {
        if scene.picture.name == "volcano" || scene.picture.name == "lava" {
            return showsHotRock ? 1 : 0
        }
        guard scene.picture.name == "hot rock" || showsHotRock else { return 0 }
        return min(picturedCount, 5)
    }

    private var volcanoGroundRocks: Int {
        if scene.picture.name == "volcano" || scene.picture.name == "lava" { return 0 }
        guard scene.picture.name != "hot rock", !showsHotRock else { return 0 }
        return min(picturedCount, 12)
    }

    private var picturedCount: Int {
        switch scene.arrangement {
        case .gather(let shown, let joining):
            return shown + (joining ?? 0)
        case .depart(let start, _):
            return start
        case .rows(let groups, let each):
            return groups * each
        case .beside(let left, let right):
            return left.count + right.count
        case .visit(let count):
            return max(count, 1)
        }
    }

    private static func isRock(_ name: String) -> Bool {
        name == "rock" || name == "hot rock" || name == "stone"
    }

    private var isVisit: Bool {
        if case .visit = scene.arrangement { return true }
        return false
    }

    private var isRocketVisit: Bool {
        guard scene.picture.name == "rocket" else { return false }
        return isVisit
    }

    private var habitat: LessonHabitat {
        if let habitatOverride { return habitatOverride }
        return LessonSkyBackdrop.habitat(for: scene.picture)
    }

    @ViewBuilder
    private var layout: some View {
        switch scene.arrangement {
        case .gather(let shown, let joining):
            flow(gatherItems(shown: shown, joining: joining))
        case .depart(let start, let leaving):
            flow(departItems(start: start, leaving: leaving))
        case .rows(let groups, let each):
            VStack(spacing: 6) {
                ForEach(0..<groups, id: \.self) { row in
                    HStack(spacing: 6) {
                        ForEach(0..<each, id: \.self) { column in
                            glyph(
                                id: "row-\(row)-\(column)",
                                picture: scene.picture,
                                size: iconSize(for: groups * each),
                                appearDelay: Double(row * each + column) * 0.12,
                                leaveDelay: nil,
                                slideIn: false
                            )
                        }
                    }
                }
            }
        case .beside(let left, let right):
            HStack(alignment: .center, spacing: DesignSystem.Spacing.sm) {
                flow(clusterItems(left, prefix: "left"))
                Capsule()
                    .fill(accent.opacity(0.45))
                    .frame(width: 3, height: 28)
                flow(clusterItems(right, prefix: "right"))
            }
        case .visit(let count):
            flow(visitItems(count: count))
        }
    }

    private func gatherItems(shown: Int, joining: Int?) -> [StoryGlyphItem] {
        let extra = joining ?? 0
        let size = iconSize(for: shown + extra)
        var items: [StoryGlyphItem] = []
        for index in 0..<shown {
            items.append(StoryGlyphItem(
                id: "shown-\(index)",
                picture: scene.picture,
                size: size,
                appearDelay: Double(index) * 0.14,
                leaveDelay: nil,
                slideIn: false
            ))
        }
        let joinStart = Double(shown) * 0.14 + 0.45
        for index in 0..<extra {
            items.append(StoryGlyphItem(
                id: "join-\(index)",
                picture: scene.picture,
                size: size,
                appearDelay: joinStart + Double(index) * 0.14,
                leaveDelay: nil,
                slideIn: true
            ))
        }
        return items
    }

    private func departItems(start: Int, leaving: Int) -> [StoryGlyphItem] {
        let size = iconSize(for: start)
        let leaveAt = Double(start) * 0.12 + 0.7
        let firstLeaving = start - leaving
        return (0..<start).map { index in
            StoryGlyphItem(
                id: "leave-\(index)",
                picture: scene.picture,
                size: size,
                appearDelay: Double(index) * 0.12,
                leaveDelay: index >= firstLeaving ? leaveAt : nil,
                slideIn: false
            )
        }
    }

    private func visitItems(count: Int) -> [StoryGlyphItem] {
        let base: CGFloat = count <= 1 ? 120 : (count == 2 ? 88 : 72)
        let size = DesignSystem.Metrics.scaled(base)
        return (0..<count).map { index in
            StoryGlyphItem(
                id: "visit-\(index)",
                picture: scene.picture,
                size: size,
                appearDelay: Double(index) * 0.12,
                leaveDelay: nil,
                slideIn: false
            )
        }
    }

    private func clusterItems(_ cluster: StoryCountCluster, prefix: String) -> [StoryGlyphItem] {
        let size = iconSize(for: cluster.count)
        return (0..<cluster.count).map { index in
            StoryGlyphItem(
                id: "\(prefix)-\(index)",
                picture: cluster.picture,
                size: size,
                appearDelay: Double(index) * 0.12,
                leaveDelay: nil,
                slideIn: false
            )
        }
    }

    private func flow(_ items: [StoryGlyphItem]) -> some View {
        let perRow = items.count <= 4 ? max(items.count, 1) : (items.count <= 10 ? 5 : 6)
        let rows = chunked(items, perRow: perRow)
        return VStack(spacing: 6) {
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 6) {
                    ForEach(row) { item in
                        glyph(item)
                    }
                }
            }
        }
    }

    private func glyph(_ item: StoryGlyphItem) -> some View {
        glyph(
            id: item.id,
            picture: item.picture,
            size: item.size,
            appearDelay: item.appearDelay,
            leaveDelay: item.leaveDelay,
            slideIn: item.slideIn
        )
    }

    private func glyph(
        id: String,
        picture: StoryPicture,
        size: CGFloat,
        appearDelay: Double,
        leaveDelay: Double?,
        slideIn: Bool
    ) -> some View {
        StoryGlyph(
            picture: picture,
            size: size,
            appearDelay: appearDelay,
            leaveDelay: leaveDelay,
            slideIn: slideIn
        )
        .id(id)
    }

    private func iconSize(for count: Int) -> CGFloat {
        let base: CGFloat
        switch count {
        case ...1: base = 56
        case 2...4: base = 42
        case 5...8: base = 34
        case 9...12: base = 28
        default: base = 24
        }
        return DesignSystem.Metrics.scaled(base)
    }

    private func chunked(_ items: [StoryGlyphItem], perRow: Int) -> [[StoryGlyphItem]] {
        guard perRow > 0, !items.isEmpty else { return [] }
        var rows: [[StoryGlyphItem]] = []
        var index = 0
        while index < items.count {
            let end = min(index + perRow, items.count)
            rows.append(Array(items[index..<end]))
            index = end
        }
        return rows
    }
}

private struct StoryGlyphItem: Identifiable {
    let id: String
    let picture: StoryPicture
    let size: CGFloat
    let appearDelay: Double
    let leaveDelay: Double?
    let slideIn: Bool
}

private struct StoryGlyph: View {
    let picture: StoryPicture
    let size: CGFloat
    let appearDelay: Double
    let leaveDelay: Double?
    let slideIn: Bool

    @State private var visible = false
    @State private var bobbing = false
    @State private var gone = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        StoryGlyphFace(picture: picture, size: size)
            .frame(width: size, height: size)
            .scaleEffect(gone ? 0.4 : (visible ? 1 : 0.2))
            .opacity(gone ? 0 : (visible ? twinkleOpacity : 0))
            .offset(x: slideOffset + (bobbing ? drift.x : 0), y: (bobbing ? drift.y : 0) + (gone ? -size * 0.85 : 0))
            .rotationEffect(.degrees(bobbing ? drift.angle : 0))
            .accessibilityHidden(true)
            .onAppear(perform: start)
    }

    private var slideOffset: CGFloat {
        slideIn && !visible ? size * 0.7 : 0
    }

    private var twinkleOpacity: Double {
        picture.motion == .twinkle && bobbing ? 0.55 : 1
    }

    private var drift: (x: CGFloat, y: CGFloat, angle: Double, duration: Double) {
        let travel = max(size / 42, 1)
        switch picture.motion {
        case .flutter: return (0, -7 * travel, -12, 0.85)
        case .waddle: return (4 * travel, 0, 7, 0.42)
        case .trot: return (7 * travel, -2 * travel, 3, 0.72)
        case .hop: return (2 * travel, -11 * travel, 0, 0.48)
        case .swim: return (10 * travel, -3 * travel, 6, 1.4)
        case .roll: return (6 * travel, 0, 20, 0.85)
        case .drive: return (9 * travel, 0, 0, 1.15)
        case .bob: return (0, -5 * travel, 0, 1.2)
        case .rest: return (0, -1.6 * travel, 0, 2.0)
        case .twinkle: return (0, -3 * travel, 0, 0.75)
        case .float: return (0, -12 * travel, 0, 1.7)
        case .glide: return (11 * travel, -5 * travel, -5, 1.45)
        }
    }

    private func start() {
        if reduceMotion {
            visible = true
            return
        }
        withAnimation(.spring(response: 0.38, dampingFraction: 0.68).delay(appearDelay)) {
            visible = true
        }
        withAnimation(.easeInOut(duration: drift.duration).repeatForever(autoreverses: true).delay(appearDelay + 0.3)) {
            bobbing = true
        }
        if let leaveDelay {
            withAnimation(.easeIn(duration: 0.45).delay(leaveDelay)) {
                gone = true
            }
        }
    }
}

private struct FernLeaflet: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let tip = CGPoint(x: rect.minX, y: rect.midY)
        let baseTop = CGPoint(x: rect.maxX, y: rect.midY - rect.height * 0.22)
        let baseBottom = CGPoint(x: rect.maxX, y: rect.midY + rect.height * 0.22)
        path.move(to: baseTop)
        path.addQuadCurve(
            to: tip,
            control: CGPoint(x: rect.midX, y: rect.midY - rect.height * 0.55)
        )
        path.addQuadCurve(
            to: baseBottom,
            control: CGPoint(x: rect.midX, y: rect.midY + rect.height * 0.35)
        )
        path.closeSubpath()
        return path
    }
}

private struct WaterDrop: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midX = rect.midX
        let radius = rect.width / 2
        let top = rect.minY
        let bottom = rect.maxY
        let centerY = rect.minY + rect.height * 0.68
        path.move(to: CGPoint(x: midX, y: top))
        path.addCurve(
            to: CGPoint(x: midX, y: bottom),
            control1: CGPoint(x: midX - radius, y: centerY),
            control2: CGPoint(x: midX - radius * 0.55, y: bottom)
        )
        path.addCurve(
            to: CGPoint(x: midX, y: top),
            control1: CGPoint(x: midX + radius * 0.55, y: bottom),
            control2: CGPoint(x: midX + radius, y: centerY)
        )
        path.closeSubpath()
        return path
    }
}

private struct StoryGlyphFace: View {
    let picture: StoryPicture
    let size: CGFloat

    var body: some View {
        switch picture.face {
        case .emoji:
            DrawnSubject(name: picture.name, size: size)
        case .firefly:
            firefly
        case .seaStar:
            seaStar
        case .dewdrop:
            dewdrop
        case .petal:
            Capsule()
                .fill(DesignSystem.Colors.coralPink)
                .frame(width: size * 0.34, height: size * 0.62)
                .rotationEffect(.degrees(-18))
        case .bead:
            ZStack {
                Circle().fill(DesignSystem.Colors.lavenderPurple)
                Circle().fill(DesignSystem.Colors.cardWhite).frame(width: size * 0.22)
            }
            .frame(width: size * 0.62, height: size * 0.62)
        case .fern:
            fern
        case .cone:
            StoryTriangle()
                .fill(DesignSystem.Colors.warmOrange)
                .frame(width: size * 0.5, height: size * 0.62)
                .overlay(alignment: .center) {
                    Rectangle()
                        .fill(DesignSystem.Colors.cardWhite)
                        .frame(width: size * 0.5, height: size * 0.08)
                        .offset(y: size * 0.06)
                }
        case .rainGauge:
            rainGauge
        case .circle:
            Circle()
                .stroke(DesignSystem.Colors.deepNavy, lineWidth: max(3, size * 0.08))
                .padding(size * 0.18)
        case .square:
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .stroke(DesignSystem.Colors.deepNavy, lineWidth: max(3, size * 0.08))
                .padding(size * 0.18)
        case .triangle:
            StoryTriangle()
                .stroke(DesignSystem.Colors.deepNavy, lineWidth: max(3, size * 0.08))
                .padding(size * 0.16)
        case .rectangle:
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .stroke(DesignSystem.Colors.deepNavy, lineWidth: max(3, size * 0.08))
                .padding(.horizontal, size * 0.1)
                .padding(.vertical, size * 0.26)
        case .wheel:
            wheel
        case .pearl:
            ZStack {
                Circle().fill(DesignSystem.Colors.cardWhite)
                Circle().stroke(DesignSystem.Colors.skyBlue.opacity(0.55), lineWidth: 2)
                Circle()
                    .fill(DesignSystem.Colors.cardWhite)
                    .frame(width: size * 0.14)
                    .offset(x: -size * 0.1, y: -size * 0.12)
            }
            .frame(width: size * 0.58, height: size * 0.58)
        case .toucan:
            toucan
        }
    }

    private var firefly: some View {
        let shell = Color(red: 0.24, green: 0.29, blue: 0.16)
        return ZStack {
            Circle()
                .fill(DesignSystem.Colors.sunshineYellow.opacity(0.72))
                .frame(width: size * 0.78)
            Ellipse()
                .fill(shell)
                .frame(width: size * 0.28, height: size * 0.18)
                .offset(x: -size * 0.12, y: size * 0.04)
            Ellipse()
                .fill(Color(red: 0.29, green: 0.35, blue: 0.18))
                .frame(width: size * 0.18, height: size * 0.15)
                .offset(x: size * 0.04, y: size * 0.02)
            Circle()
                .fill(shell)
                .frame(width: size * 0.14)
                .offset(x: size * 0.16)
            Ellipse()
                .fill(DesignSystem.Colors.sunshineYellow)
                .frame(width: size * 0.12, height: size * 0.07)
                .offset(x: -size * 0.22, y: size * 0.06)
            Ellipse()
                .fill(DesignSystem.Colors.lessonWindow)
                .frame(width: size * 0.28, height: size * 0.1)
                .rotationEffect(.degrees(40), anchor: .trailing)
                .offset(x: -size * 0.1, y: -size * 0.06)
            Ellipse()
                .fill(DesignSystem.Colors.lessonWindow)
                .frame(width: size * 0.28, height: size * 0.1)
                .rotationEffect(.degrees(-40), anchor: .leading)
                .offset(x: size * 0.18, y: -size * 0.06)
            Capsule()
                .fill(shell)
                .frame(width: size * 0.02, height: size * 0.12)
                .rotationEffect(.degrees(-24))
                .offset(x: size * 0.14, y: -size * 0.12)
            Capsule()
                .fill(shell)
                .frame(width: size * 0.02, height: size * 0.12)
                .rotationEffect(.degrees(22))
                .offset(x: size * 0.22, y: -size * 0.12)
            ZStack {
                Circle().fill(DesignSystem.Colors.lessonWindow)
                Circle().fill(DesignSystem.Colors.deepNavy).frame(width: size * 0.022)
                    .offset(x: size * 0.006)
            }
            .frame(width: size * 0.05, height: size * 0.05)
            .offset(x: size * 0.18, y: -size * 0.02)
        }
    }

    private var seaStar: some View {
        ZStack {
            ForEach(0..<5, id: \.self) { arm in
                Capsule()
                    .fill(DesignSystem.Colors.warmOrange)
                    .frame(width: size * 0.18, height: size * 0.46)
                    .offset(y: -size * 0.12)
                    .rotationEffect(.degrees(Double(arm) * 72))
            }
            Circle()
                .fill(DesignSystem.Colors.warmOrange)
                .frame(width: size * 0.26)
        }
    }

    private var dewdrop: some View {
        ZStack {
            WaterDrop()
                .fill(DesignSystem.Colors.skyBlue)
                .frame(width: size * 0.42, height: size * 0.62)
            Ellipse()
                .fill(DesignSystem.Colors.cardWhite.opacity(0.8))
                .frame(width: size * 0.08, height: size * 0.14)
                .offset(x: -size * 0.07, y: size * 0.04)
        }
    }

    private var fern: some View {
        ZStack {
            frond(tilt: -20)
            frond(tilt: 20)
            frond(tilt: 0)
        }
    }

    private func frond(tilt: Double) -> some View {
        let lengths: [CGFloat] = [0.12, 0.16, 0.20, 0.22, 0.19, 0.14]
        return ZStack {
            Capsule()
                .fill(Color(red: 0.10, green: 0.36, blue: 0.20))
                .frame(width: size * 0.03, height: size * 0.64)
            ForEach(Array(lengths.enumerated()), id: \.offset) { index, length in
                let reach = size * length
                let y = size * (CGFloat(index) * 0.078 - 0.24)
                fernLeaflet(reach: reach, side: -1)
                    .offset(x: -reach / 2, y: y)
                fernLeaflet(reach: reach, side: 1)
                    .offset(x: reach / 2, y: y)
            }
        }
        .rotationEffect(.degrees(tilt), anchor: .bottom)
    }

    private func fernLeaflet(reach: CGFloat, side: CGFloat) -> some View {
        FernLeaflet()
            .fill(Color(red: 0.28, green: 0.72, blue: 0.42))
            .frame(width: reach, height: size * 0.075)
            .scaleEffect(x: side < 0 ? 1 : -1)
            .rotationEffect(.degrees(side < 0 ? 52 : -52), anchor: side < 0 ? .trailing : .leading)
    }

    private var rainGauge: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .stroke(DesignSystem.Colors.skyBlue, lineWidth: 2)
                .frame(width: size * 0.28, height: size * 0.62)
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(DesignSystem.Colors.skyBlue.opacity(0.55))
                .frame(width: size * 0.2, height: size * 0.28)
                .padding(.bottom, 3)
        }
    }

    private var wheel: some View {
        ZStack {
            Circle()
                .stroke(DesignSystem.Colors.deepNavy, lineWidth: size * 0.08)
                .frame(width: size * 0.62)
            Circle()
                .fill(DesignSystem.Colors.deepNavy)
                .frame(width: size * 0.14)
            Capsule()
                .fill(DesignSystem.Colors.deepNavy)
                .frame(width: size * 0.06, height: size * 0.5)
            Capsule()
                .fill(DesignSystem.Colors.deepNavy)
                .frame(width: size * 0.06, height: size * 0.5)
                .rotationEffect(.degrees(90))
        }
    }

    private var toucan: some View {
        ZStack {
            Capsule()
                .fill(DesignSystem.Colors.freshGreen)
                .frame(width: size * 0.28, height: size * 0.4)
            Capsule()
                .fill(DesignSystem.Colors.warmOrange)
                .frame(width: size * 0.46, height: size * 0.16)
                .offset(x: size * 0.18)
            Circle()
                .fill(DesignSystem.Colors.deepNavy)
                .frame(width: size * 0.08)
                .offset(x: size * 0.02, y: -size * 0.08)
        }
    }
}

private struct StoryTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Matching the story's words

private enum StoryPictureLibrary {
    static let maxObjects = 36

    fileprivate struct Equation {
        enum Op { case add, subtract, multiply, divide }
        let op: Op
        let a: Int
        let b: Int
    }

    static func picture(named name: String) -> StoryPicture? {
        catalog.first { $0.picture.name == name }?.picture
    }

    /// The first drawing goal, when it names a real picture. Later goals stay details.
    static func leadGoalPicture(in goals: [String]) -> StoryPicture? {
        guard let goal = goals.first else { return nil }
        return matches(in: goal)
            .sorted { $0.range.lowerBound < $1.range.lowerBound }
            .first?
            .picture
    }

    /// A volcano story is about one mountain unless the words count more than one.
    /// A single hot rock stays one rock. A group of hot rocks can show a few.
    static func visitCount(for picture: StoryPicture, in text: String) -> Int {
        let lower = text.lowercased()
        switch picture.name {
        case "volcano", "lava":
            return 1
        case "hot rock":
            if lower.contains("hot rocks") || lower.contains("glowing rocks") { return 3 }
            return 1
        default:
            return 3
        }
    }

    static func bestStoryPicture(title: String, opening: String, passage: String) -> StoryPicture? {
        let openingHits = matches(in: opening).sorted { $0.range.lowerBound < $1.range.lowerBound }
        if let lead = openingHits.first?.picture {
            return lead
        }
        let zones = [(title, 30), (passage, 4)]
        var scores: [String: Int] = [:]
        var pictures: [String: StoryPicture] = [:]
        for (text, weight) in zones where !text.isEmpty {
            var seen = Set<String>()
            for hit in matches(in: text) where seen.insert(hit.picture.name).inserted {
                scores[hit.picture.name, default: 0] += weight + hit.phraseCount
                pictures[hit.picture.name] = hit.picture
            }
        }
        guard let best = scores.max(by: { lhs, rhs in
            if lhs.value == rhs.value { return lhs.key > rhs.key }
            return lhs.value < rhs.value
        }) else { return nil }
        return pictures[best.key]
    }

    /// "How many scoops are left?" is about scoops, even when hens are also mentioned.
    static func pictureAsked(in prompt: String) -> StoryPicture? {
        let lower = prompt.lowercased()
        let pattern = #"how many(?: more)? ([a-z]+(?: [a-z]+){0,3}) (?:are|is|does|do|can|did|were|remain|in all|altogether)\b"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let ns = lower as NSString
        guard let match = regex.firstMatch(in: lower, range: NSRange(location: 0, length: ns.length)),
              match.numberOfRanges >= 2 else { return nil }
        let noun = ns.substring(with: match.range(at: 1))
        let first = noun.split(separator: " ").first.map(String.init) ?? noun
        if ["does", "do", "is", "are", "can", "did", "were"].contains(first) { return nil }
        return picture(forNoun: noun)
    }

    /// The picture named directly after a number: "10 scoops", not a later word like "hens".
    static func directPicture(in prompt: String) -> StoryPicture? {
        let stated = statedCounts(in: prompt)
        return (stated.first { !$0.picture.isContainer } ?? stated.first)?.picture
    }

    /// When a question has no equation, the numbers in the sentence still decide the picture.
    static func promptArrangement(in lower: String, picture: StoryPicture) -> StoryCountScene.Arrangement? {
        let stated = statedCounts(in: lower).filter { $0.picture.name == picture.name }.map(\.count)
        let numbers = numbers(in: lower).map(\.value).filter { (1...maxObjects).contains($0) }
        if isGrouped(lower), numbers.count >= 2 {
            let groups = numbers[0]
            let each = numbers[1]
            if (1...6).contains(groups), each >= 1, groups * each <= maxObjects {
                return .rows(groups: groups, each: each)
            }
        }
        if stated.count >= 2 {
            let start = stated[0]
            let next = stated[1]
            if isJoining(lower) {
                return .gather(shown: start, joining: next)
            }
            if isRemoval(lower), start > next {
                return .depart(start: start, leaving: next)
            }
            return .beside(
                StoryCountCluster(picture: picture, count: start),
                StoryCountCluster(picture: picture, count: next)
            )
        }
        guard let only = stated.first else {
            guard numbers.count == 1, let single = numbers.first else { return nil }
            return .gather(shown: single, joining: nil)
        }
        if let other = numbers.first(where: { $0 != only }), (1...maxObjects).contains(other) {
            if isJoining(lower) {
                return .gather(shown: only, joining: other)
            }
            if isRemoval(lower) {
                let start = max(only, other)
                let leaving = min(only, other)
                if start > leaving {
                    return .depart(start: start, leaving: leaving)
                }
            }
            if lower.contains("how many more") || lower.contains("filled") || lower.contains("has ") {
                return .beside(
                    StoryCountCluster(picture: picture, count: only),
                    StoryCountCluster(picture: picture, count: other)
                )
            }
        }
        return .gather(shown: only, joining: nil)
    }

    private static func isGrouped(_ lower: String) -> Bool {
        lower.range(
            of: #"\b(rows? of|in each|each row|each group|each pack|each box|each tray|groups of)\b"#,
            options: .regularExpression
        ) != nil
    }

    private static func isJoining(_ lower: String) -> Bool {
        if lower.contains("arrived") || lower.contains("join") { return true }
        if lower.contains("more"),
           lower.contains("add") || lower.contains("found") || lower.contains("brings") {
            return true
        }
        return false
    }

    private static func isRemoval(_ lower: String) -> Bool {
        if isJoining(lower) { return false }
        return lower.range(
            of: #"\b(gives|give|gave|hands|handed|uses|used|takes|took|shares|shared|rolls|rolled|sends|sent|stamps|stamped|missing|left)\b"#,
            options: .regularExpression
        ) != nil
    }

    static func picture(forNoun noun: String) -> StoryPicture? {
        var words = noun.split(separator: " ").map(String.init)
        let fillers: Set<String> = ["of", "the", "a", "an", "these", "those", "her", "his", "their"]
        while let first = words.first, fillers.contains(first) {
            words.removeFirst()
        }
        while !words.isEmpty {
            let candidate = words.joined(separator: " ")
            if let picture = entries.first(where: { $0.phrase == candidate })?.picture {
                return picture
            }
            if words.count == 1 { break }
            words.removeFirst()
        }
        return nil
    }

    static func countedPicture(in prompt: String) -> StoryPicture? {
        let found = quantityPictures(in: prompt)
        if let item = found.first(where: { !$0.picture.isContainer }) {
            return item.picture
        }
        if let firstQuantity = found.first?.picture {
            return firstQuantity
        }
        let hits = matches(in: prompt)
        return hits.first(where: { !$0.picture.isContainer })?.picture ?? hits.first?.picture
    }

    static func beside(in prompt: String) -> (StoryCountCluster, StoryCountCluster)? {
        let found = quantityPictures(in: prompt)
        guard found.count >= 2 else { return nil }
        let left = found[0]
        let right = found[1]
        guard (1...12).contains(left.count), (1...12).contains(right.count) else { return nil }
        return (
            StoryCountCluster(picture: left.picture, count: left.count),
            StoryCountCluster(picture: right.picture, count: right.count)
        )
    }

    static func mentionsSides(_ lower: String) -> Bool {
        lower.range(of: #"\bsides\b"#, options: .regularExpression) != nil
    }

    static func isLengthOrTime(_ lower: String) -> Bool {
        let pattern = #"\b(centimeters?|millimeters?|meters?|inches|inch|feet|foot|minutes?|hours?|o'clock|kilograms?|liters?)\b"#
        if lower.range(of: pattern, options: .regularExpression) != nil { return true }
        return lower.contains("how much longer") || lower.contains("how much taller")
    }

    static func isMoney(_ lower: String) -> Bool {
        if lower.contains("sand dollar") { return false }
        return lower.range(of: #"\b(cents?|dollars?|coins?)\b"#, options: .regularExpression) != nil
    }

    static func isCompare(_ lower: String) -> Bool {
        if lower.contains("how many more") { return true }
        if lower.contains("which side has more") { return true }
        if lower.contains("which group has more") { return true }
        if lower.contains("larger group") { return true }
        if lower.contains("difference") { return true }
        if lower.contains("has more") { return true }
        return false
    }

    static func isMissingNumber(_ lower: String) -> Bool {
        if lower.contains("at the start") { return true }
        if lower.contains("some more arrived") { return true }
        if lower.contains("how many") && lower.contains("joined") && lower.contains("some") { return true }
        return false
    }

    /// A missing-number question still names real amounts. Draw those, not a stand-in group.
    /// "Eight fossils were waiting. Some more arrived, and now there are 9" shows 8, then 1 more.
    /// When the start is the hidden number, show the total the question already states.
    static func missingNumberScene(in lower: String, picture: StoryPicture) -> StoryCountScene? {
        guard let total = nowTotal(in: lower), (1...maxObjects).contains(total) else { return nil }
        if let start = startingCount(beforeSomeMore: lower, picture: picture),
           (1...total).contains(start) {
            let joining = total - start
            guard joining <= maxObjects else { return nil }
            return StoryCountScene(
                picture: picture,
                arrangement: .gather(shown: start, joining: joining == 0 ? nil : joining)
            )
        }
        return StoryCountScene(picture: picture, arrangement: .gather(shown: total, joining: nil))
    }

    /// "now there are 9" or "now there is one".
    private static func nowTotal(in lower: String) -> Int? {
        guard let marker = lower.range(of: #"now there (?:are|is) "#, options: .regularExpression) else {
            return nil
        }
        let rest = String(lower[marker.upperBound...])
        let token = rest.prefix { $0.isNumber || $0.isLetter }
        if let value = Int(token) { return value }
        return numberWords.first { $0.0 == token }?.1
    }

    /// The group named before "some more" is already on the scene.
    private static func startingCount(beforeSomeMore lower: String, picture: StoryPicture) -> Int? {
        guard let marker = lower.range(of: "some more") else { return nil }
        let prefix = String(lower[..<marker.lowerBound])
        return statedCounts(in: prefix).first { $0.picture.name == picture.name }?.count
    }

    static func equation(in explanation: String) -> Equation? {
        let normalized = explanation
            .replacingOccurrences(of: "−", with: "-")
            .replacingOccurrences(of: "×", with: "x")
            .replacingOccurrences(of: "÷", with: "/")
        guard let regex = try? NSRegularExpression(pattern: #"(\d+)\s*([+\-x/])\s*(\d+)"#) else { return nil }
        let ns = normalized as NSString
        guard let match = regex.firstMatch(in: normalized, range: NSRange(location: 0, length: ns.length)),
              match.numberOfRanges == 4,
              let a = Int(ns.substring(with: match.range(at: 1))),
              let b = Int(ns.substring(with: match.range(at: 3))) else {
            return nil
        }
        let symbol = ns.substring(with: match.range(at: 2))
        let op: Equation.Op
        switch symbol {
        case "+": op = .add
        case "-": op = .subtract
        case "x": op = .multiply
        case "/": op = .divide
        default: return nil
        }
        return Equation(op: op, a: a, b: b)
    }

    static func identityTotal(in explanation: String) -> Int? {
        let lower = explanation.lowercased()
        guard let regex = try? NSRegularExpression(pattern: #"total is (\d+)"#) else { return nil }
        let ns = lower as NSString
        guard let match = regex.firstMatch(in: lower, range: NSRange(location: 0, length: ns.length)),
              match.numberOfRanges >= 2 else { return nil }
        return Int(ns.substring(with: match.range(at: 1)))
    }

    static func arrangement(for equation: Equation, prompt: String) -> StoryCountScene.Arrangement {
        switch equation.op {
        case .add:
            let total = equation.a + max(equation.b, 0)
            guard equation.a >= 1, total <= maxObjects else { return .visit(count: 1) }
            if equation.b <= 0 {
                return .gather(shown: equation.a, joining: nil)
            }
            return .gather(shown: equation.a, joining: equation.b)
        case .subtract:
            guard equation.a > equation.b, equation.b >= 1, equation.a <= maxObjects else { return .visit(count: 1) }
            return .depart(start: equation.a, leaving: equation.b)
        case .multiply:
            let product = equation.a * equation.b
            guard equation.a >= 1, equation.b >= 1, equation.a <= 6, product <= maxObjects else {
                return .visit(count: 1)
            }
            return .rows(groups: equation.a, each: equation.b)
        case .divide:
            guard equation.b > 0, equation.a % equation.b == 0 else { return .visit(count: 1) }
            let quotient = equation.a / equation.b
            let eachIsDivisor = prompt.contains("groups of") || prompt.contains("each group") || prompt.contains("in each")
            let groups = eachIsDivisor ? quotient : equation.b
            let each = eachIsDivisor ? equation.b : quotient
            guard groups >= 1, each >= 1, groups <= 6, groups * each <= maxObjects else {
                return .visit(count: 1)
            }
            return .rows(groups: groups, each: each)
        }
    }

    private struct Hit {
        let range: Range<String.Index>
        let picture: StoryPicture
        let phraseCount: Int
    }

    fileprivate struct Quantity {
        let count: Int
        let picture: StoryPicture
    }

    /// A number that sits directly on a picture word: "four rocks", "two bright stars".
    /// "Three weeks later the volcano" is a span of time, so it is not three volcanoes.
    static func statedCounts(in text: String) -> [Quantity] {
        let lower = text.lowercased()
        let nums = numbers(in: lower)
        let pics = matches(in: lower)
        var found: [Quantity] = []
        for (index, number) in nums.enumerated() {
            guard (1...maxObjects).contains(number.value) else { continue }
            let nextStart = index + 1 < nums.count ? nums[index + 1].range.lowerBound : lower.endIndex
            guard let hit = pics.first(where: {
                $0.range.lowerBound >= number.range.upperBound && $0.range.lowerBound < nextStart
            }) else { continue }
            let gap = lower[number.range.upperBound..<hit.range.lowerBound]
            let words = gap.split { !$0.isLetter }.map(String.init)
            guard words.allSatisfy({ countModifiers.contains($0) }) else { continue }
            found.append(Quantity(count: number.value, picture: hit.picture))
        }
        return found
    }

    private static let countModifiers: Set<String> = [
        "a", "an", "the", "more", "other", "another",
        "fluffy", "bright", "small", "little", "tiny", "big", "large",
        "young", "baby", "new", "old", "red", "blue", "green", "yellow", "hot",
        "glowing", "pretty", "colorful", "soft", "round", "volcanic"
    ]

    private static func quantityPictures(in text: String) -> [Quantity] {
        let lower = text.lowercased()
        let nums = numbers(in: lower)
        let pics = matches(in: lower)
        var found: [Quantity] = []
        for (index, number) in nums.enumerated() {
            let nextStart = index + 1 < nums.count ? nums[index + 1].range.lowerBound : lower.endIndex
            let cap = lower.index(number.range.upperBound, offsetBy: 36, limitedBy: lower.endIndex) ?? lower.endIndex
            let end = nextStart < cap ? nextStart : cap
            guard let hit = pics.first(where: { $0.range.lowerBound >= number.range.upperBound && $0.range.lowerBound < end }) else {
                continue
            }
            found.append(Quantity(count: number.value, picture: hit.picture))
        }
        return found
    }

    private struct NumberHit {
        let value: Int
        let range: Range<String.Index>
    }

    private static let numberWords: [(String, Int)] = [
        ("twenty", 20), ("nineteen", 19), ("eighteen", 18), ("seventeen", 17), ("sixteen", 16),
        ("fifteen", 15), ("fourteen", 14), ("thirteen", 13), ("twelve", 12), ("eleven", 11),
        ("ten", 10), ("nine", 9), ("eight", 8), ("seven", 7), ("six", 6), ("five", 5),
        ("four", 4), ("three", 3), ("two", 2), ("one", 1)
    ]

    private static func numbers(in lower: String) -> [NumberHit] {
        var hits: [NumberHit] = []
        var taken: [Range<String.Index>] = []
        if let regex = try? NSRegularExpression(pattern: #"\d+"#) {
            let ns = lower as NSString
            for match in regex.matches(in: lower, range: NSRange(location: 0, length: ns.length)) {
                guard let range = Range(match.range, in: lower), let value = Int(lower[range]) else { continue }
                hits.append(NumberHit(value: value, range: range))
                taken.append(range)
            }
        }
        for (word, value) in numberWords {
            var search = lower.startIndex
            while search < lower.endIndex, let range = lower.range(of: word, range: search..<lower.endIndex) {
                search = range.upperBound
                guard isWord(lower, range: range) else { continue }
                guard !taken.contains(where: { $0.overlaps(range) }) else { continue }
                taken.append(range)
                hits.append(NumberHit(value: value, range: range))
            }
        }
        return hits.sorted { $0.range.lowerBound < $1.range.lowerBound }
    }

    private struct Entry {
        let phrase: String
        let picture: StoryPicture
    }

    private static func matches(in text: String) -> [Hit] {
        let lower = text.lowercased()
        var taken: [Range<String.Index>] = []
        var hits: [Hit] = []
        for entry in entries {
            var search = lower.startIndex
            while search < lower.endIndex, let range = lower.range(of: entry.phrase, range: search..<lower.endIndex) {
                search = range.upperBound
                guard isWord(lower, range: range) else { continue }
                guard !isLocationSquare(lower, range: range) else { continue }
                guard !taken.contains(where: { $0.overlaps(range) }) else { continue }
                taken.append(range)
                hits.append(Hit(range: range, picture: entry.picture, phraseCount: entry.phrase.count))
            }
        }
        return hits.sorted { $0.range.lowerBound < $1.range.lowerBound }
    }

    /// "City square" is a place. A counted square is the shape.
    private static func isLocationSquare(_ text: String, range: Range<String.Index>) -> Bool {
        let word = text[range]
        guard word == "square" || word == "squares" else { return false }
        guard let previous = previousWord(in: text, before: range.lowerBound) else { return false }
        return ["city", "town", "market", "public", "village", "main"].contains(previous)
    }

    private static func previousWord(in text: String, before index: String.Index) -> String? {
        var cursor = index
        while cursor > text.startIndex {
            let previous = text.index(before: cursor)
            if text[previous].isLetter { break }
            cursor = previous
        }
        guard cursor > text.startIndex else { return nil }
        let end = text.index(before: cursor)
        guard text[end].isLetter else { return nil }
        var start = end
        while start > text.startIndex {
            let previous = text.index(before: start)
            guard text[previous].isLetter else { break }
            start = previous
        }
        return String(text[start...end])
    }

    private static func isWord(_ text: String, range: Range<String.Index>) -> Bool {
        if range.lowerBound > text.startIndex {
            let previous = text[text.index(before: range.lowerBound)]
            if previous.isLetter { return false }
        }
        if range.upperBound < text.endIndex {
            let next = text[range.upperBound]
            if next.isLetter { return false }
        }
        return true
    }

    private static let catalog: [(picture: StoryPicture, phrases: [String])] = {
        func pic(
            _ name: String,
            _ plural: String,
            _ motion: StoryPicture.Motion,
            _ face: StoryPicture.Face,
            _ phrases: [String],
            container: Bool = false
        ) -> (picture: StoryPicture, phrases: [String]) {
            (
                StoryPicture(name: name, plural: plural, motion: motion, face: face, isContainer: container),
                phrases
            )
        }
        return [
            pic("fairy", "fairies", .flutter, .emoji("🧚"), ["fairies", "fairy"]),
            pic("pig", "pigs", .waddle, .emoji("🐷"), ["piglets", "piglet", "pigs", "pig"]),
            pic("cow", "cows", .waddle, .emoji("🐄"), ["cows", "cow"]),
            pic("hen", "hens", .waddle, .emoji("🐔"), ["hens", "hen"]),
            pic("chicken", "chickens", .waddle, .emoji("🐔"), ["chickens", "chicken"]),
            pic("rooster", "roosters", .waddle, .emoji("🐓"), ["roosters", "rooster"]),
            pic("duck", "ducks", .waddle, .emoji("🦆"), ["ducks", "duck"]),
            pic("sheep", "sheep", .waddle, .emoji("🐑"), ["sheep"]),
            pic("goat", "goats", .waddle, .emoji("🐐"), ["goats", "goat"]),
            pic("giraffe", "giraffes", .rest, .emoji("🦒"), ["giraffes", "giraffe"]),
            pic("elephant", "elephants", .waddle, .emoji("🐘"), ["elephants", "elephant"]),
            pic("horse", "horses", .trot, .emoji("🐴"), ["horses", "horse"]),
            pic("pony", "ponies", .trot, .emoji("🐴"), ["ponies", "pony"]),
            pic("dog", "dogs", .waddle, .emoji("🐶"), ["dogs", "dog"]),
            pic("puppy", "puppies", .waddle, .emoji("🐶"), ["puppies", "puppy"]),
            pic("cat", "cats", .waddle, .emoji("🐱"), ["cats", "cat"]),
            pic("kitten", "kittens", .waddle, .emoji("🐱"), ["kittens", "kitten"]),
            pic("shark", "sharks", .swim, .emoji("🦈"), ["baby sharks", "baby shark", "reef sharks", "reef shark", "sharks", "shark"]),
            pic("dolphin", "dolphins", .swim, .emoji("🐬"), ["dolphins", "dolphin"]),
            pic("whale", "whales", .swim, .emoji("🐳"), ["whales", "whale"]),
            pic("fish", "fish", .swim, .emoji("🐟"), ["fish"]),
            pic("crab", "crabs", .waddle, .emoji("🦀"), ["hermit crabs", "hermit crab", "crabs", "crab"]),
            pic("octopus", "octopuses", .waddle, .emoji("🐙"), ["octopuses", "octopus"]),
            pic("sea star", "sea stars", .bob, .seaStar, ["sea stars", "sea star", "starfish"]),
            pic("seashell", "seashells", .bob, .emoji("🐚"), ["sand dollars", "sand dollar", "clam shells", "clam shell", "spiral shells", "spiral shell", "shell samples", "seashells", "seashell", "shells", "shell", "samples", "sample"]),
            pic("pearl", "pearls", .bob, .pearl, ["pearls", "pearl"]),
            pic("dinosaur", "dinosaurs", .waddle, .emoji("🦕"), ["horned dinosaurs", "horned dinosaur", "dinosaurs", "dinosaur"]),
            pic("triceratops", "triceratops", .waddle, .emoji("🦕"), ["triceratops"]),
            pic("tyrannosaurus", "tyrannosauruses", .waddle, .emoji("🦖"), ["tyrannosaurus"]),
            pic("dinosaur egg", "dinosaur eggs", .rest, .emoji("🥚"), ["dinosaur eggs", "dinosaur egg"]),
            pic("egg", "eggs", .rest, .emoji("🥚"), ["eggs", "egg"]),
            pic("fossil", "fossils", .rest, .emoji("🦴"), ["fossils", "fossil"]),
            pic("bone", "bones", .rest, .emoji("🦴"), ["dinosaur bones", "dinosaur bone", "bones", "bone"]),
            pic("rocket", "rockets", .glide, .emoji("🚀"), ["rockets", "rocket"]),
            pic("planet", "planets", .float, .emoji("🪐"), ["planets", "planet"]),
            pic("earth", "earths", .float, .emoji("🌍"), ["earth"]),
            pic("venus", "venus", .float, .emoji("🌕"), ["venus"]),
            pic("spacecraft", "spacecraft", .glide, .emoji("🛰️"), ["spacecrafts", "spacecraft"]),
            pic("moon", "moons", .float, .emoji("🌕"), ["moons", "moon"]),
            pic("star crystal", "star crystals", .twinkle, .emoji("💎"), ["star crystals", "star crystal"]),
            pic("star", "stars", .twinkle, .emoji("⭐"), ["stars", "star"]),
            pic("moon rock", "moon rocks", .rest, .emoji("🪨"), ["moon rocks", "moon rock"]),
            pic("volcano", "volcanoes", .rest, .emoji("🌋"), ["volcanoes", "volcano"]),
            pic("lava", "lava", .rest, .emoji("🌋"), ["lava"]),
            pic("magma", "magma", .rest, .emoji("🌋"), ["magma"]),
            pic("hot rock", "hot rocks", .rest, .emoji("🪨"), ["glowing rocks", "glowing rock", "hot rocks", "hot rock"]),
            pic("rock", "rocks", .rest, .emoji("🪨"), ["volcanic rocks", "volcanic rock", "rock samples", "rock sample", "rocks", "rock"]),
            pic("cloud", "clouds", .float, .emoji("☁️"), ["clouds", "cloud"]),
            pic("sun", "suns", .twinkle, .emoji("☀️"), ["suns", "sun"]),
            pic("cape", "capes", .flutter, .emoji("🦸"), ["capes", "cape"]),
            pic("sensor", "sensors", .rest, .emoji("📡"), ["sensors", "sensor"]),
            pic("gear", "gears", .rest, .emoji("⚙️"), ["gears", "gear"]),
            pic("pinecone", "pinecones", .rest, .emoji("🌲"), ["pinecones", "pinecone"]),
            pic("chick", "chicks", .hop, .emoji("🐤"), ["chicks", "chick"]),
            pic("robot", "robots", .waddle, .emoji("🤖"), ["robots", "robot"]),
            pic("firefly", "fireflies", .twinkle, .firefly, ["fireflies", "firefly"]),
            pic("bee", "bees", .flutter, .emoji("🐝"), ["bees", "bee"]),
            pic("ladybug", "ladybugs", .waddle, .emoji("🐞"), ["ladybugs", "ladybug"]),
            pic("butterfly", "butterflies", .flutter, .emoji("🦋"), ["butterflies", "butterfly"]),
            pic("caterpillar", "caterpillars", .waddle, .emoji("🐛"), ["caterpillars", "caterpillar"]),
            pic("ant", "ants", .waddle, .emoji("🐜"), ["ants", "ant"]),
            pic("bird", "birds", .flutter, .emoji("🐦"), ["birds", "bird"]),
            pic("hawk", "hawks", .flutter, .emoji("🦅"), ["hawks", "hawk"]),
            pic("penguin", "penguins", .waddle, .emoji("🐧"), ["penguins", "penguin"]),
            pic("toucan", "toucans", .flutter, .toucan, ["toucans", "toucan"]),
            pic("monkey", "monkeys", .waddle, .emoji("🐒"), ["monkeys", "monkey"]),
            pic("frog", "frogs", .hop, .emoji("🐸"), ["frogs", "frog"]),
            pic("rabbit", "rabbits", .hop, .emoji("🐰"), ["rabbits", "rabbit"]),
            pic("flower", "flowers", .bob, .emoji("🌸"), ["flowers", "flower"]),
            pic("rose", "roses", .bob, .emoji("🌹"), ["roses", "rose"]),
            pic("petal", "petals", .flutter, .petal, ["petals", "petal"]),
            pic("dewdrop", "dewdrops", .bob, .dewdrop, ["dewdrops", "dewdrop"]),
            pic("berry", "berries", .bob, .emoji("🫐"), ["berries", "berry"]),
            pic("apple", "apples", .bob, .emoji("🍎"), ["apples", "apple"]),
            pic("mushroom", "mushrooms", .bob, .emoji("🍄"), ["mushroom caps", "mushroom cap", "mushrooms", "mushroom"]),
            pic("fern", "ferns", .bob, .fern, ["fern stems", "fern stem", "ferns", "fern"]),
            pic("leaf", "leaves", .flutter, .emoji("🍃"), ["leaves", "leaf"]),
            pic("seed", "seeds", .bob, .emoji("🌱"), ["seeds", "seed"]),
            pic("bead", "beads", .twinkle, .bead, ["sparkle beads", "sparkle bead", "beads", "bead"]),
            pic("cupcake", "cupcakes", .bob, .emoji("🧁"), ["cupcakes", "cupcake"]),
            pic("coin", "coins", .rest, .emoji("🪙"), ["gold coins", "gold coin", "coins", "coin", "cents", "cent", "dollars", "dollar"]),
            pic("jewel", "jewels", .twinkle, .emoji("💎"), ["jewels", "jewel"]),
            pic("soccer ball", "soccer balls", .roll, .emoji("⚽️"), ["soccer balls", "soccer ball"]),
            pic("basketball", "basketballs", .roll, .emoji("🏀"), ["basketballs", "basketball"]),
            pic("tennis ball", "tennis balls", .roll, .emoji("🎾"), ["tennis balls", "tennis ball"]),
            pic("yarn ball", "yarn balls", .roll, .emoji("🧶"), ["yarn balls", "yarn ball"]),
            pic("cone", "cones", .rest, .cone, ["safety cones", "safety cone", "cones", "cone"]),
            pic("battery", "batteries", .rest, .emoji("🔋"), ["batteries", "battery"]),
            pic("paintbrush", "paintbrushes", .rest, .emoji("🖌️"), ["paintbrushes", "paintbrush", "brushes", "brush"]),
            pic("drum", "drums", .rest, .emoji("🥁"), ["drums", "drum"]),
            pic("spoon", "spoons", .rest, .emoji("🥄"), ["wooden spoons", "wooden spoon", "spoons", "spoon"]),
            pic("cup", "cups", .rest, .emoji("🥛"), ["measuring cups", "measuring cup", "cups", "cup"], container: true),
            pic("jar", "jars", .rest, .emoji("🫙"), ["spice jars", "spice jar", "jars", "jar"], container: true),
            pic("pouch", "pouches", .rest, .emoji("👜"), ["pouches", "pouch"], container: true),
            pic("bag", "bags", .rest, .emoji("👜"), ["bags", "bag"], container: true),
            pic("box", "boxes", .rest, .emoji("📦"), ["boxes", "box"], container: true),
            pic("basket", "baskets", .rest, .emoji("🧺"), ["baskets", "basket"], container: true),
            pic("bowl", "bowls", .rest, .emoji("🥣"), ["bowls", "bowl"], container: true),
            pic("chest", "chests", .rest, .emoji("🧰"), ["chests", "chest"], container: true),
            pic("umbrella", "umbrellas", .rest, .emoji("☂️"), ["umbrellas", "umbrella"]),
            pic("rain gauge", "rain gauges", .rest, .rainGauge, ["rain gauges", "rain gauge"]),
            pic("suitcase", "suitcases", .drive, .emoji("🧳"), ["suitcases", "suitcase"]),
            pic("ticket", "tickets", .rest, .emoji("🎫"), ["boarding passes", "boarding pass", "tickets", "ticket"]),
            pic("train", "trains", .drive, .emoji("🚂"), ["trains", "train"]),
            pic("train car", "train cars", .drive, .emoji("🚃"), ["train cars", "train car"]),
            pic("car", "cars", .drive, .emoji("🚗"), ["cars", "car"]),
            pic("hubcap", "hubcaps", .roll, .emoji("⚙️"), ["hubcaps", "hubcap"]),
            pic("traffic light", "traffic lights", .rest, .emoji("🚦"), ["traffic lights", "traffic light"]),
            pic("airplane", "airplanes", .glide, .emoji("✈️"), ["airplanes", "airplane"]),
            pic("wheel", "wheels", .roll, .wheel, ["wheels", "wheel"]),
            pic("castle", "castles", .rest, .emoji("🏰"), ["castles", "castle"]),
            pic("barn", "barns", .rest, .emoji("🏚️"), ["barns", "barn"]),
            pic("hero", "heroes", .float, .emoji("🦸"), ["superheroes", "superhero", "heroes", "hero"]),
            pic("princess", "princesses", .bob, .emoji("👸"), ["princesses", "princess"]),
            pic("pirate", "pirates", .bob, .emoji("🏴‍☠️"), ["pirates", "pirate"]),
            pic("ship", "ships", .swim, .emoji("🚢"), ["ships", "ship"]),
            pic("lighthouse", "lighthouses", .rest, .emoji("🗼"), ["lighthouses", "lighthouse"]),
            pic("wind vane", "wind vanes", .rest, .emoji("🧭"), ["wind vanes", "wind vane"]),
            pic("torch", "torches", .twinkle, .emoji("🔥"), ["torches", "torch"]),
            pic("stone", "stones", .rest, .emoji("🪨"), ["stones", "stone"]),
            pic("space tool", "space tools", .rest, .emoji("🔧"), ["wrenches", "wrench", "space tools", "space tool"]),
            pic("scoop", "scoops", .rest, .emoji("🌾"), ["scoops of grain", "scoops", "scoop", "grain"]),
            pic("bucket", "buckets", .rest, .emoji("🪣"), ["feed buckets", "feed bucket", "buckets", "bucket"]),
            pic("hay bale", "hay bales", .rest, .emoji("🌾"), ["hay bales", "hay bale"]),
            pic("tag", "tags", .rest, .emoji("🏷️"), ["turtle tags", "tags", "tag"]),
            pic("patch", "patches", .rest, .emoji("🏅"), ["mission patches", "moon patches", "rocket patches", "star patches", "patches", "patch"]),
            pic("card", "cards", .rest, .emoji("🃏"), ["rocket cards", "cards", "card"]),
            pic("jersey", "jerseys", .rest, .emoji("👕"), ["jerseys", "jersey"]),
            pic("bottle", "bottles", .rest, .emoji("🍼"), ["oil bottles", "oil bottle", "water bottles", "water bottle", "bottles", "bottle"]),
            pic("trophy", "trophies", .rest, .emoji("🏆"), ["trophies", "trophy"]),
            pic("toy", "toys", .rest, .emoji("🧸"), ["chew toys", "feather toys", "toys", "toy"]),
            pic("candle", "candles", .rest, .emoji("🕯️"), ["candles", "candle"]),
            pic("mask", "masks", .rest, .emoji("🎭"), ["masks", "mask"]),
            pic("shaker", "shakers", .rest, .emoji("🪇"), ["shakers", "shaker"]),
            pic("lemon", "lemons", .rest, .emoji("🍋"), ["lemons", "lemon"]),
            pic("feather", "feathers", .flutter, .emoji("🪶"), ["feathers", "feather"]),
            pic("helmet", "helmets", .rest, .emoji("⛑️"), ["helmets", "helmet"]),
            pic("paint tube", "paint tubes", .rest, .emoji("🎨"), ["paint tubes", "paint tube"]),
            pic("wristband", "wristbands", .rest, .emoji("⌚"), ["wristbands", "wristband"]),
            pic("blanket", "blankets", .rest, .emoji("🛏️"), ["soft blankets", "blankets", "blanket"]),
            pic("bandana", "bandanas", .rest, .emoji("🎀"), ["puppy bandanas", "bandanas", "bandana"]),
            pic("ribbon", "ribbons", .rest, .emoji("🎀"), ["ribbons", "ribbon"]),
            pic("hairpin", "hairpins", .rest, .emoji("📍"), ["jeweled hairpins", "hairpins", "hairpin"]),
            pic("biscuit", "biscuits", .rest, .emoji("🍪"), ["dog biscuits", "biscuits", "biscuit"]),
            pic("medal", "medals", .rest, .emoji("🎖️"), ["victory medals", "goal medals", "medals", "medal"]),
            pic("orange slice", "orange slices", .rest, .emoji("🍊"), ["orange slices", "orange slice"]),
            pic("table setting", "table settings", .rest, .emoji("🍽️"), ["banquet settings", "table settings", "settings"]),
            pic("cell", "cells", .rest, .emoji("🔋"), ["cells", "cell"]),
            pic("drumstick", "drumsticks", .rest, .emoji("🥁"), ["drumsticks", "drumstick"]),
            pic("beetle", "beetles", .waddle, .emoji("🪲"), ["beetles", "beetle"]),
            pic("chart", "charts", .rest, .emoji("📊"), ["weather charts", "charts", "chart"]),
            pic("thermometer", "thermometers", .rest, .emoji("🌡️"), ["thermometers", "thermometer"]),
            pic("fruit", "fruit", .rest, .emoji("🍎"), ["pieces of fruit", "pieces", "piece"]),
            pic("compass", "compasses", .rest, .emoji("🧭"), ["compasses", "compass"]),
            pic("map clue", "map clues", .rest, .emoji("🗺️"), ["map clues", "map clue"]),
            pic("passenger", "passengers", .rest, .emoji("🧑"), ["passengers", "passenger"]),
            pic("dog treat", "dog treats", .rest, .emoji("🦴"), ["dog treats", "dog treat", "cat treats", "cat treat", "fish-shaped treats", "training treats", "treats", "treat"]),
            pic("tractor", "tractors", .drive, .emoji("🚜"), ["tractors", "tractor"]),
            pic("circle", "circles", .rest, .circle, ["circles", "circle"]),
            pic("square", "squares", .rest, .square, ["squares", "square"]),
            pic("triangle", "triangles", .rest, .triangle, ["triangles", "triangle"]),
            pic("rectangle", "rectangles", .rest, .rectangle, ["rectangles", "rectangle"])
        ]
    }()

    /// Longest phrases first so "starfish" wins over "star" and "pig" never matches "pigment".
    private static let entries: [Entry] = catalog
        .flatMap { item in item.phrases.map { Entry(phrase: $0, picture: item.picture) } }
        .sorted { $0.phrase.count > $1.phrase.count }
}
