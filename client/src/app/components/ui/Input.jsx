import React from "react";

/**
 * @param {object} props
 * @param {string} [props.className]
 * @param {string} [props.id]
 * @param {string} [props.name]
 * @param {string} [props.placeholder]
 * @param {string} [props.type]
 * @param {string} [props.value]
 * @param {(e: React.ChangeEvent<HTMLInputElement>) => void} [props.onChange]
 */
export default function Input({ className = "", id, name, placeholder, type = "text", value, onChange }) {
  return (
    <input
      id={id}
      name={name}
      type={type}
      value={value}
      onChange={onChange}
      placeholder={placeholder}
      className={`flex w-full rounded-md border border-brand-border bg-brand-surface px-3 py-2 text-sm text-brand-text placeholder:text-brand-text-muted focus:outline-none focus:ring-2 focus:ring-brand-primary ${className}`}
    />
  );
}