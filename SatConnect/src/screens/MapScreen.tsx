import React, { useState, useEffect, useRef, useCallback } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Alert,
  Animated,
  Easing,
  Dimensions,
  Platform,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING, GLASS } from '../constants/theme';

const SCREEN_WIDTH = Dimensions.get('window').width;
const MAP_HEIGHT = 380;
const MAP_PADDING = SPACING.lg;

interface LocationEntry {
  id: string;
  latitude: number;
  longitude: number;
  timestamp: string;
  synced: boolean;
  accuracy: number;
}

interface Satellite {
  id: string;
  name: string;
  orbitRadius: number;
  speed: number;
  startAngle: number;
  color: string;
  signalStrength: number;
  altitude: number;
  type: 'LEO' | 'MEO' | 'GEO';
}

interface CoverageZone {
  id: string;
  x: number;
  y: number;
  radius: number;
  strength: 'strong' | 'moderate' | 'weak';
}

const MOCK_LOCATIONS: LocationEntry[] = [
  { id: '1', latitude: 45.5943, longitude: 24.2737, timestamp: '2026-03-17T19:00:00Z', synced: true, accuracy: 5 },
  { id: '2', latitude: 45.5950, longitude: 24.2745, timestamp: '2026-03-17T18:30:00Z', synced: true, accuracy: 8 },
  { id: '3', latitude: 45.5938, longitude: 24.2730, timestamp: '2026-03-17T18:00:00Z', synced: false, accuracy: 15 },
  { id: '4', latitude: 45.5955, longitude: 24.2750, timestamp: '2026-03-17T17:30:00Z', synced: false, accuracy: 12 },
  { id: '5', latitude: 45.5960, longitude: 24.2755, timestamp: '2026-03-17T17:00:00Z', synced: true, accuracy: 4 },
];

const SATELLITES: Satellite[] = [
  { id: 'sat-1', name: 'SAT-01 Iridium', orbitRadius: 42, speed: 8, startAngle: 0, color: COLORS.accent, signalStrength: 92, altitude: 780, type: 'LEO' },
  { id: 'sat-2', name: 'SAT-02 Globalstar', orbitRadius: 38, speed: 12, startAngle: 72, color: '#60A5FA', signalStrength: 78, altitude: 1414, type: 'LEO' },
  { id: 'sat-3', name: 'SAT-03 Starlink', orbitRadius: 35, speed: 6, startAngle: 144, color: '#A78BFA', signalStrength: 95, altitude: 550, type: 'LEO' },
  { id: 'sat-4', name: 'SAT-04 OneWeb', orbitRadius: 45, speed: 15, startAngle: 216, color: '#FBBF24', signalStrength: 65, altitude: 1200, type: 'MEO' },
  { id: 'sat-5', name: 'SAT-05 Telesat', orbitRadius: 48, speed: 20, startAngle: 288, color: '#F87171', signalStrength: 45, altitude: 1000, type: 'LEO' },
];

const COVERAGE_ZONES: CoverageZone[] = [
  { id: 'cz-1', x: 35, y: 30, radius: 22, strength: 'strong' },
  { id: 'cz-2', x: 65, y: 55, radius: 18, strength: 'moderate' },
  { id: 'cz-3', x: 20, y: 70, radius: 15, strength: 'weak' },
  { id: 'cz-4', x: 75, y: 25, radius: 12, strength: 'strong' },
  { id: 'cz-5', x: 50, y: 80, radius: 10, strength: 'moderate' },
];

const STARS = Array.from({ length: 60 }, (_, i) => ({
  id: i,
  x: Math.random() * 100,
  y: Math.random() * 100,
  size: Math.random() * 2 + 0.5,
  opacity: Math.random() * 0.6 + 0.2,
}));

