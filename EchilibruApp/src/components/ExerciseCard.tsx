import React from 'react';
import { View, Text, StyleSheet, Image, TouchableOpacity, Dimensions } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import { Exercise } from '../constants/types';

const { width } = Dimensions.get('window');
const cardWidth = (width - 48) / 2;

interface ExerciseCardProps {
  exercise: Exercise;
  onPress: () => void;
}

export default function ExerciseCard({ exercise, onPress }: ExerciseCardProps) {
  const difficultyColor: Record<string, string> = {
    incepator: Colors.primary,
    intermediar: Colors.secondary,
    avansat: Colors.accent,
  };

  const difficultyLabel: Record<string, string> = {
    incepator: 'Incepator',
    intermediar: 'Intermediar',
    avansat: 'Avansat',
  };

  return (
    <TouchableOpacity style={styles.card} onPress={onPress} activeOpacity={0.8}>
      <View style={styles.imageContainer}>
        <Image source={{ uri: exercise.image }} style={styles.image} />
        {exercise.hasVideo && (
          <View style={styles.videoBadge}>
            <Ionicons name="videocam" size={10} color="#FFF" />
            <Text style={styles.videoText}>Video</Text>
          </View>
        )}
        {exercise.isPremium && (
          <View style={styles.premiumBadge}>
            <Ionicons name="star" size={10} color="#FFF" />
            <Text style={styles.premiumText}>Premium</Text>
          </View>
        )}
      </View>
      <View style={styles.content}>
        <View style={styles.titleRow}>
          <View style={[styles.iconCircle, { backgroundColor: Colors.primaryLight }]}>
            <Ionicons name="fitness" size={16} color={Colors.primary} />
          </View>
          <Text style={styles.title} numberOfLines={2}>{exercise.name}</Text>
        </View>
        <Text style={styles.description} numberOfLines={2}>{exercise.description}</Text>
        <View style={styles.tagsRow}>
          <View style={[styles.tag, { backgroundColor: difficultyColor[exercise.difficulty] + '20' }]}>
            <Text style={[styles.tagText, { color: difficultyColor[exercise.difficulty] }]}>
              {difficultyLabel[exercise.difficulty]}
            </Text>
          </View>
          <View style={[styles.tag, { backgroundColor: Colors.blue + '20' }]}>
            <Text style={[styles.tagText, { color: Colors.blue }]}>{exercise.muscleGroup}</Text>
          </View>
        </View>
      </View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  card: {
    width: cardWidth,
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
  videoBadge: {
    position: 'absolute',
    top: 8,
    left: 8,
    backgroundColor: Colors.accent,
    borderRadius: 12,
    paddingHorizontal: 8,
    paddingVertical: 3,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 3,
  },
  videoText: {
    color: '#FFF',
    fontSize: 10,
    fontWeight: '600',
  },
  premiumBadge: {
    position: 'absolute',
    top: 8,
    right: 8,
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
  content: {
    padding: 10,
  },
  titleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    marginBottom: 4,
  },
  iconCircle: {
    width: 28,
    height: 28,
    borderRadius: 14,
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    flex: 1,
    fontSize: 13,
    fontWeight: '700',
    color: Colors.black,
  },
  description: {
    fontSize: 11,
    color: Colors.gray[500],
    lineHeight: 15,
    marginBottom: 8,
  },
  tagsRow: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 4,
  },
  tag: {
    borderRadius: 8,
    paddingHorizontal: 8,
    paddingVertical: 3,
  },
  tagText: {
    fontSize: 10,
    fontWeight: '600',
  },
});
