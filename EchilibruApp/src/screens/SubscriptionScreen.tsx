import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, Alert } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import type { RootStackParamList } from '../constants/types';

type Props = NativeStackScreenProps<RootStackParamList, 'Subscription'>;

interface PlanFeature {
  text: string;
  included: boolean;
}

interface SubscriptionPlan {
  id: string;
  name: string;
  price: string;
  period: string;
  description: string;
  features: PlanFeature[];
  gradient: [string, string];
  icon: keyof typeof Ionicons.glyphMap;
  badge?: string;
  appleProductId: string;
}

const plans: SubscriptionPlan[] = [
  {
    id: 'monthly',
    name: 'Lunar',
    price: '29.99 RON',
    period: '/luna',
    description: 'Acces complet la toate functiile premium',
    gradient: ['#10B981', '#059669'],
    icon: 'leaf',
    appleProductId: 'com.echilibru.monthly',
    features: [
      { text: 'Toate cele 122 retete complete', included: true },
      { text: 'Toate cele 85 exercitii cu video', included: true },
      { text: 'Planuri alimentare personalizate', included: true },
      { text: 'Planuri de antrenament complete', included: true },
      { text: 'Calculator de calorii avansat', included: true },
      { text: 'Sfaturi nutritionale expert', included: true },
      { text: 'Lista de cumparaturi smart', included: true },
      { text: 'Fara reclame', included: true },
      { text: 'Suport prioritar', included: false },
      { text: 'Consultanta nutritionala 1-la-1', included: false },
    ],
  },
  {
    id: 'yearly',
    name: 'Anual',
    price: '199.99 RON',
    period: '/an',
    description: 'Cel mai bun pret! Economisesti 44%',
    gradient: ['#F59E0B', '#D97706'],
    icon: 'diamond',
    badge: 'BEST VALUE',
    appleProductId: 'com.echilibru.yearly',
    features: [
      { text: 'Toate cele 122 retete complete', included: true },
      { text: 'Toate cele 85 exercitii cu video', included: true },
      { text: 'Planuri alimentare personalizate', included: true },
      { text: 'Planuri de antrenament complete', included: true },
      { text: 'Calculator de calorii avansat', included: true },
      { text: 'Sfaturi nutritionale expert', included: true },
      { text: 'Lista de cumparaturi smart', included: true },
      { text: 'Fara reclame', included: true },
      { text: 'Suport prioritar 24/7', included: true },
      { text: 'Consultanta nutritionala 1-la-1', included: true },
    ],
  },
];

export default function SubscriptionScreen({ navigation }: Props) {
  const [selectedPlan, setSelectedPlan] = useState<string>('yearly');
  const [loading, setLoading] = useState(false);

  const handleSubscribe = async () => {
    const plan = plans.find(p => p.id === selectedPlan);
    if (!plan) return;

    setLoading(true);
    
    setTimeout(() => {
      setLoading(false);
      Alert.alert(
        'Abonament Activat!',
        `Felicitari! Ai activat abonamentul ${plan.name} (${plan.price}${plan.period}).\n\nAcum ai acces la toate functiile premium ale aplicatiei Echilibru.`,
        [
          {
            text: 'Excelent!',
            onPress: () => navigation.goBack(),
          },
        ]
      );
    }, 2000);
  };

  const handleRestore = () => {
    Alert.alert(
      'Restaurare Achizitii',
      'Se verifica achizitiile anterioare prin Apple ID...',
      [{ text: 'OK' }]
    );
  };

  return (
    <ScrollView style={s.container} showsVerticalScrollIndicator={false}>
      <LinearGradient colors={['#10B981', '#059669']} style={s.header}>
        <TouchableOpacity style={s.closeBtn} onPress={() => navigation.goBack()}>
          <Ionicons name="close" size={24} color="#FFF" />
        </TouchableOpacity>
        <Ionicons name="star" size={48} color="#FFF" />
        <Text style={s.headerTitle}>Echilibru Premium</Text>
        <Text style={s.headerDesc}>Deblocheaza tot continutul si toate functiile pentru o viata mai sanatoasa</Text>
        
        <View style={s.statsRow}>
          <View style={s.stat}>
            <Text style={s.statNum}>122</Text>
            <Text style={s.statLabel}>Retete</Text>
          </View>
          <View style={s.statDivider} />
          <View style={s.stat}>
            <Text style={s.statNum}>85</Text>
            <Text style={s.statLabel}>Exercitii</Text>
          </View>
          <View style={s.statDivider} />
          <View style={s.stat}>
            <Text style={s.statNum}>Video</Text>
            <Text style={s.statLabel}>HD</Text>
          </View>
        </View>
      </LinearGradient>

      <View style={s.plansContainer}>
        <Text style={s.sectionTitle}>Alege Abonamentul</Text>

        {plans.map((plan) => (
          <TouchableOpacity
            key={plan.id}
            style={[s.planCard, selectedPlan === plan.id && s.planCardSelected]}
            onPress={() => setSelectedPlan(plan.id)}
          >
            {plan.badge && (
              <View style={s.planBadge}>
                <Text style={s.planBadgeText}>{plan.badge}</Text>
              </View>
            )}
            
            <View style={s.planHeader}>
              <View style={s.planRadio}>
                {selectedPlan === plan.id && <View style={s.planRadioInner} />}
              </View>
              <View style={s.planInfo}>
                <View style={s.planNameRow}>
                  <LinearGradient colors={plan.gradient} style={s.planIcon}>
                    <Ionicons name={plan.icon} size={20} color="#FFF" />
                  </LinearGradient>
                  <Text style={s.planName}>{plan.name}</Text>
                </View>
                <Text style={s.planDesc}>{plan.description}</Text>
              </View>
              <View style={s.planPricing}>
                <Text style={s.planPrice}>{plan.price}</Text>
                <Text style={s.planPeriod}>{plan.period}</Text>
              </View>
            </View>

            {selectedPlan === plan.id && (
              <View style={s.featuresContainer}>
                {plan.features.map((feature, idx) => (
                  <View key={idx} style={s.featureRow}>
                    <Ionicons
                      name={feature.included ? 'checkmark-circle' : 'close-circle'}
                      size={18}
                      color={feature.included ? Colors.primary : Colors.gray[300]}
                    />
                    <Text style={[s.featureText, !feature.included && s.featureDisabled]}>
                      {feature.text}
                    </Text>
                  </View>
                ))}
              </View>
            )}
          </TouchableOpacity>
        ))}

        <TouchableOpacity
          style={[s.subscribeBtn, loading && s.subscribeBtnLoading]}
          onPress={handleSubscribe}
          disabled={loading}
        >
          <LinearGradient
            colors={selectedPlan === 'yearly' ? ['#F59E0B', '#D97706'] : ['#10B981', '#059669']}
            style={s.subscribeBtnGradient}
          >
            {loading ? (
              <Text style={s.subscribeBtnText}>Se proceseaza...</Text>
            ) : (
              <>
                <Ionicons name="logo-apple" size={22} color="#FFF" />
                <Text style={s.subscribeBtnText}>
                  Aboneaza-te cu Apple Pay
                </Text>
              </>
            )}
          </LinearGradient>
        </TouchableOpacity>

        <TouchableOpacity style={s.restoreBtn} onPress={handleRestore}>
          <Text style={s.restoreText}>Restaureaza achizitiile</Text>
        </TouchableOpacity>

        <View style={s.infoBox}>
          <Ionicons name="shield-checkmark" size={20} color={Colors.primary} />
          <View style={s.infoTextContainer}>
            <Text style={s.infoTitle}>Plata securizata prin Apple</Text>
            <Text style={s.infoDesc}>
              Abonamentul se renoieste automat. Poti anula oricand din Setari &gt; Apple ID &gt; Abonamente.
              Plata se proceseaza prin contul tau Apple ID.
            </Text>
          </View>
        </View>

        <View style={s.legalLinks}>
          <TouchableOpacity><Text style={s.legalText}>Termeni si Conditii</Text></TouchableOpacity>
          <Text style={s.legalDot}>{'\u2022'}</Text>
          <TouchableOpacity><Text style={s.legalText}>Politica de Confidentialitate</Text></TouchableOpacity>
        </View>
      </View>
      <View style={{ height: 40 }} />
    </ScrollView>
  );
}

