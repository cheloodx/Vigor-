import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  Alert,
  TouchableOpacity,
  ActivityIndicator,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING } from '../constants/theme';
import { PLANS } from '../constants/data';
import { PlanCard } from '../components/PlanCard';
import { Plan, PlanType } from '../types';
import { appleIAP, PRODUCT_IDS } from '../services/appleIAP';

const PLAN_PRODUCT_MAP: Record<string, string> = {
  free: PRODUCT_IDS.FREE,
  basic: PRODUCT_IDS.EXPLORER,
  standard: PRODUCT_IDS.PRO,
  premium: PRODUCT_IDS.UNLIMITED,
};

export function PlansScreen() {
  const [currentPlan, setCurrentPlan] = useState<PlanType>('basic');
  const [purchasing, setPurchasing] = useState(false);
  const [restoring, setRestoring] = useState(false);

  const handleSelectPlan = (plan: Plan) => {
    if (plan.id === currentPlan) return;

    Alert.alert(
      'Cumpără planul',
      `Vrei să treci la planul ${plan.name} (€${plan.price}/${plan.period})?\n\nPlata se procesează prin Apple In-App Purchase.`,
      [
        { text: 'Anulează', style: 'cancel' },
        {
          text: 'Cumpără',
          onPress: async () => {
            setPurchasing(true);
            try {
              const productId = PLAN_PRODUCT_MAP[plan.id] || PRODUCT_IDS.FREE;
              const result = await appleIAP.purchaseSubscription(productId);
              if (result.success) {
                setCurrentPlan(plan.id as PlanType);
                Alert.alert('Achiziție reușită!', `Planul ${plan.name} a fost activat.`);
              } else {
                Alert.alert('Eroare', result.error || 'Achiziția a eșuat.');
              }
            } catch {
              Alert.alert('Eroare', 'Achiziția a eșuat. Încearcă din nou.');
            } finally {
              setPurchasing(false);
            }
          },
        },
      ]
    );
  };

  const handleRestorePurchases = async () => {
    setRestoring(true);
    try {
      const result = await appleIAP.restorePurchases();
      if (result.success && result.subscription) {
        const planType = appleIAP.getPlanTypeForProduct(result.subscription.productId);
        if (planType) setCurrentPlan(planType as PlanType);
        Alert.alert('Restaurare reușită!', 'Abonamentul tău a fost restaurat.');
      } else {
        Alert.alert('Info', result.error || 'Nu au fost găsite achiziții anterioare.');
      }
    } catch {
      Alert.alert('Eroare', 'Restaurarea a eșuat. Încearcă din nou.');
    } finally {
      setRestoring(false);
    }
  };

  return (
    <View style={styles.wrapper}>
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

      {/* Restore Purchases */}
      <TouchableOpacity
        style={styles.restoreButton}
        onPress={handleRestorePurchases}
        disabled={restoring}
      >
        {restoring ? (
          <ActivityIndicator size="small" color={COLORS.accent} />
        ) : (
          <MaterialCommunityIcons name="restore" size={18} color={COLORS.accent} />
        )}
        <Text style={styles.restoreText}>Restaurează cumpărăturile</Text>
      </TouchableOpacity>

      <View style={styles.footer}>
        <Text style={styles.footerTitle}>Ai nevoie de mai mult?</Text>
        <Text style={styles.footerText}>
          Contactează-ne pentru planuri personalizate pentru echipe și business.
        </Text>
        <Text style={styles.footerNote}>
          Toate planurile includ buton SOS de urgență și criptare end-to-end.
          Plățile sunt procesate securizat prin Apple In-App Purchase.
        </Text>
      </View>
    </ScrollView>

      {/* Purchase in progress overlay - outside ScrollView for proper positioning */}
      {purchasing && (
        <View style={styles.purchasingOverlay}>
          <View style={styles.purchasingCard}>
            <MaterialCommunityIcons name="apple" size={36} color={COLORS.text} />
            <Text style={styles.purchasingText}>Se procesează plata...</Text>
            <ActivityIndicator size="large" color={COLORS.primary} />
          </View>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  wrapper: {
    flex: 1,
  },
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
  restoreButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: SPACING.sm,
    paddingVertical: SPACING.md,
    marginBottom: SPACING.md,
  },
  restoreText: {
    fontSize: FONTS.sizes.sm,
    fontWeight: '600',
    color: COLORS.accent,
  },
  purchasingOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(0,0,0,0.4)',
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 100,
  },
  purchasingCard: {
    backgroundColor: COLORS.white,
    borderRadius: RADIUS.xl,
    padding: SPACING.xxl,
    alignItems: 'center',
    gap: SPACING.md,
    width: 250,
  },
  purchasingText: {
    fontSize: FONTS.sizes.md,
    fontWeight: '600',
    color: COLORS.text,
  },
});
