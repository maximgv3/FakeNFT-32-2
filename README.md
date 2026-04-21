# FakeNFT

FakeNFT is an iOS app for browsing NFT collections, viewing NFT details, managing favorites, editing profile data, and completing purchases through a cart and order flow.

## Features

- NFT catalog and collection browsing
- Collection details and NFT cards
- Sorting options in catalog
- Favorites screen
- My NFTs screen
- Profile screen and profile editing
- Cart screen with order flow
- Payment currency selection
- Network-based data loading
- Shared design system and reusable UI components
- Supports iOS 17+

## Tech Stack

- Swift
- SwiftUI
- MVVM
- async/await
- URLSession
- Kingfisher
- UserDefaults

## Installation

1. Clone the repository:
   `git clone https://github.com/maximgv3/FakeNFT-32-2.git`

2. Open the project:
   `open iOS-FakeNFT-Extended.xcodeproj`

3. Run the app in Xcode.

## Architecture

The project has a modular structure with feature-based separation:

- **Catalog** — collections, NFT cards, sorting, and collection details
- **Profile** — profile data, editing, favorites, and personal NFTs
- **Cart** — cart items, order flow, and payment
- **Core** — networking, storage, design system, and shared UI

The app is primarily built with **SwiftUI** and follows the **MVVM** pattern.

## Teamwork

This project was developed in a team environment with Git workflow, pull requests, and feature documentation.

## Result

This project demonstrates work on a multi-screen team iOS application with modular architecture, networking, shared UI components, and e-commerce style flows.
