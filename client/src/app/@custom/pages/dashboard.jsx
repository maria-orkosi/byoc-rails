import { useState, useEffect } from "react";
import { Activity, Server, FileText } from "lucide-react";
import Sidebar from "../components/Sidebar.jsx";
import ComponentCard from "../components/ComponentCard.jsx";

const API_BASE = import.meta.env.VITE_API_URL || "";

export default function DashboardPage() {
  const [components, setComponents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    let cancelled = false;

    async function fetchComponents() {
      try {
        const res = await fetch(`${API_BASE}/api/components`);
        if (!res.ok) throw new Error("Failed to fetch components");
        const data = await res.json();
        if (!cancelled) {
          setComponents(data);
          setError(null);
        }
      } catch (err) {
        if (!cancelled) {
          setError("Unable to load components.");
        }
      } finally {
        if (!cancelled) {
          setLoading(false);
        }
      }
    }

    fetchComponents();
    return () => {
      cancelled = true;
    };
  }, []);

  const sidebarLinks = [
    { label: "Components", href: "#components", icon: Activity },
    { label: "Configurations", href: "#configurations", icon: Server },
    { label: "Logs", href: "#logs", icon: FileText },
  ];

  return (
    <div className="flex min-h-screen bg-background">
      <Sidebar links={sidebarLinks} title="Builders" />
      <main className="flex-1 p-8 overflow-y-auto">
        <h1 className="text-2xl font-bold text-foreground mb-6">Dashboard</h1>

        {loading && (
          <div className="flex items-center justify-center min-h-[200px]">
            <p className="text-muted-foreground">Loading components...</p>
          </div>
        )}

        {error && (
          <div className="flex items-center justify-center min-h-[200px]">
            <p className="text-destructive">{error}</p>
          </div>
        )}

        {!loading && !error && components.length === 0 && (
          <div className="flex items-center justify-center min-h-[200px] border-2 border-dashed border-border rounded-lg bg-card">
            <p className="text-muted-foreground">
              No components yet. Create your first one.
            </p>
          </div>
        )}

        {!loading && !error && components.length > 0 && (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {components.map((component) => (
              <ComponentCard key={component.id} component={component} />
            ))}
          </div>
        )}
      </main>
    </div>
  );
}