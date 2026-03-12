import React from 'react';
import { View, Text, StyleSheet, ScrollView, Image, TouchableOpacity } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import type { RootStackParamList } from '../constants/types';
import { useLanguage } from '../context/LanguageContext';

type Props = NativeStackScreenProps<RootStackParamList, 'RecipeDetail'>;

export default function RecipeDetailScreen({ route, navigation }: Props) {
  const { recipe } = route.params;
  const { t } = useLanguage();

  return (
    <ScrollView style={s.container} showsVerticalScrollIndicator={false}>
      <Image source={{ uri: recipe.image }} style={s.image} />
      <TouchableOpacity style={s.back} onPress={() => navigation.goBack()}>
        <Ionicons name="arrow-back" size={24} color="#FFF" />
      </TouchableOpacity>

      <View style={s.content}>
        <View style={s.badges}>
          {recipe.isPremium && (
            <View style={s.premBadge}><Ionicons name="star" size={12} color="#FFF" /><Text style={s.premText}>{t.common.premium}</Text></View>
          )}
          <View style={s.originBadge}><Text style={s.originText}>{recipe.origin}</Text></View>
        </View>

        <Text style={s.title}>{recipe.title}</Text>
        <Text style={s.desc}>{recipe.description}</Text>

        <View style={s.infoRow}>
                    <View style={s.infoItem}><Ionicons name="time-outline" size={20} color={Colors.primary} /><Text style={s.infoLabel}>{t.recipeDetail.time}</Text><Text style={s.infoValue}>{recipe.prepTime}</Text></View>
                    <View style={s.infoItem}><Ionicons name="people-outline" size={20} color={Colors.primary} /><Text style={s.infoLabel}>{t.recipeDetail.portions}</Text><Text style={s.infoValue}>{recipe.portions}</Text></View>
                    <View style={s.infoItem}><Ionicons name="flame-outline" size={20} color={Colors.accent} /><Text style={s.infoLabel}>{t.recipeDetail.calories}</Text><Text style={s.infoValue}>{recipe.calories} kcal</Text></View>
        </View>

                <Text style={s.sectionTitle}>{t.recipeDetail.nutritionalInfo}</Text>
                <View style={s.nutritionRow}>
                  <View style={[s.nutritionItem, { backgroundColor: '#DBEAFE' }]}><Text style={s.nutritionValue}>{recipe.nutritionalInfo.proteine}g</Text><Text style={s.nutritionLabel}>{t.recipeDetail.protein}</Text></View>
                  <View style={[s.nutritionItem, { backgroundColor: '#FEF3C7' }]}><Text style={s.nutritionValue}>{recipe.nutritionalInfo.carbohidrati}g</Text><Text style={s.nutritionLabel}>{t.recipeDetail.carbs}</Text></View>
                  <View style={[s.nutritionItem, { backgroundColor: '#FEE2E2' }]}><Text style={s.nutritionValue}>{recipe.nutritionalInfo.grasimi}g</Text><Text style={s.nutritionLabel}>{t.recipeDetail.fats}</Text></View>
                  <View style={[s.nutritionItem, { backgroundColor: '#D1FAE5' }]}><Text style={s.nutritionValue}>{recipe.nutritionalInfo.fibre}g</Text><Text style={s.nutritionLabel}>{t.recipeDetail.fiber}</Text></View>
        </View>

        <Text style={s.sectionTitle}>{t.recipeDetail.ingredients}</Text>
        {recipe.ingredients.map((ing, i) => (
          <View key={i} style={s.ingredientRow}>
            <Ionicons name="checkmark-circle" size={18} color={Colors.primary} />
            <Text style={s.ingredientText}>{ing}</Text>
          </View>
        ))}

        <Text style={s.sectionTitle}>{t.recipeDetail.instructions}</Text>
        {recipe.instructions.map((inst, i) => (
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
  image: { width: '100%', height: 280, backgroundColor: Colors.gray[200] },
  back: { position: 'absolute', top: 50, left: 16, width: 40, height: 40, borderRadius: 20, backgroundColor: 'rgba(0,0,0,0.4)', justifyContent: 'center', alignItems: 'center' },
  content: { padding: 20, marginTop: -20, backgroundColor: Colors.white, borderTopLeftRadius: 20, borderTopRightRadius: 20 },
  badges: { flexDirection: 'row', gap: 8, marginBottom: 12 },
  premBadge: { flexDirection: 'row', alignItems: 'center', gap: 4, backgroundColor: Colors.primary, paddingHorizontal: 10, paddingVertical: 4, borderRadius: 12 },
  premText: { color: '#FFF', fontSize: 12, fontWeight: '600' },
  originBadge: { backgroundColor: Colors.gray[100], paddingHorizontal: 10, paddingVertical: 4, borderRadius: 12 },
  originText: { fontSize: 12, fontWeight: '600', color: Colors.gray[600] },
  title: { fontSize: 24, fontWeight: '800', color: Colors.black, marginBottom: 8 },
  desc: { fontSize: 15, color: Colors.gray[600], lineHeight: 22, marginBottom: 20 },
  infoRow: { flexDirection: 'row', justifyContent: 'space-around', backgroundColor: Colors.primaryBg, borderRadius: 16, padding: 16, marginBottom: 24 },
  infoItem: { alignItems: 'center', gap: 4 },
  infoLabel: { fontSize: 11, color: Colors.gray[500] },
  infoValue: { fontSize: 13, fontWeight: '700', color: Colors.black },
  sectionTitle: { fontSize: 18, fontWeight: '700', color: Colors.black, marginBottom: 12, marginTop: 8 },
  nutritionRow: { flexDirection: 'row', gap: 8, marginBottom: 20 },
  nutritionItem: { flex: 1, borderRadius: 12, padding: 12, alignItems: 'center' },
  nutritionValue: { fontSize: 16, fontWeight: '700', color: Colors.black },
  nutritionLabel: { fontSize: 11, color: Colors.gray[500], marginTop: 2 },
  ingredientRow: { flexDirection: 'row', alignItems: 'center', gap: 10, paddingVertical: 8, borderBottomWidth: 1, borderBottomColor: Colors.gray[100] },
  ingredientText: { fontSize: 14, color: Colors.gray[700], flex: 1 },
  stepRow: { flexDirection: 'row', alignItems: 'flex-start', gap: 12, marginBottom: 12 },
  stepNum: { width: 28, height: 28, borderRadius: 14, backgroundColor: Colors.primary, justifyContent: 'center', alignItems: 'center' },
  stepNumText: { color: '#FFF', fontWeight: '700', fontSize: 13 },
  stepText: { flex: 1, fontSize: 14, color: Colors.gray[700], lineHeight: 20, paddingTop: 4 },
});
