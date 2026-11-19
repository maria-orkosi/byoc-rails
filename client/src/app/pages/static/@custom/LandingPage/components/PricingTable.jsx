import React from "react";
import Button from "../../../../../components/ui/Button.jsx";

/**
 * Pricing section: displays plans from brand configuration or "Contact us".
 */
export default function PricingTable() {
  return (
    <section className="border-b border-brand-border bg-brand-surface px-4 py-20">
      <div className="mx-auto max-w-6xl">
        <div className="mb-12 text-center">
          <h2 className="mb-4 text-3xl font-bold text-brand-text">Pricing</h2>
          <p className="mx-auto max-w-2xl text-brand-text-muted">
            Simple, transparent pricing for teams of every size.
          </p>
        </div>

        <div className="mx-auto max-w-md rounded-lg border border-brand-border bg-brand-bg p-8 text-center">
          <h3 className="mb-2 text-xl font-semibold text-brand-text">
            Contact us
          </h3>
          <p className="mb-6 text-sm leading-relaxed text-brand-text-muted">
            We offer flexible plans tailored to your team&rsquo;s needs. Reach
            out and we&rsquo;ll find the right fit for your SaaS.
          </p>
          <Button onClick={() => {}}>Contact us</Button>
        </div>
      </div>
    </section>
  );
}