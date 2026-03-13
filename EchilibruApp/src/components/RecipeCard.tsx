import React from 'react';
import { View, Text, StyleSheet, Image, TouchableOpacity } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import { Recipe } from '../constants/types';
import { useLanguage } from '../context/LanguageContext';

interface RecipeCardProps {
  recipe: Recipe;
  onPress: () => void;
  onFavorite?: () => void;
  isFavorite?: boolean;
}

const categoryColor: Record<string, string> = {
  mic_dejun: Colors.secondary,
  pranz: Colors.primary,
  cina: Colors.purple,
  desert: Colors.pink,
};

function RecipeCard({ recipe, onPress, onFavorite, isFavorite }: RecipeCardProps) {
  const { t } = useLanguage();
  const categoryLabel: Record<string, string> = {
    mic_dejun: t.recipes.breakfast,
    pranz: t.recipes.lunch,
    cina: t.recipes.dinner,
    desert: t.recipes.dessert,
  };
  return (
    <TouchableOpacity style={styles.card} onPress={onPress} activeOpacity={0.8}>
      <View style={styles.imageContainer}>
        <Image source={{ uri: recipe.image }} style={styles.image} />
        {recipe.isPremium && (
          <View style={styles.premiumBadge}>
            <Ionicons name="star" size={10} color="#FFF" />
            <Text style={styles.premiumText}>Premium</Text>
          </View>
        )}
        <View style={[styles.categoryBadge, { backgroundColor: categoryColor[recipe.category] || Colors.primary }]}>
          <Text style={styles.categoryText}>{categoryLabel[recipe.category]}</Text>
        </View>
        {onFavorite && (
          <TouchableOpacity style={styles.favoriteBtn} onPress={onFavorite}>
            <Ionicons name={isFavorite ? 'heart' : 'heart-outline'} size={20} color={isFavorite ? Colors.accent : '#FFF'} />
          </TouchableOpacity>
        )}
      </View>
      <View style={styles.content}>
        <Text style={styles.title} numberOfLines={2}>{recipe.title}</Text>
        <Text style={styles.description} numberOfLines={2}>{recipe.description}</Text>
        <View style={styles.infoRow}>
          <View style={styles.infoItem}>
            <Ionicons name="time-outline" size={14} color={Colors.primary} />
            <Text style={styles.infoText}>{recipe.prepTime}</Text>
          </View>
          <View style={styles.infoItem}>
            <Ionicons name="people-outline" size={14} color={Colors.primary} />
            <Text style={styles.infoText}>{recipe.portions}</Text>
          </View>
          <View style={styles.infoItem}>
            <Ionicons name="flame-outline" size={14} color={Colors.accent} />
            <Text style={styles.infoText}>{recipe.calories} kcal</Text>
          </View>
        </View>
      </View>
    </TouchableOpacity>
  );
}

export default React.memo(RecipeCard);

const styles = StyleSheet.create({
  card: {
    width: '48%',
    backgroundColor: Colors.white,
    borderRadius: 16,
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 3,
    overflow: 'hidden',
  },
  imageContainer: {
    position: 'relative',
  },
  image: {
    width: '100%',
    height: 120,
    backgroundColor: Colors.gray[200],
  },
  premiumBadge: {
    position: 'absolute',
    top: 8,
    left: 8,
    backgroundColor: Colors.primary,
    borderRadius: 12,
    paddingHorizontal: 8,
    paddingVertical: 3,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 3,
  },
  premiumText: {
    color: '#FFF',
    fontSize: 10,
    fontWeight: '600',
  },
  categoryBadge: {
    position: 'absolute',
    top: 8,
    right: 8,
    borderRadius: 12,
    paddingHorizontal: 8,
    paddingVertical: 3,
  },
  categoryText: {
    color: '#FFF',
    fontSize: 10,
    fontWeight: '600',
  },
  favoriteBtn: {
    position: 'absolute',
    bottom: 8,
    right: 8,
    backgroundColor: 'rgba(0,0,0,0.3)',
    borderRadius: 20,
    padding: 6,
  },
  content: {
    padding: 10,
  },
  title: {
    fontSize: 14,
    fontWeight: '700',
    color: Colors.black,
    marginBottom: 4,
  },
  description: {
    fontSize: 11,
    color: Colors.gray[500],
    lineHeight: 15,
    marginBottom: 8,
  },
  infoRow: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 6,
  },
  infoItem: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 3,
  },
  infoText: {
    fontSize: 10,
    color: Colors.gray[600],
  },
});
