import { brand } from "../../../config/@custom/brand-tokens.js";

const styles = {
  primary: {
    padding: "8px 16px",
    borderRadius: brand.radius.md,
    border: "none",
    background: brand.color.primary,
    color: brand.color.textOnPrimary,
    fontSize: 14,
    fontWeight: 500,
    fontFamily: `'${brand.font.body}', sans-serif`,
    cursor: "pointer",
  },
  secondary: {
    padding: "8px 16px",
    borderRadius: brand.radius.md,
    border: `1px solid ${brand.color.border}`,
    background: brand.color.bg,
    color: brand.color.text,
    fontSize: 14,
    fontWeight: 500,
    fontFamily: `'${brand.font.body}', sans-serif`,
    cursor: "pointer",
  },
  ghost: {
    padding: "4px 12px",
    borderRadius: brand.radius.sm,
    border: `1px solid ${brand.color.border}`,
    background: brand.color.bg,
    color: brand.color.text,
    fontSize: 13,
    fontFamily: `'${brand.font.body}', sans-serif`,
    cursor: "pointer",
  },
  danger: {
    padding: "4px 12px",
    borderRadius: brand.radius.sm,
    border: `1px solid ${brand.color.border}`,
    background: brand.color.bg,
    color: brand.color.textMuted,
    fontSize: 13,
    fontFamily: `'${brand.font.body}', sans-serif`,
    cursor: "pointer",
  },
};

export default function Button({ variant = "primary", ...props }) {
  return <button style={styles[variant] || styles.primary} {...props} />;
}