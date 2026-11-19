import React from "react";

/**
 * @param {object} props
 * @param {string[]} props.steps
 * @param {string} props.currentStep
 * @param {boolean} props.completed
 */
export default function OnboardingProgress({ steps, currentStep, completed }) {
  const currentIndex = steps.indexOf(currentStep);

  return (
    <div className="mb-8">
      <div className="flex items-center justify-between">
        {steps.map((step, index) => {
          const isActive = index === currentIndex && !completed;
          const isCompleted = completed || index < currentIndex;

          return (
            <div key={step} className="flex flex-col items-center">
              <div
                className={`flex h-8 w-8 items-center justify-center rounded-full text-xs font-medium ${
                  isCompleted
                    ? "bg-brand-primary text-brand-text-on-primary"
                    : isActive
                      ? "border-2 border-brand-primary text-brand-primary"
                      : "border border-brand-border bg-brand-surface text-brand-text-muted"
                }`}
              >
                {isCompleted ? "\u2713" : index + 1}
              </div>
              <span
                className={`mt-1 text-xs ${
                  isActive || isCompleted ? "text-brand-text" : "text-brand-text-muted"
                }`}
              >
                {step.charAt(0).toUpperCase() + step.slice(1)}
              </span>
            </div>
          );
        })}
      </div>
      <div className="mt-2 flex">
        {steps.map((step, index) => {
          const isCompleted = completed || index < currentIndex;
          return (
            <div
              key={step}
              className={`h-1 flex-1 ${
                index > 0 ? "ml-1" : ""
              } ${isCompleted ? "bg-brand-primary" : "bg-brand-border"}`}
            />
          );
        })}
      </div>
    </div>
  );
}