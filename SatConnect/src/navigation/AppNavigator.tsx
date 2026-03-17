import React, { useState, useEffect } from 'react';
import { View, ActivityIndicator, StyleSheet } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { MaterialCommunityIcons } from '@expo/vector-icons';

import { COLORS, FONTS } from '../constants/theme';
import { storage } from '../services/storage';

import { OnboardingScreen } from '../screens/OnboardingScreen';
import { LoginScreen } from '../screens/LoginScreen';
import { RegisterScreen } from '../screens/RegisterScreen';
import { HomeScreen } from '../screens/HomeScreen';
import { MessagesScreen } from '../screens/MessagesScreen';
import { ChatScreen } from '../screens/ChatScreen';
import { MapScreen } from '../screens/MapScreen';
import { PlansScreen } from '../screens/PlansScreen';
import { ProfileScreen } from '../screens/ProfileScreen';

type AppScreen = 'loading' | 'onboarding' | 'login' | 'register' | 'main';

const Tab = createBottomTabNavigator();
const Stack = createNativeStackNavigator();

function MainTabs({ onLogout, onOpenChat }: { onLogout: () => void; onOpenChat: (conversationId: string, contactName: string) => void }) {
  return (
    <Tab.Navigator
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: COLORS.primary,
        tabBarInactiveTintColor: COLORS.textLight,
        tabBarStyle: {
          borderTopColor: COLORS.border,
          paddingBottom: 8,
          paddingTop: 4,
          height: 64,
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
        {() => <ProfileScreen onLogout={onLogout} />}
      </Tab.Screen>
    </Tab.Navigator>
  );
}

export function AppNavigator() {
  const [currentScreen, setCurrentScreen] = useState<AppScreen>('loading');
  const [chatState, setChatState] = useState<{ conversationId: string; contactName: string } | null>(null);

  useEffect(() => {
    const init = async () => {
      const onboardingDone = await storage.isOnboardingComplete();
      const token = await storage.getAuthToken();
      if (token) {
        setCurrentScreen('main');
      } else if (onboardingDone) {
        setCurrentScreen('login');
      } else {
        setCurrentScreen('onboarding');
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
            await storage.setAuthToken('mock-jwt-token');
            await storage.setUser({ id: '1', name: 'Ion Popescu', email: 'ion@exemplu.com', plan: 'standard' });
            setCurrentScreen('main');
          }}
          onGoToRegister={() => setCurrentScreen('register')}
        />
      </NavigationContainer>
    );
  }

  if (currentScreen === 'register') {
    return (
      <NavigationContainer>
        <RegisterScreen
          onRegister={async () => {
            await storage.setAuthToken('mock-jwt-token');
            await storage.setUser({ id: '1', name: 'Ion Popescu', email: 'ion@exemplu.com', plan: 'basic' });
            setCurrentScreen('main');
          }}
          onGoToLogin={() => setCurrentScreen('login')}
        />
      </NavigationContainer>
    );
  }

  // Main app with chat as absolute overlay (preserves tab state)
  return (
    <View style={{ flex: 1 }}>
      <NavigationContainer>
        <MainTabs
          onLogout={async () => {
            await storage.removeAuthToken();
            await storage.removeUser();
            setCurrentScreen('login');
          }}
          onOpenChat={(conversationId, contactName) => setChatState({ conversationId, contactName })}
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
    </View>
  );
}

const styles = StyleSheet.create({
  loading: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: COLORS.white,
  },
});
