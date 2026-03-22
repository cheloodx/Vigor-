import React, { useState, useEffect } from 'react';
import { View, ActivityIndicator, StyleSheet, BackHandler } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { MaterialCommunityIcons } from '@expo/vector-icons';

import { COLORS, GLASS, FONTS } from '../constants/theme';
import { storage } from '../services/storage';
import { supabaseAuth } from '../services/supabaseAuth';

import { OnboardingScreen } from '../screens/OnboardingScreen';
import { LoginScreen } from '../screens/LoginScreen';
import { RegisterScreen } from '../screens/RegisterScreen';
import { ForgotPasswordScreen } from '../screens/ForgotPasswordScreen';
import { HomeScreen } from '../screens/HomeScreen';
import { MessagesScreen } from '../screens/MessagesScreen';
import { ChatScreen } from '../screens/ChatScreen';
import { MapScreen } from '../screens/MapScreen';
import { ESIMScreen } from '../screens/ESIMScreen';
import { PlansScreen } from '../screens/PlansScreen';
import { ProfileScreen } from '../screens/ProfileScreen';
import { SettingsScreen } from '../screens/SettingsScreen';
import { TermsScreen } from '../screens/TermsScreen';
import { PrivacyScreen } from '../screens/PrivacyScreen';
import { ContactsScreen } from '../screens/ContactsScreen';

type AppScreen = 'loading' | 'onboarding' | 'login' | 'register' | 'forgotPassword' | 'main';
type OverlayScreen = 'settings' | 'terms' | 'privacy' | 'contacts' | null;

const Tab = createBottomTabNavigator();
const Stack = createNativeStackNavigator();

function MainTabs({ onLogout, onOpenChat, onOpenOverlay }: {
  onLogout: () => void;
  onOpenChat: (conversationId: string, contactName: string) => void;
  onOpenOverlay: (screen: OverlayScreen) => void;
}) {
  return (
    <Tab.Navigator
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: COLORS.accent,
        tabBarInactiveTintColor: COLORS.textLight,
        tabBarStyle: {
            ...GLASS.tabBar,
            position: 'absolute',
            height: 85,
            paddingBottom: 20,
            paddingTop: 8,
          },
        tabBarLabelStyle: {
          fontSize: FONTS.sizes.xs,
          fontWeight: '600',
        },
      }}
    >
      <Tab.Screen
        name="Home"
        component={HomeScreen}
        options={{
          tabBarLabel: 'Acasă',
          tabBarIcon: ({ color, size }) => (
            <MaterialCommunityIcons name="home-outline" size={size} color={color} />
          ),
        }}
      />
      <Tab.Screen
        name="Messages"
        options={{
          tabBarLabel: 'Mesaje',
          tabBarIcon: ({ color, size }) => (
            <MaterialCommunityIcons name="message-text-outline" size={size} color={color} />
          ),
          tabBarBadge: 1,
        }}
      >
        {() => <MessagesScreen onOpenChat={onOpenChat} />}
      </Tab.Screen>
      <Tab.Screen
        name="Map"
        component={MapScreen}
        options={{
          tabBarLabel: 'Locație',
          tabBarIcon: ({ color, size }) => (
            <MaterialCommunityIcons name="map-marker-outline" size={size} color={color} />
          ),
        }}
      />
      <Tab.Screen
        name="ESIM"
        component={ESIMScreen}
        options={{
          tabBarLabel: 'eSIM',
          tabBarIcon: ({ color, size }) => (
            <MaterialCommunityIcons name="sim-outline" size={size} color={color} />
          ),
        }}
      />
      <Tab.Screen
        name="Plans"
        component={PlansScreen}
        options={{
          tabBarLabel: 'Planuri',
          tabBarIcon: ({ color, size }) => (
            <MaterialCommunityIcons name="star-outline" size={size} color={color} />
          ),
        }}
      />
      <Tab.Screen
        name="Profile"
        options={{
          tabBarLabel: 'Profil',
          tabBarIcon: ({ color, size }) => (
            <MaterialCommunityIcons name="account-outline" size={size} color={color} />
          ),
        }}
      >
        {() => (
          <ProfileScreen
            onLogout={onLogout}
            onOpenSettings={() => onOpenOverlay('settings')}
            onOpenTerms={() => onOpenOverlay('terms')}
            onOpenPrivacy={() => onOpenOverlay('privacy')}
            onOpenContacts={() => onOpenOverlay('contacts')}
          />
        )}
      </Tab.Screen>
    </Tab.Navigator>
  );
}

