import React, { useState, useCallback, useRef, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TextInput,
  TouchableOpacity,
  ActivityIndicator,
  Alert,
  Animated,
  Dimensions,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING, GLASS } from '../constants/theme';
import {
  esimProvisioning,
  ESIMCountry,
  ESIMCountryPlan,
  ProvisioningResult,
} from '../services/esimProvisioning';
import { createCheckoutSession, openCheckout, getPaymentStatus, provisionAfterPayment, ProvisionedOrder } from '../services/stripeService';
import { runtimeConfig } from '../services/runtimeConfig';

const SCREEN_WIDTH = Dimensions.get('window').width;

type Step = 'country' | 'plans' | 'payment' | 'activating' | 'success';

export function ESIMScreen() {
  const [step, setStep] = useState<Step>('country');
  const [search, setSearch] = useState('');
  const [countries, setCountries] = useState<ESIMCountry[]>([]);
  const [selectedCountry, setSelectedCountry] = useState<ESIMCountry | null>(null);
  const [plans, setPlans] = useState<ESIMCountryPlan[]>([]);
  const [selectedPlan, setSelectedPlan] = useState<ESIMCountryPlan | null>(null);
  const [result, setResult] = useState<ProvisioningResult | null>(null);
  const [provisionedOrder, setProvisionedOrder] = useState<ProvisionedOrder | null>(null);
  const [loadingPlans, setLoadingPlans] = useState(false);
  const [checkoutSessionId, setCheckoutSessionId] = useState<string | null>(null);
  const [paymentSent, setPaymentSent] = useState(false);
  const [verifyingPayment, setVerifyingPayment] = useState(false);
  const fadeAnim = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    esimProvisioning.initialize().then(() => {
      setCountries(esimProvisioning.getCountries());
    });
  }, []);

  const filteredCountries = search
    ? countries.filter(
        (c) =>
          c.name.toLowerCase().includes(search.toLowerCase()) ||
          c.code.toLowerCase().includes(search.toLowerCase()),
      )
    : countries;
  const popularCountries = countries.filter((c) => c.popular);

  const animateStep = (nextStep: Step) => {
    Animated.timing(fadeAnim, { toValue: 0, duration: 150, useNativeDriver: true }).start(() => {
      setStep(nextStep);
      Animated.timing(fadeAnim, { toValue: 1, duration: 200, useNativeDriver: true }).start();
    });
  };

  const handleSelectCountry = async (country: ESIMCountry) => {
    setSelectedCountry(country);
    setLoadingPlans(true);
    animateStep('plans');
    try {
      const p = await esimProvisioning.getPlansForCountry(country.code);
      setPlans(p);
    } catch {
      setPlans([]);
    } finally {
      setLoadingPlans(false);
    }
  };

  const handleSelectPlan = async (plan: ESIMCountryPlan) => {
    setSelectedPlan(plan);
    // If backend is configured, show payment step; otherwise provision directly (demo mode)
    if (runtimeConfig.backendUrl) {
      animateStep('payment');
    } else {
      // Demo mode: skip payment, provision directly
      animateStep('activating');
      try {
        const res = await esimProvisioning.provisionESIM(plan.id);
        setResult(res);
        if (res.success) {
          setTimeout(() => animateStep('success'), 1500);
        } else {
          Alert.alert('Eroare', res.error || 'Nu s-a putut activa eSIM-ul.');
          animateStep('plans');
        }
      } catch {
        Alert.alert('Eroare', 'Nu s-a putut activa eSIM-ul. Incercati din nou.');
        animateStep('plans');
      }
    }
  };

  const handlePayment = async () => {
    if (!selectedPlan || !selectedCountry) return;
    try {
      const checkout = await createCheckoutSession({
        planId: selectedPlan.id,
        planName: `eSIM ${selectedPlan.dataLabel}`,
        countryName: selectedCountry.name,
        countryFlag: selectedCountry.flag,
        dataLabel: selectedPlan.dataLabel,
        price: selectedPlan.price,
        currency: selectedPlan.currency,
        validDays: selectedPlan.validDays,
      });
      if (checkout.url) {
        setCheckoutSessionId(checkout.sessionId);
        setPaymentSent(true);
        await openCheckout(checkout.url);
      } else {
        Alert.alert('Eroare', 'Nu s-a putut genera linkul de plata. Incercati din nou.');
        animateStep('plans');
      }
    } catch {
      Alert.alert('Eroare', 'Nu s-a putut initia plata. Incercati din nou.');
      animateStep('plans');
    }
  };

  const handleVerifyPayment = async () => {
    if (!checkoutSessionId) return;
    setVerifyingPayment(true);
    try {
      const status = await getPaymentStatus(checkoutSessionId);
      if (status.status === 'paid') {
        await handleProvisionAfterPayment();
      } else {
        Alert.alert('Plata in asteptare', 'Plata nu a fost confirmata inca. Finalizati plata in browser si incercati din nou.');
      }
    } catch {
      Alert.alert('Eroare', 'Nu s-a putut verifica plata. Incercati din nou.');
    } finally {
      setVerifyingPayment(false);
    }
  };

  const handleProvisionAfterPayment = async () => {
    if (!selectedPlan || !checkoutSessionId) return;
    animateStep('activating');
    try {
      // Call backend to provision eSIM (backend handles Airalo + DB)
      const order = await provisionAfterPayment(checkoutSessionId);
      setProvisionedOrder(order);
      setResult({
        success: true,
        profile: {
          id: order.id,
          iccid: order.iccid,
          activationCode: order.lpa || '',
          carrier: 'Airalo',
          region: order.countryName,
          countries: [],
          dataLimitMB: 0,
          dataUsedMB: 0,
          validFrom: new Date().toISOString(),
          validUntil: '',
          status: 'active',
          qrCodeUrl: order.qrcodeUrl,
          directAppleInstallUrl: order.directAppleInstallUrl,
        },
      });
      setTimeout(() => animateStep('success'), 1500);
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Nu s-a putut activa eSIM-ul.';
      Alert.alert('Eroare', message);
      animateStep('plans');
    }
  };

  const handleReset = () => {
    setSelectedCountry(null);
    setSelectedPlan(null);
    setResult(null);
    setPlans([]);
    setSearch('');
    setPaymentSent(false);
    setCheckoutSessionId(null);
    setProvisionedOrder(null);
    animateStep('country');
  };

  // Country selection
  if (step === 'country') {
    return (
      <Animated.View style={[styles.container, { opacity: fadeAnim }]}>
        <ScrollView contentContainerStyle={styles.content}>
          <Text style={styles.screenTitle}>eSIM Global</Text>
          <Text style={styles.screenSub}>Alege tara si activeaza instant</Text>

          {/* Search */}
          <View style={styles.searchWrap}>
            <MaterialCommunityIcons name="magnify" size={20} color={COLORS.textLight} />
            <TextInput
              style={styles.searchInput}
              placeholder="Cauta tara..."
              placeholderTextColor={COLORS.textLight}
              value={search}
              onChangeText={setSearch}
            />
            {search.length > 0 && (
              <TouchableOpacity onPress={() => setSearch('')}>
                <MaterialCommunityIcons name="close-circle" size={18} color={COLORS.textLight} />
              </TouchableOpacity>
            )}
          </View>

          {/* Popular countries */}
          {!search && (
            <>
              <Text style={styles.sectionLabel}>Populare</Text>
              <View style={styles.popularGrid}>
                {popularCountries.slice(0, 9).map((c) => (
                  <TouchableOpacity key={c.code} style={styles.popularCard} onPress={() => handleSelectCountry(c)}>
                    <Text style={styles.popularFlag}>{c.flag}</Text>
                    <Text style={styles.popularName}>{c.name}</Text>
                  </TouchableOpacity>
                ))}
              </View>
            </>
          )}

          {/* All countries */}
          <Text style={styles.sectionLabel}>{search ? 'Rezultate' : 'Toate tarile'}</Text>
          {filteredCountries.map((c) => (
            <TouchableOpacity key={c.code} style={styles.countryRow} onPress={() => handleSelectCountry(c)}>
              <Text style={styles.countryFlag}>{c.flag}</Text>
              <Text style={styles.countryName}>{c.name}</Text>
              <MaterialCommunityIcons name="chevron-right" size={20} color={COLORS.textLight} />
            </TouchableOpacity>
          ))}
        </ScrollView>
      </Animated.View>
    );
  }

  // Plans selection
  if (step === 'plans') {
    return (
      <Animated.View style={[styles.container, { opacity: fadeAnim }]}>
        <ScrollView contentContainerStyle={styles.content}>
          <TouchableOpacity style={styles.backBtn} onPress={handleReset}>
            <MaterialCommunityIcons name="arrow-left" size={20} color={COLORS.accent} />
            <Text style={styles.backText}>Inapoi</Text>
          </TouchableOpacity>
          <View style={styles.countryHeader}>
            <Text style={styles.countryHeaderFlag}>{selectedCountry?.flag}</Text>
            <Text style={styles.countryHeaderName}>{selectedCountry?.name}</Text>
          </View>
          <Text style={styles.sectionLabel}>Alege planul</Text>
          {loadingPlans ? (
            <View style={styles.loadingWrap}>
              <ActivityIndicator size="large" color={COLORS.accent} />
              <Text style={styles.loadingText}>Se incarca planurile...</Text>
            </View>
          ) : (
            plans.map((plan) => (
              <TouchableOpacity
                key={plan.id}
                style={[styles.planCard, plan.popular && styles.planCardPopular]}
                onPress={() => handleSelectPlan(plan)}
              >
                {plan.popular && (
                  <View style={styles.popularBadge}>
                    <Text style={styles.popularBadgeText}>POPULAR</Text>
                  </View>
                )}
                <View style={styles.planHeader}>
                  <Text style={styles.planData}>{plan.dataLabel}</Text>
                  <Text style={styles.planPrice}>{plan.currency === 'EUR' ? '\u20ac' : '$'}{plan.price.toFixed(2)}</Text>
                </View>
                <Text style={styles.planValidity}>{plan.validDays} zile</Text>
                <View style={styles.planFeatures}>
                  <View style={styles.planFeature}>
                    <MaterialCommunityIcons name="check-circle" size={14} color={COLORS.accent} />
                    <Text style={styles.planFeatureText}>Activare instant</Text>
                  </View>
                  <View style={styles.planFeature}>
                    <MaterialCommunityIcons name="check-circle" size={14} color={COLORS.accent} />
                    <Text style={styles.planFeatureText}>Date 4G/5G</Text>
                  </View>
                </View>
              </TouchableOpacity>
            ))
          )}
        </ScrollView>
      </Animated.View>
    );
  }

  // Payment confirmation
  if (step === 'payment') {
    return (
      <Animated.View style={[styles.container, { opacity: fadeAnim }]}>
        <ScrollView contentContainerStyle={styles.content}>
          <TouchableOpacity style={styles.backBtn} onPress={() => animateStep('plans')}>
            <MaterialCommunityIcons name="arrow-left" size={20} color={COLORS.accent} />
            <Text style={styles.backText}>Inapoi</Text>
          </TouchableOpacity>

          <View style={styles.paymentCard}>
            <View style={styles.paymentIcon}>
              <MaterialCommunityIcons name="credit-card-outline" size={40} color={COLORS.accent} />
            </View>
            <Text style={styles.paymentTitle}>Confirma plata</Text>

            <View style={styles.paymentDetails}>
              <View style={styles.paymentRow}>
                <Text style={styles.paymentLabel}>Plan</Text>
                <Text style={styles.paymentValue}>{selectedPlan?.dataLabel}</Text>
              </View>
              <View style={styles.paymentRow}>
                <Text style={styles.paymentLabel}>Tara</Text>
                <Text style={styles.paymentValue}>{selectedCountry?.flag} {selectedCountry?.name}</Text>
              </View>
              <View style={styles.paymentRow}>
                <Text style={styles.paymentLabel}>Validitate</Text>
                <Text style={styles.paymentValue}>{selectedPlan?.validDays} zile</Text>
              </View>
              <View style={[styles.paymentRow, styles.paymentRowTotal]}>
                <Text style={styles.paymentTotalLabel}>Total</Text>
                <Text style={styles.paymentTotalValue}>
                  {selectedPlan?.currency === 'EUR' ? '\u20ac' : '$'}{selectedPlan?.price.toFixed(2)}
                </Text>
              </View>
            </View>

            {!paymentSent ? (
              <TouchableOpacity style={styles.payBtn} onPress={handlePayment}>
                <MaterialCommunityIcons name="lock" size={18} color={COLORS.primary} />
                <Text style={styles.payBtnText}>Plateste securizat</Text>
              </TouchableOpacity>
            ) : (
              <>
                <TouchableOpacity style={styles.payBtn} onPress={handleVerifyPayment} disabled={verifyingPayment}>
                  {verifyingPayment ? (
                    <ActivityIndicator size="small" color={COLORS.primary} />
                  ) : (
                    <MaterialCommunityIcons name="check-circle-outline" size={18} color={COLORS.primary} />
                  )}
                  <Text style={styles.payBtnText}>{verifyingPayment ? 'Se verifica...' : 'Am platit - Verifica'}</Text>
                </TouchableOpacity>
                <TouchableOpacity style={styles.retryPayBtn} onPress={handlePayment}>
                  <Text style={styles.retryPayBtnText}>Deschide Stripe din nou</Text>
                </TouchableOpacity>
              </>
            )}

            <View style={styles.paymentSecure}>
              <MaterialCommunityIcons name="shield-check" size={14} color={COLORS.textLight} />
              <Text style={styles.paymentSecureText}>Plata procesata securizat prin Stripe</Text>
            </View>
          </View>
        </ScrollView>
      </Animated.View>
    );
  }

  // Activating
  if (step === 'activating') {
    return (
      <Animated.View style={[styles.container, styles.centerContent, { opacity: fadeAnim }]}>
        <View style={styles.activatingCard}>
          <ActivityIndicator size="large" color={COLORS.accent} />
          <Text style={styles.activatingTitle}>Se activeaza eSIM...</Text>
          <Text style={styles.activatingSub}>Asteptati cateva secunde</Text>
        </View>
      </Animated.View>
    );
  }

  // Success
  return (
    <Animated.View style={[styles.container, { opacity: fadeAnim }]}>
      <ScrollView contentContainerStyle={[styles.content, styles.centerContent]}>
        <View style={styles.successCard}>
          <View style={styles.successIcon}>
            <MaterialCommunityIcons name="check-circle" size={48} color={COLORS.success} />
          </View>
          <Text style={styles.successTitle}>eSIM Activat!</Text>
          <Text style={styles.successSub}>{selectedPlan?.dataLabel} - {selectedCountry?.name}</Text>
          {result?.profile && (
            <>
              <View style={styles.orderInfo}>
                <Text style={styles.orderLabel}>ICCID</Text>
                <Text style={styles.orderValue}>{result.profile.iccid}</Text>
              </View>
              {result.profile.activationCode ? (
                <View style={styles.orderInfo}>
                  <Text style={styles.orderLabel}>LPA / Cod Activare</Text>
                  <Text style={styles.orderValue}>{result.profile.activationCode}</Text>
                </View>
              ) : null}
              {result.profile.qrCodeUrl ? (
                <View style={styles.orderInfo}>
                  <Text style={styles.orderLabel}>QR Code</Text>
                  <Text style={[styles.orderValue, { color: COLORS.accent }]}>Disponibil - scanati pentru activare</Text>
                </View>
              ) : null}
            </>
          )}
          <View style={styles.activationSteps}>
            <Text style={styles.activationStepsTitle}>Pasi de activare:</Text>
            <Text style={styles.activationStep}>1. Setari {'>'} Celular {'>'} Adauga plan eSIM</Text>
            <Text style={styles.activationStep}>2. Scanati codul QR sau introduceti LPA manual</Text>
            <Text style={styles.activationStep}>3. Activati planul de date</Text>
          </View>
          <TouchableOpacity style={styles.doneBtn} onPress={handleReset}>
            <Text style={styles.doneBtnText}>Gata</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: COLORS.surface },
  content: { paddingHorizontal: SPACING.lg, paddingTop: 60, paddingBottom: SPACING.xxxl },
  centerContent: { justifyContent: 'center', alignItems: 'center' },
  screenTitle: { fontSize: FONTS.sizes.xxxl, fontWeight: '800', color: COLORS.text, letterSpacing: -0.5 },
  screenSub: { fontSize: FONTS.sizes.md, color: COLORS.textSecondary, marginTop: 4, marginBottom: SPACING.xl },
  searchWrap: { ...GLASS.card, borderRadius: RADIUS.lg, flexDirection: 'row', alignItems: 'center', paddingHorizontal: SPACING.md, paddingVertical: SPACING.sm, gap: SPACING.sm, marginBottom: SPACING.xl },
  searchInput: { flex: 1, fontSize: FONTS.sizes.md, color: COLORS.text },
  sectionLabel: { fontSize: FONTS.sizes.sm, fontWeight: '700', color: COLORS.textSecondary, textTransform: 'uppercase', letterSpacing: 1, marginBottom: SPACING.md },
  popularGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: SPACING.sm, marginBottom: SPACING.xl },
  popularCard: { width: '30%', ...GLASS.card, borderRadius: RADIUS.lg, padding: SPACING.md, alignItems: 'center', gap: 6 },
  popularFlag: { fontSize: 28 },
  popularName: { fontSize: FONTS.sizes.xs, color: COLORS.text, fontWeight: '600', textAlign: 'center' },
  countryRow: { ...GLASS.panel, borderRadius: RADIUS.md, flexDirection: 'row', alignItems: 'center', padding: SPACING.md, marginBottom: SPACING.sm, gap: SPACING.md },
  countryFlag: { fontSize: 24 },
  countryName: { flex: 1, fontSize: FONTS.sizes.md, color: COLORS.text, fontWeight: '500' },
  backBtn: { flexDirection: 'row', alignItems: 'center', gap: 6, marginBottom: SPACING.lg },
  backText: { fontSize: FONTS.sizes.md, color: COLORS.accent, fontWeight: '600' },
  countryHeader: { flexDirection: 'row', alignItems: 'center', gap: SPACING.md, marginBottom: SPACING.xl },
  countryHeaderFlag: { fontSize: 40 },
  countryHeaderName: { fontSize: FONTS.sizes.xxl, fontWeight: '800', color: COLORS.text },
  loadingWrap: { alignItems: 'center', paddingVertical: SPACING.xxl, gap: SPACING.md },
  loadingText: { fontSize: FONTS.sizes.md, color: COLORS.textSecondary },
  planCard: { ...GLASS.card, borderRadius: RADIUS.xl, padding: SPACING.lg, marginBottom: SPACING.md, position: 'relative' as const },
  planCardPopular: { ...GLASS.cardActive, borderColor: COLORS.accent + '40' },
  popularBadge: { position: 'absolute' as const, top: SPACING.md, right: SPACING.md, backgroundColor: 'rgba(0,212,170,0.15)', paddingHorizontal: SPACING.sm, paddingVertical: 2, borderRadius: RADIUS.full, borderWidth: 1, borderColor: 'rgba(0,212,170,0.3)' },
  popularBadgeText: { fontSize: 9, fontWeight: '800', color: COLORS.accent, letterSpacing: 1 },
  planHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 4 },
  planData: { fontSize: FONTS.sizes.xl, fontWeight: '800', color: COLORS.text },
  planPrice: { fontSize: FONTS.sizes.xl, fontWeight: '800', color: COLORS.accent },
  planValidity: { fontSize: FONTS.sizes.sm, color: COLORS.textSecondary, marginBottom: SPACING.md },
  planFeatures: { gap: 6 },
  planFeature: { flexDirection: 'row', alignItems: 'center', gap: 6 },
  planFeatureText: { fontSize: FONTS.sizes.sm, color: COLORS.textSecondary },
  activatingCard: { ...GLASS.card, borderRadius: RADIUS.xxl, padding: SPACING.xxl, alignItems: 'center', gap: SPACING.lg, width: SCREEN_WIDTH * 0.8 },
  activatingTitle: { fontSize: FONTS.sizes.xl, fontWeight: '700', color: COLORS.text },
  activatingSub: { fontSize: FONTS.sizes.md, color: COLORS.textSecondary },
  successCard: { ...GLASS.card, borderRadius: RADIUS.xxl, padding: SPACING.xxl, alignItems: 'center', gap: SPACING.md, width: SCREEN_WIDTH * 0.85 },
  successIcon: { marginBottom: SPACING.sm },
  successTitle: { fontSize: FONTS.sizes.xxl, fontWeight: '800', color: COLORS.success },
  successSub: { fontSize: FONTS.sizes.md, color: COLORS.textSecondary },
  orderInfo: { ...GLASS.panel, borderRadius: RADIUS.md, padding: SPACING.md, width: '100%', alignItems: 'center', marginTop: SPACING.sm },
  orderLabel: { fontSize: FONTS.sizes.xs, color: COLORS.textLight, marginBottom: 4 },
  orderValue: { fontSize: FONTS.sizes.sm, color: COLORS.text, fontWeight: '600' },
  activationSteps: { ...GLASS.panel, borderRadius: RADIUS.md, padding: SPACING.md, width: '100%', marginTop: SPACING.md },
  activationStepsTitle: { fontSize: FONTS.sizes.sm, fontWeight: '700', color: COLORS.text, marginBottom: SPACING.sm },
  activationStep: { fontSize: FONTS.sizes.sm, color: COLORS.textSecondary, marginBottom: 4 },
  doneBtn: { backgroundColor: COLORS.accent, borderRadius: RADIUS.lg, paddingVertical: SPACING.md, paddingHorizontal: SPACING.xxl, marginTop: SPACING.lg },
  doneBtnText: { fontSize: FONTS.sizes.md, fontWeight: '700', color: COLORS.primary },
  // Payment styles
  paymentCard: { ...GLASS.card, borderRadius: RADIUS.xxl, padding: SPACING.xl, alignItems: 'center' as const, marginTop: SPACING.lg },
  paymentIcon: { width: 72, height: 72, borderRadius: 36, backgroundColor: 'rgba(0,212,170,0.1)', justifyContent: 'center' as const, alignItems: 'center' as const, marginBottom: SPACING.lg },
  paymentTitle: { fontSize: FONTS.sizes.xxl, fontWeight: '800' as const, color: COLORS.text, marginBottom: SPACING.xl },
  paymentDetails: { width: '100%' as unknown as number, gap: SPACING.md, marginBottom: SPACING.xl },
  paymentRow: { flexDirection: 'row' as const, justifyContent: 'space-between' as const, paddingVertical: SPACING.sm, borderBottomWidth: 1, borderBottomColor: 'rgba(255,255,255,0.06)' },
  paymentRowTotal: { borderBottomWidth: 0, paddingTop: SPACING.md, marginTop: SPACING.sm, borderTopWidth: 1, borderTopColor: 'rgba(255,255,255,0.1)' },
  paymentLabel: { fontSize: FONTS.sizes.md, color: COLORS.textSecondary },
  paymentValue: { fontSize: FONTS.sizes.md, color: COLORS.text, fontWeight: '600' as const },
  paymentTotalLabel: { fontSize: FONTS.sizes.lg, color: COLORS.text, fontWeight: '700' as const },
  paymentTotalValue: { fontSize: FONTS.sizes.xl, color: COLORS.accent, fontWeight: '800' as const },
  payBtn: { flexDirection: 'row' as const, alignItems: 'center' as const, justifyContent: 'center' as const, backgroundColor: COLORS.accent, borderRadius: RADIUS.lg, paddingVertical: SPACING.md, paddingHorizontal: SPACING.xxl, gap: SPACING.sm, width: '100%' as unknown as number },
  payBtnText: { fontSize: FONTS.sizes.md, fontWeight: '700' as const, color: COLORS.primary },
  retryPayBtn: { marginTop: SPACING.sm, paddingVertical: SPACING.sm },
  retryPayBtnText: { fontSize: FONTS.sizes.sm, color: COLORS.accent, fontWeight: '600' as const, textDecorationLine: 'underline' as const },
  paymentSecure: { flexDirection: 'row' as const, alignItems: 'center' as const, gap: 6, marginTop: SPACING.md },
  paymentSecureText: { fontSize: FONTS.sizes.xs, color: COLORS.textLight },
});
