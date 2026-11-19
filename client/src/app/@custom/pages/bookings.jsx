import { useState, useEffect } from "react";

const API_BASE = "/api";

export default function BookingsPage() {
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [guest, setGuest] = useState("");
  const [night, setNight] = useState("");
  const [email, setEmail] = useState("");
  const [editingId, setEditingId] = useState(null);

  const fetchBookings = async () => {
    setLoading(true);
    setError(null);
    try {
      const res = await fetch(`${API_BASE}/bookings`);
      if (!res.ok) throw new Error("Failed to fetch bookings");
      const data = await res.json();
      setBookings(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchBookings();
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(null);
    try {
      const payload = { guest, night };
      if (email) payload.email = email;

      let res;
      if (editingId) {
        res = await fetch(`${API_BASE}/bookings/${editingId}`, {
          method: "PATCH",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(payload),
        });
      } else {
        res = await fetch(`${API_BASE}/bookings`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(payload),
        });
      }

      if (!res.ok) throw new Error("Failed to save booking");
      setGuest("");
      setNight("");
      setEmail("");
      setEditingId(null);
      await fetchBookings();
    } catch (err) {
      setError(err.message);
    }
  };

  const handleEdit = (booking) => {
    setGuest(booking.guest);
    setNight(booking.night);
    setEmail(booking.email || "");
    setEditingId(booking.id);
  };

  const handleDelete = async (id) => {
    setError(null);
    try {
      const res = await fetch(`${API_BASE}/bookings/${id}`, {
        method: "DELETE",
      });
      if (!res.ok) throw new Error("Failed to delete booking");
      await fetchBookings();
    } catch (err) {
      setError(err.message);
    }
  };

  const handleCancel = () => {
    setGuest("");
    setNight("");
    setEmail("");
    setEditingId(null);
  };

  return (
    <main
      style={{
        fontFamily: "'Inter', sans-serif",
        maxWidth: 800,
        margin: "0 auto",
        padding: 24,
      }}
    >
      <h1
        style={{
          fontSize: 24,
          fontWeight: 700,
          marginBottom: 24,
          color: "#111827",
        }}
      >
        Bookings
      </h1>

      {error && (
        <div
          style={{
            padding: 12,
            marginBottom: 16,
            borderRadius: 8,
            background: "#fef2f2",
            color: "#991b1b",
            border: "1px solid #fecaca",
          }}
        >
          {error}
        </div>
      )}

      <form
        onSubmit={handleSubmit}
        style={{
          display: "flex",
          flexDirection: "column",
          gap: 12,
          marginBottom: 32,
          padding: 20,
          borderRadius: 12,
          border: "1px solid #e5e7eb",
          background: "#f9fafb",
        }}
      >
        <h2 style={{ fontSize: 18, fontWeight: 600, margin: 0, color: "#111827" }}>
          {editingId ? "Edit Booking" : "New Booking"}
        </h2>
        <div style={{ display: "flex", flexDirection: "column", gap: 4 }}>
          <label htmlFor="guest" style={{ fontSize: 14, fontWeight: 500, color: "#374151" }}>
            Guest Name
          </label>
          <input
            id="guest"
            type="text"
            value={guest}
            onChange={(e) => setGuest(e.target.value)}
            required
            style={{
              padding: "8px 12px",
              borderRadius: 8,
              border: "1px solid #d1d5db",
              fontSize: 14,
              fontFamily: "'Inter', sans-serif",
            }}
          />
        </div>
        <div style={{ display: "flex", flexDirection: "column", gap: 4 }}>
          <label htmlFor="night" style={{ fontSize: 14, fontWeight: 500, color: "#374151" }}>
            Night
          </label>
          <input
            id="night"
            type="date"
            value={night}
            onChange={(e) => setNight(e.target.value)}
            required
            style={{
              padding: "8px 12px",
              borderRadius: 8,
              border: "1px solid #d1d5db",
              fontSize: 14,
              fontFamily: "'Inter', sans-serif",
            }}
          />
        </div>
        <div style={{ display: "flex", flexDirection: "column", gap: 4 }}>
          <label htmlFor="email" style={{ fontSize: 14, fontWeight: 500, color: "#374151" }}>
            Email
          </label>
          <input
            id="email"
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            style={{
              padding: "8px 12px",
              borderRadius: 8,
              border: "1px solid #d1d5db",
              fontSize: 14,
              fontFamily: "'Inter', sans-serif",
            }}
          />
        </div>
        <div style={{ display: "flex", gap: 8 }}>
          <button
            type="submit"
            style={{
              padding: "8px 16px",
              borderRadius: 8,
              border: "none",
              background: "#6b7280",
              color: "#fff",
              fontSize: 14,
              fontWeight: 500,
              fontFamily: "'Inter', sans-serif",
              cursor: "pointer",
            }}
          >
            {editingId ? "Update" : "Create"}
          </button>
          {editingId && (
            <button
              type="button"
              onClick={handleCancel}
              style={{
                padding: "8px 16px",
                borderRadius: 8,
                border: "1px solid #d1d5db",
                background: "#fff",
                color: "#374151",
                fontSize: 14,
                fontWeight: 500,
                fontFamily: "'Inter', sans-serif",
                cursor: "pointer",
              }}
            >
              Cancel
            </button>
          )}
        </div>
      </form>

      <section aria-busy={loading}>
        <h2 style={{ fontSize: 18, fontWeight: 600, marginBottom: 16, color: "#111827" }}>
          All Bookings
        </h2>

        {loading && (
          <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
            {[1, 2, 3].map((i) => (
              <div
                key={i}
                style={{
                  height: 48,
                  borderRadius: 8,
                  background: "#f3f4f6",
                }}
              />
            ))}
          </div>
        )}

        {!loading && !error && bookings.length === 0 && (
          <div style={{ textAlign: "center", padding: 32, color: "#6b7280" }}>
            <p style={{ fontSize: 16, marginBottom: 8 }}>No bookings yet</p>
            <p style={{ fontSize: 14 }}>Create your first booking using the form above.</p>
          </div>
        )}

        {!loading && bookings.length > 0 && (
          <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
            {bookings.map((booking) => (
              <div
                key={booking.id}
                style={{
                  display: "flex",
                  justifyContent: "space-between",
                  alignItems: "center",
                  padding: "12px 16px",
                  borderRadius: 8,
                  border: "1px solid #e5e7eb",
                  background: "#fff",
                }}
              >
                <div>
                  <div style={{ fontWeight: 600, color: "#111827" }}>
                    {booking.guest}
                  </div>
                  <div style={{ fontSize: 14, color: "#6b7280" }}>
                    {booking.night}
                    {booking.email ? ` — ${booking.email}` : ""}
                  </div>
                </div>
                <div style={{ display: "flex", gap: 8 }}>
                  <button
                    onClick={() => handleEdit(booking)}
                    style={{
                      padding: "4px 12px",
                      borderRadius: 6,
                      border: "1px solid #d1d5db",
                      background: "#fff",
                      color: "#374151",
                      fontSize: 13,
                      fontFamily: "'Inter', sans-serif",
                      cursor: "pointer",
                    }}
                  >
                    Edit
                  </button>
                  <button
                    onClick={() => handleDelete(booking.id)}
                    style={{
                      padding: "4px 12px",
                      borderRadius: 6,
                      border: "1px solid #fecaca",
                      background: "#fef2f2",
                      color: "#991b1b",
                      fontSize: 13,
                      fontFamily: "'Inter', sans-serif",
                      cursor: "pointer",
                    }}
                  >
                    Delete
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </section>
    </main>
  );
}
