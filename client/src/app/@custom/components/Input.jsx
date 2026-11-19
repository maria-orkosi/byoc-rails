import { brand } from "../../../config/@custom/brand-tokens.js";

const inputVars = {
  "--br": brand.radius.md,
  "--b-clr": brand.color.border,
  "--fs": "14px",
  "--ff": `'${brand.font.body}', sans-serif`,
  "--clr": brand.color.text,
  "--bg": brand.color.bg,
};

export default function Input(props) {
  return (
    <input
      className="rounded-[var(--br)] border border-solid border-[var(--b-clr)] bg-[var(--bg)] px-3 py-2 text-[var(--fs)] text-[var(--clr)] outline-none w-full box-border font-[var(--ff)]"
      style={inputVars}
      {...props}
    />
  );
}