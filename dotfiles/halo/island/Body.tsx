import { Box, Shape, type Element } from "halo";
import type { Accessor } from "halo/signals";
import type { Mode } from "@/island/state";

export interface Geometry {
  width: number;
  /** A fixed height, or "auto" to follow the content. */
  height: number | "auto";
  radius: number;
  /** Negative slides the island up behind the screen edge. */
  y: number;
}

export const spring = { curve: { stiffness: 340, damping: 24 } };
export const settle = { curve: { stiffness: 460, damping: 34 } };
// Critically damped: sliding in never overshoots, which would pull the shoulders off the screen edge.
const slide = { curve: { stiffness: 340, damping: 37 } };

// The body starts this far above the screen edge, so a spring overshooting downwards never opens a gap there.
const overhang = 40;
const shoulder = 14;

export const geometry: Record<Mode, Geometry> = {
  hidden: { width: 300, height: 34, radius: 17, y: -90 },
  shelf: { width: 300, height: 40, radius: 20, y: 0 },
  compact: { width: 300, height: 34, radius: 17, y: 0 },
  toast: { width: 360, height: 58, radius: 24, y: 0 },
  drop: { width: 460, height: 118, radius: 30, y: 0 },
  dashboard: { width: 680, height: "auto", radius: 26, y: 0 },
};

const concave = (side: "left" | "right") =>
  side === "left"
    ? "M 0 0 L 14 0 L 14 14 C 14 6.27 7.73 0 0 0 Z"
    : "M 14 0 L 0 0 L 0 14 C 0 6.27 6.27 0 14 0 Z";

function Shoulder(props: { side: "left" | "right" }) {
  return (
    <Shape
      path={concave(props.side)}
      viewBox={[shoulder, shoulder]}
      fit="stretch"
      style={{
        position: "absolute",
        top: overhang,
        [props.side]: -shoulder,
        width: shoulder,
        height: shoulder,
        fill: "#000000",
        transition: { layout: spring },
      }}
    />
  );
}

export function Body(props: {
  geometry: Accessor<Geometry>;
  children?: Element;
  onHover?: (hovered: boolean) => void;
  onClick?: () => void;
  onDragEnter?: (event: { files: string[] }) => void;
  onDragLeave?: () => void;
  onDrop?: (event: { files: string[] }) => void;
}) {
  const height = (): number | "auto" => {
    const { height } = props.geometry();
    return height === "auto" ? "auto" : height + overhang;
  };
  return (
    <Box
      style={{
        position: "relative",
        top: -overhang,
        translateY: () => props.geometry().y,
        transition: { layout: spring, translateY: slide },
      }}
    >
      <Shoulder side="left" />
      <Shoulder side="right" />
      <Box
        onHover={props.onHover}
        onClick={props.onClick}
        onDragEnter={props.onDragEnter}
        onDragLeave={props.onDragLeave}
        onDrop={props.onDrop}
        style={{
          width: () => props.geometry().width,
          height,
          padding: [overhang, 0, 0, 0],
          background: "#000000",
          radius: () => props.geometry().radius,
          corners: ["bottomLeft", "bottomRight"],
          shadow: { color: "#00000066", blur: 24, y: 8 },
          clip: true,
          transition: { layout: spring, radius: spring },
        }}
      >
        {props.children ?? null}
      </Box>
    </Box>
  );
}

/** Content fades and settles in as the shape starts to grow around it. */
export const reveal = {
  enter: {
    from: { opacity: 0, scale: 0.96, translateY: -6 },
    duration: 240,
    delay: 60,
    curve: [0.2, 0.9, 0.3, 1] as [number, number, number, number],
  },
  exit: { to: { opacity: 0, scale: 0.98 }, duration: 90, curve: "ease-in" as const },
};
