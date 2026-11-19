export default function Input({ value, onChange, placeholder, className = "", autoFocus, type = "text", ...props }) {
  return (
    <input
      type={type}
      value={value}
      onChange={onChange}
      placeholder={placeholder}
      className={className}
      autoFocus={autoFocus}
      {...props}
    />
  );
}