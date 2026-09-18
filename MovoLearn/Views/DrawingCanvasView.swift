import SwiftUI
import PencilKit
import OSLog

private let drawingLog = Logger(subsystem: "com.movolearn.app", category: "DrawingCanvas")
/// Fine enough for details (gills, stars) without feeling like a marker.
private let drawingPenWidth: CGFloat = 1.5

/// Topic-based checklist goals that turn drawing into a mini Art Quest.
enum DrawingQuestGoals {
    static func goals(for topic: Topic, authored: [String] = []) -> [String] {
        let trimmed = authored
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        if !trimmed.isEmpty {
            return Array(trimmed.prefix(4))
        }
        switch topic {
        case .horses:
            return ["A pony", "Sunny sky", "A story detail"]
        case .sharks, .oceanAnimals:
            return ["Ocean water", "A sea friend", "A story detail"]
        case .space, .planets, .rockets:
            return ["A star", "A rocket or moon", "A story detail"]
        case .dinosaurs:
            return ["A dino", "A plant or leaf", "A story detail"]
        case .dogs:
            return ["A dog", "A park or yard", "A story detail"]
        case .robots:
            return ["A robot", "A button or light", "A story detail"]
        default:
            return ["A main character", "A place", "A story detail"]
        }
    }
}

private struct DrawingSwatch: Identifiable {
    let name: String
    let uiColor: UIColor
    var preview: Color? = nil
    var needsDarkStroke: Bool = false

    var id: String { name }
    var color: Color { preview ?? Color(uiColor: uiColor) }
}

/// Converts a SwiftUI swatch into the opaque sRGB `UIColor` PencilKit inks with.
private enum PencilKitInk {
    static let black = rgbInk(red: 0, green: 0, blue: 0)
    static let white = rgbInk(red: 1, green: 1, blue: 1)

    static func color(from color: Color) -> UIColor {
        let resolved = color.resolve(in: EnvironmentValues())
        return rgbInk(
            red: CGFloat(resolved.red),
            green: CGFloat(resolved.green),
            blue: CGFloat(resolved.blue)
        )
    }

    /// PencilKit inverts grayscale `UIColor.white` / `.black` to the opposite color.
    /// Keep a tiny RGB bias in sRGB so white stays white and black stays black.
    private static func rgbInk(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        var r = min(max(red, 0), 1)
        var g = min(max(green, 0), 1)
        var b = min(max(blue, 0), 1)
        if abs(r - g) < 0.002 && abs(g - b) < 0.002 {
            if r > 0.9 {
                r = 1
                g = 0.998
                b = 0.996
            } else {
                r = min(r + 0.004, 1)
                g = min(g + 0.002, 1)
            }
        }
        guard let space = CGColorSpace(name: CGColorSpace.sRGB),
              let cgColor = CGColor(colorSpace: space, components: [r, g, b, 1]) else {
            return UIColor(red: r, green: g, blue: b, alpha: 1)
        }
        return UIColor(cgColor: cgColor)
    }
}

/// Child-friendly drawing canvas with colors, quest checklist, pen, eraser, undo, and clear.
struct DrawingCanvasView: View {
    @Binding var hasContent: Bool
    var accent: Color = DesignSystem.Colors.warmOrange
    var questGoals: [String] = []
    var onSubmit: ((Data?) -> Void)? = nil

    @State private var canvasView = PKCanvasView()
    @State private var tool: DrawingTool = .pen
    @State private var inkColor: UIColor = PencilKitInk.color(from: DesignSystem.Colors.deepNavy)
    @State private var completedGoals: Set<String> = []
    @State private var didClear = false
    @State private var starBounce = false

    private enum DrawingTool {
        case pen
        case eraser
    }

