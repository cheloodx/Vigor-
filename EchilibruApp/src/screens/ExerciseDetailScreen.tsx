import React from 'react';
import { View, Text, StyleSheet, ScrollView, Image, TouchableOpacity } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import type { RootStackParamList } from '../constants/types';

type Props = NativeStackScreenProps<RootStackParamList, 'ExerciseDetail'>;

export default function ExerciseDetailScreen({ route, navigation }: Props) {
  const { exercise } = route.params;
  const diffColor: Record<string, string> = { incepator: Colors.primary, intermediar: Colors.secondary, avansat: Colors.accent };
  const diffLabel: Record<string, string> = { incepator: 'Incepator', intermediar: 'Intermediar', avansat: 'Avansat' };

  return (
    <ScrollView style={s.container} showsVerticalScrollIndicator={false}>
      <Image source={{ uri: exercise.image }} style={s.image} />
      <TouchableOpacity style={s.back} onPress={() => navigation.goBack()}>
        <Ionicons name="arrow-back" size={24} color="#FFF" />
      </TouchableOpacity>

      {exercise.hasVideo && (
        <View style={s.playBtn}><Ionicons name="play" size={40} color="#FFF" /></View>
      )}

      <View style={s.content}>
        <View style={s.badges}>
          <View style={[s.diffBadge, { backgroundColor: (diffColor[exercise.difficulty] || Colors.primary) + '20' }]}>
            <Text style={[s.diffText, { color: diffColor[exercise.difficulty] || Colors.primary }]}>{diffLabel[exercise.difficulty]}</Text>
          </View>
          <View style={s.muscleBadge}><Text style={s.muscleText}>{exercise.muscleGroup}</Text></View>
          {exercise.isPremium && (
            <View style={s.premBadge}><Ionicons name="star" size={12} color="#FFF" /><Text style={s.premText}>Premium</Text></View>
          )}
        </View>

        <Text style={s.title}>{exercise.name}</Text>
        <Text style={s.desc}>{exercise.description}</Text>

        {(exercise.sets || exercise.reps) && (
          <View style={s.setsRow}>
            {exercise.sets && <View style={s.setItem}><Text style={s.setLabel}>Seturi</Text><Text style={s.setValue}>{exercise.sets}</Text></View>}
            {exercise.reps && <View style={s.setItem}><Text style={s.setLabel}>Repetari</Text><Text style={s.setValue}>{exercise.reps}</Text></View>}
          </View>
        )}

        <Text style={s.sectionTitle}>Instructiuni</Text>
        {exercise.instructions.map((inst, i) => (
          <View key={i} style={s.stepRow}>
            <View style={s.stepNum}><Text style={s.stepNumText}>{i + 1}</Text></View>
            <Text style={s.stepText}>{inst}</Text>
          </View>
        ))}
      </View>
      <View style={{ height: 40 }} />
    </ScrollView>
  );
}

const s = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.white },
  image: { width: '100%', height: 300, backgroundColor: Colors.gray[200] },
  back: { position: 'absolute', top: 50, left: 16, width: 40, height: 40, borderRadius: 20, backgroundColor: 'rgba(0,0,0,0.4)', justifyContent: 'center', alignItems: 'center' },
  playBtn: { position: 'absolute', top: 130, alignSelf: 'center', width: 70, height: 70, borderRadius: 35, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', alignItems: 'center' },
  content: { padding: 20, marginTop: -20, backgroundColor: Colors.white, borderTopLeftRadius: 20, borderTopRightRadius: 20 },
  badges: { flexDirection: 'row', gap: 8, marginBottom: 12, flexWrap: 'wrap' },
  diffBadge: { paddingHorizontal: 12, paddingVertical: 4, borderRadius: 12 },
  diffText: { fontSize: 12, fontWeight: '700' },
  muscleBadge: { backgroundColor: Colors.blue + '20', paddingHorizontal: 12, paddingVertical: 4, borderRadius: 12 },
  muscleText: { fontSize: 12, fontWeight: '700', color: Colors.blue },
  premBadge: { flexDirection: 'row', alignItems: 'center', gap: 4, backgroundColor: Colors.primary, paddingHorizontal: 10, paddingVertical: 4, borderRadius: 12 },
  premText: { color: '#FFF', fontSize: 12, fontWeight: '600' },
  title: { fontSize: 24, fontWeight: '800', color: Colors.black, marginBottom: 8 },
  desc: { fontSize: 15, color: Colors.gray[600], lineHeight: 22, marginBottom: 20 },
  setsRow: { flexDirection: 'row', gap: 16, backgroundColor: Colors.primaryBg, borderRadius: 16, padding: 16, marginBottom: 20 },
  setItem: { flex: 1, alignItems: 'center' },
  setLabel: { fontSize: 12, color: Colors.gray[500], marginBottom: 4 },
  setValue: { fontSize: 20, fontWeight: '800', color: Colors.primary },
  sectionTitle: { fontSize: 18, fontWeight: '700', color: Colors.black, marginBottom: 12, marginTop: 8 },
  stepRow: { flexDirection: 'row', alignItems: 'flex-start', gap: 12, marginBottom: 12 },
  stepNum: { width: 28, height: 28, borderRadius: 14, backgroundColor: Colors.primary, justifyContent: 'center', alignItems: 'center' },
  stepNumText: { color: '#FFF', fontWeight: '700', fontSize: 13 },
  stepText: { flex: 1, fontSize: 14, color: Colors.gray[700], lineHeight: 20, paddingTop: 4 },
});
