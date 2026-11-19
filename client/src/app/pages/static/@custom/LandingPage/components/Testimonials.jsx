import React from "react";

/**
 * Testimonials section: social proof placeholder with quote cards.
 */
export default function Testimonials() {
  const testimonials = [
    {
      quote: "Your customer's words go here",
      author: "Customer name, company",
      badge: "Placeholder",
    },
    {
      quote: "Your customer's words go here",
      author: "Customer name, company",
      badge: "Placeholder",
    },
    {
      quote: "Your customer's words go here",
      author: "Customer name, company",
      badge: "Placeholder",
    },
  ];

  return (
    <section className="border-b border-brand-border bg-brand-bg px-4 py-20">
      <div className="mx-auto max-w-6xl">
        <div className="mb-12 text-center">
          <h2 className="mb-4 text-3xl font-bold text-brand-text">
            Teams that build with us
          </h2>
          <p className="mx-auto max-w-2xl text-brand-text-muted">
            Hear from teams who brought their code to Orkosi.
          </p>
        </div>

        <div className="grid gap-6 md:grid-cols-3">
          {testimonials.map((item, index) => (
            <div
              key={index}
              className="flex flex-col rounded-lg border border-brand-border bg-brand-surface p-6"
            >
              <div className="mb-3">
                <span className="inline-block rounded-full bg-brand-accent/20 px-2 py-0.5 text-xs font-medium text-brand-accent">
                  {item.badge}
                </span>
              </div>
              <p className="mb-4 flex-1 text-sm leading-relaxed text-brand-text italic">
                &ldquo;{item.quote}&rdquo;
              </p>
              <p className="text-xs text-brand-text-muted">{item.author}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}