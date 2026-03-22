import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING, GLASS } from '../constants/theme';

interface Props {
  name: string;
  price: string;
  period: string;
  features: string[];
  popular?: boolean;
  current?: boolean;
  onPress?: () => void;
}

export function PlanCard({ name, price, period, features, popular, current, onPress }: Props) {
  return (
    <TouchableOpacity
      style={[styles.card, popular && styles.cardPopular, current && styles.cardCurrent]}
      onPress={onPress}
      activeOpacity={0.7}
    >
      {popular && (
        <View style={styles.popularBadge}>
          <Text style={styles.popularText}>POPULAR</Text>
        </View>
      )}
      {current && (
        <View style={styles.currentBadge}>
          <Text style={styles.currentText}>ACTUAL</Text>
        </View>
      )}
      <Text style={styles.name}>{name}</Text>
      <View style={styles.priceRow}>
        <Text style={[styles.price, popular && { color: COLORS.accent }]}>{price}</Text>
        <Text style={styles.period}>{period}</Text>
      </View>
      <View style={styles.features}>
        {features.map((f, i) => (
          <View key={i} style={styles.featureRow}>
            <MaterialCommunityIcons name="check-circle" size={14} color={popular ? COLORS.accent : COLORS.success} />
            <Text style={styles.featureText}>{f}</Text>
          </View>
        ))}
      </View>
      {!current && (
        <View style={[styles.selectBtn, popular && styles.selectBtnPopular]}>
          <Text style={[styles.selectBtnText, popular && { color: COLORS.primary }]}>
            {popular ? 'Upgrade Acum' : 'Selecteaza'}
          </Text>
        </View>
      )}
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  card: { ...GLASS.card, borderRadius: RADIUS.xl, padding: SPACING.lg, position: 'relative' as const },
  cardPopular: { ...GLASS.cardActive, borderColor: COLORS.accent + '40' },
  cardCurrent: { borderColor: COLORS.success + '30' },
  popularBadge: { position: 'absolute' as const, top: SPACING.md, right: SPACING.md, backgroundColor: 'rgba(0,212,170,0.15)', paddingHorizontal: SPACING.sm, paddingVertical: 2, borderRadius: RADIUS.full, borderWidth: 1, borderColor: 'rgba(0,212,170,0.3)' },
  popularText: { fontSize: 9, fontWeight: '800', color: COLORS.accent, letterSpacing: 1 },
  currentBadge: { position: 'absolute' as const, top: SPACING.md, right: SPACING.md, backgroundColor: 'rgba(52,211,153,0.15)', paddingHorizontal: SPACING.sm, paddingVertical: 2, borderRadius: RADIUS.full, borderWidth: 1, borderColor: 'rgba(52,211,153,0.3)' },
  currentText: { fontSize: 9, fontWeight: '800', color: COLORS.success, letterSpacing: 1 },
  name: { fontSize: FONTS.sizes.lg, fontWeight: '700', color: COLORS.text },
  priceRow: { flexDirection: 'row', alignItems: 'baseline', gap: 2, marginTop: 4, marginBottom: SPACING.md },
  price: { fontSize: FONTS.sizes.xxl, fontWeight: '800', color: COLORS.text },
  period: { fontSize: FONTS.sizes.sm, color: COLORS.textSecondary },
  features: { gap: 8, marginBottom: SPACING.lg },
  featureRow: { flexDirection: 'row', alignItems: 'center', gap: 6 },
  featureText: { fontSize: FONTS.sizes.sm, color: COLORS.textSecondary },
  selectBtn: { ...GLASS.panel, borderRadius: RADIUS.lg, paddingVertical: SPACING.md, alignItems: 'center' },
  selectBtnPopular: { backgroundColor: COLORS.accent },
  selectBtnText: { fontSize: FONTS.sizes.md, fontWeight: '700', color: COLORS.textSecondary },
});
