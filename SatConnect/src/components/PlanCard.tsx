import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING, SHADOWS } from '../constants/theme';
import { Plan } from '../types';
import { Button } from './Button';

interface PlanCardProps {
  plan: Plan;
  isCurrentPlan: boolean;
  onSelect: (plan: Plan) => void;
}

export function PlanCard({ plan, isCurrentPlan, onSelect }: PlanCardProps) {
  return (
    <View style={[styles.card, plan.popular && styles.popular, isCurrentPlan && styles.current]}>
      {plan.popular && (
        <View style={styles.popularBadge}>
          <Text style={styles.popularText}>Popular</Text>
        </View>
      )}
      {isCurrentPlan && (
        <View style={styles.currentBadge}>
          <Text style={styles.currentText}>Planul tău</Text>
        </View>
      )}

      <Text style={[styles.name, plan.popular && styles.namePopular]}>{plan.name}</Text>

      <View style={styles.priceRow}>
        <Text style={[styles.currency, plan.popular && styles.pricePopular]}>
          {plan.currency === 'EUR' ? '€' : plan.currency}
        </Text>
        <Text style={[styles.price, plan.popular && styles.pricePopular]}>{plan.price}</Text>
        <Text style={[styles.period, plan.popular && styles.periodPopular]}>/{plan.period}</Text>
      </View>

      <View style={styles.divider} />

      <View style={styles.features}>
        {plan.features.map((feature, index) => (
          <View key={index} style={styles.featureRow}>
            <Ionicons
              name="checkmark-circle"
              size={18}
              color={plan.popular ? COLORS.accent : COLORS.success}
            />
            <Text style={[styles.featureText, plan.popular && styles.featurePopular]}>
              {feature}
            </Text>
          </View>
        ))}
      </View>

      <Button
        title={isCurrentPlan ? 'Plan activ' : 'Alege planul'}
        onPress={() => onSelect(plan)}
        variant={plan.popular ? 'primary' : 'secondary'}
        disabled={isCurrentPlan}
        size="md"
      />
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: COLORS.white,
    borderRadius: RADIUS.xl,
    padding: SPACING.xl,
    marginBottom: SPACING.lg,
    borderWidth: 1,
    borderColor: COLORS.border,
    ...SHADOWS.md,
  },
  popular: {
    backgroundColor: COLORS.primary,
    borderColor: COLORS.primary,
  },
  current: {
    borderColor: COLORS.accent,
    borderWidth: 2,
  },
  popularBadge: {
    position: 'absolute',
    top: -10,
    right: SPACING.xl,
    backgroundColor: COLORS.accent,
    paddingHorizontal: SPACING.md,
    paddingVertical: SPACING.xs,
    borderRadius: RADIUS.full,
  },
  popularText: {
    color: COLORS.primaryDark,
    fontSize: FONTS.sizes.xs,
    fontWeight: '700',
  },
  currentBadge: {
    position: 'absolute',
    top: -10,
    left: SPACING.xl,
    backgroundColor: COLORS.accent,
    paddingHorizontal: SPACING.md,
    paddingVertical: SPACING.xs,
    borderRadius: RADIUS.full,
  },
  currentText: {
    color: COLORS.primaryDark,
    fontSize: FONTS.sizes.xs,
    fontWeight: '700',
  },
  name: {
    fontSize: FONTS.sizes.xl,
    fontWeight: '700',
    color: COLORS.text,
    marginBottom: SPACING.sm,
  },
  namePopular: {
    color: COLORS.white,
  },
  priceRow: {
    flexDirection: 'row',
    alignItems: 'baseline',
    marginBottom: SPACING.md,
  },
  currency: {
    fontSize: FONTS.sizes.lg,
    fontWeight: '600',
    color: COLORS.text,
  },
  price: {
    fontSize: FONTS.sizes.xxxl,
    fontWeight: '800',
    color: COLORS.text,
  },
  pricePopular: {
    color: COLORS.white,
  },
  period: {
    fontSize: FONTS.sizes.md,
    color: COLORS.textSecondary,
    marginLeft: 2,
  },
  periodPopular: {
    color: COLORS.gray[300],
  },
  divider: {
    height: 1,
    backgroundColor: COLORS.border,
    marginVertical: SPACING.md,
    opacity: 0.3,
  },
  features: {
    marginBottom: SPACING.lg,
    gap: SPACING.sm,
  },
  featureRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: SPACING.sm,
  },
  featureText: {
    fontSize: FONTS.sizes.md,
    color: COLORS.text,
    flex: 1,
  },
  featurePopular: {
    color: COLORS.gray[200],
  },
});