const s = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.white },
  header: { paddingTop: 60, paddingBottom: 30, paddingHorizontal: 20, alignItems: 'center' },
  closeBtn: { position: 'absolute', top: 50, right: 16, width: 36, height: 36, borderRadius: 18, backgroundColor: 'rgba(255,255,255,0.2)', justifyContent: 'center', alignItems: 'center' },
  headerTitle: { fontSize: 28, fontWeight: '800', color: '#FFF', marginTop: 12, marginBottom: 8 },
  headerDesc: { fontSize: 15, color: 'rgba(255,255,255,0.9)', textAlign: 'center', lineHeight: 22 },
  statsRow: { flexDirection: 'row', alignItems: 'center', marginTop: 20, backgroundColor: 'rgba(255,255,255,0.15)', borderRadius: 16, padding: 16 },
  stat: { flex: 1, alignItems: 'center' },
  statNum: { fontSize: 22, fontWeight: '800', color: '#FFF' },
  statLabel: { fontSize: 12, color: 'rgba(255,255,255,0.8)', marginTop: 2 },
  statDivider: { width: 1, height: 30, backgroundColor: 'rgba(255,255,255,0.3)' },
  plansContainer: { padding: 20 },
  sectionTitle: { fontSize: 20, fontWeight: '800', color: Colors.black, marginBottom: 16 },
  planCard: { borderWidth: 2, borderColor: Colors.gray[200], borderRadius: 16, marginBottom: 16, overflow: 'hidden' },
  planCardSelected: { borderColor: Colors.primary },
  planBadge: { position: 'absolute', top: 0, right: 0, backgroundColor: '#F59E0B', paddingHorizontal: 12, paddingVertical: 4, borderBottomLeftRadius: 12, zIndex: 1 },
  planBadgeText: { color: '#FFF', fontSize: 11, fontWeight: '800' },
  planHeader: { flexDirection: 'row', alignItems: 'center', padding: 16, gap: 12 },
  planRadio: { width: 22, height: 22, borderRadius: 11, borderWidth: 2, borderColor: Colors.primary, justifyContent: 'center', alignItems: 'center' },
  planRadioInner: { width: 12, height: 12, borderRadius: 6, backgroundColor: Colors.primary },
  planInfo: { flex: 1 },
  planNameRow: { flexDirection: 'row', alignItems: 'center', gap: 8, marginBottom: 4 },
  planIcon: { width: 32, height: 32, borderRadius: 16, justifyContent: 'center', alignItems: 'center' },
  planName: { fontSize: 18, fontWeight: '800', color: Colors.black },
  planDesc: { fontSize: 13, color: Colors.gray[500] },
  planPricing: { alignItems: 'flex-end' },
  planPrice: { fontSize: 18, fontWeight: '800', color: Colors.primary },
  planPeriod: { fontSize: 12, color: Colors.gray[500] },
  featuresContainer: { paddingHorizontal: 16, paddingBottom: 16, gap: 8 },
  featureRow: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  featureText: { fontSize: 14, color: Colors.gray[700] },
  featureDisabled: { color: Colors.gray[400] },
  subscribeBtn: { marginTop: 8, borderRadius: 16, overflow: 'hidden' },
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
});
