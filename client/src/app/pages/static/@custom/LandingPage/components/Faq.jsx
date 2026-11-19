import React, { useState } from "react";
import Button from "../../../../../components/ui/Button.jsx";

/**
 * FAQ section using accordion pattern with five questions.
 */
export default function Faq() {
  const faqItems = [
    {
      question: "What is Byoc Rails?",
      answer:
        "Byoc Rails is the repository maria-orkosi/byoc-rails, brought to Orkosi as it is and run from its own code. Every part of your Rails application is detected, placed, and deployed without a remake. It is a SaaS platform that lets you bring your existing codebase and deploy it directly.",
    },
    {
      question: "Who is Byoc Rails for?",
      answer:
        "Byoc Rails is built for SaaS teams that want to deploy their Rails applications without rebuilding them for a specific platform. If you have a Rails repository and want to run it in production with minimal configuration, Byoc Rails is for you.",
    },
    {
      question: "How do I get started?",
      answer:
        "Getting started is straightforward: sign up, connect your repository, and Orkosi automatically detects your stack. Your Rails app, database, background jobs, and dependencies are placed on the right infrastructure and deployed from your own code — no rewrites needed.",
    },
    {
      question: "What does it cost?",
      answer:
        "We offer flexible pricing tailored to your team's needs. Contact us to discuss the right plan for your SaaS application. Our plans scale with your usage and include infrastructure, monitoring, and support.",
    },
    {
      question: "How is my data handled and can I cancel?",
      answer:
        "Your code stays yours — Byoc Rails runs your repository as it is. You can cancel at any time and export your data. We do not lock you into a proprietary format or platform. Your repository, your database, and your data remain under your control.",
    },
  ];

  return (
    <section className="border-b border-brand-border bg-brand-bg px-4 py-20">
      <div className="mx-auto max-w-3xl">
        <div className="mb-12 text-center">
          <h2 className="mb-4 text-3xl font-bold text-brand-text">
            Frequently asked questions
          </h2>
          <p className="mx-auto max-w-2xl text-brand-text-muted">
            Everything you need to know about Byoc Rails.
          </p>
        </div>

        <div className="flex flex-col gap-3">
          {faqItems.map((item) => (
            <FaqItem key={item.question} question={item.question} answer={item.answer} />
          ))}
        </div>
      </div>
    </section>
  );
}

/**
 * @param {object} props
 * @param {string} props.question
 * @param {string} props.answer
 */
function FaqItem({ question, answer }) {
  const [open, setOpen] = useState(false);

  return (
    <div className="rounded-lg border border-brand-border bg-brand-surface">
      <Button
        className="flex w-full items-center justify-between rounded-lg px-6 py-4 text-left text-sm font-medium text-brand-text bg-transparent hover:bg-transparent"
        onClick={() => setOpen(!open)}
      >
        <span>{question}</span>
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="16"
          height="16"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
          className={`transition-transform ${open ? "rotate-180" : ""}`}
        >
          <polyline points="6 9 12 15 18 9" />
        </svg>
      </Button>
      {open && (
        <div className="border-t border-brand-border px-6 py-4">
          <p className="text-sm leading-relaxed text-brand-text-muted">{answer}</p>
        </div>
      )}
    </div>
  );
}