import { useState } from "react";
import {
  Wifi,
  Satellite,
  Globe,
  Shield,
  Zap,
  MapPin,
  MessageSquare,
  Phone,
  ChevronDown,
  Check,
  Star,
  Users,
  Signal,
  Clock,
  Smartphone,
  Menu,
  X,
  ArrowRight,
  Download,
  AlertTriangle,
  Battery,
  Radio,
} from "lucide-react";
import "./App.css";

function App() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [activeFaq, setActiveFaq] = useState<number | null>(null);

  const plans = [
    {
      name: "Free",
      price: "0",
      period: "luna",
      data: "3 GB",
      features: [
        "Mesaje text nelimitate",
        "GPS de baza",
        "SOS de urgenta",
        "1 dispozitiv",
        "Suport comunitar",
      ],
      popular: false,
      cta: "Incepe gratuit",
    },
    {
      name: "Explorer",
      price: "1.99",
      period: "luna",
      data: "100 GB",
      features: [
        "Totul din Free +",
        "Roaming global 175 tari",
        "eSIM virtual inclus",
        "5 dispozitive",
        "Viteza 4G/5G",
        "Suport prioritar",
      ],
      popular: true,
      cta: "Alege Explorer",
    },
    {
      name: "Pro",
      price: "3.99",
      period: "luna",
      data: "500 GB",
      features: [
        "Totul din Explorer +",
        "GPS satelit avansat",
        "Conectivitate satelit",
        "10 dispozitive",
        "VPN integrat",
        "API acces",
        "Suport 24/7",
      ],
      popular: false,
      cta: "Alege Pro",
    },
    {
      name: "Unlimited",
      price: "6.99",
      period: "luna",
      data: "Nelimitat",
      features: [
        "Totul din Pro +",
        "Date nelimitate fair-use",
        "5G prioritar global",
        "Dispozitive nelimitate",
        "Family sharing",
        "Manager dedicat",
        "SLA garantat 99.9%",
      ],
      popular: false,
      cta: "Alege Unlimited",
    },
  ];

  const esimCards = [
    {
      region: "Europa",
      countries: "30+ tari",
      data: "50 GB",
      price: "4.99",
      flag: "EU",
    },
    {
      region: "America & Asia",
      countries: "80+ tari",
      data: "30 GB",
      price: "7.99",
      flag: "AA",
    },
    {
      region: "Global Total",
      countries: "175 tari",
      data: "100 GB",
      price: "12.99",
      flag: "GL",
    },
  ];

  const features = [
    {
      icon: <Satellite className="w-8 h-8" />,
      title: "Conectivitate Satelit",
      description:
        "Ramai conectat si in zonele fara semnal mobil prin integrare cu retelele satelitare.",
    },
    {
      icon: <Globe className="w-8 h-8" />,
      title: "175 Tari Acoperite",
      description:
        "Un singur cont, o singura aplicatie - internet global fara grija roaming-ului.",
    },
    {
      icon: <Smartphone className="w-8 h-8" />,
      title: "eSIM Virtual",
      description:
        "Activeaza un plan de date direct din aplicatie, fara cartela fizica.",
    },
    {
      icon: <Shield className="w-8 h-8" />,
      title: "Criptare End-to-End",
      description:
        "Toate mesajele si datele tale sunt criptate cu standarde militare (AES-256).",
    },
    {
      icon: <Zap className="w-8 h-8" />,
      title: "Offline-First",
      description:
        "Functioneaza fara internet. Sincronizare automata cand conexiunea revine.",
    },
    {
      icon: <AlertTriangle className="w-8 h-8" />,
      title: "SOS de Urgenta",
      description:
        "Buton de urgenta cu localizare GPS care functioneaza chiar si prin satelit.",
    },
  ];

  const stats = [
    { value: "175", label: "Tari acoperite", icon: <Globe className="w-6 h-6" /> },
    { value: "50K+", label: "Utilizatori activi", icon: <Users className="w-6 h-6" /> },
    { value: "99.9%", label: "Uptime garantat", icon: <Signal className="w-6 h-6" /> },
    { value: "24/7", label: "Suport non-stop", icon: <Clock className="w-6 h-6" /> },
  ];

  const connectivityModes = [
    { icon: <Wifi className="w-6 h-6" />, name: "WiFi", desc: "Hotspot-uri locale + Starlink" },
    { icon: <Signal className="w-6 h-6" />, name: "Date Mobile", desc: "4G/5G in 175 tari" },
    { icon: <Globe className="w-6 h-6" />, name: "Roaming", desc: "Fara taxe suplimentare" },
    { icon: <Satellite className="w-6 h-6" />, name: "Satelit GPS", desc: "Oriunde pe planeta" },
    { icon: <Smartphone className="w-6 h-6" />, name: "eSIM", desc: "Cartela virtuala instant" },
    { icon: <Radio className="w-6 h-6" />, name: "Bluetooth", desc: "Dispozitive externe" },
  ];

  const faqs = [
    {
      q: "Cum functioneaza conectivitatea prin satelit?",
      a: "SatConnect se conecteaza la retelele satelitare existente (Starlink, Iridium) prin hotspot WiFi sau dispozitive externe Bluetooth. Nu necesita hardware special - telefonul tau este suficient.",
    },
    {
      q: "Ce este eSIM virtual si cum il activez?",
      a: "eSIM este o cartela SIM digitala integrata in telefon. O activezi direct din aplicatie in cateva secunde, fara a merge la un magazin sau a astepta livrarea unei cartele fizice.",
    },
    {
      q: "Functioneaza aplicatia fara internet?",
      a: "Da! SatConnect are arhitectura offline-first. Mesajele, locatiile GPS si toate actiunile se stocheaza local si se sincronizeaza automat cand conexiunea revine.",
    },
    {
      q: "Cum functioneaza butonul SOS?",
      a: "Tine apasat butonul SOS timp de 3 secunde pentru a trimite o alerta de urgenta cu locatia ta GPS exacta. Functioneaza chiar si prin conexiune satelit, in zone fara semnal mobil.",
    },
    {
      q: "Pot folosi SatConnect pe mai multe dispozitive?",
      a: "Da! In functie de plan, poti conecta intre 1 si un numar nelimitat de dispozitive. Planul Explorer permite 5 dispozitive, Pro 10, iar Unlimited - nelimitat.",
    },
    {
      q: "Care este diferenta fata de un plan de roaming normal?",
      a: "Planurile de roaming traditionale costa 5-15 EUR/GB. SatConnect ofera pana la 100GB la 1.99 EUR/luna - de 50-100x mai ieftin. Plus conectivitate satelit ca backup.",
    },
  ];

  const countries = [
    "Romania", "Germania", "Franta", "Italia", "Spania", "Marea Britanie",
    "SUA", "Canada", "Japonia", "Australia", "Brazilia", "India",
    "Mexic", "Turcia", "Egipt", "Africa de Sud", "Thailanda", "Coreea de Sud",
  ];

  return (
    <div className="min-h-screen bg-white text-gray-900 font-sans">
      {/* Navigation */}
      <nav className="fixed top-0 left-0 right-0 bg-white/95 backdrop-blur-md z-50 border-b border-gray-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center gap-2">
              <div className="w-9 h-9 bg-gradient-to-br from-blue-900 to-teal-500 rounded-xl flex items-center justify-center">
                <Satellite className="w-5 h-5 text-white" />
              </div>
              <span className="text-xl font-bold bg-gradient-to-r from-blue-900 to-teal-600 bg-clip-text text-transparent">
                SatConnect
              </span>
            </div>

            <div className="hidden md:flex items-center gap-8">
              <a href="#features" className="text-sm font-medium text-gray-600 hover:text-blue-900 transition-colors">Functionalitati</a>
              <a href="#connectivity" className="text-sm font-medium text-gray-600 hover:text-blue-900 transition-colors">Conectivitate</a>
              <a href="#esim" className="text-sm font-medium text-gray-600 hover:text-blue-900 transition-colors">eSIM</a>
              <a href="#pricing" className="text-sm font-medium text-gray-600 hover:text-blue-900 transition-colors">Preturi</a>
              <a href="#faq" className="text-sm font-medium text-gray-600 hover:text-blue-900 transition-colors">FAQ</a>
            </div>

            <div className="hidden md:flex items-center gap-3">
              <button className="text-sm font-medium text-gray-600 hover:text-blue-900 px-4 py-2 transition-colors">
                Login
              </button>
              <button className="text-sm font-semibold text-white bg-gradient-to-r from-blue-900 to-teal-600 px-5 py-2.5 rounded-xl hover:shadow-lg hover:shadow-blue-900/25 transition-all">
                Descarca App
              </button>
            </div>

            <button
              className="md:hidden p-2"
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
            >
              {mobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>
        </div>

        {mobileMenuOpen && (
          <div className="md:hidden bg-white border-t border-gray-100 px-4 py-4 space-y-3">
            <a href="#features" className="block text-sm font-medium text-gray-600 py-2" onClick={() => setMobileMenuOpen(false)}>Functionalitati</a>
            <a href="#connectivity" className="block text-sm font-medium text-gray-600 py-2" onClick={() => setMobileMenuOpen(false)}>Conectivitate</a>
            <a href="#esim" className="block text-sm font-medium text-gray-600 py-2" onClick={() => setMobileMenuOpen(false)}>eSIM</a>
            <a href="#pricing" className="block text-sm font-medium text-gray-600 py-2" onClick={() => setMobileMenuOpen(false)}>Preturi</a>
            <a href="#faq" className="block text-sm font-medium text-gray-600 py-2" onClick={() => setMobileMenuOpen(false)}>FAQ</a>
            <button className="w-full text-sm font-semibold text-white bg-gradient-to-r from-blue-900 to-teal-600 px-5 py-3 rounded-xl mt-2">
              Descarca App
            </button>
          </div>
        )}
      </nav>

      {/* Hero Section */}
      <section className="relative pt-24 pb-20 lg:pt-32 lg:pb-28 overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-br from-blue-950 via-blue-900 to-teal-800" />
        <div
          className="absolute inset-0 opacity-20"
          style={{
            backgroundImage: "url('/images/hero-satellite.jpg')",
            backgroundSize: "cover",
            backgroundPosition: "center",
          }}
        />
        <div className="absolute inset-0 bg-gradient-to-t from-blue-950/80 to-transparent" />

        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <div className="inline-flex items-center gap-2 bg-white/10 backdrop-blur-sm border border-white/20 rounded-full px-4 py-2 mb-8">
              <div className="w-2 h-2 bg-teal-400 rounded-full animate-pulse" />
              <span className="text-sm font-medium text-teal-300">
                Acum disponibil in 175 de tari
              </span>
            </div>

            <h1 className="text-4xl sm:text-5xl lg:text-7xl font-black text-white leading-tight mb-6">
              Conectat{" "}
              <span className="bg-gradient-to-r from-teal-400 to-cyan-300 bg-clip-text text-transparent">
                oriunde
              </span>
              <br />
              pe planeta
            </h1>

            <p className="text-lg sm:text-xl text-blue-200 max-w-2xl mx-auto mb-10 leading-relaxed">
              O singura aplicatie. Un singur cont. Internet global prin WiFi,
              date mobile, roaming si satelit — fara grija roaming-ului.
            </p>

            <div className="flex flex-col sm:flex-row items-center justify-center gap-4 mb-16">
              <button className="flex items-center gap-3 bg-white text-blue-900 px-8 py-4 rounded-2xl font-bold text-lg hover:shadow-2xl hover:shadow-white/20 transition-all hover:-translate-y-0.5">
                <Download className="w-5 h-5" />
                Descarca pentru iOS
              </button>
              <button className="flex items-center gap-3 bg-white/10 backdrop-blur-sm border border-white/30 text-white px-8 py-4 rounded-2xl font-bold text-lg hover:bg-white/20 transition-all">
                Afla mai multe
                <ArrowRight className="w-5 h-5" />
              </button>
            </div>

            {/* Stats */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-6 max-w-3xl mx-auto">
              {stats.map((stat, i) => (
                <div
                  key={i}
                  className="bg-white/10 backdrop-blur-sm border border-white/10 rounded-2xl p-4"
                >
                  <div className="text-teal-400 flex justify-center mb-2">
                    {stat.icon}
                  </div>
                  <div className="text-2xl sm:text-3xl font-black text-white">
                    {stat.value}
                  </div>
                  <div className="text-sm text-blue-300">{stat.label}</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="py-20 lg:py-28 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <span className="text-sm font-semibold text-teal-600 uppercase tracking-wider">
              Functionalitati
            </span>
            <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black text-gray-900 mt-3 mb-4">
              De ce SatConnect?
            </h2>
            <p className="text-lg text-gray-600 max-w-2xl mx-auto">
              Tehnologie de ultima generatie pentru conectivitate globala, securitate
              maxima si functionare chiar si fara internet.
            </p>
          </div>

          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {features.map((feature, i) => (
              <div
                key={i}
                className="bg-white rounded-2xl p-8 hover:shadow-xl hover:shadow-blue-900/5 transition-all hover:-translate-y-1 border border-gray-100"
              >
                <div className="w-14 h-14 bg-gradient-to-br from-blue-900 to-teal-600 rounded-xl flex items-center justify-center text-white mb-5">
                  {feature.icon}
                </div>
                <h3 className="text-xl font-bold text-gray-900 mb-3">
                  {feature.title}
                </h3>
                <p className="text-gray-600 leading-relaxed">
                  {feature.description}
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Connectivity Section */}
      <section id="connectivity" className="py-20 lg:py-28 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid lg:grid-cols-2 gap-16 items-center">
            <div>
              <span className="text-sm font-semibold text-teal-600 uppercase tracking-wider">
                Multi-Conectivitate
              </span>
              <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black text-gray-900 mt-3 mb-6">
                6 moduri de{" "}
                <span className="bg-gradient-to-r from-blue-900 to-teal-600 bg-clip-text text-transparent">
                  conectare
                </span>
              </h2>
              <p className="text-lg text-gray-600 mb-8 leading-relaxed">
                SatConnect alege automat cea mai buna conexiune disponibila.
                WiFi, date mobile, roaming international sau satelit — totul
                transparent, fara interventie manuala.
              </p>

              <div className="grid grid-cols-2 gap-4">
                {connectivityModes.map((mode, i) => (
                  <div
                    key={i}
                    className="flex items-center gap-3 bg-gray-50 rounded-xl p-4 border border-gray-100"
                  >
                    <div className="w-10 h-10 bg-gradient-to-br from-blue-900 to-teal-600 rounded-lg flex items-center justify-center text-white shrink-0">
                      {mode.icon}
                    </div>
                    <div>
                      <div className="font-semibold text-gray-900 text-sm">
                        {mode.name}
                      </div>
                      <div className="text-xs text-gray-500">{mode.desc}</div>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            <div className="relative">
              <div className="relative rounded-3xl overflow-hidden shadow-2xl shadow-blue-900/20">
                <img
                  src="/images/earth-space.jpg"
                  alt="Pamantul vazut din spatiu cu retele de conectivitate"
                  className="w-full h-96 object-cover"
                  onError={(e) => {
                    (e.target as HTMLImageElement).src = "https://placehold.co/800x600/1E3A5F/00D4AA?text=Global+Connectivity";
                  }}
                />
                <div className="absolute inset-0 bg-gradient-to-t from-blue-900/60 to-transparent" />
                <div className="absolute bottom-6 left-6 right-6">
                  <div className="flex items-center gap-3 bg-white/95 backdrop-blur-sm rounded-xl p-4">
                    <div className="w-3 h-3 bg-teal-500 rounded-full animate-pulse" />
                    <div>
                      <div className="font-semibold text-gray-900 text-sm">
                        Conectat — WiFi + Satelit GPS
                      </div>
                      <div className="text-xs text-gray-500">
                        175 tari - 99.9% uptime - Sincronizare activa
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Use Cases Section */}
      <section className="py-20 lg:py-28 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <span className="text-sm font-semibold text-teal-600 uppercase tracking-wider">
              Cazuri de utilizare
            </span>
            <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black text-gray-900 mt-3 mb-4">
              Pentru orice aventura
            </h2>
            <p className="text-lg text-gray-600 max-w-2xl mx-auto">
              De la calatorii internationale la expeditii in salbaticie — SatConnect te
              tine conectat.
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            {[
              {
                img: "/images/mountain-hiking.jpg",
                title: "Drumetii & Expeditii",
                desc: "GPS satelit si SOS de urgenta in zone montane fara semnal mobil.",
                icon: <MapPin className="w-5 h-5" />,
              },
              {
                img: "/images/ocean-sailing.jpg",
                title: "Navigatie & Marine",
                desc: "Conectivitate pe mare prin satelit. Partajare locatie in timp real.",
                icon: <Satellite className="w-5 h-5" />,
              },
              {
                img: "/images/city-travel.jpg",
                title: "Calatorii Internationale",
                desc: "eSIM virtual instant. Roaming in 175 tari la preturi imbatabile.",
                icon: <Globe className="w-5 h-5" />,
              },
            ].map((useCase, i) => (
              <div
                key={i}
                className="group bg-white rounded-2xl overflow-hidden hover:shadow-xl hover:shadow-blue-900/10 transition-all hover:-translate-y-1 border border-gray-100"
              >
                <div className="relative h-56 overflow-hidden">
                  <img
                    src={useCase.img}
                    alt={useCase.title}
                    className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                    onError={(e) => {
                      (e.target as HTMLImageElement).src = "https://placehold.co/800x500/1E3A5F/00D4AA?text=" + encodeURIComponent(useCase.title);
                    }}
                  />
                  <div className="absolute top-4 left-4 bg-white/95 backdrop-blur-sm rounded-lg p-2">
                    <div className="text-blue-900">{useCase.icon}</div>
                  </div>
                </div>
                <div className="p-6">
                  <h3 className="text-lg font-bold text-gray-900 mb-2">
                    {useCase.title}
                  </h3>
                  <p className="text-gray-600 text-sm leading-relaxed">
                    {useCase.desc}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* eSIM Section */}
      <section id="esim" className="py-20 lg:py-28 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <span className="text-sm font-semibold text-teal-600 uppercase tracking-wider">
              eSIM Virtual
            </span>
            <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black text-gray-900 mt-3 mb-4">
              Cartela virtuala{" "}
              <span className="bg-gradient-to-r from-blue-900 to-teal-600 bg-clip-text text-transparent">
                instant
              </span>
            </h2>
            <p className="text-lg text-gray-600 max-w-2xl mx-auto">
              Activeaza un plan eSIM direct din aplicatie in cateva secunde. Fara
              cartela fizica, fara asteptare.
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-8 max-w-4xl mx-auto">
            {esimCards.map((card, i) => (
              <div
                key={i}
                className="relative bg-gradient-to-br from-blue-900 to-blue-950 rounded-2xl p-6 text-white overflow-hidden group hover:shadow-xl hover:shadow-blue-900/30 transition-all hover:-translate-y-1"
              >
                <div className="absolute top-4 right-4 w-10 h-7 bg-gradient-to-br from-yellow-400 to-yellow-600 rounded-md opacity-80" />
                <div className="absolute -bottom-8 -right-8 w-32 h-32 bg-teal-500/10 rounded-full" />

                <div className="w-10 h-10 bg-white/10 rounded-lg flex items-center justify-center text-teal-400 font-bold text-sm mb-3">
                  {card.flag}
                </div>
                <h3 className="text-xl font-bold mb-1">{card.region}</h3>
                <p className="text-blue-300 text-sm mb-6">{card.countries}</p>

                <div className="flex items-end gap-1 mb-2">
                  <span className="text-3xl font-black">{card.data}</span>
                </div>
                <div className="flex items-baseline gap-1 mb-6">
                  <span className="text-2xl font-bold text-teal-400">
                    {card.price} EUR
                  </span>
                  <span className="text-blue-300 text-sm">/luna</span>
                </div>

                <button className="w-full bg-teal-500 hover:bg-teal-400 text-blue-950 font-semibold py-3 rounded-xl transition-colors">
                  Activeaza eSIM
                </button>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Pricing Section */}
      <section id="pricing" className="py-20 lg:py-28 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <span className="text-sm font-semibold text-teal-600 uppercase tracking-wider">
              Planuri & Preturi
            </span>
            <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black text-gray-900 mt-3 mb-4">
              Cele mai bune preturi din piata
            </h2>
            <p className="text-lg text-gray-600 max-w-2xl mx-auto">
              De la 0 EUR/luna. Pana la 100x mai ieftin decat roaming-ul traditional.
              Fara contracte, fara surprize.
            </p>
          </div>

          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
            {plans.map((plan, i) => (
              <div
                key={i}
                className={`relative bg-white rounded-2xl p-6 border-2 transition-all hover:-translate-y-1 ${
                  plan.popular
                    ? "border-teal-500 shadow-xl shadow-teal-500/10"
                    : "border-gray-100 hover:shadow-lg hover:shadow-blue-900/5"
                }`}
              >
                {plan.popular && (
                  <div className="absolute -top-3 left-1/2 -translate-x-1/2 bg-gradient-to-r from-teal-500 to-cyan-500 text-white text-xs font-bold px-4 py-1 rounded-full flex items-center gap-1">
                    <Star className="w-3 h-3" />
                    Popular
                  </div>
                )}

                <div className="text-center mb-6">
                  <h3 className="text-lg font-bold text-gray-900 mb-1">
                    {plan.name}
                  </h3>
                  <div className="text-sm text-teal-600 font-semibold mb-4">
                    {plan.data}
                  </div>
                  <div className="flex items-baseline justify-center gap-1">
                    <span className="text-lg text-gray-400">EUR</span>
                    <span className="text-5xl font-black text-gray-900">
                      {plan.price}
                    </span>
                    <span className="text-gray-400">/{plan.period}</span>
                  </div>
                </div>

                <ul className="space-y-3 mb-8">
                  {plan.features.map((feature, j) => (
                    <li key={j} className="flex items-start gap-2">
                      <Check className="w-4 h-4 text-teal-500 mt-0.5 shrink-0" />
                      <span className="text-sm text-gray-600">{feature}</span>
                    </li>
                  ))}
                </ul>

                <button
                  className={`w-full py-3 rounded-xl font-semibold text-sm transition-all ${
                    plan.popular
                      ? "bg-gradient-to-r from-blue-900 to-teal-600 text-white hover:shadow-lg hover:shadow-blue-900/25"
                      : "bg-gray-100 text-gray-900 hover:bg-gray-200"
                  }`}
                >
                  {plan.cta}
                </button>
              </div>
            ))}
          </div>

          <div className="text-center mt-10">
            <p className="text-sm text-gray-500">
              Toate planurile includ SOS de urgenta si criptare end-to-end.
              Plati securizate prin Apple In-App Purchase.
            </p>
          </div>
        </div>
      </section>

      {/* Global Coverage */}
      <section className="py-20 lg:py-28 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <span className="text-sm font-semibold text-teal-600 uppercase tracking-wider">
              Acoperire Globala
            </span>
            <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black text-gray-900 mt-3 mb-4">
              175 de tari, o singura aplicatie
            </h2>
          </div>

          <div className="flex flex-wrap justify-center gap-3 max-w-4xl mx-auto">
            {countries.map((country, i) => (
              <span
                key={i}
                className="bg-gray-100 text-gray-700 px-4 py-2 rounded-full text-sm font-medium hover:bg-blue-900 hover:text-white transition-colors cursor-default"
              >
                {country}
              </span>
            ))}
            <span className="bg-gradient-to-r from-blue-900 to-teal-600 text-white px-6 py-2 rounded-full text-sm font-semibold">
              + 157 alte tari
            </span>
          </div>
        </div>
      </section>

      {/* FAQ Section */}
      <section id="faq" className="py-20 lg:py-28 bg-gray-50">
        <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <span className="text-sm font-semibold text-teal-600 uppercase tracking-wider">
              Intrebari Frecvente
            </span>
            <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black text-gray-900 mt-3 mb-4">
              FAQ
            </h2>
          </div>

          <div className="space-y-3">
            {faqs.map((faq, i) => (
              <div
                key={i}
                className="bg-white rounded-xl border border-gray-100 overflow-hidden"
              >
                <button
                  className="w-full flex items-center justify-between p-5 text-left"
                  onClick={() => setActiveFaq(activeFaq === i ? null : i)}
                >
                  <span className="font-semibold text-gray-900 pr-4">
                    {faq.q}
                  </span>
                  <ChevronDown
                    className={`w-5 h-5 text-gray-400 shrink-0 transition-transform ${
                      activeFaq === i ? "rotate-180" : ""
                    }`}
                  />
                </button>
                {activeFaq === i && (
                  <div className="px-5 pb-5">
                    <p className="text-gray-600 leading-relaxed">{faq.a}</p>
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Download CTA Section */}
      <section className="py-20 lg:py-28 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-br from-blue-950 via-blue-900 to-teal-800" />
        <div className="absolute inset-0 opacity-10" style={{
          backgroundImage: "url('/images/desert-adventure.jpg')",
          backgroundSize: "cover",
          backgroundPosition: "center",
        }} />

        <div className="relative max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <div className="inline-flex items-center gap-2 bg-white/10 backdrop-blur-sm border border-white/20 rounded-full px-4 py-2 mb-8">
            <Battery className="w-4 h-4 text-teal-400" />
            <span className="text-sm font-medium text-teal-300">
              Disponibil pe iPhone & iPad
            </span>
          </div>

          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-black text-white mb-6">
            Descarca SatConnect
            <br />
            <span className="bg-gradient-to-r from-teal-400 to-cyan-300 bg-clip-text text-transparent">
              si ramai conectat
            </span>
          </h2>

          <p className="text-lg text-blue-200 max-w-xl mx-auto mb-10">
            Incepe gratuit cu 3 GB. Fara card de credit, fara contracte.
            Upgrade oricand din aplicatie.
          </p>

          <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
            <button className="flex items-center gap-3 bg-white text-blue-900 px-8 py-4 rounded-2xl font-bold text-lg hover:shadow-2xl hover:shadow-white/20 transition-all hover:-translate-y-0.5">
              <svg className="w-7 h-7" viewBox="0 0 24 24" fill="currentColor">
                <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.8-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/>
              </svg>
              <div className="text-left">
                <div className="text-xs font-normal opacity-70">Descarca din</div>
                <div className="text-base font-bold -mt-0.5">App Store</div>
              </div>
            </button>

            <button className="flex items-center gap-3 bg-white/10 backdrop-blur-sm border border-white/30 text-white px-8 py-4 rounded-2xl font-bold text-lg hover:bg-white/20 transition-all">
              <Phone className="w-6 h-6" />
              <div className="text-left">
                <div className="text-xs font-normal opacity-70">In curand pe</div>
                <div className="text-base font-bold -mt-0.5">Google Play</div>
              </div>
            </button>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-950 text-gray-400 py-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-4 gap-10 mb-12">
            <div>
              <div className="flex items-center gap-2 mb-4">
                <div className="w-9 h-9 bg-gradient-to-br from-blue-600 to-teal-500 rounded-xl flex items-center justify-center">
                  <Satellite className="w-5 h-5 text-white" />
                </div>
                <span className="text-xl font-bold text-white">SatConnect</span>
              </div>
              <p className="text-sm leading-relaxed">
                Conectivitate globala prin WiFi, date mobile, roaming si satelit.
                O singura aplicatie pentru 175 de tari.
              </p>
            </div>

            <div>
              <h4 className="text-white font-semibold mb-4">Produs</h4>
              <ul className="space-y-2 text-sm">
                <li><a href="#features" className="hover:text-teal-400 transition-colors">Functionalitati</a></li>
                <li><a href="#pricing" className="hover:text-teal-400 transition-colors">Preturi</a></li>
                <li><a href="#esim" className="hover:text-teal-400 transition-colors">eSIM</a></li>
                <li><a href="#connectivity" className="hover:text-teal-400 transition-colors">Conectivitate</a></li>
              </ul>
            </div>

            <div>
              <h4 className="text-white font-semibold mb-4">Companie</h4>
              <ul className="space-y-2 text-sm">
                <li><a href="#" className="hover:text-teal-400 transition-colors">Despre noi</a></li>
                <li><a href="#" className="hover:text-teal-400 transition-colors">Blog</a></li>
                <li><a href="#" className="hover:text-teal-400 transition-colors">Cariere</a></li>
                <li><a href="#" className="hover:text-teal-400 transition-colors">Contact</a></li>
              </ul>
            </div>

            <div>
              <h4 className="text-white font-semibold mb-4">Legal</h4>
              <ul className="space-y-2 text-sm">
                <li><a href="#" className="hover:text-teal-400 transition-colors">Termeni si conditii</a></li>
                <li><a href="#" className="hover:text-teal-400 transition-colors">Politica de confidentialitate</a></li>
                <li><a href="#" className="hover:text-teal-400 transition-colors">Politica cookies</a></li>
                <li><a href="#" className="hover:text-teal-400 transition-colors">GDPR</a></li>
              </ul>
            </div>
          </div>

          <div className="border-t border-gray-800 pt-8 flex flex-col md:flex-row items-center justify-between gap-4">
            <p className="text-sm">
              2026 SatConnect. Toate drepturile rezervate.
            </p>
            <div className="flex items-center gap-2">
              <MessageSquare className="w-4 h-4" />
              <span className="text-sm">suport@satconnect.app</span>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}

export default App;
