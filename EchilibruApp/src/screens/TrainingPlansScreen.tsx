import React from 'react';
import { View, Text, StyleSheet, ScrollView, Image, TouchableOpacity } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import { trainingPlans } from '../data/trainingPlans';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import type { RootStackParamList } from '../constants/types';

type Nav = NativeStackNavigationProp<RootStackParamList>;

const levelColor: Record<string, string> = { incepator: Colors.primary, intermediar: Colors.secondary, avansat: Colors.accent };
const levelLabel: Record<string, string> = { incepator: 'Incepator', intermediar: 'Intermediar', avansat: 'Avansat' };

export default function TrainingPlansScreen() {
  const navigation = useNavigation<Nav>();

  return (
    <ScrollView style={s.container} showsVerticalScrollIndicator={false}>
      <LinearGradient colors={Colors.gradient.primary} style={s.header}>
        <Ionicons name="barbell" size={32} color="#FFF" />
        <Text style={s.headerTitle}>Planuri de Antrenament</Text>
        <Text style={s.headerDesc}>Programe complete de antrenament pentru toate nivelurile. Urmeaza un plan structurat si ating-ti obiectivele tale!</Text>
      </LinearGradient>

      <View style={s.countBar}>
        <Text style={s.countTitle}>Planuri disponibile ({trainingPlans.length})</Text>
        <Text style={s.countDesc}>Alege planul potrivit pentru nivelul tau de experienta si obiectivele tale.</Text>
      </View>

      {trainingPlans.map(plan => (
        <TouchableOpacity key={plan.id} style={s.card} onPress={() => navigation.navigate('TrainingPlanDetail', { plan })}>
          <Image source={{ uri: plan.image }} style={s.cardImage} />
          {plan.isPremium && (
            <View style={s.premBadge}><Ionicons name="star" size={10} color="#FFF" /><Text style={s.premText}>Premium</Text></View>
          )}
          <View style={s.cardContent}>
            <Text style={s.cardTitle}>{plan.title}</Text>
            <Text style={s.cardDesc} numberOfLines={2}>{plan.description}</Text>
            <View style={s.tags}>
              <View style={[s.tag, { backgroundColor: (levelColor[plan.level] || Colors.primary) + '20' }]}>
                <Text style={[s.tagText, { color: levelColor[plan.level] || Colors.primary }]}>{levelLabel[plan.level]}</Text>
              </View>
              {plan.tags.slice(1).map((t, i) => (
                <View key={i} style={[s.tag, { backgroundColor: Colors.gray[100] }]}>
                  <Text style={[s.tagText, { color: Colors.gray[600] }]}>{t}</Text>
                </View>
              ))}
            </View>
            <View style={s.statsRow}>
              <View style={s.statItem}><Text style={s.statValue}>{plan.duration.split(' ')[0]}</Text><Text style={s.statUnit}>saptamani</Text><Text style={s.statLabel}>Durata</Text></View>
              <View style={s.statItem}><Text style={s.statValue}>{plan.daysPerWeek}</Text><Text style={s.statUnit}>Zile/sapt</Text><Text style={s.statLabel}>Frecventa</Text></View>
              <View style={s.statItem}><Text style={s.statValue}>{plan.exerciseCount}</Text><Text style={s.statUnit}>Exercitii</Text><Text style={s.statLabel}>Per sesiune</Text></View>
            </View>
          </View>
        </TouchableOpacity>
      ))}
      <View style={{ height: 100 }} />
    </ScrollView>
  );
}

const s = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.white },
  header: { paddingTop: 60, paddingBottom: 24, paddingHorizontal: 20, alignItems: 'center' },
  headerTitle: { fontSize: 24, fontWeight: '800', color: '#FFF', marginTop: 8, marginBottom: 8 },
  headerDesc: { fontSize: 14, color: 'rgba(255,255,255,0.9)', textAlign: 'center', lineHeight: 20 },
  countBar: { padding: 16, borderBottomWidth: 1, borderBottomColor: Colors.gray[100] },
  countTitle: { fontSize: 18, fontWeight: '700', color: Colors.black },
  countDesc: { fontSize: 13, color: Colors.gray[500], marginTop: 2 },
  card: { marginHorizontal: 16, marginTop: 16, borderRadius: 16, backgroundColor: Colors.white, shadowColor: '#000', shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 8, elevation: 3, overflow: 'hidden' },
  cardImage: { width: '100%', height: 160, backgroundColor: Colors.gray[200] },
  premBadge: { position: 'absolute', top: 12, right: 12, flexDirection: 'row', alignItems: 'center', gap: 4, backgroundColor: Colors.primary, paddingHorizontal: 10, paddingVertical: 4, borderRadius: 12 },
  premText: { color: '#FFF', fontSize: 11, fontWeight: '600' },
  cardContent: { padding: 16 },
  cardTitle: { fontSize: 18, fontWeight: '700', color: Colors.black, marginBottom: 6 },
  cardDesc: { fontSize: 13, color: Colors.gray[500], lineHeight: 18, marginBottom: 12 },
  tags: { flexDirection: 'row', gap: 6, marginBottom: 16, flexWrap: 'wrap' },
  tag: { paddingHorizontal: 10, paddingVertical: 4, borderRadius: 10 },
  tagText: { fontSize: 12, fontWeight: '600' },
  statsRow: { flexDirection: 'row', justifyContent: 'space-around', backgroundColor: Colors.primaryBg, borderRadius: 12, padding: 12 },
  statItem: { alignItems: 'center' },
  statValue: { fontSize: 22, fontWeight: '800', color: Colors.primary },
  statUnit: { fontSize: 11, color: Colors.gray[500] },
  statLabel: { fontSize: 10, color: Colors.gray[400], marginTop: 2 },
});
