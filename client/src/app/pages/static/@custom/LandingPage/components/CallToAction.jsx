import React from "react";
import Button from "../../../../../components/ui/Button.jsx";

/**
 * Closing call to action section.
 *
 * @param {object} props
 * @param {() => void} [props.onCtaClick]
 */
export default function CallToAction({ onCtaClick }) {
  return (
    <section className="bg-brand-surface px-4 py-20">
      <div className="mx-auto max-w-2xl text-center">
        <h2 className="mb-4 text-3xl font-bold text-brand-text">
          Run your Rails app from your own code
        </h2>
        <p className="mb-8 text-lg leading-relaxed text-brand-text-muted">
          Bring your repository to Orkosi. Every part detected, placed, and
          deployed without a remake.
        </p>
        <Button onClick={onCtaClick}>Get started</Button>
      </div>
    </section>
  );
}