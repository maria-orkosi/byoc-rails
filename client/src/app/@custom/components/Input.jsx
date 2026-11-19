import { brand } from "../../../config/@custom/brand-tokens.js";

export default function Input(props) {
  return (
    <input
      className="primitive-input"
      style={{
        padding: "8px 12px",
        borderRadius: brand.radius.md,
        border: `1px solid ${brand.color.border}`,
        fontSize: 14,
        fontFamily: `'${brand.font.body}', sans-serif`,
        color: brand.color.text,
        background: brand.color.bg,
        outline: "none",
        width: "100%",
        boxSizing: "border-box",
      }}
      {...props}
    />
  );
}