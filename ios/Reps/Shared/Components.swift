import SwiftUI

/// A small uppercase label above a section, in the style the website uses for its own.
struct SectionLabel: View {
    let text: String
    var color: Color = .secondary

    var body: some View {
        Text(text.uppercased())
            .font(.caption.weight(.semibold))
            .tracking(1.5)
            .foregroundColor(color)
            .accessibilityAddTraits(.isHeader)
    }
}

/// A raised panel. `tint` gives it the accent (or flag) wash the website uses for the thing to act on.
struct Card<Content: View>: View {
    var tint: Color?
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background((tint ?? Color(.secondarySystemBackground)).opacity(tint == nil ? 1 : 0.10))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(tint ?? Color.clear, lineWidth: tint == nil ? 0 : 1))
        .cornerRadius(12)
    }
}

/// A failure, inline where it happened, in the website's own words.
struct ErrorBanner: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.footnote)
            .foregroundColor(.primary)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.red.opacity(0.10))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.red.opacity(0.6), lineWidth: 1))
            .cornerRadius(8)
            .accessibilityAddTraits(.updatesFrequently)
    }
}

/// The main action on a screen.
struct PrimaryButton: View {
    let title: String
    var busy = false
    var disabled = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if busy { ProgressView().tint(.white) }
                Text(title).fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .disabled(busy || disabled)
        .opacity(busy || disabled ? 0.6 : 1)
    }
}

/// The quieter action beside it.
struct SecondaryButton: View {
    let title: String
    var busy = false
    var disabled = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if busy { ProgressView() }
                Text(title).fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.separator), lineWidth: 1))
            .foregroundColor(.primary)
        }
        .disabled(busy || disabled)
        .opacity(busy || disabled ? 0.6 : 1)
    }
}

/// A thin progress bar, 0…1.
struct ProgressBar: View {
    let fraction: Double
    var height: CGFloat = 6

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule().fill(Color(.separator).opacity(0.5))
                Capsule()
                    .fill(Color.accentColor)
                    .frame(width: max(0, min(1, fraction)) * proxy.size.width)
            }
        }
        .frame(height: height)
        .accessibilityElement()
        .accessibilityValue("\(Int((max(0, min(1, fraction)) * 100).rounded()))%")
    }
}

/// A quoted line with the rule down its left side, used for worked examples and model answers.
struct QuoteBlock: View {
    let text: String
    var emphasised = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Rectangle()
                .fill(emphasised ? Color.accentColor : Color(.separator))
                .frame(width: 2)
            Text(text)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

/// A single-line text counter, shown only once the limit is near — showing it from the first
/// keystroke would make writing a line feel like a test with a word limit.
struct CharacterCounter: View {
    let used: Int
    let max: Int
    let strings: Strings
    /// How close to the limit before it appears.
    var threshold = 40

    var body: some View {
        if max - used <= threshold {
            Text(strings.t("chat.charactersLeft", ["count": max - used]))
                .font(.caption.monospacedDigit())
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

extension DateFormatter {
    /// `2026-09-14` → a `Date` at local midnight, the way a day is written in the log.
    static let isoDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

extension ISO8601DateFormatter {
    /// Supabase timestamps carry fractional seconds.
    static let withFraction: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    static let plain = ISO8601DateFormatter()

    static func parse(_ text: String) -> Date? {
        withFraction.date(from: text) ?? plain.date(from: text)
    }
}