const CONTINENT_POINTS = [
  { x: 48, y: 22, w: 8, h: 12 },
  { x: 45, y: 28, w: 12, h: 8 },
  { x: 50, y: 18, w: 6, h: 10 },
  { x: 47, y: 42, w: 10, h: 18 },
  { x: 44, y: 38, w: 8, h: 8 },
  { x: 60, y: 20, w: 18, h: 16 },
  { x: 65, y: 32, w: 12, h: 10 },
  { x: 72, y: 38, w: 8, h: 8 },
  { x: 18, y: 18, w: 10, h: 14 },
  { x: 20, y: 32, w: 6, h: 8 },
  { x: 22, y: 42, w: 8, h: 18 },
  { x: 78, y: 58, w: 10, h: 8 },
];

// Animated Satellite Component
function AnimatedSatellite({ sat, mapWidth, mapHeight }: { sat: Satellite; mapWidth: number; mapHeight: number }) {
  const animValue = useRef(new Animated.Value(0)).current;
  useEffect(() => {
    const animation = Animated.loop(
      Animated.timing(animValue, { toValue: 1, duration: sat.speed * 1000, easing: Easing.linear, useNativeDriver: true })
    );
    animation.start();
    return () => animation.stop();
  }, [animValue, sat.speed]);
  const centerX = mapWidth / 2;
  const centerY = mapHeight / 2;
  const radiusX = (sat.orbitRadius / 100) * mapWidth * 0.48;
  const radiusY = (sat.orbitRadius / 100) * mapHeight * 0.42;
  const startRad = (sat.startAngle * Math.PI) / 180;
  const translateX = animValue.interpolate({
    inputRange: [0, 0.25, 0.5, 0.75, 1],
    outputRange: [
      centerX + radiusX * Math.cos(startRad) - 8,
      centerX + radiusX * Math.cos(startRad + Math.PI / 2) - 8,
      centerX + radiusX * Math.cos(startRad + Math.PI) - 8,
      centerX + radiusX * Math.cos(startRad + (3 * Math.PI) / 2) - 8,
      centerX + radiusX * Math.cos(startRad + 2 * Math.PI) - 8,
    ],
  });
  const translateY = animValue.interpolate({
    inputRange: [0, 0.25, 0.5, 0.75, 1],
    outputRange: [
      centerY + radiusY * Math.sin(startRad) - 8,
      centerY + radiusY * Math.sin(startRad + Math.PI / 2) - 8,
      centerY + radiusY * Math.sin(startRad + Math.PI) - 8,
      centerY + radiusY * Math.sin(startRad + (3 * Math.PI) / 2) - 8,
      centerY + radiusY * Math.sin(startRad + 2 * Math.PI) - 8,
    ],
  });
  return (
    <Animated.View style={[styles.satellite, { transform: [{ translateX }, { translateY }] }]}>
      <View style={[styles.satDot, { backgroundColor: sat.color, shadowColor: sat.color }]}>
        <View style={[styles.satGlow, { backgroundColor: sat.color + '40' }]} />
      </View>
    </Animated.View>
  );
}

// Orbit Path Component
function OrbitPath({ sat, mapWidth, mapHeight }: { sat: Satellite; mapWidth: number; mapHeight: number }) {
  const centerX = mapWidth / 2;
  const centerY = mapHeight / 2;
  const radiusX = (sat.orbitRadius / 100) * mapWidth * 0.48;
  const radiusY = (sat.orbitRadius / 100) * mapHeight * 0.42;
  return (
    <>
      {Array.from({ length: 48 }, (_, i) => {
        const angle = (i / 48) * 2 * Math.PI;
        return (
          <View key={'orbit-' + sat.id + '-' + i} style={[styles.orbitDot, { left: centerX + radiusX * Math.cos(angle) - 1, top: centerY + radiusY * Math.sin(angle) - 1, backgroundColor: sat.color, opacity: 0.15 + (i / 48) * 0.15 }]} />
        );
      })}
    </>
  );
}

