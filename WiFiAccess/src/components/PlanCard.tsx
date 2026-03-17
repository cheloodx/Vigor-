import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SHADOWS, SPACING } from '../constants/theme';
import { Button } from './Button';
import { Plan } from '../types';

interface PlanCardProps {
  plan: Plan;
  onSelect: (plan: Plan) => void;
}

export function PlanCard({ plan, onSelect }: PlanCardProps) {
  return (
    <View style={[styles.container, plan.popular && styles.popular]}>
      {plan.popular && (
        <View style={styles.badge}>
          <Text style={styles.badgeText}>Cel mai popular</Text>
        </View>
      )}
      <Text style={styles.name}>{plan.name}</Text>
      <View style={styles.priceRow}>
        <Text style={styles.price}>{plan.price}</Text>
        <Text style={styles.currency}>
          {plan.currency}/{plan.period}
        </Text>
      </View>
      <View style={styles.divider} />
      {plan.features.map((feature, index) => (
        <View key={index} style={styles.featureRow}>
          <Ionicons
            name="checkmark-circle"
            size={20}
            color={COLORS.success}
          />
          <Text style={styles.featureText}>{feature}</Text>
        </View>
      ))}
      <Button
        title={`Alege ${plan.name}`}
        onPress={() => onSelect(plan)}
        variant={plan.popular ? 'primary' : 'outline'}
        style={styles.button}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: COLORS.white,
    borderRadius: RADIUS.lg,
    padding: SPACING.lg,
    marginBottom: SPACING.md,
    borderWidth: 1,
    borderColor: COLORS.border,
    ...SHADOWS.md,
  },
  popular: {
    borderColor: COLORS.primary,
    borderWidth: 2,
  },
  badge: {
    backgroundColor: COLORS.primary,
    paddingHorizontal: SPACING.md,
    paddingVertical: SPACING.xs,
    borderRadius: RADIUS.full,
    alignSelf: 'flex-start',
    marginBottom: SPACING.sm,
  },
  badgeText: {
    color: COLORS.white,
    fontSize: FONTS.sizes.xs,
    fontWeight: '600',
  },
  name: {
    fontSize: FONTS.sizes.xl,
    fontWeight: '700',
    color: COLORS.text,
  },
  priceRow: {
    flexDirection: 'row',
    alignItems: 'baseline',
    marginTop: SPACING.xs,
  },
  price: {
    fontSize: FONTS.sizes.hero,
    fontWeight: '700',
    color: COLORS.text,
  },
  currency: {
    fontSize: FONTS.sizes.md,
    color: COLORS.textSecondary,
    marginLeft: SPACING.sm,
  },
  divider: {
    height: 1,
    backgroundColor: COLORS.border,
    marginVertical: SPACING.md,
  },
  featureRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: SPACING.sm,
    marginBottom: SPACING.sm,
  },
  featureText: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.text,
  },
  button: {
    marginTop: SPACING.md,
  },
});
