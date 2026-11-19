import React from "react";

/**
 * Steps section: three numbered steps from first visit to the outcome.
 */
export default function Steps() {
  const steps = [
    {
      number: 1,
      title: "Bring your repository",
      description:
        "Connect your Rails repository to Orkosi. Every part of your codebase is detected automatically — your app, database, jobs, and dependencies.",
    },
    {
      number: 2,
      title: "Let Orkosi place it",
      description:
        "Orkosi analyzes your stack and provisions the right infrastructure. No manual configs, no YAML wrangling. Your Rails app gets the environment it needs.",
    },
    {
      number: 3,
      title: "Deploy and iterate",
      description:
        "Your app goes live from its own code. Push changes, scale up, monitor health — all from one place. Your repository stays yours, running on your terms.",
    },
  ];

  return (
    <section className="border-b border-brand-border bg-brand-surface px-4 py-20">
      <div className="mx-auto max-w-6xl">
        <div className="mb-12 text-center">
          <h2 className="mb-4 text-3xl font-bold text-brand-text">
            How it works
          </h2>
          <p className="mx-auto max-w-2xl text-brand-text-muted">
            Three steps from repository to running SaaS. No remake required.
          </p>
        </div>

        <div className="grid gap-8 md:grid-cols-3">
          {steps.map((step) => (
            <div key={step.number} className="flex flex-col items-center text-center">
              <div className="mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-brand-primary text-lg font-bold text-brand-text-on-primary">
                {step.number}
              </div>
              <h3 className="mb-2 text-lg font-semibold text-brand-text">
                {step.title}
              </h3>
              <p className="text-sm leading-relaxed text-brand-text-muted">
                {step.description}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}