import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, TextInput, Alert } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import { useAuth } from '../context/AuthContext';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import type { RootStackParamList } from '../constants/types';
import { recipes } from '../data/recipes';

type Nav = NativeStackNavigationProp<RootStackParamList>;

export default function ProfileScreen() {
  const { user, isAuthenticated, logout, favorites, shoppingList, toggleShoppingItem, addShoppingItem } = useAuth();
  const navigation = useNavigation<Nav>();
  const [tab, setTab] = useState<'progres' | 'favorite' | 'lista' | 'plan'>('progres');
  const [newItem, setNewItem] = useState('');

  if (!isAuthenticated) {
    return (
      <View style={s.authContainer}>
        <LinearGradient colors={['#F0FDF4', '#FFFFFF']} style={s.authBg}>
          <Ionicons name="person-circle" size={80} color={Colors.gray[300]} />
          <Text style={s.authTitle}>Autentificare necesara</Text>
          <Text style={s.authDesc}>Intra in contul tau pentru a accesa profilul, progresul si favoritele tale.</Text>
          <TouchableOpacity style={s.authBtn} onPress={() => navigation.navigate('Login')}>
            <Text style={s.authBtnText}>Autentifica-te</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => navigation.navigate('Register')}>
            <Text style={s.authLink}>Nu ai cont? Inregistreaza-te</Text>
          </TouchableOpacity>
        </LinearGradient>
      </View>
    );
  }

  const favRecipes = recipes.filter(r => favorites.includes(r.id));

  const handleAddItem = () => {
    if (!newItem.trim()) return;
    addShoppingItem(newItem.trim());
    setNewItem('');
  };

  return (
    <ScrollView style={s.container} showsVerticalScrollIndicator={false}>
      <LinearGradient colors={Colors.gradient.primary} style={s.header}>
        <View style={s.avatar}>
          <Text style={s.avatarText}>{user?.name?.charAt(0)?.toUpperCase() || 'U'}</Text>
        </View>
        <Text style={s.userName}>{user?.name}</Text>
        <Text style={s.userEmail}>{user?.email}</Text>
        <TouchableOpacity style={s.logoutBtn} onPress={logout}>
          <Ionicons name="log-out" size={16} color={Colors.accent} />
          <Text style={s.logoutText}>Deconectare</Text>
        </TouchableOpacity>
      </LinearGradient>

      <View style={s.tabs}>
        {([['progres', 'analytics', 'Progres'], ['favorite', 'heart', 'Favorite'], ['lista', 'cart', 'Lista'], ['plan', 'calendar', 'Plan']] as const).map(([key, icon, label]) => (
          <TouchableOpacity key={key} style={[s.tab, tab === key && s.tabActive]} onPress={() => setTab(key)}>
            <Ionicons name={icon as keyof typeof Ionicons.glyphMap} size={18} color={tab === key ? Colors.primary : Colors.gray[400]} />
            <Text style={[s.tabText, tab === key && s.tabTextActive]}>{label}</Text>
          </TouchableOpacity>
        ))}
      </View>

      {tab === 'progres' && (
        <View style={s.section}>
          <Text style={s.sectionTitle}>Progresul Tau</Text>
          <View style={s.progressCard}>
            <Ionicons name="trending-up" size={40} color={Colors.primary} />
            <Text style={s.progressTitle}>Urmareste-ti progresul</Text>
            <Text style={s.progressDesc}>Adauga masuratori corporale si urmareste-ti evolutia in timp.</Text>
            <View style={s.progressStats}>
              <View style={s.progressStat}><Text style={s.progressStatValue}>--</Text><Text style={s.progressStatLabel}>Greutate (kg)</Text></View>
              <View style={s.progressStat}><Text style={s.progressStatValue}>--</Text><Text style={s.progressStatLabel}>IMC</Text></View>
              <View style={s.progressStat}><Text style={s.progressStatValue}>--</Text><Text style={s.progressStatLabel}>% Grasime</Text></View>
            </View>
          </View>
        </View>
      )}

      {tab === 'favorite' && (
        <View style={s.section}>
          <Text style={s.sectionTitle}>Retete Favorite ({favRecipes.length})</Text>
          {favRecipes.length === 0 ? (
            <View style={s.emptyCard}><Ionicons name="heart-outline" size={40} color={Colors.gray[300]} /><Text style={s.emptyText}>Nu ai retete favorite inca</Text></View>
          ) : (
            favRecipes.map(r => (
              <TouchableOpacity key={r.id} style={s.favCard} onPress={() => navigation.navigate('RecipeDetail', { recipe: r })}>
                <Text style={s.favTitle}>{r.title}</Text>
                <Text style={s.favMeta}>{r.calories} kcal - {r.prepTime}</Text>
              </TouchableOpacity>
            ))
          )}
        </View>
      )}

      {tab === 'lista' && (
        <View style={s.section}>
          <Text style={s.sectionTitle}>Lista de Cumparaturi</Text>
          <View style={s.addRow}>
            <TextInput style={s.addInput} placeholder="Adauga un produs..." value={newItem} onChangeText={setNewItem} />
            <TouchableOpacity style={s.addBtn} onPress={handleAddItem}><Ionicons name="add" size={24} color="#FFF" /></TouchableOpacity>
          </View>
          {shoppingList.map(item => (
            <TouchableOpacity key={item.id} style={s.listItem} onPress={() => toggleShoppingItem(item.id)}>
              <Ionicons name={item.checked ? 'checkbox' : 'square-outline'} size={22} color={item.checked ? Colors.primary : Colors.gray[400]} />
              <Text style={[s.listItemText, item.checked && s.listItemChecked]}>{item.name}</Text>
            </TouchableOpacity>
          ))}
        </View>
      )}

      {tab === 'plan' && (
        <View style={s.section}>
          <Text style={s.sectionTitle}>Planificare Mese</Text>
          <View style={s.planCard}>
            <Ionicons name="calendar" size={40} color={Colors.primary} />
            <Text style={s.planTitle}>Planifica-ti mesele</Text>
            <Text style={s.planDesc}>Organizeaza-ti saptamana cu planuri de masa personalizate. Functionalitate disponibila in curand!</Text>
          </View>
        </View>
      )}
      <View style={{ height: 100 }} />
    </ScrollView>
  );
}

