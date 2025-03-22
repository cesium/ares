"use client";

import type React from "react";
import { useState, useRef, useEffect } from "react";

type TooltipPosition =
  | "top"
  | "right"
  | "bottom"
  | "left"
  | "topStart"
  | "topEnd";

interface TooltipProps {
  content: React.ReactNode;
  position?: TooltipPosition;
  delay?: number;
  children: React.ReactNode;
  className?: string;
}

// Helper function to conditionally join class names
const cn = (...classes: (string | boolean | undefined)[]) => {
  return classes.filter(Boolean).join(" ");
};

export function Tooltip({
  content,
  position = "top",
  delay = 300,
  children,
  className,
}: TooltipProps) {
  const [isVisible, setIsVisible] = useState(false);
  const [isMounted, setIsMounted] = useState(false);
  const timeoutRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const tooltipRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (isVisible && !isMounted) {
      setIsMounted(true);
    }

    return () => {
      if (timeoutRef.current) {
        clearTimeout(timeoutRef.current);
      }
    };
  }, [isVisible, isMounted]);

  const showTooltip = () => {
    if (timeoutRef.current) {
      clearTimeout(timeoutRef.current);
    }
    timeoutRef.current = setTimeout(() => {
      setIsVisible(true);
    }, delay);
  };

  const hideTooltip = () => {
    if (timeoutRef.current) {
      clearTimeout(timeoutRef.current);
    }
    setIsVisible(false);
  };

  const positionClasses = {
    top: "bottom-full left-1/2 -translate-x-1/2 -translate-y-2",
    right: "left-full top-1/2 translate-x-2 -translate-y-1/2",
    bottom: "top-full left-1/2 -translate-x-1/2 translate-y-2",
    left: "right-full top-1/2 -translate-x-2 -translate-y-1/2",
    topStart: "bottom-full left-0 -translate-y-2",
    topEnd: "bottom-full right-0 -translate-y-2",
  };

  return (
    <div
      className="relative inline-block"
      onMouseEnter={showTooltip}
      onMouseLeave={hideTooltip}
    >
      {children}
      {isMounted && (
        <div
          ref={tooltipRef}
          className={cn(
            "absolute z-50 whitespace-nowrap rounded px-2 py-1 text-xs font-medium",
            "bg-primary text-primary-foreground shadow-md",
            "transition-opacity duration-200",
            isVisible ? "opacity-100" : "opacity-0 pointer-events-none",
            positionClasses[position],
            className || "",
          )}
          role="tooltip"
        >
          {content}
          <span className={cn("absolute border-4", "border-primary")} />
        </div>
      )}
    </div>
  );
}

export default Tooltip;
