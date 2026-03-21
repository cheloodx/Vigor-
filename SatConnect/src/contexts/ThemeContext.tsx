import React, { createContext, useContext, useState, useEffect, useMemo } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { COLORS } from '../constants/theme';

export interface ThemeColors {
  primary: string;
  primaryLight: string;
  primaryDark: string;
  accent: string;
  accentLight: string;
  accentDark: string;
  success: string;
  warning: string;
  error: string;
  info: string;
  sos: string;
  sosLight: string;
  satellite: string;
  online: string;
  offline: string;
  syncing: string;
  white: string;
  black: string;
  text: string;
  textSecondary: string;
  textLight: string;
  surface: string;
  border: string;
  card: string;
  background: string;
}

const lightColors: ThemeColors = {
  primary: COLORS.primary,
  primaryLight: COLORS.primaryLight,
  primaryDark: COLORS.primaryDark,
  accent: COLORS.accent,
  accentLight: COLORS.accentLight,
  accentDark: COLORS.accentDark,
  success: COLORS.success,
  warning: COLORS.warning,
  error: COLORS.error,
  info: COLORS.info,
  sos: COLORS.sos,
  sosLight: COLORS.sosLight,
  satellite: COLORS.satellite,
  online: COLORS.online,
  offline: COLORS.offline,
  syncing: COLORS.syncing,
  white: '#FFFFFF',
  black: '#000000',
  text: '#1E293B',
  textSecondary: '#64748B',
  textLight: '#94A3B8',
  surface: '#F1F5F9',
  border: '#E2E8F0',
  card: '#FFFFFF',
  background: '#FFFFFF',
};

const darkColors: ThemeColors = {
  primary: '#4A90D9',
  primaryLight: '#6BAAF0',
  primaryDark: '#0F1F33',
  accent: '#00D4AA',
  accentLight: '#33DFBB',
  accentDark: '#00A888',
  success: '#22C55E',
  warning: '#F59E0B',
  error: '#EF4444',
  info: '#3B82F6',
  sos: '#DC2626',
  sosLight: '#3B1515',
  satellite: '#8B5CF6',
  online: '#22C55E',
  offline: '#EF4444',
  syncing: '#F59E0B',
  white: '#1A1A2E',
  black: '#FFFFFF',
  text: '#E2E8F0',
  textSecondary: '#94A3B8',
  textLight: '#64748B',
  surface: '#0F172A',
  border: '#334155',
  card: '#1E293B',
  background: '#0F172A',
};

interface ThemeContextType {
  isDark: boolean;
  colors: ThemeColors;
  toggleTheme: () => void;
}

const ThemeContext = createContext<ThemeContextType>({
  isDark: false,
  colors: lightColors,
  toggleTheme: () => {},
});

const THEME_KEY = '@satconnect_theme';

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [isDark, setIsDark] = useState(false);
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    AsyncStorage.getItem(THEME_KEY).then((value) => {
      if (value === 'dark') setIsDark(true);
      setLoaded(true);
    });
  }, []);

  const toggleTheme = () => {
    setIsDark(prev => !prev);
  };

  useEffect(() => {
    if (!loaded) return;
    AsyncStorage.setItem(THEME_KEY, isDark ? 'dark' : 'light');
  }, [isDark, loaded]);

  const value = useMemo(() => ({
    isDark,
    colors: isDark ? darkColors : lightColors,
    toggleTheme,
  }), [isDark]);

  return (
    <ThemeContext.Provider value={value}>
      {children}
    </ThemeContext.Provider>
  );
}

export function useTheme() {
  return useContext(ThemeContext);
}
