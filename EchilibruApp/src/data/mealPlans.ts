import { MealPlan } from '../constants/types';

export const weeklyMealPlan: MealPlan[] = [
  {
    day: 'Luni',
    meals: [
      { type: 'mic_dejun', name: 'Mamaliga cu branza si ou', prepTime: '15 min', calories: 400 },
      { type: 'pranz', name: 'Ciorba de perisoare', prepTime: '30 min', calories: 700 },
      { type: 'cina', name: 'Salata orientala', prepTime: '25 min', calories: 600 },
    ],
  },
  {
    day: 'Marti',
    meals: [
      { type: 'mic_dejun', name: 'Omleta cu legume', prepTime: '10 min', calories: 350 },
      { type: 'pranz', name: 'Piept de pui la gratar cu orez', prepTime: '25 min', calories: 650 },
      { type: 'cina', name: 'Supa crema de dovleac', prepTime: '30 min', calories: 450 },
    ],
  },
  {
    day: 'Miercuri',
    meals: [
      { type: 'mic_dejun', name: 'Smoothie bowl cu fructe', prepTime: '10 min', calories: 320 },
      { type: 'pranz', name: 'Paste integrale cu sos de rosii', prepTime: '20 min', calories: 580 },
      { type: 'cina', name: 'Somon la cuptor cu legume', prepTime: '35 min', calories: 550 },
    ],
  },
  {
    day: 'Joi',
    meals: [
      { type: 'mic_dejun', name: 'Iaurt grecesc cu granola', prepTime: '5 min', calories: 380 },
      { type: 'pranz', name: 'Ghiveci de legume', prepTime: '40 min', calories: 520 },
      { type: 'cina', name: 'Piept de curcan cu salata', prepTime: '20 min', calories: 480 },
    ],
  },
  {
    day: 'Vineri',
    meals: [
      { type: 'mic_dejun', name: 'Toast cu avocado si ou', prepTime: '10 min', calories: 420 },
      { type: 'pranz', name: 'Risotto cu ciuperci', prepTime: '30 min', calories: 620 },
      { type: 'cina', name: 'Salata Caesar cu pui', prepTime: '15 min', calories: 500 },
    ],
  },
  {
    day: 'Sambata',
    meals: [
      { type: 'mic_dejun', name: 'Clatite proteice cu fructe', prepTime: '15 min', calories: 450 },
      { type: 'pranz', name: 'Burger de vita cu cartofi dulci', prepTime: '25 min', calories: 700 },
      { type: 'cina', name: 'Wrap cu pui si legume', prepTime: '15 min', calories: 480 },
    ],
  },
  {
    day: 'Duminica',
    meals: [
      { type: 'mic_dejun', name: 'Brunch: Eggs Benedict light', prepTime: '20 min', calories: 500 },
      { type: 'pranz', name: 'Friptura de vita cu garnitura', prepTime: '45 min', calories: 750 },
      { type: 'cina', name: 'Supa de legume cu paine', prepTime: '25 min', calories: 400 },
    ],
  },
];
