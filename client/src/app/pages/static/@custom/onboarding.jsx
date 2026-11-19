import { useState, useEffect } from "react";
import Button from "../../../components/ui/Button.jsx";
import Input from "../../../components/ui/Input.jsx";
import Select from "../../../components/ui/Select.jsx";
import Checkbox from "../../../components/ui/Checkbox.jsx";

const API_BASE = import.meta.env.VITE_API_URL || "";
const TOTAL_STEPS = 4;

const STEP_TITLES = {
  1: "Name Your Project",
  2: "Choose Your Database",
  3: "Select Optional Gems",
  4: "Review and Create",
};

const STEP_DESCRIPTIONS = {
  1: "Give your Byoc Rails project a name to get started.",
  2: "Select the database engine for your new project.",
  3: "Pick any additional gems you would like included.",
  4: "Review your choices and set an initial commit message.",
};

const DATABASE_OPTIONS = [
  { label: "PostgreSQL", value: "postgresql" },
  { label: "MySQL", value: "mysql" },
  { label: "SQLite", value: "sqlite" },
];

const GEM_OPTIONS = [
  { label: "Devise (authentication)", value: "devise" },
  { label: "RSpec (testing)", value: "rspec" },
  { label: "Sidekiq (background jobs)", value: "sidekiq" },
  { label: "Pundit (authorization)", value: "pundit" },
  { label: "Kaminari (pagination)", value: "kaminari" },
];

export default function OnboardingPage() {
  const [step, setStep] = useState(1);
  const [data, setData] = useState({
    project_name: "",
    database_choice: "",
    gems: [],
    commit_message: "",
  });
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(true);
  const [redirecting, setRedirecting] = useState(false);

  useEffect(() => {
    let cancelled = false;

    async function loadState() {
      try {
        const res = await fetch(`${API_BASE}/onboarding?step=1`, {
          headers: { Accept: "application/json" },
        });
        if (!cancelled) {
          if (res.redirected || res.status === 302) {
            setRedirecting(true);
          } else if (res.ok) {
            const json = await res.json();
            if (json.step) setStep(json.step);
            if (json.onboarding_data) setData(json.onboarding_data);
            if (json.has_projects) setRedirecting(true);
          }
        }
      } catch (_err) {
        // Continue with defaults
      } finally {
        if (!cancelled) setLoading(false);
      }
    }

    loadState();
    return () => { cancelled = true; };
  }, []);

  function validateCurrentStep() {
    const newErrors = {};
    switch (step) {
      case 1:
        if (!data.project_name.trim()) newErrors.project_name = "Project name is required";
        break;
      case 2:
        if (!data.database_choice) newErrors.database_choice = "Please select a database";
        break;
      case 3:
        break;
      case 4:
        if (!data.commit_message.trim()) newErrors.commit_message = "Commit message is required";
        break;
    }
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  }

  async function handleNext() {
    if (!validateCurrentStep()) return;

    try {
      const res = await fetch(`${API_BASE}/onboarding`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json", Accept: "application/json" },
        body: JSON.stringify({ step, ...data }),
      });
      if (res.ok) {
        const json = await res.json();
        if (json.redirect_to) {
          window.location.href = json.redirect_to;
        } else if (json.next_step) {
          setStep(json.next_step);
          setErrors({});
        }
      } else {
        const json = await res.json();
        if (json.errors) setErrors(json.errors);
      }
    } catch (_err) {
      setErrors({ base: "Network error. Please try again." });
    }
  }

  async function handleBack() {
    try {
      const res = await fetch(`${API_BASE}/onboarding`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json", Accept: "application/json" },
        body: JSON.stringify({ step, direction: "back" }),
      });
      if (res.ok) {
        const json = await res.json();
        if (json.step) setStep(json.step);
      }
    } catch (_err) {
      if (step > 1) setStep(step - 1);
    }
  }

  function handleChange(field, value) {
    setData((prev) => ({ ...prev, [field]: value }));
    if (errors[field]) setErrors((prev) => { const next = { ...prev }; delete next[field]; return next; });
  }

  function handleGemToggle(value) {
    setData((prev) => {
      const gems = prev.gems || [];
      if (gems.includes(value)) return { ...prev, gems: gems.filter((g) => g !== value) };
      return { ...prev, gems: [...gems, value] };
    });
  }
if (redirecting) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <p className="text-muted-foreground text-lg">Redirecting to your dashboard...</p>
      </div>
    );
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <p className="text-muted-foreground text-lg">Loading...</p>
      </div>
    );
  }
