import Foundation
import SwiftUI
import CoreLocation
import MapKit
import Combine // AnyCancellable in SheetView


struct Pub_MapTouch_CLPlaceMark_Page: View {
   
    @EnvironmentObject var locationOps: Pub_Location_Operations
    
    @FocusState private var focusState: Pub_FocusedField?
    
    @State var mapCenter = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.192587899819436, longitude: -96.17889980144378), span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(0.01), longitudeDelta: CLLocationDegrees(0.01)))
    @State private var showingSheet = false
    @State private var searchText: String = String.defaultValue
    // search bar vars
    @State private var address = ""
    @StateObject private var mapSearch = MapSearch()
    
    let heights = stride(from: 0.1, through: 1.0, by: 0.1).map { PresentationDetent.fraction($0 + 0.23) }
    
    var body: some View {
      
        ZStack{
            
            if showingSheet {
                Image(Scatter_ImageAssets.mapAnnotationPinSelected.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(.bottom, 40)
                            .zIndex(1)

            } // if
            if focusState != .nameField && !showingSheet {
                Circle()
                    .fill(.cyan)
                    .opacity(0.3)
                    .frame(width: 20, height: 20)
                    .overlay(Circle().stroke(Color.white))
                    .zIndex(1)
            }
            
            ZStack(alignment: .topLeading){
                Group{
                    HStack{
                        VStack(alignment: .leading){
                            Pub_BackArrowButtonView( .mapTouch_CLPlaceMark_Page )
                            Spacer()
                        } // VStack
                        VStack{
                            searchField
                            Spacer()
                        } // VStack
                        
                    } // HStack
                    .padding()
                    .zIndex(1)
                }
               
                Map(coordinateRegion: $mapCenter)
                    .ignoresSafeArea(.all, edges: .bottom)
                    .onTapGesture {
                        getCLPlaceMark()
                        focusState = nil
                        showingSheet.toggle()
                    } // onTapGesture
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged { gesture in
                               focusState = nil
                            } // onChanged
                    ) // simultaneousGesture
                   
            } // ZStack
        } // ZStack
        .sheet(isPresented: $showingSheet) {
            Pub_ClPlaceMarkInfo_Sheet()
                .presentationDetents( Set(heights) )
                
        } // sheet
        .onReceive( locationOps.$mapRegion) { newregion in
            mapCenter = newregion
            print("new regin combine##############")
            print("center: \(newregion.center)")
        }
    } // body
} // Pub_MapTouch_CLPlaceMark

extension Pub_MapTouch_CLPlaceMark_Page{
     func getCLPlaceMark(){
         
        let coords = CLLocation(latitude: mapCenter.center.latitude, longitude: mapCenter.center.longitude)
        locationOps.getReversGeoInfoFor(coords)
         
    }
}

//44.74412236463722, -88.4389532410217

// MARK: SEARCH FIELD
extension Pub_MapTouch_CLPlaceMark_Page{
    
    var searchField: some View{
        VStack{
            
            TextField(text: $mapSearch.searchTerm) {
                Text("Search")
                    .foregroundColor( .white )
            } // TextField
            .font(.title3)
            .foregroundColor( .white )
            .padding(8)
            .background( Pub_Palette.searchTextField )
            .cornerRadius(13)
            .frame(maxWidth: .infinity)
            .focused($focusState, equals: .nameField)
            if address != mapSearch.searchTerm && focusState == .nameField && mapSearch.searchTerm != String.defaultValue {
                ScrollView {
                    LazyVStack(alignment: .leading ,spacing: 0) {
                        Group{
                            // Show auto-complete results
                            ForEach(mapSearch.locationResults, id: \.self) { location in
                                Button {
                                    
                                    reverseGeo(location: location)
                                    focusState = nil
                                    showingSheet = true
                                    
                                } label: {
                                    VStack(alignment: .leading ) {
                                        Text(location.title)
                                            .foregroundColor(Color.white)
                                        Text(location.subtitle)
                                            .font(.system(.caption))
                                            .foregroundColor(Color.white)
                                    } // VStack
                                    .padding()
                                    
                                } // End Label
                                
                                Divider()
                                    .padding(.horizontal, 10)
                            } // End ForEach
                            
                        } // Group

                    } // lazyVStack
                    .background( Pub_Palette.searchFieldResults )
                    .cornerRadius(13)
                    .frame(maxWidth: .infinity)
                } // ScrollView
                .frame(maxHeight: 200)
            } // if
 
        } // VStack
        .toolbar_Keyboard()
        .onAppear(){
            focusState = .nameField
            UITextField.appearance().clearButtonMode = .whileEditing
               
        } // onAppear
    } // searchField
    
    func reverseGeo(location: MKLocalSearchCompletion) {
        print("### STARTED REVERSEGEO LOCATION FUNC ###")
        let searchRequest = MKLocalSearch.Request(completion: location)
        
        let search = MKLocalSearch(request: searchRequest)
        
        var coordinateK : CLLocationCoordinate2D?
        
        search.start { (response, error) in
            
            if error == nil, let coordinate = response?.mapItems.first?.placemark.coordinate {
            coordinateK = coordinate
            } // if let
          
        if let c = coordinateK {
            let location = CLLocation(latitude: c.latitude, longitude: c.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
               
            guard let placemark = placemarks?.first else {
                let errorString = error?.localizedDescription ?? "Unexpected Error"
                print("Unable to reverse geocode the given location. Error: \(errorString)")
                return
            } // guard let
                print("####### \n")
                print("&&&&&&&&&&*********** response: \(placemarks!.description)")
                print("####### \n")
            let reversedGeoLocation = ReversedGeoLocation(with: placemark)
            address = "\(reversedGeoLocation.streetNumber) \(reversedGeoLocation.streetName)"
//            city = "\(reversedGeoLocation.city)"
//            state = "\(reversedGeoLocation.state)"
//            zip = "\(reversedGeoLocation.zipCode)"
            mapSearch.searchTerm = address
            //mapCenter.center = c
            locationOps.currentPlacemark = placemark
            locationOps.updateZoom(c)
            //focusState = nil

                } //reverseGeocodeLocation closure
            } // if let c
        } // search.start
    } // reverseGeo
} // extension


struct ReversedGeoLocation {
    let streetNumber: String    // eg. 1
    let streetName: String      // eg. Infinite Loop
    let city: String            // eg. Cupertino
    let state: String           // eg. CA
    let zipCode: String         // eg. 95014
    let country: String         // eg. United States
    let isoCountryCode: String  // eg. US

    var formattedAddress: String {
        return """
        \(streetNumber) \(streetName),
        \(city), \(state) \(zipCode)
        \(country)
        """
    }

    // Handle optionals as needed
    init(with placemark: CLPlacemark) {
        self.streetName     = placemark.thoroughfare ?? ""
        self.streetNumber   = placemark.subThoroughfare ?? ""
        self.city           = placemark.locality ?? ""
        self.state          = placemark.administrativeArea ?? ""
        self.zipCode        = placemark.postalCode ?? ""
        self.country        = placemark.country ?? ""
        self.isoCountryCode = placemark.isoCountryCode ?? ""
    }
}
