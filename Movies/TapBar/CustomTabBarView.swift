//
//  CustomTabBarView1.swift
//  Movies
//
//  Created by Ahmed Fathy on 19/04/2026.
//

import UIKit

protocol CustomTabBarDelegate: AnyObject {
    func didSelectTab(index: Int)
}

class CustomTabBarView: UIView {

    weak var delegate: CustomTabBarDelegate?

        private var buttons: [UIButton] = []

        private let titles = ["Home", "Search", "Watch list"]
        private let icons = ["house", "magnifyingglass", "bookmark"]
        private let selectedColor = UIColor(hex: "#0296E5")
        private let unselectedColor = UIColor.gray

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupUI()
        }

        private func setupUI() {
            backgroundColor = UIColor(hex: "#242A32")
            clipsToBounds = true

            let topSeparator = UIView()
            topSeparator.backgroundColor = selectedColor
            topSeparator.translatesAutoresizingMaskIntoConstraints = false
            addSubview(topSeparator)

            NSLayoutConstraint.activate([
                topSeparator.topAnchor.constraint(equalTo: topAnchor),
                topSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
                topSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
                topSeparator.heightAnchor.constraint(equalToConstant: 1)
            ])

            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillEqually

            addSubview(stack)
            stack.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: topSeparator.bottomAnchor),
                stack.bottomAnchor.constraint(equalTo: bottomAnchor),
                stack.leadingAnchor.constraint(equalTo: leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])

            for i in 0..<titles.count {
                let button = createButton(index: i)
                buttons.append(button)
                stack.addArrangedSubview(button)
            }

            updateSelection(index: 0)
        }

        private func createButton(index: Int) -> UIButton {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: icons[index])
            config.title = titles[index]
            config.imagePlacement = .top
            config.imagePadding = 6
            config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = .systemFont(ofSize: 12, weight: .medium)
                return outgoing
            }

            let button = UIButton(configuration: config)
            button.tag = index
            button.tintColor = unselectedColor
            button.setTitleColor(unselectedColor, for: .normal)
            button.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)

            return button
        }

        @objc private func tabTapped(_ sender: UIButton) {
            updateSelection(index: sender.tag)
            delegate?.didSelectTab(index: sender.tag)
        }

        func select(index: Int) {
            updateSelection(index: index)
        }

        private func updateSelection(index: Int) {
            for btn in buttons {
                let isSelected = btn.tag == index
                let color = isSelected ? selectedColor : unselectedColor
                btn.tintColor = color
                btn.setTitleColor(color, for: .normal)
                btn.configuration?.baseForegroundColor = color
            }
        }
    }
