export default function ComponentCard({ component }) {
  const isActive = ["active", "ok", "running"].includes(
    (component.status || "").toLowerCase()
  );
  const isInactive = ["inactive", "error", "stopped"].includes(
    (component.status || "").toLowerCase()
  );

  return (
    <div className="bg-card border border-border rounded-lg p-5 hover:border-accent transition-colors">
      <div className="flex items-center justify-between mb-3">
        <span className="text-base font-semibold text-foreground">
          {component.name}
        </span>
        <span
          className={`inline-block w-2.5 h-2.5 rounded-full flex-shrink-0 ${
            isActive
              ? "bg-primary shadow-[0_0_4px_var(--primary)]"
              : isInactive
                ? "bg-destructive shadow-[0_0_4px_var(--destructive)]"
                : "bg-muted-foreground"
          }`}
          title={component.status || "unknown"}
        />
      </div>
      <div className="flex flex-col gap-1">
        <span className="text-sm text-muted-foreground capitalize">
          {component.status || "unknown"}
        </span>
        <span className="text-xs text-muted-foreground">
          {component.last_deployed_at
            ? `Deployed: ${new Date(component.last_deployed_at).toLocaleString()}`
            : "Not yet deployed"}
        </span>
      </div>
    </div>
  );
}