import { sh } from "halo";
import type { Accessor } from "halo/signals";
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

export function calculatorItem(
  value: number,
  copied: Accessor<boolean>,
  onCopy: () => void,
): Item {
  return {
    id: "calc",
    title: formatNumber(value),
    subtitle: () => (copied() ? "Copied to clipboard" : "Enter to copy"),
    icon: () => SymbolIcon("equal"),
    run: () => {
      sh(`printf %s '${formatNumber(value)}' | pbcopy`);
      onCopy();
    },
    closeAfter: 700,
  };
}
