import React from "react";
import Button from "../../../../../components/ui/Button.jsx";

/**
 * Hero section with logo, headline, description, and primary CTA.
 *
 * @param {object} props
 * @param {() => void} [props.onCtaClick]
 */
export default function Hero({ onCtaClick }) {
  return (
    <section className="relative overflow-hidden border-b border-brand-border bg-brand-bg">
      <div className="mx-auto flex max-w-6xl flex-col items-center gap-8 px-4 py-20 md:flex-row md:gap-12 md:py-28">
        {/* Text content */}
        <div className="flex flex-1 flex-col items-start gap-6 text-left">
          <div className="flex items-center gap-3">
            <img
              src="/images/@custom/hero.svg"
              alt="Byoc Rails logo"
              className="h-10 w-10 rounded-md"
            />
            <span className="text-lg font-medium text-brand-text-muted">
              Byoc Rails
            </span>
          </div>

          <h1 className="max-w-md text-4xl font-bold leading-tight tracking-tight text-brand-text md:text-5xl">
            Byoc Rails
          </h1>

          <p className="max-w-md text-lg leading-relaxed text-brand-text-muted">
            Bring your Rails repository to Orkosi, and run it from its
            own code. Every part detected, placed and deployed.
          </p>

          <Button onClick={onCtaClick}>Get started</Button>
        </div>

        {/* Hero illustration */}
        <div className="flex flex-1 items-center justify-center">
          <img
            src="/images/@custom/hero.svg"
            alt="Byoc Rails illustration"
            className="w-full max-w-lg rounded-lg border border-brand-border"
          />
        </div>
      </div>
    </section>
  );
}