import React from 'react';
import { TouchableOpacity, Text, StyleSheet, ActivityIndicator, View, ViewStyle } from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING, GLASS } from '../constants/theme';

type Variant = 'primary' | 'secondary' | 'ghost' | 'danger' | 'sos';
type Size = 'sm' | 'md' | 'lg';

interface Props {
  title: string;
  onPress: () => void;
  variant?: Variant;
  size?: Size;
  loading?: boolean;
  disabled?: boolean;
  icon?: string | React.ReactElement;
  style?: ViewStyle;
}

const VARIANT_STYLES: Record<Variant, { bg: string; text: string; border?: string }> = {
  primary: { bg: COLORS.accent, text: COLORS.primary },
  secondary: { bg: 'rgba(255,255,255,0.08)', text: COLORS.text, border: 'rgba(255,255,255,0.12)' },
  ghost: { bg: 'transparent', text: COLORS.accent },
  danger: { bg: 'rgba(248,113,113,0.15)', text: COLORS.error, border: 'rgba(248,113,113,0.2)' },
  sos: { bg: COLORS.sos, text: COLORS.white },
};

const SIZE_STYLES: Record<Size, { py: number; px: number; font: number }> = {
  sm: { py: 8, px: 12, font: FONTS.sizes.sm },
  md: { py: 12, px: 20, font: FONTS.sizes.md },
  lg: { py: 16, px: 28, font: FONTS.sizes.lg },
};

export function Button({ title, onPress, variant = 'primary', size = 'md', loading, disabled, icon, style }: Props) {
  const v = VARIANT_STYLES[variant];
  const s = SIZE_STYLES[size];

  return (
    <TouchableOpacity
      style={[
        styles.button,
        { backgroundColor: v.bg, paddingVertical: s.py, paddingHorizontal: s.px },
        v.border ? { borderWidth: 1, borderColor: v.border } : undefined,
        disabled && styles.disabled,
        style,
      ]}
      onPress={onPress}
      disabled={disabled || loading}
      activeOpacity={0.7}
    >
      {loading ? (
        <ActivityIndicator color={v.text} />
      ) : (
        <View style={styles.content}>
          {icon && (typeof icon === 'string' ? <MaterialCommunityIcons name={icon as keyof typeof MaterialCommunityIcons.glyphMap} size={s.font + 2} color={v.text} /> : icon)}
          {title ? <Text style={[styles.text, { color: v.text, fontSize: s.font }]}>{title}</Text> : null}
        </View>
      )}
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  button: { borderRadius: RADIUS.lg, alignItems: 'center', justifyContent: 'center' },
  content: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  text: { fontWeight: '700' },
  disabled: { opacity: 0.5 },
});
