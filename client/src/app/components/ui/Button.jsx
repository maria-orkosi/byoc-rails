import React from "react";

/**
 * @param {object} props
 * @param {React.ReactNode} props.children
 * @param {string} [props.className]
 * @param {boolean} [props.disabled]
 * @param {() => void} [props.onClick]
 * @param {"button" | "submit"} [props.type]
 */
export default function Button({ children, className = "", disabled = false, onClick, type = "button" }) {
  return (
    <button
      type={type}
      disabled={disabled}
      onClick={onClick}
      className={`inline-flex items-center justify-center rounded-md bg-brand-primary px-4 py-2 text-sm font-medium text-brand-text-on-primary transition-colors hover:bg-brand-primary/90 disabled:cursor-not-allowed disabled:opacity-50 ${className}`}
    >
      {children}
    </button>
  );
}