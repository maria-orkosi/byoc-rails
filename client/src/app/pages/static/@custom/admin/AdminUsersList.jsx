import React, { useState, useEffect, useCallback } from "react";
import { useNavigate } from "react-router-dom";
import Button from "../../../../components/ui/Button.jsx";
import Input from "../../../../components/ui/Input.jsx";
import content from "../../../../content/@custom/admin/users.json";

/**
 * @typedef {Object} Meta
 * @property {number} current_page
 * @property {number} total_pages
 * @property {number} total_count
 * @property {number} per_page
 */

/**
 * @typedef {Object} User
 * @property {number} id
 * @property {string} name
 * @property {string} email
 * @property {string} subscribed_at
 * @property {string} status
 * @property {string} created_at
 */

export default function AdminUsersList() {
  const navigate = useNavigate();
  const [users, setUsers] = useState([]);
  const [meta, setMeta] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [sort, setSort] = useState("created_at");
  const [direction, setDirection] = useState("desc");
  const [page, setPage] = useState(1);
  const [adminToken, setAdminToken] = useState("");
  const [authorized, setAuthorized] = useState(false);

  useEffect(() => {
    const token = localStorage.getItem("adminToken") || "";
    setAdminToken(token);
    if (token) setAuthorized(true);
  }, []);

  const fetchUsers = useCallback(async () => {
    if (!adminToken) { setLoading(false); return; }
    setLoading(true);
    setError("");

    try {
      const params = new URLSearchParams({ sort, direction, page: String(page) });
      const response = await fetch(`/api/admin/users?${params}`, {
        headers: { "X-Admin-Token": adminToken, "Content-Type": "application/json" }
      });

      if (response.status === 403) {
        setAuthorized(false);
        setError(content.messages.unauthorized);
        setLoading(false);
        return;
      }

      if (!response.ok) {
        setError(content.messages.loadError);
        setLoading(false);
        return;
      }

      const data = await response.json();
      setUsers(data.users || []);
      setMeta(data.meta || null);
    } catch {
      setError(content.messages.loadError);
    } finally {
      setLoading(false);
    }
  }, [adminToken, sort, direction, page]);

  useEffect(() => { fetchUsers(); }, [fetchUsers]);

  const handleSort = (newSort) => {
    if (sort === newSort) {
      setDirection((prev) => (prev === "asc" ? "desc" : "asc"));
    } else {
      setSort(newSort);
      setDirection("asc");
    }
    setPage(1);
  };

  const handleLogin = (e) => {
    e.preventDefault();
    const token = e.target.elements.adminToken?.value || "";
    localStorage.setItem("adminToken", token);
    setAdminToken(token);
    if (token) setAuthorized(true);
  };

  const sortIndicator = (column) => {
    if (sort !== column) return "";
    return direction === "asc" ? " \u2191" : " \u2193";
  };

  if (!authorized) {
    return (
      <div className="flex min-h-screen flex-col items-center justify-center px-4">
        <div className="w-full max-w-md rounded-lg border border-brand-border bg-brand-surface p-8 shadow-sm">
          <h1 className="mb-6 text-center text-2xl font-semibold text-brand-text">
            {content.heading}
          </h1>
          {error && <p className="mb-4 text-sm text-destructive">{error}</p>}
          <form onSubmit={handleLogin} className="flex flex-col gap-4">
            <div>
              <label className="mb-1 block text-sm font-medium text-brand-text" htmlFor="adminToken">
                {content.loginForm.tokenLabel}
              </label>
              <Input
                id="adminToken"
                name="adminToken"
                type="password"
                placeholder={content.loginForm.tokenPlaceholder}
              />
            </div>
            <Button type="submit">{content.loginForm.loginButton}</Button>
          </form>
        </div>
      </div>
    );
  }
return (
    <div className="min-h-screen px-4 py-8">
      <div className="mx-auto max-w-5xl">
        <h1 className="mb-6 text-2xl font-semibold text-brand-text">{content.heading}</h1>

        {error && <p className="mb-4 text-sm text-destructive">{error}</p>}

        {loading ? (
          <p className="text-brand-text-muted">{content.messages.loading}</p>
        ) : users.length === 0 ? (
          <p className="text-brand-text-muted">{content.messages.noUsers}</p>
        ) : (
          <>
            <div className="overflow-x-auto rounded-lg border border-brand-border">
              <table className="w-full text-left text-sm">
                <thead>
                  <tr className="border-b border-brand-border bg-brand-surface-muted">
                    <th className="cursor-pointer px-4 py-3 font-medium text-brand-text hover:text-brand-primary"
                      onClick={() => handleSort("name")}>
                      {content.columns.name}{sortIndicator("name")}
                    </th>
                    <th className="cursor-pointer px-4 py-3 font-medium text-brand-text hover:text-brand-primary"
                      onClick={() => handleSort("email")}>
                      {content.columns.email}{sortIndicator("email")}
                    </th>
                    <th className="cursor-pointer px-4 py-3 font-medium text-brand-text hover:text-brand-primary"
                      onClick={() => handleSort("created_at")}>
                      {content.columns.signupDate}{sortIndicator("created_at")}
                    </th>
                    <th className="px-4 py-3 font-medium text-brand-text">{content.columns.status}</th>
                    <th className="px-4 py-3 font-medium text-brand-text"></th>
                  </tr>
                </thead>
                <tbody>
                  {users.map((user) => (
                    <tr key={user.id}
                      className={`border-b border-brand-border transition-colors hover:bg-brand-surface-muted ${
                        user.status === "deactivated" ? "opacity-50" : ""
                      }`}>
                      <td className="px-4 py-3 text-brand-text">
                        {user.name || "\u2014"}
                        {user.status === "deactivated" && (
                          <span className="ml-2 text-xs text-brand-text-muted">{content.deactivatedBadge}</span>
                        )}
                      </td>
                      <td className="px-4 py-3 text-brand-text">{user.email}</td>
                      <td className="px-4 py-3 text-brand-text-muted">
                        {user.created_at ? new Date(user.created_at).toLocaleDateString() : "\u2014"}
                      </td>
                      <td className="px-4 py-3">
                        <span className={`inline-block rounded-full px-2 py-0.5 text-xs font-medium ${
                          user.status === "active" ? "bg-accent text-primary" : "bg-muted text-muted-foreground"
                        }`}>
                          {content.statusLabels[user.status] || user.status}
                        </span>
                      </td>
                      <td className="px-4 py-3">
                        <Button onClick={() => navigate(`/admin/users/${user.id}`)}>
                          {content.actions.view}
                        </Button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {meta && meta.total_pages > 1 && (
              <div className="mt-4 flex items-center justify-between">
                <div className="text-sm text-brand-text-muted">
                  {content.pagination.page} {meta.current_page} / {meta.total_pages} ({meta.total_count} total)
                </div>
                <div className="flex gap-2">
                  <Button disabled={meta.current_page <= 1} onClick={() => setPage((p) => Math.max(1, p - 1))}>
                    {content.pagination.previous}
                  </Button>
                  <Button disabled={meta.current_page >= meta.total_pages} onClick={() => setPage((p) => p + 1)}>
                    {content.pagination.next}
                  </Button>
                </div>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}