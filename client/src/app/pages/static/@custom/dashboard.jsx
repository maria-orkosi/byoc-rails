import { useState, useEffect } from "react";

const API_BASE = import.meta.env.VITE_API_URL || "";

export default function DashboardPage() {
  const [projects, setProjects] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [noProjects, setNoProjects] = useState(false);

  useEffect(() => {
    let cancelled = false;

    async function fetchProjects() {
      try {
        const res = await fetch(`${API_BASE}/projects`, {
          headers: { Accept: "application/json" },
        });
        if (!cancelled) {
          if (res.redirected || res.status === 302) {
            window.location.href = "/onboarding?step=1";
            return;
          }
          if (res.ok) {
            const data = await res.json();
            if (Array.isArray(data)) {
              setProjects(data);
              if (data.length === 0) setNoProjects(true);
            } else {
              setProjects(data.projects || []);
            }
          } else {
            setError("Unable to load projects.");
          }
        }
      } catch (_err) {
        if (!cancelled) setError("Unable to reach the server.");
      } finally {
        if (!cancelled) setLoading(false);
      }
    }

    fetchProjects();
    return () => { cancelled = true; };
  }, []);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <p className="text-muted-foreground text-lg">Loading dashboard...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[60vh] gap-4">
        <h1 className="text-2xl font-semibold text-foreground">Dashboard</h1>
        <p className="text-muted-foreground">{error}</p>
      </div>
    );
  }

  if (noProjects || projects.length === 0) {
    return (
      <div className="max-w-2xl mx-auto py-12 px-4 text-center">
        <h1 className="text-2xl font-semibold text-foreground mb-4">Dashboard</h1>
        <p className="text-muted-foreground mb-6">No projects yet.</p>
        <a
          href="/onboarding?step=1"
          className="inline-block px-4 py-2 rounded-md bg-accent text-white text-sm font-medium hover:opacity-90 transition-opacity"
        >
          Create Your First Project
        </a>
      </div>
    );
  }

  return (
    <div className="max-w-2xl mx-auto py-12 px-4">
      <h1 className="text-2xl font-semibold text-foreground mb-6">Dashboard</h1>

      <div className="rounded-lg border bg-card">
        {projects.map((project) => (
          <div
            key={project.id}
            className="p-4 border-b border-muted last:border-b-0"
          >
            <a
              href={`/projects/${project.id}`}
              className="font-semibold text-sm text-accent hover:underline"
            >
              {project.name}
            </a>
            <p className="text-xs text-muted-foreground mt-1">
              Database: {(project.database_choice || "").charAt(0).toUpperCase() + (project.database_choice || "").slice(1)} |
              Created: {new Date(project.created_at).toLocaleDateString()}
              <span className="ml-2 inline-block px-1.5 py-0.5 rounded-full text-xs font-medium bg-accent/10 text-accent">
                {project.status}
              </span>
            </p>
          </div>
        ))}
      </div>

      <div className="text-center mt-6">
        <a
          href="/onboarding?step=1"
          className="inline-block px-4 py-2 rounded-md bg-accent text-white text-sm font-medium hover:opacity-90 transition-opacity"
        >
          New Project
        </a>
      </div>
    </div>
  );
}