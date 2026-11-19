import React from "react";

/**
 * @param {object} props
 * @param {string} props.title
 * @param {string} props.description
 * @param {React.ReactNode} props.icon
 */
function FeatureCard({ title, description, icon }) {
  return (
    <div className="rounded-lg border border-brand-border bg-brand-surface p-6">
      <div className="mb-4 text-brand-primary">{icon}</div>
      <h3 className="mb-2 text-lg font-semibold text-brand-text">{title}</h3>
      <p className="text-sm leading-relaxed text-brand-text-muted">{description}</p>
    </div>
  );
}

/**
 * FeatureGrid section showing 3-6 features from the product description.
 */
export default function FeatureGrid() {
  const features = [
    {
      icon: (
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z" />
        </svg>
      ),
      title: "Auto-Detection",
      description:
        "Every part of your repository is detected automatically when you bring it to Orkosi. No manual configuration required.",
    },
    {
      icon: (
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" />
        </svg>
      ),
      title: "Deploy from Your Own Code",
      description:
        "Your repository runs directly from its own code on Orkosi. No rewrites, no platform lock-in.",
    },
    {
      icon: (
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <polyline points="16 3 21 3 21 8" />
          <line x1="4" y1="20" x2="21" y2="3" />
          <polyline points="21 16 21 21 16 21" />
          <line x1="15" y1="15" x2="21" y2="21" />
          <line x1="4" y1="4" x2="9" y2="9" />
        </svg>
      ),
      title: "Seamless Placement",
      description:
        "Your code is placed and deployed on infrastructure that matches your stack. Rails, databases, background jobs — it all just works.",
    },
    {
      icon: (
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <rect x="2" y="3" width="20" height="14" rx="2" ry="2" />
          <line x1="8" y1="21" x2="16" y2="21" />
          <line x1="12" y1="17" x2="12" y2="21" />
        </svg>
      ),
      title: "Full Operations",
      description:
        "Monitoring, logging, scaling, and zero-downtime deployments are built in. Focus on your product while Orkosi handles operations.",
    },
    {
      icon: (
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
        </svg>
      ),
      title: "Built-In Reliability",
      description:
        "Every deployment gets health checks, automatic restarts, and isolated environments so your SaaS stays online.",
    },
    {
      icon: (
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <circle cx="12" cy="12" r="10" />
          <polyline points="12 6 12 12 16 14" />
        </svg>
      ),
      title: "Rapid Time-to-Value",
      description:
        "Bring your repo and go live in minutes, not weeks. Byoc Rails shortens the path from code to production.",
    },
  ];

  return (
    <section className="border-b border-brand-border bg-brand-bg px-4 py-20">
      <div className="mx-auto max-w-6xl">
        <div className="mb-12 text-center">
          <h2 className="mb-4 text-3xl font-bold text-brand-text">
            Everything your repository needs to run
          </h2>
          <p className="mx-auto max-w-2xl text-brand-text-muted">
            Byoc Rails detects, places, and deploys every part of your Rails
            application so you can focus on building your SaaS.
          </p>
        </div>

        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {features.map((feature) => (
            <FeatureCard
              key={feature.title}
              title={feature.title}
              description={feature.description}
              icon={feature.icon}
            />
          ))}
        </div>
      </div>
    </section>
  );
}