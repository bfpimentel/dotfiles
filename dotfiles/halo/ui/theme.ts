export interface Theme {
  accent: string;
  background: string;
  foreground: string;
  muted: string;
}

export const theme: Theme = {
  accent: "#d6d6d6",
  background: "#141414f2",
  foreground: "#e8e8e8",
  muted: "#6b6b6b",
};

export const alpha = (hex: string, amount: number) =>
  hex.slice(0, 7) +
  Math.round(amount * 255)
    .toString(16)
    .padStart(2, "0");