// Pulsing Location Marker
function PulsingMarker({ x, y }: { x: number; y: number }) {
  const pulseAnim = useRef(new Animated.Value(0)).current;
  useEffect(() => {
    const animation = Animated.loop(
      Animated.sequence([
        Animated.timing(pulseAnim, { toValue: 1, duration: 1500, easing: Easing.out(Easing.ease), useNativeDriver: true }),
        Animated.timing(pulseAnim, { toValue: 0, duration: 0, useNativeDriver: true }),
      ])
    );
    animation.start();
    return () => animation.stop();
  }, [pulseAnim]);
  const scale = pulseAnim.interpolate({ inputRange: [0, 1], outputRange: [1, 2.5] });
  const opacity = pulseAnim.interpolate({ inputRange: [0, 1], outputRange: [0.6, 0] });
  return (
    <View style={[styles.pulsingMarkerContainer, { left: `${x}%` as const, top: `${y}%` as const }]}>
      <Animated.View style={[styles.pulseRing, { transform: [{ scale }], opacity }]} />
      <View style={styles.locationDotOuter}><View style={styles.locationDotInner} /></View>
    </View>
  );
}

// Twinkling Star
function TwinklingStar({ star }: { star: (typeof STARS)[0] }) {
  const twinkle = useRef(new Animated.Value(star.opacity)).current;
  useEffect(() => {
    const animation = Animated.loop(
      Animated.sequence([
        Animated.timing(twinkle, { toValue: star.opacity * 0.3, duration: 1500 + Math.random() * 2000, useNativeDriver: true }),
        Animated.timing(twinkle, { toValue: star.opacity, duration: 1500 + Math.random() * 2000, useNativeDriver: true }),
      ])
    );
    animation.start();
    return () => animation.stop();
  }, [twinkle, star.opacity]);
  return (
    <Animated.View style={[styles.star, { left: `${star.x}%` as const, top: `${star.y}%` as const, width: star.size, height: star.size, borderRadius: star.size / 2, opacity: twinkle }]} />
  );
}

// Signal Strength Bar
function SignalBar({ strength }: { strength: number }) {
  const barColor = strength > 75 ? COLORS.success : strength > 50 ? COLORS.warning : COLORS.error;
  return (
    <View style={styles.signalBarWrap}>
      <View style={styles.signalBarBg}>
        <View style={[styles.signalBarFill, { width: `${strength}%` as const, backgroundColor: barColor }]} />
      </View>
      <Text style={[styles.signalBarValue, { color: barColor }]}>{strength}%</Text>
    </View>
  );
}

