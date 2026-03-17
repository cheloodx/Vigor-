import React, { useState } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Ionicons } from '@expo/vector-icons';
import { COLORS } from '../constants/theme';

import { OnboardingScreen } from '../screens/OnboardingScreen';
import { LoginScreen } from '../screens/LoginScreen';
import { RegisterScreen } from '../screens/RegisterScreen';
import { HomeScreen } from '../screens/HomeScreen';
import { MapScreen } from '../screens/MapScreen';
import { PlansScreen } from '../screens/PlansScreen';
import { ProfileScreen } from '../screens/ProfileScreen';

const Stack = createNativeStackNavigator();
const Tab = createBottomTabNavigator();

function MainTabs({ onLogout }: { onLogout: () => void }) {

  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        headerShown: false,
        tabBarIcon: ({ focused, color, size }) => {
          let iconName: keyof typeof Ionicons.glyphMap;

          switch (route.name) {
            case 'Home':
              iconName = focused ? 'home' : 'home-outline';
              break;
            case 'Map':
              iconName = focused ? 'map' : 'map-outline';
              break;
            case 'Plans':
              iconName = focused ? 'card' : 'card-outline';
              break;
            case 'Profile':
              iconName = focused ? 'person' : 'person-outline';
              break;
            default:
              iconName = 'home-outline';
          }

          return <Ionicons name={iconName} size={size} color={color} />;
        },
        tabBarActiveTintColor: COLORS.primary,
        tabBarInactiveTintColor: COLORS.gray[400],
        tabBarStyle: {
          backgroundColor: COLORS.white,
          borderTopColor: COLORS.border,
          paddingBottom: 8,
          paddingTop: 8,
          height: 85,
        },
        tabBarLabelStyle: {
          fontSize: 11,
          fontWeight: '600',
        },
      })}
    >
      <Tab.Screen
        name="Home"
        options={{ tabBarLabel: 'Acasă' }}
      >
        {(props) => (
          <HomeScreen
            onNavigateToMap={() => props.navigation.navigate('Map')}
            onNavigateToPlans={() => props.navigation.navigate('Plans')}
          />
        )}
      </Tab.Screen>
      <Tab.Screen
        name="Map"
        component={MapScreen}
        options={{ tabBarLabel: 'Hartă' }}
      />
      <Tab.Screen
        name="Plans"
        component={PlansScreen}
        options={{ tabBarLabel: 'Planuri' }}
      />
      <Tab.Screen
        name="Profile"
        options={{ tabBarLabel: 'Profil' }}
      >
        {() => <ProfileScreen onLogout={onLogout} />}
      </Tab.Screen>
    </Tab.Navigator>
  );
}

type AppScreen = 'onboarding' | 'login' | 'register' | 'main';

export function AppNavigator() {
  const [currentScreen, setCurrentScreen] = useState<AppScreen>('onboarding');

  if (currentScreen === 'onboarding') {
    return (
      <OnboardingScreen onComplete={() => setCurrentScreen('login')} />
    );
  }

  if (currentScreen === 'login') {
    return (
      <LoginScreen
        onLogin={() => setCurrentScreen('main')}
        onGoToRegister={() => setCurrentScreen('register')}
      />
    );
  }

  if (currentScreen === 'register') {
    return (
      <RegisterScreen
        onRegister={() => setCurrentScreen('main')}
        onGoToLogin={() => setCurrentScreen('login')}
      />
    );
  }

  return (
    <NavigationContainer>
      <MainTabs onLogout={() => setCurrentScreen('login')} />
    </NavigationContainer>
  );
}
