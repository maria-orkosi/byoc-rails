import React, { useState, useEffect, useCallback } from "react";
import Button from "../../components/ui/Button.jsx";
import OnboardingProgress from "../../components/@custom/OnboardingProgress.jsx";
import content from "../../content/@custom/onboarding.json";

/**
 * @typedef {"loading" | "not_started" | "in_progress" | "completed" | "error"} OnboardingStatus
 */

/**
 * Onboarding flow page — guides new users through setup steps.
 */
export default function OnboardingFlow() {
  /** @type {[OnboardingStatus, (s: OnboardingStatus) => void]} */
  const [status, setStatus] = useState("loading");
  const [currentStep, setCurrentStep] = useState(null);
  const [steps, setSteps] = useState([]);
  const [completed, setCompleted] = useState(false);
  const [completedAt, setCompletedAt] = useState(null);
  const [error, setError] = useState(null);
  const [submitting, setSubmitting] = useState(false);

  const fetchOnboarding = useCallback(async () => {
    setStatus("loading");
    setError(null);
    try {
      const res = await fetch("/api/onboarding");
      if (!res.ok) {
        throw new Error(content.errorMessage);
      }
      const data = await res.json();
      setSteps(data.steps || []);
      setCurrentStep(data.current_step);
      setCompleted(data.completed || false);
      setCompletedAt(data.completed_at || null);
      setStatus(data.status || "not_started");
    } catch {
      setError(content.errorMessage);
      setStatus("error");
    }
  }, []);

  useEffect(() => {
    fetchOnboarding();
  }, [fetchOnboarding]);

  /** @param {"start" | "advance" | "skip"} action */
  const handleAction = async (action) => {
    setSubmitting(true);
    setError(null);
    try {
      const res = await fetch(`/api/onboarding/${action}`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
      });
      if (!res.ok) {
        const errData = await res.json().catch(() => ({}));
        throw new Error(errData.error || content.errorMessage);
      }
      const data = await res.json();
      setSteps(data.steps || []);
      setCurrentStep(data.current_step);
      setCompleted(data.completed || false);
      setCompletedAt(data.completed_at || null);
      setStatus(data.status || "in_progress");
    } catch (e) {
      setError(e.message || content.errorMessage);
    } finally {
      setSubmitting(false);
    }
  };

  if (status === "loading") {
    return (
      <div className="flex min-h-[60vh] items-center justify-center">
        <p className="text-brand-text-muted">{content.loadingMessage}</p>
      </div>
    );
  }

  if (status === "error") {
    return (
      <div className="flex min-h-[60vh] flex-col items-center justify-center gap-4">
        <p className="text-destructive">{error || content.errorMessage}</p>
        <Button onClick={fetchOnboarding}>{content.retryLabel}</Button>
      </div>
    );
  }

  if (status === "not_started") {
    return (
      <div className="mx-auto max-w-2xl px-4 py-12">
        <h1 className="mb-2 text-3xl font-semibold text-brand-text">{content.pageTitle}</h1>
        <p className="mb-8 text-brand-text-muted">{content.notStartedMessage}</p>
        <Button onClick={() => handleAction("start")} disabled={submitting}>
          {submitting ? content.startingLabel : content.startLabel}
        </Button>
      </div>
    );
  }

  if (status === "completed") {
    return (
      <div className="mx-auto max-w-2xl px-4 py-12">
        <h1 className="mb-2 text-3xl font-semibold text-brand-text">
          {content.steps.complete.title}
        </h1>
        <p className="mb-8 text-brand-text-muted">{content.completedMessage}</p>
      </div>
    );
  }

  const stepInfo = content.steps[currentStep] || {};

  return (
    <div className="mx-auto max-w-2xl px-4 py-12">
      <h1 className="mb-2 text-3xl font-semibold text-brand-text">{content.pageTitle}</h1>
      <p className="mb-6 text-brand-text-muted">{content.pageDescription}</p>

      <div className="rounded-lg border border-brand-border bg-brand-surface p-6 shadow-sm">
        <OnboardingProgress steps={steps} currentStep={currentStep} completed={completed} />

        <div className="mb-6 mt-6">
          <h2 className="mb-2 text-xl font-medium text-brand-text">{stepInfo.title}</h2>
          <p className="text-brand-text-muted">{stepInfo.description}</p>
        </div>

        {error && (
          <p className="mb-4 text-sm text-destructive">{error}</p>
        )}

        <div className="flex items-center justify-between">
          <Button onClick={() => handleAction("skip")} disabled={submitting} className="bg-brand-surface text-brand-text-muted hover:bg-brand-border">
            {content.skipLabel}
          </Button>
          <Button onClick={() => handleAction("advance")} disabled={submitting}>
            {submitting ? content.savingLabel : content.nextLabel}
          </Button>
        </div>
      </div>
    </div>
  );
}