import React, { useState, useRef } from 'react';
import { View, Text, StyleSheet, ScrollView, Image, TouchableOpacity } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Video, ResizeMode } from 'expo-av';
import { Colors } from '../constants/colors';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';
import type { RootStackParamList } from '../constants/types';

type Props = NativeStackScreenProps<RootStackParamList, 'ExerciseDetail'>;

const exerciseVideos: Record<string, string> = {
  Piept: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
  Spate: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
  Picioare: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
  Biceps: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
  Triceps: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
  Umeri: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
  Abdomen: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4',
  'Full Body': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
};

export default function ExerciseDetailScreen({ route, navigation }: Props) {
  const { exercise } = route.params;
  const [showVideo, setShowVideo] = useState(false);
  const videoRef = useRef<Video>(null);
  const diffColor: Record<string, string> = { incepator: Colors.primary, intermediar: Colors.secondary, avansat: Colors.accent };
  const diffLabel: Record<string, string> = { incepator: 'Incepator', intermediar: 'Intermediar', avansat: 'Avansat' };

  const videoUrl = exerciseVideos[exercise.muscleGroup] || exerciseVideos['Full Body'];

  return (
    <ScrollView style={s.container} showsVerticalScrollIndicator={false}>
      {showVideo && exercise.hasVideo ? (
        <View style={s.videoContainer}>
          <Video
            ref={videoRef}
            source={{ uri: videoUrl }}
            style={s.video}
            useNativeControls
            resizeMode={ResizeMode.CONTAIN}
            shouldPlay
            isLooping
          />
          <TouchableOpacity style={s.closeVideo} onPress={() => setShowVideo(false)}>
            <Ionicons name="close" size={24} color="#FFF" />
          </TouchableOpacity>
        </View>
      ) : (
        <View>
          <Image source={{ uri: exercise.image }} style={s.image} />
          {exercise.hasVideo && (
            <TouchableOpacity style={s.playBtn} onPress={() => setShowVideo(true)}>
              <View style={s.playCircle}>
                <Ionicons name="play" size={32} color="#FFF" />
              </View>
              <Text style={s.playText}>Vezi Video</Text>
            </TouchableOpacity>
          )}
        </View>
      )}

      <TouchableOpacity style={s.back} onPress={() => navigation.goBack()}>
        <Ionicons name="arrow-back" size={24} color="#FFF" />
      </TouchableOpacity>

      <View style={s.content}>
        <View style={s.badges}>
          <View style={[s.diffBadge, { backgroundColor: (diffColor[exercise.difficulty] || Colors.primary) + '20' }]}>
            <Text style={[s.diffText, { color: diffColor[exercise.difficulty] || Colors.primary }]}>{diffLabel[exercise.difficulty]}</Text>
          </View>
          <View style={s.muscleBadge}><Text style={s.muscleText}>{exercise.muscleGroup}</Text></View>
          {exercise.hasVideo && (
            <View style={s.videoBadge}><Ionicons name="videocam" size={12} color="#FFF" /><Text style={s.videoText}>Video</Text></View>
          )}
          {exercise.isPremium && (
            <View style={s.premBadge}><Ionicons name="star" size={12} color="#FFF" /><Text style={s.premText}>Premium</Text></View>
          )}
        </View>

        <Text style={s.title}>{exercise.name}</Text>
        <Text style={s.desc}>{exercise.description}</Text>

        {(exercise.sets || exercise.reps) && (
          <View style={s.setsRow}>
            {exercise.sets && <View style={s.setItem}><Text style={s.setLabel}>Seturi</Text><Text style={s.setValue}>{exercise.sets}</Text></View>}
            {exercise.reps && <View style={s.setItem}><Text style={s.setLabel}>Repetari</Text><Text style={s.setValue}>{exercise.reps}</Text></View>}
          </View>
        )}

        {exercise.hasVideo && !showVideo && (
          <TouchableOpacity style={s.watchVideoBtn} onPress={() => setShowVideo(true)}>
            <Ionicons name="play-circle" size={24} color="#FFF" />
            <Text style={s.watchVideoText}>Urmareste Video Demonstrativ</Text>
          </TouchableOpacity>
        )}

        <Text style={s.sectionTitle}>Instructiuni</Text>
        {exercise.instructions.map((inst, i) => (
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
  image: { width: '100%', height: 300, backgroundColor: Colors.gray[200] },
  videoContainer: { width: '100%', height: 300, backgroundColor: '#000' },
  video: { width: '100%', height: 300 },
  closeVideo: { position: 'absolute', top: 50, right: 16, width: 36, height: 36, borderRadius: 18, backgroundColor: 'rgba(0,0,0,0.6)', justifyContent: 'center', alignItems: 'center' },
  back: { position: 'absolute', top: 50, left: 16, width: 40, height: 40, borderRadius: 20, backgroundColor: 'rgba(0,0,0,0.4)', justifyContent: 'center', alignItems: 'center', zIndex: 10 },
  playBtn: { position: 'absolute', top: 100, alignSelf: 'center', alignItems: 'center' },
  playCircle: { width: 70, height: 70, borderRadius: 35, backgroundColor: 'rgba(16,185,129,0.85)', justifyContent: 'center', alignItems: 'center', paddingLeft: 4 },
  playText: { color: '#FFF', fontSize: 13, fontWeight: '700', marginTop: 6, textShadowColor: 'rgba(0,0,0,0.5)', textShadowOffset: { width: 0, height: 1 }, textShadowRadius: 4 },
  content: { padding: 20, marginTop: -20, backgroundColor: Colors.white, borderTopLeftRadius: 20, borderTopRightRadius: 20 },
  badges: { flexDirection: 'row', gap: 8, marginBottom: 12, flexWrap: 'wrap' },
  diffBadge: { paddingHorizontal: 12, paddingVertical: 4, borderRadius: 12 },
  diffText: { fontSize: 12, fontWeight: '700' },
  muscleBadge: { backgroundColor: Colors.blue + '20', paddingHorizontal: 12, paddingVertical: 4, borderRadius: 12 },
  muscleText: { fontSize: 12, fontWeight: '700', color: Colors.blue },
  videoBadge: { flexDirection: 'row', alignItems: 'center', gap: 4, backgroundColor: '#EF4444', paddingHorizontal: 10, paddingVertical: 4, borderRadius: 12 },
  videoText: { color: '#FFF', fontSize: 12, fontWeight: '600' },
  premBadge: { flexDirection: 'row', alignItems: 'center', gap: 4, backgroundColor: Colors.primary, paddingHorizontal: 10, paddingVertical: 4, borderRadius: 12 },
  premText: { color: '#FFF', fontSize: 12, fontWeight: '600' },
  title: { fontSize: 24, fontWeight: '800', color: Colors.black, marginBottom: 8 },
  desc: { fontSize: 15, color: Colors.gray[600], lineHeight: 22, marginBottom: 20 },
  setsRow: { flexDirection: 'row', gap: 16, backgroundColor: Colors.primaryBg, borderRadius: 16, padding: 16, marginBottom: 20 },
  setItem: { flex: 1, alignItems: 'center' },
  setLabel: { fontSize: 12, color: Colors.gray[500], marginBottom: 4 },
  setValue: { fontSize: 20, fontWeight: '800', color: Colors.primary },
  watchVideoBtn: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 8, backgroundColor: '#EF4444', borderRadius: 16, padding: 16, marginBottom: 20 },
  watchVideoText: { color: '#FFF', fontSize: 16, fontWeight: '700' },
  sectionTitle: { fontSize: 18, fontWeight: '700', color: Colors.black, marginBottom: 12, marginTop: 8 },
  stepRow: { flexDirection: 'row', alignItems: 'flex-start', gap: 12, marginBottom: 12 },
  stepNum: { width: 28, height: 28, borderRadius: 14, backgroundColor: Colors.primary, justifyContent: 'center', alignItems: 'center' },
  stepNumText: { color: '#FFF', fontWeight: '700', fontSize: 13 },
  stepText: { flex: 1, fontSize: 14, color: Colors.gray[700], lineHeight: 20, paddingTop: 4 },
});
