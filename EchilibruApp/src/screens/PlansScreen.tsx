import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import { useNavigation } from '@react-navigation/native';

export default function PlansScreen() {
  const navigation = useNavigation<any>();

  return (
    <ScrollView style={s.container} showsVerticalScrollIndicator={false}>
      <LinearGradient colors={Colors.gradient.primary} style={s.header}>
        <Ionicons name="clipboard" size={32} color="#FFF" />
        <Text style={s.headerTitle}>Planuri</Text>
        <Text style={s.headerDesc}>Alege intre planuri de mese si planuri de antrenament personalizate.</Text>
      </LinearGradient>

      <View style={s.cards}>
        <TouchableOpacity style={s.card} onPress={() => navigation.navigate('MealPlans')}>
          <LinearGradient colors={['#10B981', '#059669']} style={s.cardGradient}>
            <Ionicons name="restaurant" size={32} color="#FFF" />
            <Text style={s.cardTitle}>Planuri de Mese</Text>
            <Text style={s.cardDesc}>Planuri saptamanale echilibrate cu ~2000 cal/zi</Text>
            <View style={s.cardBadge}><Text style={s.cardBadgeText}>7 Zile</Text></View>
          </LinearGradient>
        </TouchableOpacity>

        <TouchableOpacity style={s.card} onPress={() => navigation.navigate('TrainingPlans')}>
          <LinearGradient colors={['#F97316', '#EA580C']} style={s.cardGradient}>
            <Ionicons name="barbell" size={32} color="#FFF" />
            <Text style={s.cardTitle}>Planuri de Antrenament</Text>
            <Text style={s.cardDesc}>Programe complete pentru toate nivelurile</Text>
            <View style={s.cardBadge}><Text style={s.cardBadgeText}>3 Planuri</Text></View>
          </LinearGradient>
        </TouchableOpacity>

        <TouchableOpacity style={s.card} onPress={() => navigation.navigate('BreakfastIdeas')}>
          <LinearGradient colors={['#8B5CF6', '#7C3AED']} style={s.cardGradient}>
            <Ionicons name="sunny" size={32} color="#FFF" />
            <Text style={s.cardTitle}>Idei Mic Dejun</Text>
            <Text style={s.cardDesc}>Inspiratie pentru un mic dejun sanatos si energizant</Text>
            <View style={s.cardBadge}><Text style={s.cardBadgeText}>Zilnic</Text></View>
          </LinearGradient>
        </TouchableOpacity>

        <TouchableOpacity style={s.card} onPress={() => navigation.navigate('SfaturiNutritionale')}>
          <LinearGradient colors={['#06B6D4', '#0891B2']} style={s.cardGradient}>
            <Ionicons name="bulb" size={32} color="#FFF" />
            <Text style={s.cardTitle}>Sfaturi Nutritionale</Text>
            <Text style={s.cardDesc}>Ghid complet pentru o alimentatie sanatoasa si echilibrata</Text>
            <View style={s.cardBadge}><Text style={s.cardBadgeText}>10 Sfaturi</Text></View>
          </LinearGradient>
        </TouchableOpacity>

        <TouchableOpacity style={s.card} onPress={() => navigation.navigate('CalculatorCalorii')}>
          <LinearGradient colors={['#F59E0B', '#D97706']} style={s.cardGradient}>
            <Ionicons name="calculator" size={32} color="#FFF" />
            <Text style={s.cardTitle}>Calculator de Calorii</Text>
            <Text style={s.cardDesc}>Calculeaza necesarul tau zilnic de calorii personalizat</Text>
            <View style={s.cardBadge}><Text style={s.cardBadgeText}>Personalizat</Text></View>
          </LinearGradient>
        </TouchableOpacity>

        <TouchableOpacity style={s.card} onPress={() => navigation.navigate('Subscription')}>
          <LinearGradient colors={['#EF4444', '#DC2626']} style={s.cardGradient}>
            <Ionicons name="star" size={32} color="#FFF" />
            <Text style={s.cardTitle}>Premium - {'\u00A3'}4.99/luna</Text>
            <Text style={s.cardDesc}>Acces complet la tot: retete, exercitii, video, Apple Watch si notificari</Text>
            <View style={s.cardBadge}><Text style={s.cardBadgeText}>Un Singur Abonament</Text></View>
          </LinearGradient>
        </TouchableOpacity>
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
  cards: { padding: 20, gap: 16 },
  card: { borderRadius: 20, overflow: 'hidden', shadowColor: '#000', shadowOffset: { width: 0, height: 4 }, shadowOpacity: 0.15, shadowRadius: 12, elevation: 5 },
  cardGradient: { padding: 24, alignItems: 'center', gap: 8 },
  cardTitle: { fontSize: 20, fontWeight: '800', color: '#FFF' },
  cardDesc: { fontSize: 14, color: 'rgba(255,255,255,0.9)', textAlign: 'center' },
  cardBadge: { backgroundColor: 'rgba(255,255,255,0.2)', paddingHorizontal: 16, paddingVertical: 6, borderRadius: 20, marginTop: 8 },
  cardBadgeText: { color: '#FFF', fontWeight: '700', fontSize: 13 },
});
