import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING, GLASS } from '../constants/theme';

interface Props {
  icon: string;
  title: string;
  value: string;
  maxValue?: string;
  progress?: number;
  color: string;
}

export function UsageCard({ icon, title, value, maxValue, progress, color }: Props) {
  return (
    <View style={styles.card}>
      <View style={styles.header}>
        <View style={[styles.iconCircle, { backgroundColor: color + '15' }]}>
          <MaterialCommunityIcons name={icon as keyof typeof MaterialCommunityIcons.glyphMap} size={18} color={color} />
        </View>
        <Text style={styles.title}>{title}</Text>
      </View>
      <Text style={[styles.value, { color }]}>{value}</Text>
      {maxValue && <Text style={styles.maxValue}>din {maxValue}</Text>}
      {progress !== undefined && (
        <View style={styles.progressBg}>
          <View style={[styles.progressFill, { width: `${Math.min(progress * 100, 100)}%`, backgroundColor: color }]} />
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  card: { ...GLASS.panel, borderRadius: RADIUS.lg, padding: SPACING.md },
  header: { flexDirection: 'row', alignItems: 'center', gap: 8, marginBottom: SPACING.sm },
  iconCircle: { width: 32, height: 32, borderRadius: RADIUS.sm, alignItems: 'center', justifyContent: 'center' },
  title: { fontSize: FONTS.sizes.xs, color: COLORS.textSecondary, fontWeight: '600' },
  value: { fontSize: FONTS.sizes.xxl, fontWeight: '800', letterSpacing: -0.5 },
  maxValue: { fontSize: FONTS.sizes.xs, color: COLORS.textLight, marginTop: 2 },
  progressBg: { height: 3, backgroundColor: 'rgba(255,255,255,0.06)', borderRadius: 2, marginTop: SPACING.sm, overflow: 'hidden' },
  progressFill: { height: 3, borderRadius: 2 },
});
