import React from 'react';
import { View, Text, StyleSheet, ScrollView } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';

const tips = [
  {
    id: '1',
    icon: 'water' as const,
    title: 'Hidratarea este Esentiala',
    description: 'Bea cel putin 2 litri de apa pe zi. Hidratarea corecta ajuta la digestie, absorbtia nutrientilor si mentinerea energiei. Incepe dimineata cu un pahar de apa calda cu lamaie.',
    color: '#3B82F6',
  },
  {
    id: '2',
    icon: 'leaf' as const,
    title: 'Mananca Legume la Fiecare Masa',
    description: 'Legumele furnizeaza vitamine, minerale si fibre esentiale. Incearca sa umplii jumatate din farfurie cu legume la fiecare masa principala.',
    color: '#10B981',
  },
  {
    id: '3',
    icon: 'time' as const,
    title: 'Nu Sari Peste Micul Dejun',
    description: 'Micul dejun activeaza metabolismul si iti ofera energia necesara pentru inceputut zilei. Alege proteine, fibre si grasimi sanatoase.',
    color: '#F59E0B',
  },
  {
    id: '4',
    icon: 'nutrition' as const,
    title: 'Proteina la Fiecare Masa',
    description: 'Proteinele ajuta la constructia si repararea tesuturilor musculare, mentin satietatea si stabilizeaza glicemia. Include surse variate: pui, peste, oua, leguminoase.',
    color: '#EF4444',
  },
  {
    id: '5',
    icon: 'ban' as const,
    title: 'Limiteaza Zaharul Adaugat',
    description: 'Zaharul adaugat contribuie la inflamatie, obezitate si boli cronice. Citeste etichetele si alege alternative naturale precum fructele proaspete.',
    color: '#8B5CF6',
  },
  {
    id: '6',
    icon: 'fish' as const,
    title: 'Omega-3 pentru Sanatatea Creierului',
    description: 'Acizii grasi omega-3 din peste, nuci si seminte de in sustin functia cognitiva si reduc inflamatia. Consuma peste gras de 2-3 ori pe saptamana.',
    color: '#06B6D4',
  },
  {
    id: '7',
    icon: 'moon' as const,
    title: 'Evita Mesele Tarziu in Noapte',
    description: 'Manancatul tarziu poate afecta calitatea somnului si digestia. Ultima masa ar trebui sa fie cu cel putin 2-3 ore inainte de culcare.',
    color: '#6366F1',
  },
  {
    id: '8',
    icon: 'basket' as const,
    title: 'Planifica-ti Mesele',
    description: 'Planificarea meselor reduce risul de a alege mancaruri nesanatoase din impuls. Pregateste meniul saptamanal si fa cumparaturile in avans.',
    color: '#EC4899',
  },
  {
    id: '9',
    icon: 'fitness' as const,
    title: 'Combina Nutritia cu Exercitiul',
    description: 'O alimentatie echilibrata si exercitiul fizic regulat lucreaza sinergic. Mananca proteine dupa antrenament si carbohidrati inainte pentru energie.',
    color: '#F97316',
  },
  {
    id: '10',
    icon: 'color-palette' as const,
    title: 'Mananca Colorat',
    description: 'Fiecare culoare din legume si fructe indica nutrienti diferiti. Cu cat farfuria ta este mai colorata, cu atat primesti o gama mai variata de vitamine.',
    color: '#14B8A6',
  },
];

export default function SfaturiNutritionaleScreen() {
  return (
    <ScrollView style={s.container} showsVerticalScrollIndicator={false}>
      <LinearGradient colors={['#10B981', '#059669']} style={s.header}>
        <Ionicons name="bulb" size={32} color="#FFF" />
        <Text style={s.headerTitle}>Sfaturi Nutritionale</Text>
        <Text style={s.headerDesc}>Ghid complet pentru o alimentatie sanatoasa si echilibrata</Text>
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
          <Text style={s.bottomBoxTitle}>Retine!</Text>
          <Text style={s.bottomBoxText}>
            O alimentatie sanatoasa nu inseamna restrictie, ci echilibru. Asculta-ti corpul, mananca cu placere si fii constant in alegerile sanatoase.
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
