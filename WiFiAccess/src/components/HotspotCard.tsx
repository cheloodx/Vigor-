import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SHADOWS, SPACING } from '../constants/theme';
import { Hotspot } from '../types';

interface HotspotCardProps {
  hotspot: Hotspot;
  onPress: (hotspot: Hotspot) => void;
}

const signalConfig = {
  strong: { color: COLORS.success, icon: 'wifi' as const, label: 'Puternic' },
  medium: { color: COLORS.warning, icon: 'wifi' as const, label: 'Mediu' },
  weak: { color: COLORS.error, icon: 'wifi' as const, label: 'Slab' },
};

export function HotspotCard({ hotspot, onPress }: HotspotCardProps) {
  const signal = signalConfig[hotspot.signal];

  return (
    <TouchableOpacity
      style={styles.container}
      onPress={() => onPress(hotspot)}
      activeOpacity={0.7}
    >
      <View style={styles.left}>
        <View
          style={[
            styles.signalIcon,
            { backgroundColor: signal.color + '20' },
          ]}
        >
          <Ionicons name={signal.icon} size={20} color={signal.color} />
        </View>
        <View style={styles.info}>
          <Text style={styles.name} numberOfLines={1}>
            {hotspot.name}
          </Text>
          <View style={styles.meta}>
            <Text style={[styles.signal, { color: signal.color }]}>
              {signal.label}
            </Text>
            <View style={styles.dot} />
            <Text style={styles.type}>
              {hotspot.type === 'premium' ? 'Premium' : 'Basic'}
            </Text>
          </View>
        </View>
      </View>
      <Ionicons
        name="chevron-forward"
        size={20}
        color={COLORS.gray[400]}
      />
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    backgroundColor: COLORS.white,
    borderRadius: RADIUS.md,
    padding: SPACING.md,
    marginBottom: SPACING.sm,
    borderWidth: 1,
    borderColor: COLORS.border,
    ...SHADOWS.sm,
  },
  left: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  signalIcon: {
    width: 40,
    height: 40,
    borderRadius: RADIUS.sm,
    alignItems: 'center',
    justifyContent: 'center',
  },
  info: {
    marginLeft: SPACING.md,
    flex: 1,
  },
  name: {
    fontSize: FONTS.sizes.sm,
    fontWeight: '600',
    color: COLORS.text,
  },
  meta: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 2,
  },
  signal: {
    fontSize: FONTS.sizes.xs,
    fontWeight: '500',
  },
  dot: {
    width: 3,
    height: 3,
    borderRadius: 2,
    backgroundColor: COLORS.gray[300],
    marginHorizontal: 6,
  },
  type: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.textSecondary,
  },
});
