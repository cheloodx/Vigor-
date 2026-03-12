import React, { useState, useRef, useEffect } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, Alert } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import { useAuth } from '../context/AuthContext';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import type { RootStackParamList } from '../constants/types';
import { useLanguage } from '../context/LanguageContext';

type Props = NativeStackScreenProps<RootStackParamList, 'Subscription'>;

export default function SubscriptionScreen({ navigation }: Props) {
  const { isPremium, subscribe } = useAuth();
  const { t } = useLanguage();

  const basicFeatures = [
    { text: t.subscription.basic10Recipes, included: true },
    { text: t.subscription.basic10Exercises, included: true },
    { text: t.subscription.basicCalculator, included: true },
    { text: t.subscription.all122Recipes, included: false },
    { text: t.subscription.all85ExercisesHD, included: false },
    { text: t.subscription.personalMealPlans, included: false },
    { text: t.subscription.completeTrainingPlans, included: false },
    { text: t.subscription.appleWatchConnect, included: false },
    { text: t.subscription.customNotifications, included: false },
    { text: t.subscription.noAds, included: false },
  ];

  const premiumFeatures = [
    { text: t.subscription.all122RecipesComplete, included: true },
    { text: t.subscription.all85ExercisesHD, included: true },
    { text: t.subscription.personalMealPlans, included: true },
    { text: t.subscription.completeTrainingPlans, included: true },
    { text: t.subscription.advancedCalculator, included: true },
    { text: t.subscription.expertTips, included: true },
    { text: t.subscription.smartShoppingList, included: true },
    { text: t.subscription.appleWatchConnect, included: true },
    { text: t.subscription.customNotifications, included: true },
    { text: t.subscription.noAds, included: true },
  ];
  const [loading, setLoading] = useState(false);
  const timeoutRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    return () => {
      if (timeoutRef.current) clearTimeout(timeoutRef.current);
    };
  }, []);

  const handleSubscribe = () => {
    setLoading(true);
    timeoutRef.current = setTimeout(() => {
      setLoading(false);
      subscribe();
      Alert.alert(
        t.subscription.subscriptionActivated,
        t.subscription.congratsMsg,
        [
          {
            text: t.subscription.excellent,
            onPress: () => navigation.goBack(),
          },
        ]
      );
    }, 2000);
  };

  const handleRestore = () => {
    Alert.alert(
      t.subscription.restoreTitle,
      t.subscription.restoreMsg,
      [{ text: 'OK' }]
    );
  };

  if (isPremium) {
    return (
      <ScrollView style={s.container} showsVerticalScrollIndicator={false}>
        <LinearGradient colors={['#F59E0B', '#D97706']} style={s.header}>
          <TouchableOpacity style={s.closeBtn} onPress={() => navigation.goBack()}>
            <Ionicons name="close" size={24} color="#FFF" />
          </TouchableOpacity>
          <Ionicons name="diamond" size={48} color="#FFF" />
                    <Text style={s.headerTitle}>{t.subscription.youArePremium}</Text>
                    <Text style={s.headerDesc}>{t.subscription.premiumDesc}</Text>
        </LinearGradient>

        <View style={s.plansContainer}>
          <View style={s.activeCard}>
            <Ionicons name="checkmark-circle" size={32} color={Colors.primary} />
                        <Text style={s.activeTitle}>{t.subscription.activeSubscription}</Text>
                        <Text style={s.activePrice}>{t.subscription.pricePerMonth}</Text>
                        <Text style={s.activeDesc}>{t.subscription.activeDesc}</Text>
          </View>

          <View style={s.featuresContainer}>
            <Text style={s.featuresTitle}>{t.subscription.includesTitle}</Text>
            {premiumFeatures.map((f, i) => (
              <View key={i} style={s.featureRow}>
                <Ionicons name="checkmark-circle" size={18} color={Colors.primary} />
                <Text style={s.featureText}>{f.text}</Text>
              </View>
            ))}
          </View>
        </View>
        <View style={{ height: 40 }} />
      </ScrollView>
    );
  }

  return (
    <ScrollView style={s.container} showsVerticalScrollIndicator={false}>
      <LinearGradient colors={['#10B981', '#059669']} style={s.header}>
        <TouchableOpacity style={s.closeBtn} onPress={() => navigation.goBack()}>
          <Ionicons name="close" size={24} color="#FFF" />
        </TouchableOpacity>
        <Ionicons name="star" size={48} color="#FFF" />
                <Text style={s.headerTitle}>{t.subscription.echilibruPremium}</Text>
                <Text style={s.headerDesc}>{t.subscription.unlockDesc}</Text>
        
        <View style={s.statsRow}>
          <View style={s.stat}>
            <Text style={s.statNum}>122</Text>
            <Text style={s.statLabel}>{t.subscription.recipesLabel}</Text>
          </View>
          <View style={s.statDivider} />
          <View style={s.stat}>
            <Text style={s.statNum}>85</Text>
            <Text style={s.statLabel}>{t.subscription.exercisesLabel}</Text>
          </View>
          <View style={s.statDivider} />
          <View style={s.stat}>
            <Text style={s.statNum}>Video</Text>
            <Text style={s.statLabel}>HD</Text>
          </View>
          <View style={s.statDivider} />
          <View style={s.stat}>
            <Ionicons name="watch" size={20} color="#FFF" />
            <Text style={s.statLabel}>Watch</Text>
          </View>
        </View>
      </LinearGradient>

      <View style={s.plansContainer}>
        {/* Free Basic comparison */}
        <View style={s.compareSection}>
          <Text style={s.sectionTitle}>{t.subscription.freeVsPremium}</Text>
          
          <View style={s.compareCard}>
            <View style={s.compareHeader}>
              <View style={s.compareCol}>
                              <Text style={s.compareColTitle}>{t.subscription.basic}</Text>
                              <Text style={s.compareColPrice}>{t.subscription.free}</Text>
                            </View>
                            <View style={[s.compareCol, s.compareColPremium]}>
                              <Text style={[s.compareColTitle, { color: '#FFF' }]}>{t.subscription.premium}</Text>
                              <Text style={[s.compareColPrice, { color: '#FFF' }]}>{t.subscription.priceShort}</Text>
              </View>
            </View>
            
            <View style={s.compareRows}>
              {[
                [t.subscription.compare10Recipes, t.subscription.compareAll122],
                [t.subscription.compare10Exercises, t.subscription.compareAll85],
                [t.subscription.noVideo, t.subscription.videoHD],
                [t.subscription.basicCalc, t.subscription.advancedCalc],
                [t.subscription.noPlans, t.subscription.completePlans],
                [t.subscription.noWatch, t.subscription.watchConnected],
                [t.subscription.noNotif, t.subscription.customNotif],
                [t.subscription.withAds, t.subscription.noAds],
              ].map(([basic, premium], i) => (
                <View key={i} style={s.compareRow}>
                  <View style={s.compareCellBasic}>
                    <Ionicons name={(i < 2 || i === 3) ? 'checkmark' : 'close'} size={14} color={(i < 2 || i === 3) ? Colors.gray[500] : Colors.gray[300]} />
                    <Text style={s.compareCellText}>{basic}</Text>
                  </View>
                  <View style={s.compareCellPremium}>
                    <Ionicons name="checkmark" size={14} color={Colors.primary} />
                    <Text style={[s.compareCellText, { color: Colors.primary, fontWeight: '600' }]}>{premium}</Text>
                  </View>
                </View>
              ))}
            </View>
          </View>
        </View>

        {/* Premium plan card */}
        <View style={s.premiumCard}>
          <LinearGradient colors={['#10B981', '#059669']} style={s.premiumGradient}>
            <Ionicons name="diamond" size={32} color="#FFF" />
            <Text style={s.premiumTitle}>{t.subscription.echilibruPremium}</Text>
            <View style={s.priceRow}>
              <Text style={s.priceMain}>£4.99</Text>
              <Text style={s.pricePeriod}> / luna</Text>
            </View>
            <Text style={s.premiumDesc}>{t.subscription.singleSub}</Text>
          </LinearGradient>

          <View style={s.premiumFeatures}>
            {premiumFeatures.map((f, i) => (
              <View key={i} style={s.featureRow}>
                <Ionicons name="checkmark-circle" size={18} color={Colors.primary} />
                <Text style={s.featureText}>{f.text}</Text>
              </View>
            ))}
          </View>
        </View>

        <TouchableOpacity
          style={[s.subscribeBtn, loading && s.subscribeBtnLoading]}
          onPress={handleSubscribe}
          disabled={loading}
        >
          <LinearGradient colors={['#10B981', '#059669']} style={s.subscribeBtnGradient}>
            {loading ? (
                          <Text style={s.subscribeBtnText}>{t.subscription.processing}</Text>
                        ) : (
                          <>
                            <Ionicons name="logo-apple" size={22} color="#FFF" />
                            <Text style={s.subscribeBtnText}>{t.subscription.subscribeBtn}</Text>
              </>
            )}
          </LinearGradient>
        </TouchableOpacity>

        <TouchableOpacity style={s.restoreBtn} onPress={handleRestore}>
          <Text style={s.restoreText}>{t.subscription.restorePurchases}</Text>
        </TouchableOpacity>

        <View style={s.infoBox}>
          <Ionicons name="shield-checkmark" size={20} color={Colors.primary} />
          <View style={s.infoTextContainer}>
                        <Text style={s.infoTitle}>{t.subscription.securePayment}</Text>
                        <Text style={s.infoDesc}>
                          {t.subscription.renewInfo}
                        </Text>
          </View>
        </View>

        <View style={s.legalLinks}>
          <TouchableOpacity><Text style={s.legalText}>{t.subscription.terms}</Text></TouchableOpacity>
          <Text style={s.legalDot}>{'\u2022'}</Text>
          <TouchableOpacity><Text style={s.legalText}>{t.subscription.privacy}</Text></TouchableOpacity>
        </View>
      </View>
      <View style={{ height: 40 }} />
    </ScrollView>
  );
}