export function AppNavigator() {
  const [currentScreen, setCurrentScreen] = useState<AppScreen>('loading');
  const [chatState, setChatState] = useState<{ conversationId: string; contactName: string } | null>(null);
  const [overlayScreen, setOverlayScreen] = useState<OverlayScreen>(null);

  // Android hardware back button handling for overlays
  useEffect(() => {
    if (!chatState && !overlayScreen) return;
    const handler = () => {
      if (overlayScreen) {
        setOverlayScreen(null);
        return true;
      }
      if (chatState) {
        setChatState(null);
        return true;
      }
      return false;
    };
    const sub = BackHandler.addEventListener('hardwareBackPress', handler);
    return () => sub.remove();
  }, [chatState, overlayScreen]);

  useEffect(() => {
    const init = async () => {
      const onboardingDone = await storage.isOnboardingComplete();
      const session = await supabaseAuth.initialize();
      if (session) {
        await storage.setAuthToken(session.token);
        await storage.setUser({ id: session.user.id, name: session.user.name, email: session.user.email, plan: 'standard' });
        setCurrentScreen('main');
      } else {
        // Session expired or invalid — clear any stale auth token
        await storage.removeAuthToken();
        await storage.removeUser();
        if (onboardingDone) {
          setCurrentScreen('login');
        } else {
          setCurrentScreen('onboarding');
        }
      }
    };
    init();
  }, []);

  if (currentScreen === 'loading') {
    return (
      <View style={styles.loading}>
        <ActivityIndicator size="large" color={COLORS.primary} />
      </View>
    );
  }

  if (currentScreen === 'onboarding') {
    return (
      <NavigationContainer>
        <OnboardingScreen
          onComplete={async () => {
            await storage.setOnboardingComplete();
            setCurrentScreen('login');
          }}
        />
      </NavigationContainer>
    );
  }

  if (currentScreen === 'login') {
    return (
      <NavigationContainer>
        <LoginScreen
          onLogin={async () => {
            const session = supabaseAuth.getSession();
            const user = supabaseAuth.getUser();
            await storage.setAuthToken(session?.token ?? 'mock-jwt-token');
            await storage.setUser({
              id: user?.id ?? '1',
              name: user?.name ?? 'Utilizator',
              email: user?.email ?? 'user@satconnect.app',
              plan: 'standard',
            });
            setCurrentScreen('main');
          }}
          onGoToRegister={() => setCurrentScreen('register')}
          onForgotPassword={() => setCurrentScreen('forgotPassword')}
        />
      </NavigationContainer>
    );
  }

  if (currentScreen === 'register') {
    return (
      <NavigationContainer>
        <RegisterScreen
          onRegister={async () => {
            const session = supabaseAuth.getSession();
            const user = supabaseAuth.getUser();
            await storage.setAuthToken(session?.token ?? 'mock-jwt-token');
            await storage.setUser({
              id: user?.id ?? '1',
              name: user?.name ?? 'Utilizator',
              email: user?.email ?? 'user@satconnect.app',
              plan: 'basic',
            });
            setCurrentScreen('main');
          }}
          onGoToLogin={() => setCurrentScreen('login')}
        />
      </NavigationContainer>
    );
  }

  if (currentScreen === 'forgotPassword') {
    return (
      <NavigationContainer>
        <ForgotPasswordScreen
          onBack={() => setCurrentScreen('login')}
        />
      </NavigationContainer>
    );
  }

  // Main app with chat and overlay screens as absolute overlays (preserves tab state)
  return (
    <View style={{ flex: 1 }}>
      <NavigationContainer>
        <MainTabs
          onLogout={async () => {
            await supabaseAuth.signOut();
            await storage.removeAuthToken();
            await storage.removeUser();
            setCurrentScreen('login');
          }}
          onOpenChat={(conversationId, contactName) => setChatState({ conversationId, contactName })}
          onOpenOverlay={(screen) => setOverlayScreen(screen)}
        />
      </NavigationContainer>
      {chatState && (
        <View style={StyleSheet.absoluteFill}>
          <ChatScreen
            conversationId={chatState.conversationId}
            contactName={chatState.contactName}
            onBack={() => setChatState(null)}
          />
        </View>
      )}
      {overlayScreen === 'settings' && (
        <View style={StyleSheet.absoluteFill}>
          <SettingsScreen onBack={() => setOverlayScreen(null)} />
        </View>
      )}
      {overlayScreen === 'terms' && (
        <View style={StyleSheet.absoluteFill}>
          <TermsScreen onBack={() => setOverlayScreen(null)} />
        </View>
      )}
      {overlayScreen === 'privacy' && (
        <View style={StyleSheet.absoluteFill}>
          <PrivacyScreen onBack={() => setOverlayScreen(null)} />
        </View>
      )}
      {overlayScreen === 'contacts' && (
        <View style={StyleSheet.absoluteFill}>
          <ContactsScreen onBack={() => setOverlayScreen(null)} />
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  loading: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: COLORS.surface,
  },
});
