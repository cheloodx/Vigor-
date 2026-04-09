import { BrowserRouter, Routes, Route, useLocation } from 'react-router-dom'
import { useEffect } from 'react'
import Navbar from '@/components/Navbar'
import Footer from '@/components/Footer'
import Home from '@/pages/Home'
import Features from '@/pages/Features'
import HowItWorks from '@/pages/HowItWorks'
import ForService from '@/pages/ForService'
import About from '@/pages/About'
import Contact from '@/pages/Contact'
import Pricing from '@/pages/Pricing'
import FAQ from '@/pages/FAQ'
import Terms from '@/pages/Terms'
import ToolsHub from '@/pages/tools/ToolsHub'
import ChatTool from '@/pages/tools/ChatTool'
import DTCTool from '@/pages/tools/DTCTool'
import VINTool from '@/pages/tools/VINTool'
import ScanTool from '@/pages/tools/ScanTool'
import PredictorTool from '@/pages/tools/PredictorTool'
import SoundTool from '@/pages/tools/SoundTool'
import EuropeanTool from '@/pages/tools/EuropeanTool'
import RecallTool from '@/pages/tools/RecallTool'
import BlockchainTool from '@/pages/tools/BlockchainTool'

function ScrollToTop() {
  const { pathname } = useLocation()
  useEffect(() => { window.scrollTo(0, 0) }, [pathname])
  return null
}

function App() {
  return (
    <BrowserRouter>
      <ScrollToTop />
      <div className="min-h-screen bg-slate-950 text-white">
        <Navbar />
        <main>
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/functionalitati" element={<Features />} />
            <Route path="/cum-functioneaza" element={<HowItWorks />} />
            <Route path="/pentru-service" element={<ForService />} />
            <Route path="/despre" element={<About />} />
            <Route path="/contact" element={<Contact />} />
            <Route path="/pricing" element={<Pricing />} />
            <Route path="/faq" element={<FAQ />} />
            <Route path="/termeni" element={<Terms />} />
            <Route path="/tools" element={<ToolsHub />} />
            <Route path="/tools/chat" element={<ChatTool />} />
            <Route path="/tools/dtc" element={<DTCTool />} />
            <Route path="/tools/vin" element={<VINTool />} />
            <Route path="/tools/scan" element={<ScanTool />} />
            <Route path="/tools/predictor" element={<PredictorTool />} />
            <Route path="/tools/sound" element={<SoundTool />} />
            <Route path="/tools/european" element={<EuropeanTool />} />
            <Route path="/tools/recalls" element={<RecallTool />} />
            <Route path="/tools/blockchain" element={<BlockchainTool />} />
          </Routes>
        </main>
        <Footer />
      </div>
    </BrowserRouter>
  )
}

export default App
