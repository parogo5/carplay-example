//
//  TemplateManager.swift
//  CarplayExample
//
//  Created by pablo.rodriguez.local on 7/10/24.
//
import CarPlay
import MapKit

class TemplateManager: NSObject, CPInterfaceControllerDelegate {
    
    static let shared = TemplateManager()
    var carplayInterfaceController: CPInterfaceController?
    
    // MARK: - CPInterfaceControllerDelegate
    
    public func interfaceControllerDidConnect(_ interfaceController: CPInterfaceController, scene: CPTemplateApplicationScene) {
        carplayInterfaceController = interfaceController
        carplayInterfaceController?.delegate = self
        
        // Show initial interface when CarPlay is connected
        showTabBarInterface()
    }
    
    public func interfaceControllerDidDisconnect(_ interfaceController: CPInterfaceController, scene: CPTemplateApplicationScene) {
        carplayInterfaceController = nil
    }
    
    // MARK: - Templates
    
    // 1. Show a Tab Bar interface
    func showTabBarInterface() {
        let listTemplate: CPListTemplate = CPListTemplate(title: "List", sections: [])
        let gridTemplate: CPGridTemplate = createGrid()
        
        listTemplate.updateSections([updateList()])
        listTemplate.tabImage = UIImage(systemName: "list.number")
        
        let tabBarTemplate = CPTabBarTemplate(templates: [listTemplate, gridTemplate])

        carplayInterfaceController?.setRootTemplate(tabBarTemplate, animated: true, completion: nil)
        }
    
    private func updateList() -> CPListSection {
        let listItems = [
            createListItem(text: "Item 1", detailText: "show alert", imageName: "1.circle.fill", action: {
                self.showAlert()
            }),
            createListItem(text: "Item 2", detailText: "show action sheet", imageName: "2.circle.fill", action: {
                self.showActionSheet()
            })
        ]
        return CPListSection(items: listItems)
    }

    private func createListItem(text: String, detailText: String, imageName: String, action: (() -> Void)?) -> CPListItem {
        let item = CPListItem(text: text, detailText: detailText)
        item.accessoryType = .disclosureIndicator
        item.setImage(UIImage(systemName: imageName))
        item.handler = { _ , _ in
            action?()
        }
        return item
    }
    
    private func createGridItem(text: String, imageName: String) -> CPGridButton {
        let item = CPGridButton(titleVariants: [text], image: UIImage(systemName: imageName)!)
        return item
    }
    
    // 4. Create a Grid Template
    func createGrid() -> CPGridTemplate {
        let gridButton1 = CPGridButton(titleVariants: ["POI"], image: UIImage(systemName: "mappin.circle.fill")!) {_ in
            self.showPOITemplateErrorWithMaps()
        }
        
        let gridButton2 = CPGridButton(titleVariants: ["Information"], image: UIImage(systemName: "info.circle")!) {_ in
            self.showInformationTemplate()
        }
        
        let gridButton3 = CPGridButton(titleVariants: ["Play Sound"], image: UIImage(systemName: "speaker.wave.2")!) { _ in
            DispatchQueue.main.async {
                self.playSoundTextToSpeech()
            }
        }
        
        let gridTemplate = CPGridTemplate(title: "Grid", gridButtons: [gridButton1, gridButton2, gridButton3])
        
        gridTemplate.tabImage = UIImage(systemName: "circle.grid.2x1")
        return gridTemplate
    }
    
    // 5. Show an Alert
    func showAlert() {
        let alert = CPAlertTemplate(titleVariants: ["Alert", "Gas Station Nearby"],
                                    actions: [
                                        CPAlertAction(title: "OK", style: .default, handler: { _ in
                                            self.carplayInterfaceController?.dismissTemplate(animated: true, completion: nil)
                                        }),
                                        CPAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                                            self.carplayInterfaceController?.dismissTemplate(animated: true, completion: nil)
                                        })
                                    ])
        carplayInterfaceController?.presentTemplate(alert, animated: true, completion: nil)
    }
    
    func showActionSheet() {
        // Crear un CPActionSheetTemplate
        let actionSheet = CPActionSheetTemplate(title: "Choose an Action", message: "Select one of the following options", actions: [
            CPAlertAction(title: "Option 1", style: .default, handler: { _ in
                print("Option 1 selected")
                self.carplayInterfaceController?.dismissTemplate(animated: true, completion: nil)
            }),
            CPAlertAction(title: "Option 2", style: .default, handler: { _ in
                print("Option 2 selected")
                self.carplayInterfaceController?.dismissTemplate(animated: true, completion: nil)
            }),
            CPAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                self.carplayInterfaceController?.dismissTemplate(animated: true, completion: nil)
            })
        ])
        
        // Presentar el CPActionSheetTemplate
        carplayInterfaceController?.presentTemplate(actionSheet, animated: true, completion: nil)
    }
    
    func showInformationTemplate() {
        // Crear los elementos de información
        let item1 = CPInformationItem(title: "This is the title of CPInformationItem", detail: "This is the detail of CPInformationItem")
        
        // Crear las acciones
        let okAction = CPTextButton(title: "OK", textStyle: .confirm) { _ in
            self.carplayInterfaceController?.popTemplate(animated: true, completion: nil)
        }
        
        // Inicializar el template de información
        let informationTemplate = CPInformationTemplate(
            title: "Important information",
            layout: .leading,
            items: [item1],
            actions: [okAction]
        )
        
        // Presentar el template de información
        self.carplayInterfaceController?.pushTemplate(informationTemplate, animated: true, completion: nil)
    }

    func createPOIs() -> [CPPointOfInterest]{
        // Define the first POI location using MKMapItem
        let firstMapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))) // Example coordinates for the first POI
        
        // Initialize the first Point of Interest
        let firstPOI = CPPointOfInterest(location: firstMapItem,
                                          title: "Gas Station",
                                          subtitle: "Open 24/7",
                                          summary: "Get fuel and snacks",
                                          detailTitle: "Gas Station Details",
                                          detailSubtitle: "Conveniently located",
                                          detailSummary: "Offers a variety of snacks and beverages.",
                                          pinImage: UIImage(named: "gas_station_pin"), // Custom unselected pin image
                                          selectedPinImage: UIImage(named: "gas_station_pin_selected")) // Custom selected pin image
        
        // Define the second POI location using MKMapItem
        let secondMapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094))) // Example coordinates for the second POI
        
        // Initialize the second Point of Interest
        let secondPOI = CPPointOfInterest(location: secondMapItem,
                                           title: "Restaurant",
                                           subtitle: "Dine-In and Takeout",
                                           summary: "Enjoy delicious meals",
                                           detailTitle: "Restaurant Details",
                                           detailSubtitle: "Family-friendly atmosphere",
                                           detailSummary: "Serves a variety of cuisines.",
                                           pinImage: UIImage(named: "restaurant_pin"), // Custom unselected pin image
                                           selectedPinImage: UIImage(named: "restaurant_pin_selected")) // Custom selected pin image
        
       return [firstPOI, secondPOI]
        
    }

    func showPOITemplateErrorWithMaps() {
        // Create POI items
        let poiItems = createPOIs()
        
        // Create the POI template
        let poiTemplate = CPPointOfInterestTemplate(title: "Points of Interest",
                                                    pointsOfInterest: poiItems,
                                                    selectedIndex: 0)
        
        // Present the POI template
        carplayInterfaceController?.pushTemplate(poiTemplate, animated: true, completion: nil)
    }
    
    @MainActor func playSoundTextToSpeech() {
        TextToSpeech.shared.speakText("Hola esto es un ejemplo de convertidor texto a voz")
    }
}