const s = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.white },
  header: { paddingTop: 60, paddingBottom: 30, paddingHorizontal: 20, alignItems: 'center' },
  closeBtn: { position: 'absolute', top: 50, right: 16, width: 36, height: 36, borderRadius: 18, backgroundColor: 'rgba(255,255,255,0.2)', justifyContent: 'center', alignItems: 'center', zIndex: 10 },
  headerTitle: { fontSize: 28, fontWeight: '800', color: '#FFF', marginTop: 12, marginBottom: 8 },
  headerDesc: { fontSize: 15, color: 'rgba(255,255,255,0.9)', textAlign: 'center', lineHeight: 22 },
  statsRow: { flexDirection: 'row', alignItems: 'center', marginTop: 20, backgroundColor: 'rgba(255,255,255,0.15)', borderRadius: 16, padding: 16 },
  stat: { flex: 1, alignItems: 'center' },
  statNum: { fontSize: 22, fontWeight: '800', color: '#FFF' },
  statLabel: { fontSize: 12, color: 'rgba(255,255,255,0.8)', marginTop: 2 },
  statDivider: { width: 1, height: 30, backgroundColor: 'rgba(255,255,255,0.3)' },
  plansContainer: { padding: 20 },
  compareSection: { marginBottom: 24 },
  sectionTitle: { fontSize: 20, fontWeight: '800', color: Colors.black, marginBottom: 16 },
  compareCard: { borderRadius: 16, overflow: 'hidden', borderWidth: 1, borderColor: Colors.gray[200] },
  compareHeader: { flexDirection: 'row' },
  compareCol: { flex: 1, padding: 16, alignItems: 'center', backgroundColor: Colors.gray[50] },
  compareColPremium: { backgroundColor: Colors.primary },
  compareColTitle: { fontSize: 16, fontWeight: '800', color: Colors.black },
  compareColPrice: { fontSize: 13, fontWeight: '600', color: Colors.gray[500], marginTop: 2 },
  compareRows: { padding: 8 },
  compareRow: { flexDirection: 'row', borderBottomWidth: 1, borderBottomColor: Colors.gray[100] },
  compareCellBasic: { flex: 1, flexDirection: 'row', alignItems: 'center', gap: 6, padding: 10 },
  compareCellPremium: { flex: 1, flexDirection: 'row', alignItems: 'center', gap: 6, padding: 10 },
  compareCellText: { fontSize: 12, color: Colors.gray[600], flex: 1 },
  premiumCard: { borderRadius: 16, overflow: 'hidden', borderWidth: 2, borderColor: Colors.primary, marginBottom: 20 },
  premiumGradient: { padding: 24, alignItems: 'center', gap: 8 },
  premiumTitle: { fontSize: 22, fontWeight: '800', color: '#FFF' },
  priceRow: { flexDirection: 'row', alignItems: 'baseline' },
  priceMain: { fontSize: 36, fontWeight: '800', color: '#FFF' },
  pricePeriod: { fontSize: 16, fontWeight: '600', color: 'rgba(255,255,255,0.8)' },
  premiumDesc: { fontSize: 14, color: 'rgba(255,255,255,0.9)' },
  premiumFeatures: { padding: 16, gap: 8 },
  featureRow: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  featureText: { fontSize: 14, color: Colors.gray[700], flex: 1 },
  subscribeBtn: { borderRadius: 16, overflow: 'hidden' },
  subscribeBtnLoading: { opacity: 0.7 },
  subscribeBtnGradient: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 8, padding: 18 },
  subscribeBtnText: { color: '#FFF', fontSize: 18, fontWeight: '800' },
  restoreBtn: { alignItems: 'center', padding: 16 },
  restoreText: { color: Colors.primary, fontSize: 14, fontWeight: '600' },
  infoBox: { flexDirection: 'row', gap: 12, backgroundColor: Colors.primaryBg, borderRadius: 16, padding: 16, marginTop: 8 },
  infoTextContainer: { flex: 1 },
  infoTitle: { fontSize: 14, fontWeight: '700', color: Colors.black, marginBottom: 4 },
  infoDesc: { fontSize: 12, color: Colors.gray[600], lineHeight: 18 },
  legalLinks: { flexDirection: 'row', justifyContent: 'center', alignItems: 'center', gap: 8, marginTop: 16 },
  legalText: { fontSize: 12, color: Colors.gray[400] },
  legalDot: { fontSize: 12, color: Colors.gray[400] },
  activeCard: { backgroundColor: Colors.primaryBg, borderRadius: 16, padding: 24, alignItems: 'center', gap: 8, marginBottom: 24 },
  activeTitle: { fontSize: 18, fontWeight: '800', color: Colors.black },
  activePrice: { fontSize: 24, fontWeight: '800', color: Colors.primary },
  activeDesc: { fontSize: 14, color: Colors.gray[600], textAlign: 'center', lineHeight: 20 },
  featuresContainer: { gap: 8 },
  featuresTitle: { fontSize: 16, fontWeight: '700', color: Colors.black, marginBottom: 8 },
});
