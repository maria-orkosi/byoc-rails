import React from "react";

/**
 * @param {object} props
 * @param {string} [props.className]
 * @param {string} [props.id]
 * @param {string} [props.name]
 * @param {string} [props.value]
 * @param {{ value: string, label: string }[]} [props.options]
 * @param {(e: React.ChangeEvent<HTMLSelectElement>) => void} [props.onChange]
 */
export default function Select({ className = "", id, name, value, options = [], onChange }) {
  return (
    <select
      id={id}
      name={name}
      value={value}
      onChange={onChange}
      className={`flex w-full rounded-md border border-brand-border bg-brand-surface px-3 py-2 text-sm text-brand-text focus:outline-none focus:ring-2 focus:ring-brand-primary ${className}`}
    >
      {options.map((opt) => (
        <option key={opt.value} value={opt.value}>
          {opt.label}
        </option>
      ))}
    </select>
  );
}