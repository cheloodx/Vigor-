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

interface Plan {
  id: string;
  name: string;
  price: string;
  period: string;
  features: string[];
  popular?: boolean;
  current?: boolean;
}

const SUBSCRIPTION_PLANS: Plan[] = [
  {
    id: 'free',
    name: 'Free',
    price: '$0',
    period: '/luna',
    features: ['1 eSIM activ', 'Date de baza', 'Suport email'],
    current: true,
  },
  {
    id: 'explorer',
    name: 'Explorer',
    price: '$4.99',
    period: '/luna',
    features: ['3 eSIM-uri active', '10GB bonus/luna', 'Suport prioritar', 'Hotspot inclus'],
    popular: true,
  },
  {
    id: 'pro',
    name: 'Pro',
    price: '$9.99',
    period: '/luna',
    features: ['eSIM-uri nelimitate', '25GB bonus/luna', 'Suport 24/7', 'Hotspot inclus', 'VPN integrat'],
  },
  {
    id: 'business',
    name: 'Business',
    price: '$19.99',
    period: '/luna',
    features: ['Totul din Pro', '50GB bonus/luna', 'Manager dedicat', 'Facturare firma', 'API access'],
  },
];

export function PlansScreen() {
  const [selectedPlan, setSelectedPlan] = useState<string>('free');

  const handleSubscribe = (plan: Plan) => {
    if (plan.current) return;
    Alert.alert(
      'Upgrade la ' + plan.name,
      `Doriti sa faceti upgrade la planul ${plan.name} pentru ${plan.price}${plan.period}?`,
      [
        { text: 'Anuleaza', style: 'cancel' },
        { text: 'Upgrade', onPress: () => Alert.alert('Succes', 'Planul a fost actualizat!') },
      ]
    );
  };

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      <Text style={styles.screenTitle}>Planuri</Text>
      <Text style={styles.screenSub}>Alege planul potrivit</Text>

      {SUBSCRIPTION_PLANS.map((plan) => (
        <TouchableOpacity
          key={plan.id}
          style={[
            styles.planCard,
            plan.popular && styles.planCardPopular,
            plan.current && styles.planCardCurrent,
          ]}
          onPress={() => handleSubscribe(plan)}
          activeOpacity={0.7}
        >
          {plan.popular && (
            <View style={styles.popularBadge}>
              <Text style={styles.popularBadgeText}>POPULAR</Text>
            </View>
          )}
          {plan.current && (
            <View style={styles.currentBadge}>
              <Text style={styles.currentBadgeText}>ACTUAL</Text>
            </View>
          )}
          <View style={styles.planHeader}>
            <Text style={styles.planName}>{plan.name}</Text>
            <View style={styles.planPriceWrap}>
              <Text style={[styles.planPrice, plan.popular && { color: COLORS.accent }]}>{plan.price}</Text>
              <Text style={styles.planPeriod}>{plan.period}</Text>
            </View>
          </View>
          <View style={styles.planFeatures}>
            {plan.features.map((f, i) => (
              <View key={i} style={styles.featureRow}>
                <MaterialCommunityIcons name="check-circle" size={16} color={plan.popular ? COLORS.accent : COLORS.success} />
                <Text style={styles.featureText}>{f}</Text>
              </View>
            ))}
          </View>
          {!plan.current && (
            <View style={[styles.selectBtn, plan.popular && styles.selectBtnPopular]}>
              <Text style={[styles.selectBtnText, plan.popular && styles.selectBtnTextPopular]}>
                {plan.popular ? 'Upgrade Acum' : 'Selecteaza'}
              </Text>
            </View>
          )}
        </TouchableOpacity>
      ))}

      {/* Restore */}
      <TouchableOpacity style={styles.restoreBtn}>
        <Text style={styles.restoreText}>Restaureaza achizitii</Text>
      </TouchableOpacity>

      <Text style={styles.footerText}>
        Contacteaza support@satconnect.app pentru intrebari.
      </Text>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: COLORS.surface },
  content: { paddingHorizontal: SPACING.lg, paddingTop: 60, paddingBottom: SPACING.xxxl },
  screenTitle: { fontSize: FONTS.sizes.xxxl, fontWeight: '800', color: COLORS.text, letterSpacing: -0.5 },
  screenSub: { fontSize: FONTS.sizes.md, color: COLORS.textSecondary, marginTop: 4, marginBottom: SPACING.xl },
  planCard: { ...GLASS.card, borderRadius: RADIUS.xl, padding: SPACING.lg, marginBottom: SPACING.md, position: 'relative' as const },
  planCardPopular: { ...GLASS.cardActive, borderColor: COLORS.accent + '40' },
  planCardCurrent: { borderColor: COLORS.success + '30' },
  popularBadge: { position: 'absolute' as const, top: SPACING.md, right: SPACING.md, backgroundColor: 'rgba(0,212,170,0.15)', paddingHorizontal: SPACING.sm, paddingVertical: 2, borderRadius: RADIUS.full, borderWidth: 1, borderColor: 'rgba(0,212,170,0.3)' },
  popularBadgeText: { fontSize: 9, fontWeight: '800', color: COLORS.accent, letterSpacing: 1 },
  currentBadge: { position: 'absolute' as const, top: SPACING.md, right: SPACING.md, backgroundColor: 'rgba(52,211,153,0.15)', paddingHorizontal: SPACING.sm, paddingVertical: 2, borderRadius: RADIUS.full, borderWidth: 1, borderColor: 'rgba(52,211,153,0.3)' },
  currentBadgeText: { fontSize: 9, fontWeight: '800', color: COLORS.success, letterSpacing: 1 },
  planHeader: { marginBottom: SPACING.md },
  planName: { fontSize: FONTS.sizes.lg, fontWeight: '700', color: COLORS.text },
  planPriceWrap: { flexDirection: 'row', alignItems: 'baseline', gap: 2, marginTop: 4 },
  planPrice: { fontSize: FONTS.sizes.xxl, fontWeight: '800', color: COLORS.text },
  planPeriod: { fontSize: FONTS.sizes.sm, color: COLORS.textSecondary },
  planFeatures: { gap: 8, marginBottom: SPACING.lg },
  featureRow: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  featureText: { fontSize: FONTS.sizes.sm, color: COLORS.textSecondary },
  selectBtn: { ...GLASS.panel, borderRadius: RADIUS.lg, paddingVertical: SPACING.md, alignItems: 'center' },
  selectBtnPopular: { backgroundColor: COLORS.accent },
  selectBtnText: { fontSize: FONTS.sizes.md, fontWeight: '700', color: COLORS.textSecondary },
  selectBtnTextPopular: { color: COLORS.primary },
  restoreBtn: { alignItems: 'center', padding: SPACING.lg },
  restoreText: { fontSize: FONTS.sizes.sm, color: COLORS.accent, fontWeight: '600' },
  footerText: { textAlign: 'center', fontSize: FONTS.sizes.xs, color: COLORS.textLight, paddingHorizontal: SPACING.lg },
});
