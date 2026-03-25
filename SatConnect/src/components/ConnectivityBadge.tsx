import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING, GLASS } from '../constants/theme';
import { ConnectionType } from '../types';

const CONNECTION_ICONS: Record<ConnectionType, string> = {
  satellite: 'satellite-variant',
  wifi: 'wifi',
  cellular: 'signal-cellular-3',
  roaming: 'airplane',
  esim: 'sim-outline',
  bluetooth: 'bluetooth',
  none: 'wifi-off',
};

const CONNECTION_COLORS: Record<ConnectionType, string> = {
  satellite: COLORS.satellite,
  wifi: COLORS.success,
  cellular: COLORS.info,
  roaming: COLORS.warning,
  esim: COLORS.accent,
  bluetooth: COLORS.info,
  none: COLORS.error,
};

interface Props {
  connectionType: ConnectionType;
  signalStrength: number;
  pendingSync: number;
  isSyncing: boolean;
}

export function ConnectivityBadge({ connectionType, signalStrength, pendingSync, isSyncing }: Props) {
  const icon = CONNECTION_ICONS[connectionType];
  const color = CONNECTION_COLORS[connectionType];

  return (
    <View style={styles.badge}>
      <MaterialCommunityIcons name={icon as keyof typeof MaterialCommunityIcons.glyphMap} size={16} color={color} />
      <Text style={[styles.signal, { color }]}>{signalStrength}%</Text>
      {isSyncing && (
        <View style={styles.syncDot}>
          <MaterialCommunityIcons name="sync" size={10} color={COLORS.warning} />
        </View>
      )}
      {pendingSync > 0 && !isSyncing && (
        <View style={styles.pendingDot}>
          <Text style={styles.pendingText}>{pendingSync}</Text>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  badge: { ...GLASS.panel, borderRadius: RADIUS.full, flexDirection: 'row', alignItems: 'center', paddingHorizontal: SPACING.sm, paddingVertical: 6, gap: 4 },
  signal: { fontSize: FONTS.sizes.xs, fontWeight: '700' },
  syncDot: { marginLeft: 2 },
  pendingDot: { backgroundColor: COLORS.warning, borderRadius: 8, width: 16, height: 16, alignItems: 'center', justifyContent: 'center', marginLeft: 2 },
  pendingText: { fontSize: 8, fontWeight: '800', color: COLORS.primary },
});
