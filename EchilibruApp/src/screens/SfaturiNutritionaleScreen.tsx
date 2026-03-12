import React from 'react';
import { View, Text, StyleSheet, ScrollView } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import { useLanguage } from '../context/LanguageContext';

export default function SfaturiNutritionaleScreen() {
  const { t } = useLanguage();

  const tips = [
  {
    id: '1',
    icon: 'water' as const,
    title: t.nutritionTips.tip1Title,
    description: t.nutritionTips.tip1Desc,
    color: '#3B82F6',
  },
  {
    id: '2',
    icon: 'leaf' as const,
    title: t.nutritionTips.tip2Title,
    description: t.nutritionTips.tip2Desc,
    color: '#10B981',
  },
  {
    id: '3',
    icon: 'time' as const,
    title: t.nutritionTips.tip3Title,
    description: t.nutritionTips.tip3Desc,
    color: '#F59E0B',
  },
  {
    id: '4',
    icon: 'nutrition' as const,
    title: t.nutritionTips.tip4Title,
    description: t.nutritionTips.tip4Desc,
    color: '#EF4444',
  },
  {
    id: '5',
    icon: 'ban' as const,
    title: t.nutritionTips.tip5Title,
    description: t.nutritionTips.tip5Desc,
    color: '#8B5CF6',
  },
  {
    id: '6',
    icon: 'fish' as const,
    title: t.nutritionTips.tip6Title,
    description: t.nutritionTips.tip6Desc,
    color: '#06B6D4',
  },
  {
    id: '7',
    icon: 'moon' as const,
    title: t.nutritionTips.tip7Title,
    description: t.nutritionTips.tip7Desc,
    color: '#6366F1',
  },
  {
    id: '8',
    icon: 'basket' as const,
    title: t.nutritionTips.tip8Title,
    description: t.nutritionTips.tip8Desc,
    color: '#EC4899',
  },
  {
    id: '9',
    icon: 'fitness' as const,
    title: t.nutritionTips.tip9Title,
    description: t.nutritionTips.tip9Desc,
    color: '#F97316',
  },
  {
    id: '10',
    icon: 'color-palette' as const,
    title: t.nutritionTips.tip10Title,
    description: t.nutritionTips.tip10Desc,
    color: '#14B8A6',
  },
];

  return (
    <ScrollView style={s.container} showsVerticalScrollIndicator={false}>
      <LinearGradient colors={['#10B981', '#059669']} style={s.header}>
        <Ionicons name="bulb" size={32} color="#FFF" />
                <Text style={s.headerTitle}>{t.nutritionTips.title}</Text>
                <Text style={s.headerDesc}>{t.nutritionTips.desc}</Text>
      </LinearGradient>

      <View style={s.tipsContainer}>
        {tips.map((tip, index) => (
          <View key={tip.id} style={s.tipCard}>
            <View style={[s.tipIconContainer, { backgroundColor: tip.color + '15' }]}>
              <Ionicons name={tip.icon} size={28} color={tip.color} />
            </View>
            <View style={s.tipContent}>
              <View style={s.tipHeader}>
                <Text style={s.tipNumber}>{index + 1}</Text>
                <Text style={s.tipTitle}>{tip.title}</Text>
              </View>
              <Text style={s.tipDescription}>{tip.description}</Text>
            </View>
          </View>
        ))}
      </View>

      <View style={s.bottomBox}>
        <LinearGradient colors={['#F0FDF4', '#DCFCE7']} style={s.bottomBoxGradient}>
          <Ionicons name="heart" size={24} color={Colors.primary} />
                    <Text style={s.bottomBoxTitle}>{t.nutritionTips.remember}</Text>
                    <Text style={s.bottomBoxText}>
                      {t.nutritionTips.rememberText}
                    </Text>
        </LinearGradient>
      </View>

      <View style={{ height: 100 }} />
    </ScrollView>
  );
}

const s = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.white },
  header: { paddingTop: 60, paddingBottom: 24, paddingHorizontal: 20, alignItems: 'center' },
  headerTitle: { fontSize: 28, fontWeight: '800', color: '#FFF', marginTop: 8, marginBottom: 8 },
  headerDesc: { fontSize: 14, color: 'rgba(255,255,255,0.9)', textAlign: 'center', lineHeight: 20 },
  tipsContainer: { padding: 16, gap: 12 },
  tipCard: {
    flexDirection: 'row',
    backgroundColor: '#FFF',
    borderRadius: 16,
    padding: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.08,
    shadowRadius: 8,
    elevation: 3,
    gap: 12,
  },
  tipIconContainer: {
    width: 52,
    height: 52,
    borderRadius: 14,
    justifyContent: 'center',
    alignItems: 'center',
  },
  tipContent: { flex: 1 },
  tipHeader: { flexDirection: 'row', alignItems: 'center', gap: 8, marginBottom: 6 },
  tipNumber: {
    fontSize: 12,
    fontWeight: '800',
    color: Colors.primary,
    backgroundColor: Colors.primary + '15',
    width: 22,
    height: 22,
    textAlign: 'center',
    lineHeight: 22,
    borderRadius: 11,
    overflow: 'hidden',
  },
  tipTitle: { fontSize: 15, fontWeight: '700', color: Colors.gray[800], flex: 1 },
  tipDescription: { fontSize: 13, color: Colors.gray[600], lineHeight: 19 },
  bottomBox: { margin: 16, borderRadius: 16, overflow: 'hidden' },
  bottomBoxGradient: { padding: 20, alignItems: 'center', gap: 8 },
  bottomBoxTitle: { fontSize: 18, fontWeight: '800', color: Colors.primary },
  bottomBoxText: { fontSize: 14, color: Colors.gray[700], textAlign: 'center', lineHeight: 20 },
});