    private let palette: [DrawingSwatch] = [
        DrawingSwatch(name: "Black", uiColor: PencilKitInk.black, preview: Color.black),
        DrawingSwatch(name: "White", uiColor: PencilKitInk.white, preview: Color.white, needsDarkStroke: true),
        DrawingSwatch(name: "Navy", uiColor: PencilKitInk.color(from: DesignSystem.Colors.deepNavy)),
        DrawingSwatch(name: "Red", uiColor: PencilKitInk.color(from: DesignSystem.Colors.softRed)),
        DrawingSwatch(name: "Orange", uiColor: PencilKitInk.color(from: DesignSystem.Colors.warmOrange)),
        DrawingSwatch(name: "Yellow", uiColor: PencilKitInk.color(from: DesignSystem.Colors.sunshineYellow)),
        DrawingSwatch(name: "Green", uiColor: PencilKitInk.color(from: DesignSystem.Colors.freshGreen)),
        DrawingSwatch(name: "Teal", uiColor: PencilKitInk.color(from: DesignSystem.Colors.oceanTurquoise)),
        DrawingSwatch(name: "Blue", uiColor: PencilKitInk.color(from: DesignSystem.Colors.skyBlue)),
        DrawingSwatch(name: "Purple", uiColor: PencilKitInk.color(from: DesignSystem.Colors.lavenderPurple)),
        DrawingSwatch(name: "Pink", uiColor: PencilKitInk.color(from: DesignSystem.Colors.coralPink)),
        DrawingSwatch(name: "Light pink", uiColor: PencilKitInk.color(from: DesignSystem.Colors.coralPinkLight), needsDarkStroke: true),
        DrawingSwatch(name: "Light blue", uiColor: PencilKitInk.color(from: DesignSystem.Colors.skyBlueLight), needsDarkStroke: true),
        DrawingSwatch(name: "Pale yellow", uiColor: PencilKitInk.color(from: DesignSystem.Colors.sunshineYellowLight), needsDarkStroke: true),
        DrawingSwatch(name: "Brown", uiColor: PencilKitInk.color(from: Color(red: 0.45, green: 0.28, blue: 0.16))),
        DrawingSwatch(name: "Gray", uiColor: PencilKitInk.color(from: Color(red: 0.55, green: 0.56, blue: 0.62)))
    ]

