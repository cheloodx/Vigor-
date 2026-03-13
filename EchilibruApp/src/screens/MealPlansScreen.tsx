import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import { weeklyMealPlan } from '../data/mealPlans';
import { useLanguage } from '../context/LanguageContext';

export default function MealPlansScreen() {
  const { t } = useLanguage();

  const mealTypeConfig: Record<string, { label: string; color: string; icon: string }> = {
    mic_dejun: { label: t.mealPlans.breakfast, color: Colors.primary, icon: 'sunny' },
    pranz: { label: t.mealPlans.lunch, color: Colors.secondary, icon: 'restaurant' },
    cina: { label: t.mealPlans.dinner, color: Colors.purple, icon: 'moon' },
  };
  const [expanded, setExpanded] = useState<string | null>('Luni');

  return (
    <ScrollView style={s.container} showsVerticalScrollIndicator={false}>
      <LinearGradient colors={Colors.gradient.primary} style={s.header}>
        <TouchableOpacity style={s.planBadge}>
          <Ionicons name="sparkles" size={14} color={Colors.primary} />
          <Text style={s.planBadgeText}>{t.mealPlans.weeklyPlan}</Text>
        </TouchableOpacity>
                <Text style={s.headerTitle}>{t.mealPlans.title}</Text>
                <Text style={s.headerDesc}>{t.mealPlans.desc}</Text>
      </LinearGradient>

      <View style={s.infoCards}>
        {[
          { icon: 'calendar', label: t.mealPlans.days7, value: t.mealPlans.complete },
          { icon: 'flame', label: t.mealPlans.calories, value: '~2000/' + t.mealPlans.dayShort },
          { icon: 'time', label: t.mealPlans.prepTime, value: '30-45 min' },
          { icon: 'cart', label: t.mealPlans.ingredients, value: t.mealPlans.simple },
        ].map((item, i) => (
          <View key={i} style={s.infoCard}>
            <Ionicons name={item.icon as keyof typeof Ionicons.glyphMap} size={24} color={i === 0 ? Colors.primary : i === 1 ? Colors.accent : i === 2 ? Colors.blue : Colors.secondary} />
            <Text style={s.infoLabel}>{item.label}</Text>
            <Text style={s.infoValue}>{item.value}</Text>
          </View>
        ))}
      </View>

      {weeklyMealPlan.map(day => (
        <TouchableOpacity key={day.day} activeOpacity={0.8} onPress={() => setExpanded(expanded === day.day ? null : day.day)}>
          <LinearGradient colors={expanded === day.day ? Colors.gradient.primary : [Colors.gray[100], Colors.gray[50]]} style={s.dayHeader}>
            <Ionicons name="calendar" size={20} color={expanded === day.day ? '#FFF' : Colors.gray[600]} />
            <View style={{ flex: 1 }}>
              <Text style={[s.dayTitle, expanded === day.day && s.dayTitleActive]}>{day.day}</Text>
              <Text style={[s.daySubtitle, expanded === day.day && s.daySubtitleActive]}>{t.mealPlans.fullDayPlan}</Text>
            </View>
            <Ionicons name={expanded === day.day ? 'chevron-up' : 'chevron-down'} size={20} color={expanded === day.day ? '#FFF' : Colors.gray[400]} />
          </LinearGradient>
          {expanded === day.day && (
            <View style={s.dayContent}>
              {day.meals.map((meal, mi) => {
                const cfg = mealTypeConfig[meal.type];
                return (
                  <View key={mi} style={s.mealRow}>
                    <View style={[s.mealBadge, { backgroundColor: cfg.color }]}>
                      <Ionicons name={cfg.icon as keyof typeof Ionicons.glyphMap} size={12} color="#FFF" />
                      <Text style={s.mealBadgeText}>{cfg.label}</Text>
                    </View>
                    <View style={s.mealInfo}>
                      <View style={s.mealNameRow}>
                        <Ionicons name="checkmark" size={16} color={Colors.primary} />
                        <Text style={s.mealName}>{meal.name}</Text>
                      </View>
                      <View style={s.mealMeta}>
                        <Text style={s.mealMetaText}>{meal.prepTime}</Text>
                        <Text style={s.mealMetaText}>~{meal.calories} kcal</Text>
                      </View>
                    </View>
                  </View>
                );
              })}
            </View>
          )}
        </TouchableOpacity>
      ))}
      <View style={{ height: 100 }} />
    </ScrollView>
  );
}

const s = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.white },
  header: { paddingTop: 60, paddingBottom: 24, paddingHorizontal: 20, alignItems: 'center' },
  planBadge: { flexDirection: 'row', alignItems: 'center', gap: 6, backgroundColor: '#FFF', paddingHorizontal: 14, paddingVertical: 8, borderRadius: 20, marginBottom: 12 },
  planBadgeText: { fontSize: 13, fontWeight: '600', color: Colors.primary },
  headerTitle: { fontSize: 28, fontWeight: '800', color: '#FFF', marginBottom: 8 },
  headerDesc: { fontSize: 14, color: 'rgba(255,255,255,0.9)', textAlign: 'center', lineHeight: 20 },
  infoCards: { flexDirection: 'row', padding: 16, gap: 8 },
  infoCard: { flex: 1, backgroundColor: Colors.gray[50], borderRadius: 12, padding: 12, alignItems: 'center', gap: 4 },
  infoLabel: { fontSize: 11, color: Colors.gray[500] },
  infoValue: { fontSize: 14, fontWeight: '700', color: Colors.black },
  dayHeader: { flexDirection: 'row', alignItems: 'center', gap: 12, marginHorizontal: 16, marginTop: 8, padding: 16, borderRadius: 16 },
  dayTitle: { fontSize: 18, fontWeight: '700', color: Colors.black },
  dayTitleActive: { color: '#FFF' },
  daySubtitle: { fontSize: 12, color: Colors.gray[500] },
  daySubtitleActive: { color: 'rgba(255,255,255,0.8)' },
  dayContent: { marginHorizontal: 16, padding: 16, backgroundColor: Colors.gray[50], borderBottomLeftRadius: 16, borderBottomRightRadius: 16 },
  mealRow: { marginBottom: 16 },
  mealBadge: { flexDirection: 'row', alignItems: 'center', gap: 4, alignSelf: 'flex-start', paddingHorizontal: 10, paddingVertical: 4, borderRadius: 12, marginBottom: 6 },
  mealBadgeText: { color: '#FFF', fontSize: 11, fontWeight: '600' },
  mealInfo: { paddingLeft: 4 },
  mealNameRow: { flexDirection: 'row', alignItems: 'center', gap: 6, marginBottom: 2 },
  mealName: { fontSize: 14, fontWeight: '600', color: Colors.black },
  mealMeta: { flexDirection: 'row', gap: 12, marginLeft: 22 },
  mealMetaText: { fontSize: 12, color: Colors.gray[500] },
});
