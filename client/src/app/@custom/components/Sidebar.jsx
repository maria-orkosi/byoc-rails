import { LogOut } from "lucide-react";

export default function Sidebar({ links, title }) {
  return (
    <aside className="w-60 flex-shrink-0 bg-card border-r border-border flex flex-col">
      <nav className="flex flex-col h-full p-6">
        <h2 className="text-xl font-bold text-foreground mb-8 px-2">
          {title}
        </h2>
        <ul className="flex flex-col gap-1 flex-1">
          {links.map((link) => {
            const Icon = link.icon;
            return (
              <li key={link.label}>
                <a
                  href={link.href}
                  className="flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium text-muted-foreground hover:bg-accent hover:text-foreground transition-colors"
                >
                  {Icon && <Icon className="w-4 h-4" />}
                  {link.label}
                </a>
              </li>
            );
          })}
        </ul>
        <div className="border-t border-border pt-4 mt-4">
          <a
            href="/"
            className="flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium text-destructive hover:bg-destructive/10 transition-colors"
          >
            <LogOut className="w-4 h-4" />
            Log out
          </a>
        </div>
      </nav>
    </aside>
  );
}