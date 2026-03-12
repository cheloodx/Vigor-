import React from 'react';
import { View, Text, StyleSheet, ScrollView, Image, TouchableOpacity } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import type { RootStackParamList } from '../constants/types';

type Props = NativeStackScreenProps<RootStackParamList, 'TrainingPlanDetail'>;

export default function TrainingPlanDetailScreen({ route, navigation }: Props) {
  const { plan } = route.params;

  return (
    <ScrollView style={s.container} showsVerticalScrollIndicator={false}>
      <Image source={{ uri: plan.image }} style={s.image} />
      <TouchableOpacity style={s.back} onPress={() => navigation.goBack()}>
        <Ionicons name="arrow-back" size={24} color="#FFF" />
      </TouchableOpacity>
      <View style={s.content}>
        <Text style={s.title}>{plan.title}</Text>
        <Text style={s.desc}>{plan.description}</Text>
        <View style={s.statsRow}>
          <View style={s.statItem}><Text style={s.statValue}>{plan.duration}</Text><Text style={s.statLabel}>Durata</Text></View>
          <View style={s.statItem}><Text style={s.statValue}>{plan.daysPerWeek} zile/sapt</Text><Text style={s.statLabel}>Frecventa</Text></View>
        </View>
        {plan.isPremium && (
          <View style={s.premCard}>
            <Ionicons name="lock-closed" size={24} color={Colors.secondary} />
            <Text style={s.premTitle}>Continut Premium</Text>
            <Text style={s.premDesc}>Aboneaza-te pentru a accesa acest plan complet de antrenament.</Text>
            <TouchableOpacity style={s.premBtn}><Text style={s.premBtnText}>Aboneaza-te - 29 RON/luna</Text></TouchableOpacity>
          </View>
        )}
      </View>
      <View style={{ height: 40 }} />
    </ScrollView>
  );
}

const s = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.white },
  image: { width: '100%', height: 250, backgroundColor: Colors.gray[200] },
  back: { position: 'absolute', top: 50, left: 16, width: 40, height: 40, borderRadius: 20, backgroundColor: 'rgba(0,0,0,0.4)', justifyContent: 'center', alignItems: 'center' },
  content: { padding: 20, marginTop: -20, backgroundColor: Colors.white, borderTopLeftRadius: 20, borderTopRightRadius: 20 },
  title: { fontSize: 24, fontWeight: '800', color: Colors.black, marginBottom: 8 },
  desc: { fontSize: 15, color: Colors.gray[600], lineHeight: 22, marginBottom: 20 },
  statsRow: { flexDirection: 'row', gap: 16, marginBottom: 20 },
  statItem: { flex: 1, backgroundColor: Colors.primaryBg, borderRadius: 12, padding: 16, alignItems: 'center' },
  statValue: { fontSize: 16, fontWeight: '700', color: Colors.primary, marginBottom: 4 },
  statLabel: { fontSize: 12, color: Colors.gray[500] },
  premCard: { backgroundColor: Colors.secondaryLight, borderRadius: 16, padding: 20, alignItems: 'center', gap: 8 },
  premTitle: { fontSize: 18, fontWeight: '700', color: Colors.black },
  premDesc: { fontSize: 14, color: Colors.gray[600], textAlign: 'center' },
  premBtn: { backgroundColor: Colors.secondary, paddingHorizontal: 24, paddingVertical: 12, borderRadius: 12, marginTop: 8 },
  premBtnText: { color: '#FFF', fontWeight: '700', fontSize: 14 },
});
