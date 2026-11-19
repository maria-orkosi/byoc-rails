import React, { useState } from "react";
import Button from "../../../components/ui/Button.jsx";
import Input from "../../../components/ui/Input.jsx";
import content from "../../../content/@custom/waiting-list.json";

/**
 * @typedef {"idle" | "loading" | "success" | "duplicate" | "invalid" | "rate_limit" | "error"} SubmitState
 */

/**
 * Waiting list signup page component.
 */
export default function WaitingListNew() {
  const [email, setEmail] = useState("");
  /** @type {[SubmitState, (s: SubmitState) => void]} */
  const [submitState, setSubmitState] = useState("idle");
  const [message, setMessage] = useState("");
  const [cooldown, setCooldown] = useState(false);

  /** @param {React.ChangeEvent<HTMLInputElement>} e */
  const handleEmailChange = (e) => {
    setEmail(e.target.value);
    if (submitState === "invalid") {
      setSubmitState("idle");
      setMessage("");
    }
  };

  /** @param {React.FormEvent<HTMLFormElement>} e */
  const handleSubmit = async (e) => {
    e.preventDefault();

    if (cooldown) return;

    setSubmitState("loading");

    try {
      const response = await fetch("/api/waiting_list", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email }),
      });

      const data = await response.json();

      if (response.status === 429) {
        setSubmitState("rate_limit");
        setMessage(data.message || content.rateLimitMessage);
        return;
      }

      if (response.ok || response.status === 201) {
        setSubmitState("success");
        setMessage(data.message || content.successMessage);
        setEmail("");

        // Disable button for cooldown period
        setCooldown(true);
        setTimeout(() => {
          setCooldown(false);
        }, content.submitCooldownMs);
      } else if (response.status === 422) {
        setSubmitState("invalid");
        setMessage(data.message || content.invalidMessage);
      } else if (response.status === 200) {
        setSubmitState("duplicate");
        setMessage(data.message || content.duplicateMessage);
      } else {
        setSubmitState("error");
        setMessage(content.genericErrorMessage);
      }
    } catch {
      setSubmitState("error");
      setMessage(content.networkErrorMessage);
    }
  };

  return (
    <div className="flex min-h-screen flex-col items-center justify-center px-4">
      <div className="w-full max-w-md rounded-lg border border-brand-border bg-brand-surface p-8 shadow-sm">
        <h1 className="mb-6 text-center text-2xl font-semibold text-brand-text">
          {content.heading}
        </h1>

        <form onSubmit={handleSubmit} noValidate className="flex flex-col gap-4">
          <div>
            <Input
              id="email"
              name="email"
              type="email"
              placeholder={content.emailLabel}
              value={email}
              onChange={handleEmailChange}
            />
          </div>

          <Button type="submit" disabled={submitState === "loading" || cooldown}>
            {submitState === "loading" ? "Joining..." : content.submitLabel}
          </Button>
        </form>

        {message && (
          <p
            className={`mt-4 text-center text-sm ${
              submitState === "success" || submitState === "duplicate"
                ? "text-brand-primary"
                : submitState === "invalid" || submitState === "rate_limit" || submitState === "error"
                  ? "text-destructive"
                  : "text-brand-text-muted"
            }`}
          >
            {message}
          </p>
        )}
      </div>
    </div>
  );
}