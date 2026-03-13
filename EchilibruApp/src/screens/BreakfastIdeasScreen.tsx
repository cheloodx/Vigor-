import React from 'react';
import { View, Text, StyleSheet, ScrollView, Image, TouchableOpacity } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import { recipes } from '../data/recipes';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import type { RootStackParamList } from '../constants/types';
import { useLanguage } from '../context/LanguageContext';

type Nav = NativeStackNavigationProp<RootStackParamList>;

export default function BreakfastIdeasScreen() {
  const navigation = useNavigation<Nav>();
  const { t } = useLanguage();
  const breakfastRecipes = recipes.filter(r => r.category === 'mic_dejun');

  return (
    <ScrollView style={s.container} showsVerticalScrollIndicator={false}>
      <LinearGradient colors={['#8B5CF6', '#7C3AED']} style={s.header}>
        <Ionicons name="sunny" size={32} color="#FFF" />
                <Text style={s.headerTitle}>{t.breakfast.title}</Text>
                <Text style={s.headerDesc}>{t.breakfast.desc}</Text>
      </LinearGradient>

      <View style={s.list}>
        {breakfastRecipes.map(r => (
          <TouchableOpacity key={r.id} style={s.card} onPress={() => navigation.navigate('RecipeDetail', { recipe: r })}>
            <Image source={{ uri: r.image }} style={s.cardImg} />
            <View style={s.cardContent}>
              <Text style={s.cardTitle}>{r.title}</Text>
              <Text style={s.cardDesc} numberOfLines={2}>{r.description}</Text>
              <View style={s.cardMeta}>
                <Text style={s.metaText}>{r.prepTime}</Text>
                <Text style={s.metaText}>{r.calories} kcal</Text>
              </View>
            </View>
          </TouchableOpacity>
        ))}
        {breakfastRecipes.length === 0 && (
          <View style={s.empty}><Text style={s.emptyText}>{t.breakfast.empty}</Text></View>
        )}
      </View>
      <View style={{ height: 100 }} />
    </ScrollView>
  );
}

const s = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.white },
  header: { paddingTop: 60, paddingBottom: 24, paddingHorizontal: 20, alignItems: 'center' },
  headerTitle: { fontSize: 24, fontWeight: '800', color: '#FFF', marginTop: 8, marginBottom: 8 },
  headerDesc: { fontSize: 14, color: 'rgba(255,255,255,0.9)', textAlign: 'center' },
  list: { padding: 16 },
  card: { flexDirection: 'row', backgroundColor: Colors.white, borderRadius: 16, marginBottom: 12, shadowColor: '#000', shadowOffset: { width: 0, height: 1 }, shadowOpacity: 0.08, shadowRadius: 4, elevation: 2, overflow: 'hidden' },
  cardImg: { width: 100, height: 100, backgroundColor: Colors.gray[200] },
  cardContent: { flex: 1, padding: 12, justifyContent: 'center' },
  cardTitle: { fontSize: 15, fontWeight: '700', color: Colors.black, marginBottom: 4 },
  cardDesc: { fontSize: 12, color: Colors.gray[500], lineHeight: 16, marginBottom: 6 },
  cardMeta: { flexDirection: 'row', gap: 12 },
  metaText: { fontSize: 11, color: Colors.gray[400] },
  empty: { padding: 40, alignItems: 'center' },
  emptyText: { fontSize: 14, color: Colors.gray[400] },
});