// Main MapScreen
export function MapScreen() {
  const [tracking, setTracking] = useState(true);
  const [locations] = useState<LocationEntry[]>(MOCK_LOCATIONS);
  const [showSatellites, setShowSatellites] = useState(true);
  const [showCoverage, setShowCoverage] = useState(true);
  const [showHistory, setShowHistory] = useState(true);
  const [selectedSat, setSelectedSat] = useState<Satellite | null>(null);
  const [mapDimensions, setMapDimensions] = useState({ width: SCREEN_WIDTH - MAP_PADDING * 2, height: MAP_HEIGHT });

  const syncedCount = locations.filter((l) => l.synced).length;
  const pendingCount = locations.filter((l) => !l.synced).length;
  const avgSignal = Math.round(SATELLITES.reduce((acc, s) => acc + s.signalStrength, 0) / SATELLITES.length);
  const visibleSats = SATELLITES.filter((s) => s.signalStrength > 30).length;

  const coveragePulse = useRef(new Animated.Value(0.8)).current;
  useEffect(() => {
    const animation = Animated.loop(
      Animated.sequence([
        Animated.timing(coveragePulse, { toValue: 1, duration: 3000, easing: Easing.inOut(Easing.ease), useNativeDriver: true }),
        Animated.timing(coveragePulse, { toValue: 0.8, duration: 3000, easing: Easing.inOut(Easing.ease), useNativeDriver: true }),
      ])
    );
    animation.start();
    return () => animation.stop();
  }, [coveragePulse]);

  const handleShareLocation = useCallback(() => {
    Alert.alert('Locatie partajata', 'Coordonate: ' + locations[0].latitude.toFixed(4) + ' N, ' + locations[0].longitude.toFixed(4) + ' E\n\nLocatia a fost trimisa prin satelit.', [{ text: 'OK' }]);
  }, [locations]);

  const handleToggleTracking = useCallback(() => {
    setTracking((prev) => {
      Alert.alert(prev ? 'Tracking oprit' : 'Tracking pornit', prev ? 'Locatia ta nu va mai fi partajata automat.' : 'Locatia ta va fi partajata automat la fiecare 30 de minute.', [{ text: 'OK' }]);
      return !prev;
    });
  }, []);

  const onMapLayout = useCallback((e: { nativeEvent: { layout: { width: number; height: number } } }) => {
    setMapDimensions({ width: e.nativeEvent.layout.width, height: e.nativeEvent.layout.height });
  }, []);

  const coverageColor = (strength: CoverageZone['strength']) => {
    switch (strength) {
      case 'strong': return COLORS.accent;
      case 'moderate': return COLORS.warning;
      case 'weak': return COLORS.error;
    }
  };

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      {/* Header */}
      <View style={styles.header}>
        <View>
          <Text style={styles.title}>Satellite Tracker</Text>
          <Text style={styles.subtitle}>Monitorizare in timp real</Text>
        </View>
        <View style={[styles.trackingBadge, { backgroundColor: tracking ? COLORS.success + '15' : COLORS.error + '15' }]}>
          <View style={[styles.trackingDot, { backgroundColor: tracking ? COLORS.success : COLORS.error }]} />
          <Text style={[styles.trackingText, { color: tracking ? COLORS.success : COLORS.error }]}>{tracking ? 'LIVE' : 'OFF'}</Text>
        </View>
      </View>

      {/* Signal Overview Cards */}
      <View style={styles.signalCards}>
        <View style={styles.signalCard}>
          <MaterialCommunityIcons name="satellite-variant" size={24} color={COLORS.accent} />
          <Text style={styles.signalCardValue}>{visibleSats}</Text>
          <Text style={styles.signalCardLabel}>Sateliti vizibili</Text>
        </View>
        <View style={styles.signalCard}>
          <MaterialCommunityIcons name="signal-cellular-3" size={24} color={avgSignal > 70 ? COLORS.success : COLORS.warning} />
          <Text style={styles.signalCardValue}>{avgSignal}%</Text>
          <Text style={styles.signalCardLabel}>Semnal mediu</Text>
        </View>
        <View style={styles.signalCard}>
          <MaterialCommunityIcons name="crosshairs-gps" size={24} color={COLORS.info} />
          <Text style={styles.signalCardValue}>{'\u00B1'}{locations[0].accuracy}m</Text>
          <Text style={styles.signalCardLabel}>Precizie GPS</Text>
        </View>
      </View>

      {/* === MAIN MAP === */}
      <View style={styles.mapOuter}>
        <View style={styles.mapContainer} onLayout={onMapLayout}>
          {STARS.map((star) => (<TwinklingStar key={star.id} star={star} />))}
          {[0, 1, 2, 3, 4, 5, 6, 7, 8].map((i) => (<View key={'h-' + i} style={[styles.gridLineH, { top: `${(i + 1) * 10}%` as const }]} />))}
          {[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11].map((i) => (<View key={'v-' + i} style={[styles.gridLineV, { left: `${(i + 1) * 8}%` as const }]} />))}
          {CONTINENT_POINTS.map((cp, i) => (<View key={'cont-' + i} style={[styles.continentBlock, { left: `${cp.x}%` as const, top: `${cp.y}%` as const, width: `${cp.w}%` as const, height: `${cp.h}%` as const }]} />))}
          {showCoverage && COVERAGE_ZONES.map((zone) => (
            <Animated.View key={zone.id} style={[styles.coverageZone, { left: `${zone.x - zone.radius}%` as const, top: `${zone.y - zone.radius}%` as const, width: `${zone.radius * 2}%` as const, height: `${zone.radius * 2}%` as const, borderRadius: 9999, backgroundColor: coverageColor(zone.strength) + '12', borderColor: coverageColor(zone.strength) + '30', transform: [{ scale: coveragePulse }] }]}>
              <View style={[styles.coverageInner, { backgroundColor: coverageColor(zone.strength) + '08', borderColor: coverageColor(zone.strength) + '18' }]} />
            </Animated.View>
          ))}
          {showSatellites && SATELLITES.map((sat) => (<OrbitPath key={'orbit-' + sat.id} sat={sat} mapWidth={mapDimensions.width} mapHeight={mapDimensions.height} />))}
          {showSatellites && SATELLITES.map((sat) => (<AnimatedSatellite key={sat.id} sat={sat} mapWidth={mapDimensions.width} mapHeight={mapDimensions.height} />))}
          {showHistory && locations.slice(1).map((loc, index) => {
            const xPercent = 30 + ((index * 12) % 40);
            const yPercent = 25 + ((index * 15) % 50);
            return (<View key={loc.id} style={[styles.historyPin, { left: `${xPercent}%` as const, top: `${yPercent}%` as const }]}><View style={[styles.historyPinDot, { backgroundColor: loc.synced ? COLORS.success : COLORS.warning }]} /></View>);
          })}
          <PulsingMarker x={35} y={30} />
          <View style={styles.coordLabel}>
            <Text style={styles.coordText}>{locations[0].latitude.toFixed(4)}{'\u00B0'} N, {locations[0].longitude.toFixed(4)}{'\u00B0'} E</Text>
          </View>
          <View style={styles.mapTypeLabel}>
            <MaterialCommunityIcons name="satellite-uplink" size={12} color={COLORS.accent} />
            <Text style={styles.mapTypeText}>SAT VIEW</Text>
          </View>
        </View>
        <View style={styles.mapLegend}>
          <View style={styles.legendItem}><View style={[styles.legendDot, { backgroundColor: COLORS.accent }]} /><Text style={styles.legendText}>Locatie curenta</Text></View>
          <View style={styles.legendItem}><View style={[styles.legendDot, { backgroundColor: COLORS.success }]} /><Text style={styles.legendText}>Sincronizat</Text></View>
          <View style={styles.legendItem}><View style={[styles.legendDot, { backgroundColor: COLORS.warning }]} /><Text style={styles.legendText}>In asteptare</Text></View>
        </View>
      </View>

      {/* Layer Controls */}
      <View style={styles.layerRow}>
        <TouchableOpacity style={[styles.layerBtn, showSatellites && styles.layerBtnActive]} onPress={() => setShowSatellites(!showSatellites)}>
          <MaterialCommunityIcons name="satellite-variant" size={18} color={showSatellites ? COLORS.accent : COLORS.textLight} />
          <Text style={[styles.layerBtnText, showSatellites && styles.layerBtnTextActive]}>Sateliti</Text>
        </TouchableOpacity>
        <TouchableOpacity style={[styles.layerBtn, showCoverage && styles.layerBtnActive]} onPress={() => setShowCoverage(!showCoverage)}>
          <MaterialCommunityIcons name="access-point-network" size={18} color={showCoverage ? COLORS.accent : COLORS.textLight} />
          <Text style={[styles.layerBtnText, showCoverage && styles.layerBtnTextActive]}>Acoperire</Text>
        </TouchableOpacity>
        <TouchableOpacity style={[styles.layerBtn, showHistory && styles.layerBtnActive]} onPress={() => setShowHistory(!showHistory)}>
          <MaterialCommunityIcons name="map-marker-path" size={18} color={showHistory ? COLORS.accent : COLORS.textLight} />
          <Text style={[styles.layerBtnText, showHistory && styles.layerBtnTextActive]}>Istoric</Text>
        </TouchableOpacity>
      </View>

      {/* Actions */}
      <View style={styles.actions}>
        <TouchableOpacity style={styles.primaryBtn} onPress={handleShareLocation} activeOpacity={0.8}>
          <MaterialCommunityIcons name="crosshairs-gps" size={20} color={COLORS.white} />
          <Text style={styles.primaryBtnText}>Partajeaza locatia</Text>
        </TouchableOpacity>
        <TouchableOpacity style={[styles.secondaryBtn, !tracking && styles.secondaryBtnActive]} onPress={handleToggleTracking} activeOpacity={0.8}>
          <MaterialCommunityIcons name={tracking ? 'pause-circle-outline' : 'play-circle-outline'} size={20} color={tracking ? COLORS.error : COLORS.accent} />
          <Text style={[styles.secondaryBtnText, { color: tracking ? COLORS.error : COLORS.accent }]}>{tracking ? 'Opreste tracking' : 'Porneste tracking'}</Text>
        </TouchableOpacity>
      </View>

      {/* Satellite Signal Details */}
      <Text style={styles.sectionTitle}>Sateliti activi</Text>
      <View style={styles.satList}>
        {SATELLITES.map((sat) => (
          <TouchableOpacity key={sat.id} style={[styles.satItem, selectedSat?.id === sat.id && styles.satItemSelected]} onPress={() => setSelectedSat(selectedSat?.id === sat.id ? null : sat)} activeOpacity={0.7}>
            <View style={styles.satItemLeft}>
              <View style={[styles.satIndicator, { backgroundColor: sat.color }]} />
              <View>
                <Text style={styles.satName}>{sat.name}</Text>
                <Text style={styles.satMeta}>{sat.type} {'\u2022'} {sat.altitude} km</Text>
              </View>
            </View>
            <SignalBar strength={sat.signalStrength} />
          </TouchableOpacity>
        ))}
      </View>

      {/* Stats */}
      <View style={styles.statsRow}>
        <View style={styles.stat}>
          <Text style={styles.statValue}>{locations.length}</Text>
          <Text style={styles.statLabel}>Total puncte</Text>
        </View>
        <View style={styles.stat}>
          <Text style={[styles.statValue, { color: COLORS.success }]}>{syncedCount}</Text>
          <Text style={styles.statLabel}>Sincronizate</Text>
        </View>
        <View style={styles.stat}>
          <Text style={[styles.statValue, { color: COLORS.warning }]}>{pendingCount}</Text>
          <Text style={styles.statLabel}>In asteptare</Text>
        </View>
      </View>

      {/* Location History */}
      <Text style={styles.sectionTitle}>Istoric locatii</Text>
      {locations.map((loc) => (
        <View key={loc.id} style={styles.locationItem}>
          <View style={styles.locationIcon}>
            <MaterialCommunityIcons name={loc.synced ? 'check-circle' : 'clock-outline'} size={20} color={loc.synced ? COLORS.success : COLORS.warning} />
          </View>
          <View style={styles.locationInfo}>
            <Text style={styles.locationCoords}>{loc.latitude.toFixed(4)}{'\u00B0'} N, {loc.longitude.toFixed(4)}{'\u00B0'} E</Text>
            <Text style={styles.locationTime}>{new Date(loc.timestamp).toLocaleTimeString('ro-RO', { hour: '2-digit', minute: '2-digit' })}{' \u2022 \u00B1'}{loc.accuracy}m</Text>
          </View>
          <View style={[styles.syncBadge, { backgroundColor: loc.synced ? COLORS.success + '15' : COLORS.warning + '15' }]}>
            <Text style={[styles.syncText, { color: loc.synced ? COLORS.success : COLORS.warning }]}>{loc.synced ? 'Sincronizat' : 'In coada'}</Text>
          </View>
        </View>
      ))}
      <View style={{ height: 40 }} />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: COLORS.surface },
  content: { paddingHorizontal: SPACING.lg, paddingTop: 60, paddingBottom: SPACING.xxxl + 40 },
  header: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: SPACING.lg },
  title: { fontSize: FONTS.sizes.xxl, fontWeight: '800', color: COLORS.text },
  subtitle: { fontSize: FONTS.sizes.sm, color: COLORS.textSecondary, marginTop: 2 },
  trackingBadge: { flexDirection: 'row', alignItems: 'center', gap: 6, paddingHorizontal: SPACING.md, paddingVertical: SPACING.xs, borderRadius: RADIUS.full },
  trackingDot: { width: 8, height: 8, borderRadius: 4 },
  trackingText: { fontSize: FONTS.sizes.xs, fontWeight: '800', letterSpacing: 1 },
  signalCards: { flexDirection: 'row', gap: SPACING.sm, marginBottom: SPACING.lg },
  signalCard: { flex: 1, ...GLASS.card, borderRadius: RADIUS.lg, padding: SPACING.md, alignItems: 'center', gap: 4 },
  signalCardValue: { fontSize: FONTS.sizes.xl, fontWeight: '800', color: COLORS.text },
  signalCardLabel: { fontSize: 10, color: COLORS.textSecondary, textAlign: 'center' },
  mapOuter: { ...GLASS.card, borderRadius: RADIUS.xl, marginBottom: SPACING.lg, overflow: 'hidden' },
  mapContainer: { height: MAP_HEIGHT, backgroundColor: '#060E1A', position: 'relative', overflow: 'hidden' },
  star: { position: 'absolute', backgroundColor: '#FFFFFF' },
  gridLineH: { position: 'absolute', left: 0, right: 0, height: StyleSheet.hairlineWidth, backgroundColor: COLORS.accent, opacity: 0.08 },
  gridLineV: { position: 'absolute', top: 0, bottom: 0, width: StyleSheet.hairlineWidth, backgroundColor: COLORS.accent, opacity: 0.08 },
  continentBlock: { position: 'absolute', backgroundColor: 'rgba(0,212,170,0.04)', borderRadius: 4, borderWidth: StyleSheet.hairlineWidth, borderColor: 'rgba(0,212,170,0.08)' },
  coverageZone: { position: 'absolute', borderWidth: 1, alignItems: 'center', justifyContent: 'center' },
  coverageInner: { width: '60%', height: '60%', borderRadius: 9999, borderWidth: 1 },
  satellite: { position: 'absolute', width: 16, height: 16, zIndex: 10 },
  satDot: { width: 8, height: 8, borderRadius: 4, alignSelf: 'center', marginTop: 4, shadowOffset: { width: 0, height: 0 }, shadowOpacity: 0.8, shadowRadius: 6, elevation: 4 },
  satGlow: { position: 'absolute', width: 16, height: 16, borderRadius: 8, top: -4, left: -4 },
  orbitDot: { position: 'absolute', width: 2, height: 2, borderRadius: 1 },
  historyPin: { position: 'absolute', width: 16, height: 16, alignItems: 'center', justifyContent: 'center', zIndex: 5 },
  historyPinDot: { width: 6, height: 6, borderRadius: 3, borderWidth: 1.5, borderColor: 'rgba(255,255,255,0.3)' },
  pulsingMarkerContainer: { position: 'absolute', width: 40, height: 40, marginLeft: -20, marginTop: -20, alignItems: 'center', justifyContent: 'center', zIndex: 15 },
  pulseRing: { position: 'absolute', width: 40, height: 40, borderRadius: 20, borderWidth: 2, borderColor: COLORS.accent, backgroundColor: 'transparent' },
  locationDotOuter: { width: 16, height: 16, borderRadius: 8, backgroundColor: COLORS.accent + '40', alignItems: 'center', justifyContent: 'center', borderWidth: 2, borderColor: COLORS.accent },
  locationDotInner: { width: 6, height: 6, borderRadius: 3, backgroundColor: COLORS.accent },
  coordLabel: { position: 'absolute', bottom: SPACING.sm, left: SPACING.sm, backgroundColor: 'rgba(10,22,40,0.90)', paddingHorizontal: SPACING.sm, paddingVertical: 4, borderRadius: RADIUS.sm, borderWidth: 1, borderColor: COLORS.accent + '30' },
  coordText: { fontSize: 10, fontWeight: '700', color: COLORS.accent, fontFamily: Platform.OS === 'ios' ? 'Menlo' : 'monospace' },
  mapTypeLabel: { position: 'absolute', top: SPACING.sm, right: SPACING.sm, backgroundColor: 'rgba(10,22,40,0.90)', paddingHorizontal: SPACING.sm, paddingVertical: 4, borderRadius: RADIUS.sm, borderWidth: 1, borderColor: COLORS.accent + '30', flexDirection: 'row', alignItems: 'center', gap: 4 },
  mapTypeText: { fontSize: 9, fontWeight: '800', color: COLORS.accent, letterSpacing: 1 },
  mapLegend: { flexDirection: 'row', justifyContent: 'center', gap: SPACING.lg, padding: SPACING.sm, borderTopWidth: 1, borderTopColor: 'rgba(255,255,255,0.08)' },
  legendItem: { flexDirection: 'row', alignItems: 'center', gap: 4 },
  legendDot: { width: 8, height: 8, borderRadius: 4 },
  legendText: { fontSize: FONTS.sizes.xs, color: COLORS.textSecondary },
  layerRow: { flexDirection: 'row', gap: SPACING.sm, marginBottom: SPACING.lg },
  layerBtn: { flex: 1, ...GLASS.panel, borderRadius: RADIUS.lg, paddingVertical: SPACING.sm, alignItems: 'center', gap: 4 },
  layerBtnActive: { backgroundColor: COLORS.accent + '15', borderColor: COLORS.accent + '40' },
  layerBtnText: { fontSize: FONTS.sizes.xs, fontWeight: '600', color: COLORS.textLight },
  layerBtnTextActive: { color: COLORS.accent },
  actions: { gap: SPACING.sm, marginBottom: SPACING.xl },
  primaryBtn: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: SPACING.sm, backgroundColor: COLORS.accent, borderRadius: RADIUS.lg, paddingVertical: SPACING.md + 2 },
  primaryBtnText: { fontSize: FONTS.sizes.md, fontWeight: '700', color: COLORS.white },
  secondaryBtn: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: SPACING.sm, ...GLASS.panel, borderRadius: RADIUS.lg, paddingVertical: SPACING.md },
  secondaryBtnActive: { backgroundColor: COLORS.accent + '10', borderColor: COLORS.accent + '30' },
  secondaryBtnText: { fontSize: FONTS.sizes.md, fontWeight: '600' },
  sectionTitle: { fontSize: FONTS.sizes.lg, fontWeight: '700', color: COLORS.text, marginBottom: SPACING.md },
  satList: { gap: SPACING.sm, marginBottom: SPACING.xl },
  satItem: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', ...GLASS.panel, borderRadius: RADIUS.md, padding: SPACING.md },
  satItemSelected: { ...GLASS.cardActive },
  satItemLeft: { flexDirection: 'row', alignItems: 'center', gap: SPACING.sm, flex: 1 },
  satIndicator: { width: 10, height: 10, borderRadius: 5 },
  satName: { fontSize: FONTS.sizes.sm, fontWeight: '600', color: COLORS.text },
  satMeta: { fontSize: 10, color: COLORS.textSecondary, marginTop: 1 },
  signalBarWrap: { flexDirection: 'row', alignItems: 'center', gap: SPACING.xs, width: 100 },
  signalBarBg: { flex: 1, height: 4, backgroundColor: 'rgba(255,255,255,0.06)', borderRadius: 2, overflow: 'hidden' },
  signalBarFill: { height: '100%', borderRadius: 2 },
  signalBarValue: { fontSize: 10, fontWeight: '700', minWidth: 28, textAlign: 'right' },
  statsRow: { flexDirection: 'row', justifyContent: 'space-around', ...GLASS.panel, borderRadius: RADIUS.lg, padding: SPACING.lg, marginBottom: SPACING.xl },
  stat: { alignItems: 'center' },
  statValue: { fontSize: FONTS.sizes.xxl, fontWeight: '800', color: COLORS.text },
  statLabel: { fontSize: FONTS.sizes.xs, color: COLORS.textSecondary, marginTop: 2 },
  locationItem: { flexDirection: 'row', alignItems: 'center', ...GLASS.panel, borderRadius: RADIUS.md, padding: SPACING.md, marginBottom: SPACING.sm, gap: SPACING.md },
  locationIcon: { width: 32, height: 32, alignItems: 'center', justifyContent: 'center' },
  locationInfo: { flex: 1 },
  locationCoords: { fontSize: FONTS.sizes.sm, fontWeight: '600', color: COLORS.text },
  locationTime: { fontSize: FONTS.sizes.xs, color: COLORS.textSecondary, marginTop: 2 },
  syncBadge: { paddingHorizontal: SPACING.sm, paddingVertical: SPACING.xs, borderRadius: RADIUS.full },
  syncText: { fontSize: FONTS.sizes.xs, fontWeight: '600' },
});
