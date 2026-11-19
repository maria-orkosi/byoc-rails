import { useState, useEffect } from "react";
import Input from "../../@custom/components/Input.jsx";
import Button from "../../@custom/components/Button.jsx";
import { brand } from "../../../config/@custom/brand-tokens.js";

const API_BASE = "/api";

const layoutVars = {
  "--ff": `'${brand.font.body}', sans-serif`,
};

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
      className="mx-auto max-w-[800px] p-6 font-[var(--ff)]"
      style={layoutVars}
    >
      <h1 className="mb-6 text-2xl font-bold text-[var(--brand-text)]">
        Bookings
      </h1>

      {error && (
        <div
          className="mb-4 rounded-lg border border-solid border-[var(--brand-border)] bg-[var(--brand-surface)] p-3 text-[var(--brand-text)]"
        >
          {error}
        </div>
      )}

      <form
        onSubmit={handleSubmit}
        className="mb-8 flex flex-col gap-3 rounded-xl border border-solid border-[var(--brand-border)] bg-[var(--brand-surface)] p-5"
      >
        <h2 className="m-0 text-lg font-semibold text-[var(--brand-text)]">
          {editingId ? "Edit Booking" : "New Booking"}
        </h2>
        <div className="flex flex-col gap-1">
          <label htmlFor="guest" className="text-sm font-medium text-[var(--brand-text)]">
            Guest Name
          </label>
          <Input
            id="guest"
            type="text"
            value={guest}
            onChange={(e) => setGuest(e.target.value)}
            required
          />
        </div>
        <div className="flex flex-col gap-1">
          <label htmlFor="night" className="text-sm font-medium text-[var(--brand-text)]">
            Night
          </label>
          <Input
            id="night"
            type="date"
            value={night}
            onChange={(e) => setNight(e.target.value)}
            required
          />
        </div>
        <div className="flex flex-col gap-1">
          <label htmlFor="email" className="text-sm font-medium text-[var(--brand-text)]">
            Email
          </label>
          <Input
            id="email"
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
        </div>
        <div className="flex gap-2">
          <Button type="submit" variant="primary">
            {editingId ? "Update" : "Create"}
          </Button>
          {editingId && (
            <Button type="button" variant="secondary" onClick={handleCancel}>
              Cancel
            </Button>
          )}
        </div>
      </form>

      <section aria-busy={loading}>
        <h2 className="mb-4 text-lg font-semibold text-[var(--brand-text)]">
          All Bookings
        </h2>

        {loading && (
          <div className="flex flex-col gap-3">
            {[1, 2, 3].map((i) => (
              <div
                key={i}
                className="h-12 rounded-lg bg-[var(--brand-border)]"
              />
            ))}
          </div>
        )}

        {!loading && !error && bookings.length === 0 && (
          <div className="p-8 text-center text-[var(--brand-text-muted)]">
            <p className="mb-2 text-base">No bookings yet</p>
            <p className="text-sm">Create your first booking using the form above.</p>
          </div>
        )}

        {!loading && bookings.length > 0 && (
          <div className="flex flex-col gap-2">
            {bookings.map((booking) => (
              <div
                key={booking.id}
                className="flex items-center justify-between rounded-lg border border-solid border-[var(--brand-border)] bg-[var(--brand-bg)] px-4 py-3"
              >
                <div>
                  <div className="font-semibold text-[var(--brand-text)]">
                    {booking.guest}
                  </div>
                  <div className="text-sm text-[var(--brand-text-muted)]">
                    {booking.night}
                    {booking.email ? ` — ${booking.email}` : ""}
                  </div>
                </div>
                <div className="flex gap-2">
                  <Button variant="ghost" onClick={() => handleEdit(booking)}>
                    Edit
                  </Button>
                  <Button variant="danger" onClick={() => handleDelete(booking.id)}>
                    Delete
                  </Button>
                </div>
              </div>
            ))}
          </div>
        )}
      </section>
    </main>
  );
}
