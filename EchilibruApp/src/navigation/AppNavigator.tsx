import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import type { RootStackParamList } from '../constants/types';

import HomeScreen from '../screens/HomeScreen';
import RecipesScreen from '../screens/RecipesScreen';
import RecipeDetailScreen from '../screens/RecipeDetailScreen';
import ExercisesScreen from '../screens/ExercisesScreen';
import ExerciseDetailScreen from '../screens/ExerciseDetailScreen';
import PlansScreen from '../screens/PlansScreen';
import MealPlansScreen from '../screens/MealPlansScreen';
import TrainingPlansScreen from '../screens/TrainingPlansScreen';
import TrainingPlanDetailScreen from '../screens/TrainingPlanDetailScreen';
import BreakfastIdeasScreen from '../screens/BreakfastIdeasScreen';
import ProfileScreen from '../screens/ProfileScreen';
import LoginScreen from '../screens/LoginScreen';
import RegisterScreen from '../screens/RegisterScreen';
import SfaturiNutritionaleScreen from '../screens/SfaturiNutritionaleScreen';
import CalculatorCaloriiScreen from '../screens/CalculatorCaloriiScreen';

const Stack = createNativeStackNavigator<RootStackParamList>();
const Tab = createBottomTabNavigator();

function PlansStack() {
  return (
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      <Stack.Screen name="PlansHome" component={PlansScreen} />
      <Stack.Screen name="MealPlans" component={MealPlansScreen} />
      <Stack.Screen name="TrainingPlans" component={TrainingPlansScreen} />
      <Stack.Screen name="BreakfastIdeas" component={BreakfastIdeasScreen} />
      <Stack.Screen name="SfaturiNutritionale" component={SfaturiNutritionaleScreen} />
      <Stack.Screen name="CalculatorCalorii" component={CalculatorCaloriiScreen} />
    </Stack.Navigator>
  );
}

function MainTabs() {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        headerShown: false,
        tabBarIcon: ({ focused, color, size }) => {
          let iconName: keyof typeof Ionicons.glyphMap = 'home';
          if (route.name === 'Home') iconName = focused ? 'home' : 'home-outline';
          else if (route.name === 'Recipes') iconName = focused ? 'book' : 'book-outline';
          else if (route.name === 'Exercises') iconName = focused ? 'fitness' : 'fitness-outline';
          else if (route.name === 'Plans') iconName = focused ? 'clipboard' : 'clipboard-outline';
          else if (route.name === 'Profile') iconName = focused ? 'person' : 'person-outline';
          return <Ionicons name={iconName} size={size} color={color} />;
        },
        tabBarActiveTintColor: Colors.primary,
        tabBarInactiveTintColor: Colors.gray[400],
        tabBarStyle: {
          backgroundColor: '#FFF',
          borderTopWidth: 1,
          borderTopColor: Colors.gray[100],
          paddingBottom: 8,
          paddingTop: 8,
          height: 65,
        },
        tabBarLabelStyle: {
          fontSize: 11,
          fontWeight: '600',
        },
      })}
    >
      <Tab.Screen name="Home" component={HomeScreen} options={{ tabBarLabel: 'Acasa' }} />
      <Tab.Screen name="Recipes" component={RecipesScreen} options={{ tabBarLabel: 'Retete' }} />
      <Tab.Screen name="Exercises" component={ExercisesScreen} options={{ tabBarLabel: 'Exercitii' }} />
      <Tab.Screen name="Plans" component={PlansStack} options={{ tabBarLabel: 'Planuri' }} />
      <Tab.Screen name="Profile" component={ProfileScreen} options={{ tabBarLabel: 'Profil' }} />
    </Tab.Navigator>
  );
}

export default function AppNavigator() {
  return (
    <NavigationContainer>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        <Stack.Screen name="MainTabs" component={MainTabs} />
        <Stack.Screen name="RecipeDetail" component={RecipeDetailScreen} />
        <Stack.Screen name="ExerciseDetail" component={ExerciseDetailScreen} />
        <Stack.Screen name="TrainingPlanDetail" component={TrainingPlanDetailScreen} />
        <Stack.Screen name="Login" component={LoginScreen} options={{ presentation: 'modal' }} />
        <Stack.Screen name="Register" component={RegisterScreen} options={{ presentation: 'modal' }} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}
