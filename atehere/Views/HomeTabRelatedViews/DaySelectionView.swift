//
//  DaySelectionView.swift
//  atehere
//
//  Created by Berke Bozacı on 12.11.2024.
//
//
import SwiftUI

struct DaySelectionView: View {
    @Binding var selectedDays: Set<String>
    let availableDays: [String]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Select Days")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(availableDays, id: \.self) { day in
                        DayButton(day: day.capitalized, isSelected: selectedDays.contains(day)) {
                            if selectedDays.contains(day) {
                                selectedDays.remove(day)
                            } else {
                                selectedDays.insert(day)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct DayButton: View {
    let day: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(day)
                .font(.subheadline)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(isSelected ? Color("MainColor") : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(8)
        }
    }
}