    private var starsEarned: Int {
        var stars = 0
        if hasContent { stars += 1 }
        if completedGoals.count >= 1 { stars += 1 }
        if completedGoals.count >= questGoals.count && !questGoals.isEmpty { stars += 1 }
        return min(stars, 3)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            if !questGoals.isEmpty {
                questChecklist
            }

            canvasPad

            colorPalette

            HStack(spacing: DesignSystem.Spacing.sm) {
                toolButton(
                    title: "Draw",
                    systemImage: "pencil.tip",
                    selected: tool == .pen
                ) {
                    tool = .pen
                }

                toolButton(
                    title: "Eraser",
                    systemImage: "eraser",
                    selected: tool == .eraser
                ) {
                    tool = .eraser
                }

                Spacer()

                toolButton(title: "Undo", systemImage: "arrow.uturn.backward", selected: false) {
                    undo()
                }

                toolButton(title: "Clear", systemImage: "trash", selected: false) {
                    clear()
                }
            }
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            applyTool()
        }
        .onChange(of: tool) { _, _ in
            applyTool()
        }
        .onChange(of: inkColor) { _, _ in
            applyTool()
        }
        .onChange(of: hasContent) { _, newValue in
            if newValue {
                withAnimation(DesignSystem.Animation.bounce) {
                    starBounce = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    starBounce = false
                }
            }
        }
    }

    private var canvasPad: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DesignSystem.Radius.mediumRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            DesignSystem.Colors.cardWhite,
                            accent.opacity(0.06)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            PencilKitCanvas(
                canvasView: $canvasView,
                onDrawingChanged: { drawing in
                    hasContent = !drawing.strokes.isEmpty
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.mediumRadius, style: .continuous))

            if !hasContent {
                VStack(spacing: 8) {
                    Image(systemName: "paintbrush.pointed.fill")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(accent.opacity(0.45))
                    Text("Start drawing!")
                        .font(DesignSystem.Typography.title(18))
                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                }
                .allowsHitTesting(false)
            }
        }
        .frame(minHeight: 460)
        .frame(maxHeight: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Radius.mediumRadius, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [accent.opacity(0.85), DesignSystem.Colors.sunshineYellow.opacity(0.65)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
        )
        .shadow(color: accent.opacity(0.18), radius: 10, y: 4)
    }

    private var questChecklist: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: DesignSystem.Spacing.sm) {
                Text("Tap what you added:")
                    .font(DesignSystem.Typography.title(15))
                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                Spacer()
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { index in
                        Image(systemName: index < starsEarned ? "star.fill" : "star")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(
                                index < starsEarned
                                    ? DesignSystem.Colors.sunshineYellow
                                    : DesignSystem.Colors.textTertiary.opacity(0.45)
                            )
                            .scaleEffect(starBounce && index < starsEarned ? 1.25 : 1)
                    }
                }
                .accessibilityLabel("\(starsEarned) of 3 stars earned")
            }

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 88), spacing: 8)],
                alignment: .leading,
                spacing: 8
            ) {
                ForEach(questGoals, id: \.self) { goal in
                    let done = completedGoals.contains(goal)
                    Button {
                        withAnimation(DesignSystem.Animation.select) {
                            if done {
                                completedGoals.remove(goal)
                            } else {
                                completedGoals.insert(goal)
                            }
                        }
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 14, weight: .bold))
                            Text(goal)
                                .font(DesignSystem.Typography.caption(12).weight(.bold))
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                        .foregroundStyle(done ? DesignSystem.Colors.cardWhite : DesignSystem.Colors.deepNavy)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(done ? accent : DesignSystem.Colors.surfaceMuted)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(done ? accent : DesignSystem.Colors.inputBorder, lineWidth: 1.5)
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(done ? "\(goal), completed" : "\(goal), not yet")
                }
            }
        }
    }

    private var colorPalette: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 36), spacing: 8)],
            alignment: .leading,
            spacing: 8
        ) {
            ForEach(palette) { swatch in
                let selected = colorsMatch(swatch.uiColor, inkColor) && tool == .pen
                Button {
                    inkColor = swatch.uiColor
                    tool = .pen
                } label: {
                    Circle()
                        .fill(swatch.color)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Circle()
                                .stroke(
                                    DesignSystem.Colors.deepNavy.opacity(swatch.needsDarkStroke ? 0.35 : 0.15),
                                    lineWidth: 1
                                )
                        )
                        .overlay(
                            Circle()
                                .stroke(selected ? accent : Color.clear, lineWidth: 3)
                                .padding(-3)
                        )
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("\(swatch.name) ink")
            }
        }
    }

    private func colorsMatch(_ a: UIColor, _ b: UIColor) -> Bool {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        guard a.getRed(&r1, green: &g1, blue: &b1, alpha: &a1),
              b.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else {
            return a == b
        }
        return abs(r1 - r2) < 0.01 && abs(g1 - g2) < 0.01 && abs(b1 - b2) < 0.01
    }

    private func toolButton(
        title: String,
        systemImage: String,
        selected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: systemImage)
                Text(title)
                    .font(DesignSystem.Typography.caption(12).weight(.bold))
            }
            .foregroundStyle(selected ? DesignSystem.Colors.cardWhite : DesignSystem.Colors.deepNavy)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(selected ? accent : DesignSystem.Colors.surfaceMuted)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(selected ? accent : DesignSystem.Colors.inputBorder, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }

    private func applyTool() {
        switch tool {
        case .pen:
            canvasView.overrideUserInterfaceStyle = .light
            canvasView.tool = PKInkingTool(.monoline, color: inkColor, width: drawingPenWidth)
        case .eraser:
            canvasView.tool = PKEraserTool(.bitmap)
        }
    }

    private func undo() {
        guard let undoManager = canvasView.undoManager, undoManager.canUndo else { return }
        undoManager.undo()
        hasContent = !canvasView.drawing.strokes.isEmpty
    }

    private func clear() {
        canvasView.drawing = PKDrawing()
        hasContent = false
        completedGoals.removeAll()
        didClear = true
        drawingLog.debug("Drawing canvas cleared")
    }

    /// Exports PNG data for optional persistence.
    func exportPNGData() -> Data? {
        let bounds = canvasView.bounds.isEmpty
            ? CGRect(x: 0, y: 0, width: 320, height: 460)
            : canvasView.bounds
        let image = canvasView.drawing.image(from: bounds, scale: UIScreen.main.scale)
        return image.pngData()
    }
}

private struct PencilKitCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    var onDrawingChanged: (PKDrawing) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onDrawingChanged: onDrawingChanged)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.overrideUserInterfaceStyle = .light
        canvasView.delegate = context.coordinator
        canvasView.tool = PKInkingTool(.monoline, color: PencilKitInk.color(from: DesignSystem.Colors.deepNavy), width: drawingPenWidth)
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        context.coordinator.onDrawingChanged = onDrawingChanged
    }

    final class Coordinator: NSObject, PKCanvasViewDelegate {
        var onDrawingChanged: (PKDrawing) -> Void

        init(onDrawingChanged: @escaping (PKDrawing) -> Void) {
            self.onDrawingChanged = onDrawingChanged
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            onDrawingChanged(canvasView.drawing)
        }
    }
}
