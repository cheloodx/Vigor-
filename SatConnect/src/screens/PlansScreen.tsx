import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  Alert,
} from 'react-native';
import { COLORS, FONTS, SPACING } from '../constants/theme';
import { PLANS } from '../constants/data';
import { PlanCard } from '../components/PlanCard';
import { Plan, PlanType } from '../types';

export function PlansScreen() {
  const [currentPlan] = useState<PlanType>('basic');

  const handleSelectPlan = (plan: Plan) => {
    if (plan.id === currentPlan) return;

    Alert.alert(
      'Schimbă planul',
      `Vrei să treci la planul ${plan.name} (€${plan.price}/${plan.period})?\n\nIntegrarea cu Stripe va fi disponibilă în curând.`,
      [
        { text: 'Anulează', style: 'cancel' },
        {
          text: 'Confirmă',
          onPress: () => {
            Alert.alert('Succes', `Ai selectat planul ${plan.name}. Plata va fi procesată prin Stripe.`);
          },
        },
      ]
    );
  };

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      <View style={styles.header}>
        <Text style={styles.title}>Planuri</Text>
        <Text style={styles.subtitle}>
          Alege planul potrivit pentru nevoile tale de conectivitate
        </Text>
      </View>

      {PLANS.map((plan) => (
        <PlanCard
          key={plan.id}
          plan={plan}
          isCurrentPlan={plan.id === currentPlan}
          onSelect={handleSelectPlan}
        />
      ))}

      <View style={styles.footer}>
        <Text style={styles.footerTitle}>Ai nevoie de mai mult?</Text>
        <Text style={styles.footerText}>
          Contactează-ne pentru planuri personalizate pentru echipe și business.
        </Text>
        <Text style={styles.footerNote}>
          Toate planurile includ buton SOS de urgență și criptare end-to-end.
        </Text>
      </View>
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
    marginBottom: SPACING.xl,
  },
  title: {
    fontSize: FONTS.sizes.xxl,
    fontWeight: '800',
    color: COLORS.text,
    marginBottom: SPACING.xs,
  },
  subtitle: {
    fontSize: FONTS.sizes.md,
    color: COLORS.textSecondary,
    lineHeight: 22,
  },
  footer: {
    alignItems: 'center',
    paddingVertical: SPACING.xl,
    gap: SPACING.sm,
  },
  footerTitle: {
    fontSize: FONTS.sizes.lg,
    fontWeight: '700',
    color: COLORS.text,
  },
  footerText: {
    fontSize: FONTS.sizes.md,
    color: COLORS.textSecondary,
    textAlign: 'center',
  },
  footerNote: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.textLight,
    textAlign: 'center',
    marginTop: SPACING.sm,
  },
});
