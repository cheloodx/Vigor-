import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, TextInput, Alert, Switch } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import { useAuth } from '../context/AuthContext';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import type { RootStackParamList } from '../constants/types';
import { recipes } from '../data/recipes';
import { useLanguage } from '../context/LanguageContext';

type Nav = NativeStackNavigationProp<RootStackParamList>;

export default function ProfileScreen() {
  const { user, isAuthenticated, isPremium, logout, favorites, shoppingList, toggleShoppingItem, addShoppingItem, watchConnected, toggleWatch, notificationsEnabled, toggleNotifications } = useAuth();
  const navigation = useNavigation<Nav>();
  const { t, language, setLanguage } = useLanguage();
  const [tab, setTab] = useState<'progres' | 'favorite' | 'lista' | 'setari'>('progres');
  const [newItem, setNewItem] = useState('');

  if (!isAuthenticated) {
    return (
      <View style={s.authContainer}>
        <LinearGradient colors={['#F0FDF4', '#FFFFFF']} style={s.authBg}>
          <Ionicons name="person-circle" size={80} color={Colors.gray[300]} />
          <Text style={s.authTitle}>{t.profile.authRequired}</Text>
          <Text style={s.authDesc}>{t.profile.authDesc}</Text>
          <TouchableOpacity style={s.authBtn} onPress={() => navigation.navigate('Login')}>
            <Text style={s.authBtnText}>{t.profile.login}</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => navigation.navigate('Register')}>
            <Text style={s.authLink}>{t.profile.noAccount}</Text>
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
        <View style={s.headerBtns}>
          <TouchableOpacity style={s.premiumBtn} onPress={() => navigation.navigate('Subscription')}>
            <Ionicons name="star" size={16} color="#F59E0B" />
            <Text style={s.premiumText}>Premium</Text>
          </TouchableOpacity>
          <TouchableOpacity style={s.logoutBtn} onPress={logout}>
            <Ionicons name="log-out" size={16} color={Colors.accent} />
            <Text style={s.logoutText}>{t.profile.logout}</Text>
          </TouchableOpacity>
        </View>
      </LinearGradient>

      <View style={s.tabs}>
        {([['progres', 'analytics', t.profile.progress], ['favorite', 'heart', t.profile.favorites], ['lista', 'cart', t.profile.list], ['setari', 'settings', t.profile.settings]] as const).map(([key, icon, label]) => (
          <TouchableOpacity key={key} style={[s.tab, tab === key && s.tabActive]} onPress={() => setTab(key)}>
            <Ionicons name={icon as keyof typeof Ionicons.glyphMap} size={18} color={tab === key ? Colors.primary : Colors.gray[400]} />
            <Text style={[s.tabText, tab === key && s.tabTextActive]}>{label}</Text>
          </TouchableOpacity>
        ))}
      </View>

      {tab === 'progres' && (
        <View style={s.section}>
          <Text style={s.sectionTitle}>{t.profile.yourProgress}</Text>
          <View style={s.progressCard}>
            <Ionicons name="trending-up" size={40} color={Colors.primary} />
            <Text style={s.progressTitle}>{t.profile.trackProgress}</Text>
            <Text style={s.progressDesc}>{t.profile.trackProgressDesc}</Text>
            <View style={s.progressStats}>
              <View style={s.progressStat}><Text style={s.progressStatValue}>--</Text><Text style={s.progressStatLabel}>{t.profile.weight}</Text></View>
              <View style={s.progressStat}><Text style={s.progressStatValue}>--</Text><Text style={s.progressStatLabel}>{t.profile.bmi}</Text></View>
              <View style={s.progressStat}><Text style={s.progressStatValue}>--</Text><Text style={s.progressStatLabel}>{t.profile.fatPercent}</Text></View>
            </View>
          </View>
        </View>
      )}

      {tab === 'favorite' && (
        <View style={s.section}>
          <Text style={s.sectionTitle}>{t.profile.favoriteRecipes} ({favRecipes.length})</Text>
          {favRecipes.length === 0 ? (
            <View style={s.emptyCard}><Ionicons name="heart-outline" size={40} color={Colors.gray[300]} /><Text style={s.emptyText}>{t.profile.noFavorites}</Text></View>
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
          <Text style={s.sectionTitle}>{t.profile.shoppingList}</Text>
          <View style={s.addRow}>
            <TextInput style={s.addInput} placeholder={t.profile.addProduct} value={newItem} onChangeText={setNewItem} />
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

      {tab === 'setari' && (
        <View style={s.section}>
          <Text style={s.sectionTitle}>{t.profile.settings}</Text>

          {/* Language switcher */}
          <View style={s.settingCard}>
            <View style={s.settingLeft}>
              <View style={[s.settingIcon, { backgroundColor: Colors.primary + '20' }]}>
                <Ionicons name="language" size={20} color={Colors.primary} />
              </View>
              <View>
                <Text style={s.settingTitle}>{t.profile.language}</Text>
                <Text style={s.settingDesc}>{language === 'ro' ? t.profile.romanian : t.profile.english}</Text>
              </View>
            </View>
            <View style={s.langBtns}>
              <TouchableOpacity
                style={[s.langBtn, language === 'ro' && s.langBtnActive]}
                onPress={() => setLanguage('ro')}
              >
                <Text style={[s.langBtnText, language === 'ro' && s.langBtnTextActive]}>RO</Text>
              </TouchableOpacity>
              <TouchableOpacity
                style={[s.langBtn, language === 'en' && s.langBtnActive]}
                onPress={() => setLanguage('en')}
              >
                <Text style={[s.langBtnText, language === 'en' && s.langBtnTextActive]}>EN</Text>
              </TouchableOpacity>
            </View>
          </View>

          {/* Subscription status */}
          <TouchableOpacity style={s.settingCard} onPress={() => navigation.navigate('Subscription')}>
            <View style={s.settingLeft}>
              <View style={[s.settingIcon, { backgroundColor: isPremium ? '#F59E0B20' : Colors.gray[100] }]}>
                <Ionicons name={isPremium ? 'diamond' : 'star'} size={20} color={isPremium ? '#F59E0B' : Colors.gray[400]} />
              </View>
              <View>
                <Text style={s.settingTitle}>{t.profile.subscription}</Text>
                <Text style={s.settingDesc}>{isPremium ? t.profile.premiumActive : t.profile.basicFree}</Text>
              </View>
            </View>
            <Ionicons name="chevron-forward" size={20} color={Colors.gray[400]} />
          </TouchableOpacity>

          {/* Apple Watch */}
          <View style={s.settingCard}>
            <View style={s.settingLeft}>
              <View style={[s.settingIcon, { backgroundColor: watchConnected ? Colors.primary + '20' : Colors.gray[100] }]}>
                <Ionicons name="watch" size={20} color={watchConnected ? Colors.primary : Colors.gray[400]} />
              </View>
              <View>
                <Text style={s.settingTitle}>{t.profile.appleWatch}</Text>
                <Text style={s.settingDesc}>{watchConnected ? t.profile.connected : t.profile.disconnected}</Text>
              </View>
            </View>
            <Switch
              value={watchConnected}
              onValueChange={() => {
                if (!isPremium && !watchConnected) {
                  Alert.alert(t.profile.premiumRequired, t.profile.watchPremiumMsg, [
                    { text: t.profile.cancel },
                    { text: t.profile.seePremium, onPress: () => navigation.navigate('Subscription') },
                  ]);
                } else {
                  toggleWatch();
                }
              }}
              trackColor={{ false: Colors.gray[200], true: Colors.primary + '60' }}
              thumbColor={watchConnected ? Colors.primary : Colors.gray[400]}
            />
          </View>

          {/* Notifications */}
          <View style={s.settingCard}>
            <View style={s.settingLeft}>
              <View style={[s.settingIcon, { backgroundColor: notificationsEnabled ? Colors.primary + '20' : Colors.gray[100] }]}>
                <Ionicons name="notifications" size={20} color={notificationsEnabled ? Colors.primary : Colors.gray[400]} />
              </View>
              <View>
                <Text style={s.settingTitle}>{t.profile.notifications}</Text>
                <Text style={s.settingDesc}>{notificationsEnabled ? t.profile.notifActive : t.profile.notifDisabled}</Text>
              </View>
            </View>
            <Switch
              value={notificationsEnabled}
              onValueChange={() => {
                if (!isPremium && !notificationsEnabled) {
                  Alert.alert(t.profile.premiumRequired, t.profile.notifPremiumMsg, [
                    { text: t.profile.cancel },
                    { text: t.profile.seePremium, onPress: () => navigation.navigate('Subscription') },
                  ]);
                } else {
                  toggleNotifications();
                }
              }}
              trackColor={{ false: Colors.gray[200], true: Colors.primary + '60' }}
              thumbColor={notificationsEnabled ? Colors.primary : Colors.gray[400]}
            />
          </View>

          {!isPremium && (
            <TouchableOpacity style={s.upgradeCard} onPress={() => navigation.navigate('Subscription')}>
              <LinearGradient colors={['#10B981', '#059669']} style={s.upgradeGradient}>
                <Ionicons name="star" size={24} color="#FFF" />
                <Text style={s.upgradeTitle}>{t.profile.upgradeToPremium}</Text>
                <Text style={s.upgradeDesc}>{t.profile.upgradeDesc}</Text>
              </LinearGradient>
            </TouchableOpacity>
          )}
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
  headerBtns: { flexDirection: 'row', gap: 8, marginTop: 4 },
  premiumBtn: { flexDirection: 'row', alignItems: 'center', gap: 4, backgroundColor: '#FFF', paddingHorizontal: 16, paddingVertical: 8, borderRadius: 20 },
  premiumText: { color: '#F59E0B', fontWeight: '600', fontSize: 13 },
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
  settingCard: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', backgroundColor: Colors.gray[50], borderRadius: 12, padding: 14, marginBottom: 10 },
  settingLeft: { flexDirection: 'row', alignItems: 'center', gap: 12, flex: 1 },
  settingIcon: { width: 40, height: 40, borderRadius: 12, justifyContent: 'center', alignItems: 'center' },
  settingTitle: { fontSize: 15, fontWeight: '600', color: Colors.black },
  settingDesc: { fontSize: 12, color: Colors.gray[500], marginTop: 1 },
  upgradeCard: { borderRadius: 16, overflow: 'hidden', marginTop: 12 },
  upgradeGradient: { padding: 20, alignItems: 'center', gap: 6 },
  upgradeTitle: { fontSize: 18, fontWeight: '800', color: '#FFF' },
  upgradeDesc: { fontSize: 13, color: 'rgba(255,255,255,0.9)', textAlign: 'center' },
  langBtns: { flexDirection: 'row', gap: 6 },
  langBtn: { paddingHorizontal: 14, paddingVertical: 8, borderRadius: 10, borderWidth: 1.5, borderColor: Colors.gray[200], backgroundColor: Colors.white },
  langBtnActive: { borderColor: Colors.primary, backgroundColor: Colors.primary },
  langBtnText: { fontSize: 13, fontWeight: '700', color: Colors.gray[500] },
  langBtnTextActive: { color: '#FFF' },
});
