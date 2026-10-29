import { sh } from "halo";
import type { Item } from "@/ui/palette/types";
import { SymbolIcon } from "@/ui/SymbolIcon";

const formatNumber = (value: number) => String(Number(value.toPrecision(12)));

export function calculate(query: string): number | undefined {
  const expression = query.trim();
  if (
    !/^[\d\s+\-*/().,%^]+$/.test(expression) ||
    !/\d/.test(expression) ||
    !/[+\-*/%^]/.test(expression)
  )
    return undefined;
  try {
    const value = Function(
      `"use strict"; return (${expression.replace(/\^/g, "**").replace(/,/g, ".")});`,
    )();
    return typeof value === "number" && Number.isFinite(value) ? value : undefined;
  } catch {
    return undefined;
  }
}

export function calculatorItem(value: number): Item {
  const text = formatNumber(value);
  return {
    id: "calc",
    title: text,
    subtitle: "Enter to copy",
    icon: () => SymbolIcon("equal"),
    run: () => sh(`printf %s '${text}' | pbcopy`),
    closeAfter: 0,
    feedback: () => ({
      title: `Copied ${text}`,
      subtitle: "Calculator",
      symbol: "equal",
    }),
  };
}
