import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Alert,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING, GLASS } from '../constants/theme';
import { Button } from '../components/Button';

interface LocationEntry {
  id: string;
  latitude: number;
  longitude: number;
  timestamp: string;
  synced: boolean;
  accuracy: number;
}

const MOCK_LOCATIONS: LocationEntry[] = [
  { id: '1', latitude: 45.5943, longitude: 24.2737, timestamp: '2026-03-17T19:00:00Z', synced: true, accuracy: 5 },
  { id: '2', latitude: 45.5950, longitude: 24.2745, timestamp: '2026-03-17T18:30:00Z', synced: true, accuracy: 8 },
  { id: '3', latitude: 45.5938, longitude: 24.2730, timestamp: '2026-03-17T18:00:00Z', synced: false, accuracy: 15 },
  { id: '4', latitude: 45.5955, longitude: 24.2750, timestamp: '2026-03-17T17:30:00Z', synced: false, accuracy: 12 },
  { id: '5', latitude: 45.5960, longitude: 24.2755, timestamp: '2026-03-17T17:00:00Z', synced: true, accuracy: 4 },
];

export function MapScreen() {
  const [tracking, setTracking] = useState(true);
  const [locations] = useState<LocationEntry[]>(MOCK_LOCATIONS);

  const syncedCount = locations.filter((l) => l.synced).length;
  const pendingCount = locations.filter((l) => !l.synced).length;

  const handleShareLocation = () => {
    Alert.alert(
      'Locație partajată',
      `Coordonate: ${locations[0].latitude.toFixed(4)}° N, ${locations[0].longitude.toFixed(4)}° E\n\nLocația a fost adăugată în coada de sincronizare.`,
      [{ text: 'OK' }]
    );
  };

  const handleToggleTracking = () => {
    setTracking(!tracking);
    Alert.alert(
      tracking ? 'Tracking oprit' : 'Tracking pornit',
      tracking
        ? 'Locația ta nu va mai fi partajată automat.'
        : 'Locația ta va fi partajată automat la fiecare 30 de minute.',
      [{ text: 'OK' }]
    );
  };

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      <View style={styles.header}>
        <Text style={styles.title}>Locație & GPS</Text>
        <View style={[styles.trackingBadge, { backgroundColor: tracking ? COLORS.success + '15' : COLORS.error + '15' }]}>
          <View style={[styles.trackingDot, { backgroundColor: tracking ? COLORS.success : COLORS.error }]} />
          <Text style={[styles.trackingText, { color: tracking ? COLORS.success : COLORS.error }]}>
            {tracking ? 'Tracking activ' : 'Tracking oprit'}
          </Text>
        </View>
      </View>

      {/* GPS Map with location pins */}
      <View style={styles.mapContainer}>
        <View style={styles.mapGrid}>
          {/* Grid lines */}
          {[0, 1, 2, 3, 4].map((i) => (
            <View key={`h-${i}`} style={[styles.gridLineH, { top: `${i * 25}%` }]} />
          ))}
          {[0, 1, 2, 3, 4].map((i) => (
            <View key={`v-${i}`} style={[styles.gridLineV, { left: `${i * 25}%` }]} />
          ))}
          {/* Location pins */}
          {locations.map((loc, index) => {
            const xPercent = 20 + (index * 15) % 60;
            const yPercent = 15 + (index * 18) % 65;
            return (
              <View
                key={loc.id}
                style={[
                  styles.mapPin,
                  {
                    left: `${xPercent}%`,
                    top: `${yPercent}%`,
                    backgroundColor: loc.synced ? COLORS.success : COLORS.warning,
                  },
                ]}
              >
                <MaterialCommunityIcons
                  name="map-marker"
                  size={index === 0 ? 28 : 20}
                  color={index === 0 ? COLORS.primary : loc.synced ? COLORS.success : COLORS.warning}
                />
                {index === 0 && (
                  <View style={styles.currentLocationPulse} />
                )}
              </View>
            );
          })}
          {/* Current location label */}
          <View style={styles.mapLabelContainer}>
            <Text style={styles.mapLabel}>
              {locations[0].latitude.toFixed(4)}° N, {locations[0].longitude.toFixed(4)}° E
            </Text>
            <Text style={styles.mapLabelSub}>±{locations[0].accuracy}m precizie</Text>
          </View>
        </View>
        <View style={styles.mapLegend}>
          <View style={styles.legendItem}>
            <View style={[styles.legendDot, { backgroundColor: COLORS.primary }]} />
            <Text style={styles.legendText}>Locație curentă</Text>
          </View>
          <View style={styles.legendItem}>
            <View style={[styles.legendDot, { backgroundColor: COLORS.success }]} />
            <Text style={styles.legendText}>Sincronizat</Text>
          </View>
          <View style={styles.legendItem}>
            <View style={[styles.legendDot, { backgroundColor: COLORS.warning }]} />
            <Text style={styles.legendText}>În așteptare</Text>
          </View>
        </View>
      </View>

      {/* Actions */}
      <View style={styles.actions}>
        <Button
          title="Partajează locația"
          onPress={handleShareLocation}
          variant="primary"
          size="lg"
          icon={<MaterialCommunityIcons name="crosshairs-gps" size={20} color={COLORS.white} />}
          style={styles.actionButton}
        />
        <Button
          title={tracking ? 'Oprește tracking' : 'Pornește tracking'}
          onPress={handleToggleTracking}
          variant={tracking ? 'danger' : 'secondary'}
          size="md"
          icon={
            <MaterialCommunityIcons
              name={tracking ? 'pause-circle' : 'play-circle'}
              size={20}
              color={tracking ? COLORS.white : COLORS.primary}
            />
          }
          style={styles.actionButton}
        />
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
          <Text style={styles.statLabel}>În așteptare</Text>
        </View>
      </View>

      {/* Location History */}
      <Text style={styles.sectionTitle}>Istoric locații</Text>
      {locations.map((loc) => (
        <View key={loc.id} style={styles.locationItem}>
          <View style={styles.locationIcon}>
            <MaterialCommunityIcons
              name={loc.synced ? 'check-circle' : 'clock-outline'}
              size={20}
              color={loc.synced ? COLORS.success : COLORS.warning}
            />
          </View>
          <View style={styles.locationInfo}>
            <Text style={styles.locationCoords}>
              {loc.latitude.toFixed(4)}° N, {loc.longitude.toFixed(4)}° E
            </Text>
            <Text style={styles.locationTime}>
              {new Date(loc.timestamp).toLocaleTimeString('ro-RO', {
                hour: '2-digit',
                minute: '2-digit',
              })}
              {' • '}±{loc.accuracy}m
            </Text>
          </View>
          <View style={[styles.syncBadge, {
            backgroundColor: loc.synced ? COLORS.success + '15' : COLORS.warning + '15',
          }]}>
            <Text style={[styles.syncText, {
              color: loc.synced ? COLORS.success : COLORS.warning,
            }]}>
              {loc.synced ? 'Sincronizat' : 'În coadă'}
            </Text>
          </View>
        </View>
      ))}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.surface,
  },
  content: {
    paddingHorizontal: SPACING.lg,
    paddingTop: 60,
    paddingBottom: SPACING.xxxl,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: SPACING.xl,
  },
  title: {
    fontSize: FONTS.sizes.xxl,
    fontWeight: '800',
    color: COLORS.text,
  },
  trackingBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    paddingHorizontal: SPACING.md,
    paddingVertical: SPACING.xs,
    borderRadius: RADIUS.full,
  },
  trackingDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
  },
  trackingText: {
    fontSize: FONTS.sizes.xs,
    fontWeight: '600',
  },
  mapContainer: {
    ...GLASS.card,
    borderRadius: RADIUS.xl,
    marginBottom: SPACING.xl,
    overflow: 'hidden',
  },
  mapGrid: {
    height: 280,
    backgroundColor: 'rgba(0,212,170,0.06)',
    position: 'relative',
  },
  gridLineH: {
    position: 'absolute',
    left: 0,
    right: 0,
    height: 1,
    backgroundColor: COLORS.border,
    opacity: 0.4,
  },
  gridLineV: {
    position: 'absolute',
    top: 0,
    bottom: 0,
    width: 1,
    backgroundColor: COLORS.border,
    opacity: 0.4,
  },
  mapPin: {
    position: 'absolute',
    width: 28,
    height: 28,
    borderRadius: 14,
    backgroundColor: 'transparent',
    alignItems: 'center',
    justifyContent: 'center',
  },
  currentLocationPulse: {
    position: 'absolute',
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: COLORS.primary + '20',
    borderWidth: 2,
    borderColor: COLORS.primary + '40',
  },
  mapLabelContainer: {
    position: 'absolute',
    bottom: SPACING.sm,
    left: SPACING.sm,
    backgroundColor: 'rgba(10,22,40,0.85)',
    paddingHorizontal: SPACING.sm,
    paddingVertical: SPACING.xs,
    borderRadius: RADIUS.sm,
  },
  mapLabel: {
    fontSize: FONTS.sizes.xs,
    fontWeight: '700',
    color: COLORS.text,
  },
  mapLabelSub: {
    fontSize: 10,
    color: COLORS.textSecondary,
  },
  mapLegend: {
    flexDirection: 'row',
    justifyContent: 'center',
    gap: SPACING.lg,
    padding: SPACING.sm,
    borderTopWidth: 1,
    borderTopColor: 'rgba(255,255,255,0.08)',
  },
  legendItem: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  legendDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
  },
  legendText: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.textSecondary,
  },
  actions: {
    gap: SPACING.md,
    marginBottom: SPACING.xl,
  },
  actionButton: {
    width: '100%',
  },
  statsRow: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    ...GLASS.panel,
    borderRadius: RADIUS.lg,
    padding: SPACING.lg,
    marginBottom: SPACING.xl,
  },
  stat: {
    alignItems: 'center',
  },
  statValue: {
    fontSize: FONTS.sizes.xxl,
    fontWeight: '800',
    color: COLORS.text,
  },
  statLabel: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.textSecondary,
    marginTop: 2,
  },
  sectionTitle: {
    fontSize: FONTS.sizes.lg,
    fontWeight: '700',
    color: COLORS.text,
    marginBottom: SPACING.md,
  },
  locationItem: {
    flexDirection: 'row',
    alignItems: 'center',
    ...GLASS.panel,
    borderRadius: RADIUS.md,
    padding: SPACING.md,
    marginBottom: SPACING.sm,
    gap: SPACING.md,
  },
  locationIcon: {
    width: 32,
    height: 32,
    alignItems: 'center',
    justifyContent: 'center',
  },
  locationInfo: {
    flex: 1,
  },
  locationCoords: {
    fontSize: FONTS.sizes.sm,
    fontWeight: '600',
    color: COLORS.text,
  },
  locationTime: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.textSecondary,
    marginTop: 2,
  },
  syncBadge: {
    paddingHorizontal: SPACING.sm,
    paddingVertical: SPACING.xs,
    borderRadius: RADIUS.full,
  },
  syncText: {
    fontSize: FONTS.sizes.xs,
    fontWeight: '600',
  },
});
