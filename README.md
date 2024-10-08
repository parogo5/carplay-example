# CarPlay Example Project

This project demonstrates the implementation of a CarPlay application using Swift. It showcases the main features and templates available in CarPlay, providing a functional and user-friendly interface for drivers.

## Features

- **CarPlay Integration**: Seamless integration with Apple's CarPlay, allowing users to interact with your app through their vehicle’s display.
- **Main Interface**: A user-friendly interface that adapts to the CarPlay environment.
- **Point of Interest (POI) Template**: Displays relevant locations, complete with titles, subtitles, and summary information.
- **Information Template**: Provides detailed information about selected items, with customizable actions.
- **Alert and Action Sheets**: Displays alerts and action sheets to enhance user interactions.

## Supported Templates

### 1. **Point of Interest Template**

The Point of Interest template allows users to view and select points of interest (POIs) on a map. Each POI can include:

- Title
- Subtitle
- Summary
- Custom pin images for selected and unselected states

#### Example Usage

```swift
let poi = CPPointOfInterest(location: location,
                             title: "Gas Station",
                             subtitle: "Nearby",
                             summary: "Open 24 hours",
                             detailTitle: "Gas Station Details",
                             detailSubtitle: "Find fuel quickly",
                             detailSummary: "Located just off the highway",
                             pinImage: UIImage(named: "pinImage"),
                             selectedPinImage: UIImage(named: "selectedPinImage"))
```
### 2. **Information Template**
The Information template provides detailed information about a selected item, including titles, summaries, and actions.

#### Example Usage
```swift
let infoItem = CPInformationItem(title: "Welcome to CarPlay", detail: "This is an example app demonstrating CarPlay features.")
let infoTemplate = CPInformationTemplate(title: "Information", layout: .twoColumn, items: [infoItem], actions: [CPTextButton(title: "OK", style: .default, handler: { ... })])
```

### 3. **Alert Template**

This template is used to show alerts to the user, providing options to acknowledge or cancel.

## Example Usage

 ```swift
let alertTemplate = CPAlertTemplate(titleVariants: ["Alert", "Important Update"],
                                    actions: [
                                        CPAlertAction(title: "OK", style: .default, handler: { ... }),
                                        CPAlertAction(title: "Cancel", style: .cancel, handler: { ... })
                                    ])
 ```
### 4. **Action Sheet**
Action sheets provide a set of actions that a user can take in response to a particular situation.

## Example Usage
```swift
let actionSheet = CPActionSheetTemplate(title: "Choose an Option", actions: [
    CPAlertAction(title: "Option 1", style: .default, handler: { ... }),
    CPAlertAction(title: "Option 2", style: .cancel, handler: { ... })
])
```
### Getting Started

## 1. Prerequisites
Xcode 14 or later
iOS 14 or later
CarPlay capable simulator or device
To get started with this project, follow the steps below.

## 2. Installation
Clone the repository:
```bash
git clone https://github.com/yourusername/carplay-example.git
cd carplay-example
```
Open the project in Xcode:
```bash
open CarPlayExample.xcodeproj
```
### Contributing
Feel free to submit pull requests or open issues if you have suggestions or improvements.

### License
This project is licensed under the MIT License. See the LICENSE file for details.
