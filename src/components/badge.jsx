import { cn } from '@udecode/cn'

export default function Badge({ className, children }) {
    return (
        <div className={cn(
            className,
            "inline-flex items-center rounded-full border px-3.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 text-foreground"
        )}>
            {children}
        </div>
    )
}