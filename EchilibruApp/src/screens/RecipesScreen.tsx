import React, { useState, useMemo, useCallback } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, FlatList } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import { recipes } from '../data/recipes';
import RecipeCard from '../components/RecipeCard';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import type { RootStackParamList, Recipe } from '../constants/types';
import { useAuth } from '../context/AuthContext';
import { useLanguage } from '../context/LanguageContext';

type Nav = NativeStackNavigationProp<RootStackParamList>;

export default function RecipesScreen() {
  const navigation = useNavigation<Nav>();
  const { favorites, toggleFavorite } = useAuth();
  const { t } = useLanguage();

  const categories = [
    { key: 'all', label: t.recipes.all },
    { key: 'mic_dejun', label: t.recipes.breakfast },
    { key: 'pranz', label: t.recipes.lunch },
    { key: 'cina', label: t.recipes.dinner },
    { key: 'desert', label: t.recipes.dessert },
  ];
  const [selected, setSelected] = useState('all');

  const filtered = useMemo(() => selected === 'all' ? recipes : recipes.filter(r => r.category === selected), [selected]);

  const renderRecipe = useCallback(({ item }: { item: Recipe }) => (
    <RecipeCard
      recipe={item}
      onPress={() => navigation.navigate('RecipeDetail', { recipe: item })}
      onFavorite={() => toggleFavorite(item.id)}
      isFavorite={favorites.includes(item.id)}
    />
  ), [favorites, navigation, toggleFavorite]);

  return (
    <View style={s.container}>
      <LinearGradient colors={Colors.gradient.primary} style={s.header}>
        <Ionicons name="book" size={28} color="#FFF" />
                <Text style={s.headerTitle}>{t.recipes.title}</Text>
                <Text style={s.headerDesc}>{t.recipes.desc}</Text>
      </LinearGradient>

      <ScrollView horizontal showsHorizontalScrollIndicator={false} style={s.cats} contentContainerStyle={s.catsContent}>
        {categories.map(c => (
          <TouchableOpacity
            key={c.key}
            style={[s.cat, selected === c.key && s.catActive]}
            onPress={() => setSelected(c.key)}
          >
            <Text style={[s.catText, selected === c.key && s.catTextActive]}>{c.label}</Text>
          </TouchableOpacity>
        ))}
      </ScrollView>

      <FlatList
        data={filtered}
        renderItem={renderRecipe}
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
  headerTitle: { fontSize: 24, fontWeight: '800', color: '#FFF', marginTop: 8, marginBottom: 8 },
  headerDesc: { fontSize: 14, color: 'rgba(255,255,255,0.9)', textAlign: 'center', lineHeight: 20 },
  cats: { maxHeight: 56, borderBottomWidth: 1, borderBottomColor: Colors.gray[100] },
  catsContent: { paddingHorizontal: 16, paddingVertical: 10, gap: 8 },
  cat: { paddingHorizontal: 20, paddingVertical: 8, borderRadius: 20, backgroundColor: Colors.gray[100] },
  catActive: { backgroundColor: Colors.primary },
  catText: { fontSize: 14, fontWeight: '600', color: Colors.gray[600] },
  catTextActive: { color: '#FFF' },
  list: { padding: 16, paddingBottom: 100 },
  row: { justifyContent: 'space-between' },
});
