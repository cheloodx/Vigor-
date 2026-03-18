import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING } from '../constants/theme';
import { ConnectionType } from '../types';

interface ConnectivityBadgeProps {
  connectionType: ConnectionType;
  signalStrength: number;
  pendingSync: number;
  isSyncing: boolean;
}

const CONNECTION_ICONS: Record<ConnectionType, string> = {
  wifi: 'wifi',
  cellular: 'signal-cellular-3',
  roaming: 'earth',
  satellite: 'satellite-variant',
  esim: 'sim-outline',
  bluetooth: 'bluetooth',
  none: 'wifi-off',
};

const CONNECTION_COLORS: Record<ConnectionType, string> = {
  wifi: COLORS.success,
  cellular: COLORS.info,
  roaming: '#F59E0B',
  satellite: COLORS.satellite,
  esim: COLORS.accent,
  bluetooth: COLORS.info,
  none: COLORS.error,
};

export function ConnectivityBadge({
  connectionType,
  signalStrength,
  pendingSync,
  isSyncing,
}: ConnectivityBadgeProps) {
  const color = CONNECTION_COLORS[connectionType];
  const icon = CONNECTION_ICONS[connectionType];

  return (
    <View style={[styles.container, { borderColor: color }]}>
      <MaterialCommunityIcons
        name={icon as keyof typeof MaterialCommunityIcons.glyphMap}
        size={16}
        color={color}
      />
      <View style={[styles.signalDot, { backgroundColor: color }]} />
      {signalStrength > 0 && (
        <Text style={[styles.signal, { color }]}>{signalStrength}%</Text>
      )}
      {pendingSync > 0 && (
        <View style={styles.syncBadge}>
          <Text style={styles.syncText}>
            {isSyncing ? '...' : pendingSync}
          </Text>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: COLORS.white,
    paddingHorizontal: SPACING.sm,
    paddingVertical: SPACING.xs,
    borderRadius: RADIUS.full,
    borderWidth: 1,
    gap: 4,
  },
  signalDot: {
    width: 6,
    height: 6,
    borderRadius: 3,
  },
  signal: {
    fontSize: FONTS.sizes.xs,
    fontWeight: '600',
  },
  syncBadge: {
    backgroundColor: COLORS.warning,
    borderRadius: RADIUS.full,
    minWidth: 16,
    height: 16,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 3,
  },
  syncText: {
    color: COLORS.white,
    fontSize: 9,
    fontWeight: '700',
  },
});