const s = StyleSheet.create({
  authContainer: { flex: 1 },
  authBg: { flex: 1, justifyContent: 'center', alignItems: 'center', padding: 40 },
  authTitle: { fontSize: 22, fontWeight: '800', color: Colors.black, marginTop: 16, marginBottom: 8 },
  authDesc: { fontSize: 14, color: Colors.gray[500], textAlign: 'center', lineHeight: 20, marginBottom: 24 },
  authBtn: { backgroundColor: Colors.primary, paddingHorizontal: 32, paddingVertical: 14, borderRadius: 12 },
  authBtnText: { color: '#FFF', fontSize: 16, fontWeight: '700' },
  authLink: { fontSize: 14, color: Colors.primary, fontWeight: '600', marginTop: 16 },
  container: { flex: 1, backgroundColor: Colors.white },
  header: { paddingTop: 60, paddingBottom: 24, alignItems: 'center' },
  avatar: { width: 64, height: 64, borderRadius: 32, backgroundColor: '#FFF', justifyContent: 'center', alignItems: 'center', marginBottom: 8 },
  avatarText: { fontSize: 24, fontWeight: '800', color: Colors.primary },
  userName: { fontSize: 20, fontWeight: '700', color: '#FFF' },
  userEmail: { fontSize: 14, color: 'rgba(255,255,255,0.8)', marginBottom: 12 },
  logoutBtn: { flexDirection: 'row', alignItems: 'center', gap: 4, backgroundColor: '#FFF', paddingHorizontal: 16, paddingVertical: 8, borderRadius: 20 },
  logoutText: { color: Colors.accent, fontWeight: '600', fontSize: 13 },
  tabs: { flexDirection: 'row', borderBottomWidth: 1, borderBottomColor: Colors.gray[100], paddingHorizontal: 8 },
  tab: { flex: 1, alignItems: 'center', paddingVertical: 12, gap: 2 },
  tabActive: { borderBottomWidth: 2, borderBottomColor: Colors.primary },
  tabText: { fontSize: 11, color: Colors.gray[400], fontWeight: '600' },
  tabTextActive: { color: Colors.primary },
  section: { padding: 20 },
  sectionTitle: { fontSize: 18, fontWeight: '700', color: Colors.black, marginBottom: 12 },
  progressCard: { backgroundColor: Colors.primaryBg, borderRadius: 16, padding: 24, alignItems: 'center' },
  progressTitle: { fontSize: 16, fontWeight: '700', color: Colors.black, marginTop: 12 },
  progressDesc: { fontSize: 13, color: Colors.gray[500], textAlign: 'center', marginTop: 4, marginBottom: 16 },
  progressStats: { flexDirection: 'row', gap: 16, width: '100%' },
  progressStat: { flex: 1, backgroundColor: Colors.white, borderRadius: 12, padding: 12, alignItems: 'center' },
  progressStatValue: { fontSize: 20, fontWeight: '800', color: Colors.primary },
  progressStatLabel: { fontSize: 11, color: Colors.gray[500], marginTop: 2 },
  emptyCard: { backgroundColor: Colors.gray[50], borderRadius: 16, padding: 40, alignItems: 'center', gap: 8 },
  emptyText: { fontSize: 14, color: Colors.gray[400] },
  favCard: { backgroundColor: Colors.gray[50], borderRadius: 12, padding: 14, marginBottom: 8 },
  favTitle: { fontSize: 15, fontWeight: '600', color: Colors.black },
  favMeta: { fontSize: 12, color: Colors.gray[500], marginTop: 2 },
  addRow: { flexDirection: 'row', gap: 8, marginBottom: 16 },
  addInput: { flex: 1, borderWidth: 1, borderColor: Colors.gray[200], borderRadius: 12, paddingHorizontal: 14, paddingVertical: 10, fontSize: 14, backgroundColor: Colors.gray[50] },
  addBtn: { width: 44, height: 44, borderRadius: 12, backgroundColor: Colors.primary, justifyContent: 'center', alignItems: 'center' },
  listItem: { flexDirection: 'row', alignItems: 'center', gap: 12, paddingVertical: 12, borderBottomWidth: 1, borderBottomColor: Colors.gray[100] },
  listItemText: { fontSize: 15, color: Colors.black, flex: 1 },
  listItemChecked: { textDecorationLine: 'line-through', color: Colors.gray[400] },
  planCard: { backgroundColor: Colors.primaryBg, borderRadius: 16, padding: 24, alignItems: 'center' },
  planTitle: { fontSize: 16, fontWeight: '700', color: Colors.black, marginTop: 12 },
  planDesc: { fontSize: 13, color: Colors.gray[500], textAlign: 'center', marginTop: 4 },
});