return (
    <div className="max-w-2xl mx-auto py-12 px-4">
      {/* Progress Indicator */}
      <div className="flex items-center justify-center gap-2 mb-8">
        {Array.from({ length: TOTAL_STEPS }, (_, i) => i + 1).map((s) => (
          <div key={s} className="flex items-center gap-2">
            <div
              className={`w-8 h-8 rounded-full flex items-center justify-center text-sm font-semibold border-2 ${
                s < step
                  ? "bg-accent border-accent text-white"
                  : s === step
                  ? "border-accent text-accent"
                  : "border-muted text-muted-foreground"
              }`}
            >
              {s < step ? "\u2713" : s}
            </div>
            {s < TOTAL_STEPS && (
              <div className={`w-8 h-0.5 ${s < step ? "bg-accent" : "bg-muted"}`} />
            )}
          </div>
        ))}
      </div>
<h1 className="text-2xl font-semibold text-foreground mb-2">{STEP_TITLES[step]}</h1>
      <p className="text-muted-foreground mb-6">{STEP_DESCRIPTIONS[step]}</p>

      <div className="rounded-lg border bg-card p-6">
        {errors.base && (
          <div className="rounded-md bg-destructive/10 text-destructive px-3 py-2 mb-4 text-sm">
            {errors.base}
          </div>
        )}

        {step === 1 && (
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-foreground mb-1">Project Name</label>
              <Input type="text" value={data.project_name}
                onChange={(e) => handleChange("project_name", e.target.value)}
                placeholder="e.g., my-byoc-rails-app"
                className={`w-full px-3 py-2 rounded-md border text-sm ${
                  errors.project_name ? "border-destructive" : "border-input"
                } bg-background text-foreground`} autoFocus />
              {errors.project_name && (
                <p className="text-destructive text-xs mt-1">{errors.project_name}</p>
              )}
            </div>
          </div>
        )}
{step === 2 && (
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-foreground mb-1">Database</label>
              <Select value={data.database_choice}
                onChange={(e) => handleChange("database_choice", e.target.value)}
                className={`w-full px-3 py-2 rounded-md border text-sm ${
                  errors.database_choice ? "border-destructive" : "border-input"
                } bg-background text-foreground`}>
                <option value="">-- Select a database --</option>
                {DATABASE_OPTIONS.map((opt) => (
                  <option key={opt.value} value={opt.value}>{opt.label}</option>
                ))}
              </Select>
              {errors.database_choice && (
                <p className="text-destructive text-xs mt-1">{errors.database_choice}</p>
              )}
            </div>
          </div>
        )}

        {step === 3 && (
          <div className="space-y-3">
            <p className="text-sm text-muted-foreground">
              These gems are optional. You can add them later.
            </p>
            {GEM_OPTIONS.map((opt) => (
              <label key={opt.value} className="flex items-center gap-2 cursor-pointer text-sm">
                <Checkbox checked={(data.gems || []).includes(opt.value)}
                  onChange={() => handleGemToggle(opt.value)} className="w-4 h-4" />
                {opt.label}
              </label>
            ))}
          </div>
        )}
{step === 4 && (
          <div className="space-y-4">
            <div className="rounded-md bg-muted/30 p-3 space-y-2">
              <div>
                <span className="text-xs text-muted-foreground uppercase tracking-wide">Project Name</span>
                <p className="text-sm font-medium">{data.project_name}</p>
              </div>
              <div>
                <span className="text-xs text-muted-foreground uppercase tracking-wide">Database</span>
                <p className="text-sm font-medium">
                  {data.database_choice
                    ? data.database_choice.charAt(0).toUpperCase() + data.database_choice.slice(1)
                    : ""}
                </p>
              </div>
              <div>
                <span className="text-xs text-muted-foreground uppercase tracking-wide">Optional Gems</span>
                <p className="text-sm font-medium">
                  {(data.gems || []).length > 0 ? data.gems.join(", ") : "None selected"}
                </p>
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-foreground mb-1">Initial Commit Message</label>
              <Input type="text" value={data.commit_message}
                onChange={(e) => handleChange("commit_message", e.target.value)}
                placeholder="e.g., Initial scaffold of Byoc Rails project"
                className={`w-full px-3 py-2 rounded-md border text-sm ${
                  errors.commit_message ? "border-destructive" : "border-input"
                } bg-background text-foreground`} autoFocus />
              {errors.commit_message && (
                <p className="text-destructive text-xs mt-1">{errors.commit_message}</p>
              )}
            </div>
          </div>
        )}
      </div>

      <div className="flex justify-between items-center mt-6">
        <div>
          {step > 1 && (
            <Button onClick={handleBack}
              className="px-4 py-2 rounded-md border border-input bg-background text-foreground text-sm font-medium hover:bg-muted transition-colors">
              Back
            </Button>
          )}
        </div>
        <div>
          <Button onClick={handleNext}
            className="px-4 py-2 rounded-md bg-accent text-white text-sm font-medium hover:opacity-90 transition-opacity">
            {step < TOTAL_STEPS ? "Next" : "Create Project"}
          </Button>
        </div>
      </div>

      <p className="text-center mt-6">
        <a href="/projects"
          className="text-sm text-muted-foreground underline hover:text-foreground">
          Skip onboarding
        </a>
      </p>
    </div>
  );
}