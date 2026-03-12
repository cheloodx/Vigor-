export interface Recipe {
  id: string;
  title: string;
  description: string;
  image: string;
  category: 'mic_dejun' | 'pranz' | 'cina' | 'desert';
  origin: string;
  prepTime: string;
  portions: string;
  calories: number;
  isPremium: boolean;
  ingredients: string[];
  instructions: string[];
  nutritionalInfo: {
    proteine: number;
    carbohidrati: number;
    grasimi: number;
    fibre: number;
  };
}

export interface Exercise {
  id: string;
  name: string;
  description: string;
  image: string;
  muscleGroup: string;
  difficulty: 'incepator' | 'intermediar' | 'avansat';
  hasVideo: boolean;
  isPremium: boolean;
  instructions: string[];
  sets?: string;
  reps?: string;
}

export interface MealPlan {
  day: string;
  meals: {
    type: 'mic_dejun' | 'pranz' | 'cina';
    name: string;
    prepTime: string;
    calories: number;
  }[];
}

export interface TrainingPlan {
  id: string;
  title: string;
  description: string;
  image: string;
  level: 'incepator' | 'intermediar' | 'avansat';
  duration: string;
  daysPerWeek: number;
  exerciseCount: number;
  isPremium: boolean;
  tags: string[];
}

export type RootStackParamList = {
  MainTabs: undefined;
  RecipeDetail: { recipe: Recipe };
  ExerciseDetail: { exercise: Exercise };
  TrainingPlanDetail: { plan: TrainingPlan };
  Login: undefined;
  Register: undefined;
  PlansHome: undefined;
  MealPlans: undefined;
  TrainingPlans: undefined;
  BreakfastIdeas: undefined;
  SfaturiNutritionale: undefined;
  CalculatorCalorii: undefined;
};

export type TabParamList = {
  Home: undefined;
  Recipes: undefined;
  Exercises: undefined;
  Plans: undefined;
  Profile: undefined;
};
