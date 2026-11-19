import { useState, useEffect } from "react";

const API_BASE = import.meta.env.VITE_API_URL || "";

export default function HealthStatusPage() {
  const [health, setHealth] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    let cancelled = false;

    async function fetchHealth() {
      try {
        const res = await fetch(`${API_BASE}/health`);
        const data = await res.json();
        if (!cancelled) {
          setHealth(data);
          setError(null);
        }
      } catch (err) {
        if (!cancelled) {
          setError("Unable to reach health endpoint.");
        }
      } finally {
        if (!cancelled) {
          setLoading(false);
        }
      }
    }

    fetchHealth();
    return () => {
      cancelled = true;
    };
  }, []);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <p className="text-muted-foreground text-lg">Loading system status...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[60vh] gap-4">
        <div className="rounded-full bg-destructive/10 p-4">
          <span className="text-destructive text-2xl font-bold">!</span>
        </div>
        <h1 className="text-2xl font-semibold text-foreground">System Status Unavailable</h1>
        <p className="text-muted-foreground">{error}</p>
      </div>
    );
  }

  const statusOk = health?.status === "ok";
  const checks = health?.checks || {};

  return (
    <div className="max-w-2xl mx-auto py-12 px-4">
      <div className="flex items-center gap-3 mb-8">
        <div
          className={`rounded-full p-2 ${
            statusOk ? "bg-accent/10" : "bg-destructive/10"
          }`}
        >
          <span
            className={`text-lg font-bold ${
              statusOk ? "text-accent" : "text-destructive"
            }`}
          >
            {statusOk ? "\u2713" : "\u2717"}
          </span>
        </div>
        <div>
          <h1 className="text-2xl font-semibold text-foreground">
            System Status
          </h1>
          <p className="text-muted-foreground">
            {statusOk ? "All systems operational" : "Service disruption detected"}
          </p>
        </div>
      </div>

      <div className="grid gap-4">
        <div className="rounded-lg border bg-card p-4">
          <h2 className="text-sm font-medium text-muted-foreground mb-2">
            Overall Status
          </h2>
          <p
            className={`text-lg font-semibold ${
              statusOk ? "text-accent" : "text-destructive"
            }`}
          >
            {statusOk ? "Healthy" : "Degraded"}
          </p>
        </div>

        <div className="rounded-lg border bg-card p-4">
          <h2 className="text-sm font-medium text-muted-foreground mb-2">
            Uptime
          </h2>
          <p className="text-lg font-semibold text-foreground">
            {health?.uptime != null ? `${health.uptime}s` : "N/A"}
          </p>
        </div>

        <div className="rounded-lg border bg-card p-4">
          <h2 className="text-sm font-medium text-muted-foreground mb-3">
            Dependency Checks
          </h2>
          <div className="space-y-2">
            {Object.entries(checks).map(([name, value]) => (
              <div
                key={name}
                className="flex items-center justify-between py-1"
              >
                <span className="text-foreground font-medium capitalize">
                  {name}
                </span>
                <span
                  className={`px-2 py-0.5 rounded text-sm font-medium ${
                    value === "ok"
                      ? "bg-accent/10 text-accent"
                      : "bg-destructive/10 text-destructive"
                  }`}
                >
                  {value === "ok" ? "OK" : "ERROR"}
                </span>
              </div>
            ))}
          </div>
        </div>

        <div className="rounded-lg border bg-card p-4">
          <h2 className="text-sm font-medium text-muted-foreground mb-2">
            Last Checked
          </h2>
          <p className="text-foreground">
            {health?.timestamp
              ? new Date(health.timestamp).toLocaleString()
              : "N/A"}
          </p>
        </div>
      </div>

      <p className="text-xs text-muted-foreground mt-8 text-center">
        Byoc Rails — System Health
      </p>
    </div>
  );
}