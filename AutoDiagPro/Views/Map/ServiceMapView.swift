import SwiftUI
import MapKit

struct ServiceMapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 46.7712, longitude: 23.6236),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var locations: [ServiceLocation] = ServiceLocation.sampleLocations
    @State private var selectedLocation: ServiceLocation?
    @State private var selectedFilter: ServiceType?
    @State private var showList = false
    @State private var followUser = true
    @State private var showLocationInfo = false
    
    var filteredLocations: [ServiceLocation] {
        if let filter = selectedFilter {
            return locations.filter { $0.type == filter }
        }
        return locations
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // Map with real-time user location
                Map(coordinateRegion: $region,
                    showsUserLocation: true,
                    userTrackingMode: .constant(followUser ? .follow : .none),
                    annotationItems: filteredLocations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        Button(action: { withAnimation { selectedLocation = location } }) {
                            VStack(spacing: 2) {
                                Image(systemName: location.type.icon)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(location.type.color)
                                    .cornerRadius(8)
                                    .shadow(color: location.type.color.opacity(0.5), radius: 4)
                                
                                if selectedLocation?.id == location.id {
                                    Text(location.name)
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(Theme.textPrimary)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Theme.cardBackground)
                                        .cornerRadius(4)
                                }
                            }
                        }
                    }
                }
                .ignoresSafeArea(edges: .top)
                .onAppear {
                    locationManager.startTracking()
                    updateDistances()
                }
                .onDisappear {
                    locationManager.stopTracking()
                }
                .onChange(of: locationManager.userLocation?.latitude) { _ in
                    updateDistances()
                }
                
                // Location tracking button (top-right overlay)
                VStack {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            // Center on user button
                            Button(action: {
                                followUser = true
                                if let loc = locationManager.userLocation {
                                    withAnimation {
                                        region.center = loc
                                        region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                    }
                                }
                            }) {
                                Image(systemName: followUser ? "location.fill" : "location")
                                    .font(.system(size: 16))
                                    .foregroundColor(followUser ? Theme.primary : Theme.textSecondary)
                                    .frame(width: 40, height: 40)
                                    .background(Theme.cardBackground.opacity(0.95))
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.3), radius: 4)
                            }
                            
                            // Location info button
                            Button(action: { withAnimation { showLocationInfo.toggle() } }) {
                                Image(systemName: "info.circle")
                                    .font(.system(size: 16))
                                    .foregroundColor(Theme.textSecondary)
                                    .frame(width: 40, height: 40)
                                    .background(Theme.cardBackground.opacity(0.95))
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.3), radius: 4)
                            }
                        }
                        .padding(.trailing, 12)
                        .padding(.top, 60)
                    }
                    Spacer()
                }
                
                // Location info overlay
                if showLocationInfo {
                    VStack {
                        locationInfoBar
                            .padding(.top, 50)
                        Spacer()
                    }
                }
                
                // Bottom overlay
                VStack(spacing: 0) {
                    // Filter chips
                    filterBar
                    
                    // Selected location card
                    if let location = selectedLocation {
                        locationDetailCard(location)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(systemName: "map.fill")
                            .foregroundColor(Theme.primary)
                        Text("Service-uri Aproape")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showList.toggle() }) {
                        Image(systemName: showList ? "map" : "list.bullet")
                            .foregroundColor(Theme.primary)
                    }
                }
            }
            .sheet(isPresented: $showList) {
                serviceListView
            }
        }
    }
    
    // MARK: - Filter Bar
    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                filterChip(title: "Toate", icon: "mappin.and.ellipse", isSelected: selectedFilter == nil) {
                    withAnimation { selectedFilter = nil }
                }
                
                ForEach(ServiceType.allCases, id: \.self) { type in
                    filterChip(title: type.rawValue, icon: type.icon, isSelected: selectedFilter == type) {
                        withAnimation { selectedFilter = selectedFilter == type ? nil : type }
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .background(Theme.background.opacity(0.95))
    }
    
    private func filterChip(title: String, icon: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isSelected ? Theme.primary.opacity(0.2) : Theme.cardBackground)
            .foregroundColor(isSelected ? Theme.primary : Theme.textSecondary)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(isSelected ? Theme.primary.opacity(0.5) : Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
        }
    }
    
    // MARK: - Location Detail Card
    private func locationDetailCard(_ location: ServiceLocation) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(location.name)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        
                        if location.isAuthorized {
                            Text("AUTORIZAT")
                                .font(.system(size: 8, weight: .bold))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.purple.opacity(0.2))
                                .foregroundColor(Color.purple)
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(location.address)
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                // Close button
                Button(action: { withAnimation { selectedLocation = nil } }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Theme.textMuted)
                        .padding(6)
                        .background(Theme.surfaceBackground)
                        .cornerRadius(12)
                }
            }
            
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.gaugeYellow)
                    Text(location.formattedRating)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    Text("(\(location.reviewCount))")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.primary)
                    Text(location.formattedDistance)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                }
                
                Text(location.priceLevel.rawValue)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Theme.gaugeGreen)
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(location.isOpen ? Theme.gaugeGreen : Theme.gaugeRed)
                        .frame(width: 6, height: 6)
                    Text(location.isOpen ? "Deschis" : "Inchis")
                        .font(.system(size: 11))
                        .foregroundColor(location.isOpen ? Theme.gaugeGreen : Theme.gaugeRed)
                }
            }
            
            // Specialties
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(location.specialties, id: \.self) { specialty in
                        Text(specialty)
                            .font(.system(size: 10, weight: .semibold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Theme.primary.opacity(0.1))
                            .foregroundColor(Theme.primary)
                            .cornerRadius(4)
                    }
                }
            }
            
            // Action buttons
            HStack(spacing: 8) {
                Button(action: { callService(location) }) {
                    HStack(spacing: 6) {
                        Image(systemName: "phone.fill")
                        Text("Suna")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Theme.primaryGradient)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                Button(action: { navigateTo(location) }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                        Text("Navigheaza")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Theme.surfaceBackground)
                    .foregroundColor(Theme.textPrimary)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(red: 0.12, green: 0.17, blue: 0.23), lineWidth: 1))
                }
            }
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(location.type.color.opacity(0.3), lineWidth: 1))
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
    }
    
    // MARK: - Service List View
    private var serviceListView: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(locations.sorted(by: { ($0.distance ?? 999) < ($1.distance ?? 999) })) { location in
                        Button(action: {
                            selectedLocation = location
                            region.center = location.coordinate
                            showList = false
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: location.type.icon)
                                    .font(.system(size: 14))
                                    .foregroundColor(location.type.color)
                                    .frame(width: 32, height: 32)
                                    .background(location.type.color.opacity(0.15))
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(location.name)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Theme.textPrimary)
                                    Text(location.address)
                                        .font(.system(size: 11))
                                        .foregroundColor(Theme.textSecondary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 2) {
                                    HStack(spacing: 2) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 9))
                                            .foregroundColor(Theme.gaugeYellow)
                                        Text(location.formattedRating)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Theme.textPrimary)
                                    }
                                    Text(location.formattedDistance)
                                        .font(.system(size: 10))
                                        .foregroundColor(Theme.textMuted)
                                }
                            }
                            .padding(10)
                        }
                        .background(Theme.cardBackground)
                        .cornerRadius(8)
                    }
                }
                .padding(16)
            }
            .background(Theme.background)
            .navigationTitle("Service-uri")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Location Info Bar
    private var locationInfoBar: some View {
        HStack(spacing: 12) {
            if let loc = locationManager.userLocation {
                HStack(spacing: 4) {
                    Circle()
                        .fill(Theme.gaugeGreen)
                        .frame(width: 8, height: 8)
                    Text("GPS Activ")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Theme.gaugeGreen)
                }
                
                Text(String(format: "%.4f, %.4f", loc.latitude, loc.longitude))
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(Theme.textSecondary)
                
                if locationManager.speed > 0.5 {
                    Text(String(format: "%.0f km/h", locationManager.speed * 3.6))
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Theme.primary)
                }
                
                Text(String(format: "±%.0fm", locationManager.accuracy))
                    .font(.system(size: 9))
                    .foregroundColor(Theme.textMuted)
            } else if let error = locationManager.locationError {
                HStack(spacing: 4) {
                    Circle()
                        .fill(Theme.gaugeRed)
                        .frame(width: 8, height: 8)
                    Text(error)
                        .font(.system(size: 10))
                        .foregroundColor(Theme.gaugeRed)
                        .lineLimit(1)
                }
            } else {
                HStack(spacing: 4) {
                    ProgressView()
                        .scaleEffect(0.6)
                    Text("Se cauta locatia...")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.textMuted)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Theme.cardBackground.opacity(0.95))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.3), radius: 4)
        .padding(.horizontal, 12)
    }
    
    // MARK: - Update Distances
    private func updateDistances() {
        guard let userLoc = locationManager.userLocation else { return }
        for i in locations.indices {
            let dist = locationManager.distanceTo(locations[i].coordinate)
            locations[i].distance = dist
        }
    }
    
    // MARK: - Actions
    private func callService(_ location: ServiceLocation) {
        let cleanPhone = location.phone.replacingOccurrences(of: "-", with: "")
        if let url = URL(string: "tel://\(cleanPhone)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func navigateTo(_ location: ServiceLocation) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
        mapItem.name = location.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}
