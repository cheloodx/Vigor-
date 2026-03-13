import React, { useCallback } from 'react';
import { View, Text, StyleSheet, FlatList } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import { exercises } from '../data/exercises';
import ExerciseCard from '../components/ExerciseCard';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import type { RootStackParamList, Exercise } from '../constants/types';
import { useLanguage } from '../context/LanguageContext';

type Nav = NativeStackNavigationProp<RootStackParamList>;

export default function ExercisesScreen() {
  const navigation = useNavigation<Nav>();
  const { t } = useLanguage();

  const renderExercise = useCallback(({ item }: { item: Exercise }) => (
    <ExerciseCard exercise={item} onPress={() => navigation.navigate('ExerciseDetail', { exercise: item })} />
  ), [navigation]);

  return (
    <View style={s.container}>
      <LinearGradient colors={Colors.gradient.primary} style={s.header}>
        <Ionicons name="fitness" size={32} color="#FFF" />
                <Text style={s.headerTitle}>{t.exercises.title}</Text>
                <Text style={s.headerDesc}>{t.exercises.desc}</Text>
      </LinearGradient>

      <View style={s.countBar}>
                <Text style={s.countText}>{t.exercises.allExercises} ({exercises.length})</Text>
                <Text style={s.countDesc}>{t.exercises.exploreDesc}</Text>
      </View>

      <FlatList
        data={exercises}
        renderItem={renderExercise}
        keyExtractor={item => item.id}
        numColumns={2}
        columnWrapperStyle={s.row}
        contentContainerStyle={s.list}
        showsVerticalScrollIndicator={false}
        initialNumToRender={8}
        maxToRenderPerBatch={6}
        windowSize={5}
        removeClippedSubviews={true}
      />
    </View>
  );
}

const s = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.white },
  header: { paddingTop: 60, paddingBottom: 24, paddingHorizontal: 20, alignItems: 'center' },
  headerTitle: { fontSize: 28, fontWeight: '800', color: '#FFF', marginTop: 8, marginBottom: 8 },
  headerDesc: { fontSize: 14, color: 'rgba(255,255,255,0.9)', textAlign: 'center', lineHeight: 20 },
  countBar: { padding: 16, borderBottomWidth: 1, borderBottomColor: Colors.gray[100] },
  countText: { fontSize: 18, fontWeight: '700', color: Colors.black },
  countDesc: { fontSize: 13, color: Colors.gray[500], marginTop: 2 },
  list: { padding: 16, paddingBottom: 100 },
  row: { justifyContent: 'space-between' },
});
