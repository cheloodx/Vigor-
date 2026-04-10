import { BrowserRouter, Routes, Route } from 'react-router-dom'
import { AuthProvider } from '@/lib/auth'
import Navbar from '@/components/Navbar'
import Footer from '@/components/Footer'
import Home from '@/pages/Home'
import Features from '@/pages/Features'
import HowItWorks from '@/pages/HowItWorks'
import ForService from '@/pages/ForService'
import Pricing from '@/pages/Pricing'
import About from '@/pages/About'
import Contact from '@/pages/Contact'
import FAQ from '@/pages/FAQ'
import Terms from '@/pages/Terms'
import Login from '@/pages/auth/Login'
import Register from '@/pages/auth/Register'
import ForgotPassword from '@/pages/auth/ForgotPassword'
import MyVehicles from '@/pages/MyVehicles'
import ToolsHub from '@/pages/tools/ToolsHub'
import ChatTool from '@/pages/tools/ChatTool'
import ScanTool from '@/pages/tools/ScanTool'
import DTCTool from '@/pages/tools/DTCTool'
import VINTool from '@/pages/tools/VINTool'
import PredictorTool from '@/pages/tools/PredictorTool'
import SoundTool from '@/pages/tools/SoundTool'
import EuropeanTool from '@/pages/tools/EuropeanTool'
import RecallTool from '@/pages/tools/RecallTool'
import BlockchainTool from '@/pages/tools/BlockchainTool'
import ScorSanatate from '@/pages/tools/ScorSanatate'
import DiagramaAuto from '@/pages/tools/DiagramaAuto'
import ScannerPiese from '@/pages/tools/ScannerPiese'
import DiagnosticRapid from '@/pages/tools/DiagnosticRapid'
import RadarITP from '@/pages/tools/RadarITP'
import DigitalTwin from '@/pages/tools/DigitalTwin'
import CVAuto from '@/pages/tools/CVAuto'
import OBD2Tool from '@/pages/tools/OBD2Tool'
import CalculatorConsum from '@/pages/tools/CalculatorConsum'
import EstimatorValoare from '@/pages/tools/EstimatorValoare'
import ServiceCalendar from '@/pages/tools/ServiceCalendar'
import CosturiTool from '@/pages/tools/CosturiTool'
import VoceTool from '@/pages/tools/VoceTool'
import ComparatorTool from '@/pages/tools/ComparatorTool'
import ComparatorRCA from '@/pages/tools/ComparatorRCA'
import HartaService from '@/pages/tools/HartaService'
import Marketplace from '@/pages/tools/Marketplace'
import LegalAmenzi from '@/pages/tools/LegalAmenzi'

export default function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <div className="min-h-screen bg-[#020617] text-white">
          <Navbar />
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/features" element={<Features />} />
            <Route path="/how-it-works" element={<HowItWorks />} />
            <Route path="/for-service" element={<ForService />} />
            <Route path="/pricing" element={<Pricing />} />
            <Route path="/about" element={<About />} />
            <Route path="/contact" element={<Contact />} />
            <Route path="/faq" element={<FAQ />} />
            <Route path="/terms" element={<Terms />} />
            <Route path="/login" element={<Login />} />
            <Route path="/register" element={<Register />} />
            <Route path="/forgot-password" element={<ForgotPassword />} />
            <Route path="/my-vehicles" element={<MyVehicles />} />
            <Route path="/tools" element={<ToolsHub />} />
            <Route path="/tools/chat" element={<ChatTool />} />
            <Route path="/tools/scan" element={<ScanTool />} />
            <Route path="/tools/dtc" element={<DTCTool />} />
            <Route path="/tools/vin" element={<VINTool />} />
            <Route path="/tools/predictor" element={<PredictorTool />} />
            <Route path="/tools/sound" element={<SoundTool />} />
            <Route path="/tools/european" element={<EuropeanTool />} />
            <Route path="/tools/recall" element={<RecallTool />} />
            <Route path="/tools/blockchain" element={<BlockchainTool />} />
            <Route path="/tools/scor-sanatate" element={<ScorSanatate />} />
            <Route path="/tools/diagrama" element={<DiagramaAuto />} />
            <Route path="/tools/scanner-piese" element={<ScannerPiese />} />
            <Route path="/tools/diagnostic-rapid" element={<DiagnosticRapid />} />
            <Route path="/tools/radar-itp" element={<RadarITP />} />
            <Route path="/tools/digital-twin" element={<DigitalTwin />} />
            <Route path="/tools/cv-auto" element={<CVAuto />} />
            <Route path="/tools/obd2" element={<OBD2Tool />} />
            <Route path="/tools/calculator-consum" element={<CalculatorConsum />} />
            <Route path="/tools/estimator-valoare" element={<EstimatorValoare />} />
            <Route path="/tools/service-calendar" element={<ServiceCalendar />} />
            <Route path="/tools/costuri" element={<CosturiTool />} />
            <Route path="/tools/voce" element={<VoceTool />} />
            <Route path="/tools/comparator" element={<ComparatorTool />} />
            <Route path="/tools/comparator-rca" element={<ComparatorRCA />} />
            <Route path="/tools/harta-service" element={<HartaService />} />
            <Route path="/tools/marketplace" element={<Marketplace />} />
            <Route path="/tools/legal-amenzi" element={<LegalAmenzi />} />
          </Routes>
          <Footer />
        </div>
      </AuthProvider>
    </BrowserRouter>
  )
}
