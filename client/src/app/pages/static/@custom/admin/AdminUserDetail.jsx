import React, { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import Button from "../../../../components/ui/Button.jsx";
import Input from "../../../../components/ui/Input.jsx";
import Select from "../../../../components/@custom/ui/Select.jsx";
import content from "../../../../content/@custom/admin/users.json";

export default function AdminUserDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [editing, setEditing] = useState(false);
  const [formData, setFormData] = useState({ name: "", email: "", status: "active" });
  const [saveErrors, setSaveErrors] = useState([]);
  const [saveMessage, setSaveMessage] = useState("");
  const [adminToken, setAdminToken] = useState("");
  const [authorized, setAuthorized] = useState(false);

  useEffect(() => {
    const token = localStorage.getItem("adminToken") || "";
    setAdminToken(token);
    if (token) setAuthorized(true);
  }, []);

  useEffect(() => {
    if (!adminToken || !id) return;

    const fetchUser = async () => {
      setLoading(true);
      setError("");

      try {
        const response = await fetch(`/api/admin/users/${id}`, {
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
        setUser(data.user);
        setFormData({
          name: data.user.name || "",
          email: data.user.email || "",
          status: data.user.status || "active"
        });
      } catch {
        setError(content.messages.loadError);
      } finally {
        setLoading(false);
      }
    };

    fetchUser();
  }, [adminToken, id]);

  const handleSave = async (e) => {
    e.preventDefault();
    setSaveErrors([]);
    setSaveMessage("");

    try {
      const response = await fetch(`/api/admin/users/${id}`, {
        method: "PATCH",
        headers: { "X-Admin-Token": adminToken, "Content-Type": "application/json" },
        body: JSON.stringify(formData)
      });

      const data = await response.json();

      if (response.ok) {
        setUser(data.user);
        setEditing(false);
        setSaveMessage(content.messages.saveSuccess);
      } else {
        setSaveErrors(data.errors || [content.messages.saveError]);
      }
    } catch {
      setSaveErrors([content.messages.saveError]);
    }
  };

  const handleDeactivate = async () => {
    setSaveErrors([]);
    setSaveMessage("");

    try {
      const response = await fetch(`/api/admin/users/${id}`, {
        method: "DELETE",
        headers: { "X-Admin-Token": adminToken, "Content-Type": "application/json" }
      });

      const data = await response.json();

      if (response.ok) {
        setUser(data.user);
        setFormData({ ...formData, status: data.user.status });
        setSaveMessage(content.messages.deactivated);
      } else {
        setSaveErrors(data.errors || [content.messages.saveError]);
      }
    } catch {
      setSaveErrors([content.messages.saveError]);
    }
  };

  if (!authorized) {
    return (
      <div className="flex min-h-screen flex-col items-center justify-center px-4">
        <div className="w-full max-w-md rounded-lg border border-brand-border bg-brand-surface p-8 shadow-sm">
          <h1 className="mb-6 text-center text-2xl font-semibold text-brand-text">
            {content.messages.unauthorized}
          </h1>
        </div>
      </div>
    );
  }

  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center px-4">
        <p className="text-brand-text-muted">{content.messages.loading}</p>
      </div>
    );
  }

  if (error && !user) {
    return (
      <div className="flex min-h-screen flex-col items-center justify-center px-4 gap-4">
        <p className="text-destructive">{error}</p>
        <Button onClick={() => navigate("/admin/users")}>{content.actions.back}</Button>
      </div>
    );
  }

  if (!user) return null;

  if (editing) {
    return (
      <div className="min-h-screen px-4 py-8">
        <div className="mx-auto max-w-lg">
          <h1 className="mb-6 text-2xl font-semibold text-brand-text">{content.editTitle}</h1>

          {saveErrors.length > 0 && (
            <div className="mb-4 rounded-md border border-destructive bg-destructive/10 p-3">
              {saveErrors.map((err, i) => (
                <p key={i} className="text-sm text-destructive">{err}</p>
              ))}
            </div>
          )}

          {saveMessage && (
            <p className="mb-4 text-sm text-brand-primary">{saveMessage}</p>
          )}

          <form onSubmit={handleSave} className="rounded-lg border border-brand-border bg-brand-surface p-6">
            <div className="flex flex-col gap-4">
              <div>
                <label className="mb-1 block text-sm font-medium text-brand-text" htmlFor="name">
                  {content.fields.name}
                </label>
                <Input
                  id="name"
                  name="name"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                />
              </div>
              <div>
                <label className="mb-1 block text-sm font-medium text-brand-text" htmlFor="email">
                  {content.fields.email}
                </label>
                <Input
                  id="email"
                  name="email"
                  type="email"
                  value={formData.email}
                  onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                />
              </div>
              <div>
                <label className="mb-1 block text-sm font-medium text-brand-text" htmlFor="status">
                  {content.fields.status}
                </label>
                <Select
                  id="status"
                  name="status"
                  value={formData.status}
                  options={[
                    { value: "active", label: content.statusLabels.active },
                    { value: "deactivated", label: content.statusLabels.deactivated }
                  ]}
                  onChange={(e) => setFormData({ ...formData, status: e.target.value })}
                />
              </div>
            </div>
            <div className="mt-6 flex gap-3">
              <Button type="submit">{content.actions.save}</Button>
              <Button onClick={() => setEditing(false)}>{content.actions.cancel}</Button>
            </div>
          </form>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen px-4 py-8">
      <div className="mx-auto max-w-lg">
        <div className="mb-4 flex items-center justify-between">
          <h1 className="text-2xl font-semibold text-brand-text">{content.detailTitle}</h1>
          <Button onClick={() => navigate("/admin/users")}>{content.actions.back}</Button>
        </div>

        {saveMessage && (
          <p className="mb-4 text-sm text-brand-primary">{saveMessage}</p>
        )}

        <div className="rounded-lg border border-brand-border bg-brand-surface p-6">
          <dl className="flex flex-col gap-4">
            <div>
              <dt className="text-sm font-medium text-brand-text-muted">{content.fields.name}</dt>
              <dd className="mt-1 text-brand-text">{user.name || "\u2014"}</dd>
            </div>
            <div>
              <dt className="text-sm font-medium text-brand-text-muted">{content.fields.email}</dt>
              <dd className="mt-1 text-brand-text">{user.email}</dd>
            </div>
            <div>
              <dt className="text-sm font-medium text-brand-text-muted">{content.fields.status}</dt>
              <dd className="mt-1">
                <span className={`inline-block rounded-full px-2 py-0.5 text-xs font-medium ${
                  user.status === "active" ? "bg-accent text-primary" : "bg-muted text-muted-foreground"
                }`}>
                  {content.statusLabels[user.status] || user.status}
                </span>
              </dd>
            </div>
            <div>
              <dt className="text-sm font-medium text-brand-text-muted">{content.fields.subscribedAt}</dt>
              <dd className="mt-1 text-brand-text">
                {user.subscribed_at ? new Date(user.subscribed_at).toLocaleString() : "\u2014"}
              </dd>
            </div>
            <div>
              <dt className="text-sm font-medium text-brand-text-muted">{content.fields.createdAt}</dt>
              <dd className="mt-1 text-brand-text">
                {user.created_at ? new Date(user.created_at).toLocaleString() : "\u2014"}
              </dd>
            </div>
            <div>
              <dt className="text-sm font-medium text-brand-text-muted">{content.fields.updatedAt}</dt>
              <dd className="mt-1 text-brand-text">
                {user.updated_at ? new Date(user.updated_at).toLocaleString() : "\u2014"}
              </dd>
            </div>
          </dl>

          <div className="mt-6 flex gap-3">
            <Button onClick={() => setEditing(true)}>{content.actions.edit}</Button>
            {user.status === "active" && (
              <Button onClick={handleDeactivate}>{content.actions.deactivate}</Button>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
