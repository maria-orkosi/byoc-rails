import React from "react";
import { useNavigate } from "react-router-dom";
import Hero from "./components/Hero.jsx";
import FeatureGrid from "./components/FeatureGrid.jsx";
import Steps from "./components/Steps.jsx";
import Testimonials from "./components/Testimonials.jsx";
import PricingTable from "./components/PricingTable.jsx";
import Faq from "./components/Faq.jsx";
import CallToAction from "./components/CallToAction.jsx";

/**
 * LandingPage — public landing page for Byoc Rails.
 * Sections: Hero, Features, How it works, Social proof, Pricing, FAQ, CTA.
 */
export default function LandingPage() {
  const navigate = useNavigate();

  /** Navigate to the sign-up page. */
  const handleCtaClick = () => {
    navigate("/waiting_list/new");
  };

  return (
    <div className="min-h-screen bg-brand-bg text-brand-text">
      <Hero onCtaClick={handleCtaClick} />
      <FeatureGrid />
      <Steps />
      <Testimonials />
      <PricingTable />
      <Faq />
      <CallToAction onCtaClick={handleCtaClick} />
    </div>
  );
}