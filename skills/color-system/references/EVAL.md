# Activation eval set

Spot-check 3–5 of these in a fresh Claude session to confirm the description triggers (and doesn't over-trigger). If activation is unreliable, rework the description in SKILL.md.

## Should trigger

1. "what color palette should I use for my dashboard?"
2. "create a color scheme for my landing page"
3. "set up dark mode colors for my app"
4. "I need colorblind-safe chart colors"
5. "pick colors for my brand"
6. "give me a terminal/TUI theme palette"
7. "what hex for success/warning/error states?"
8. "does this text color pass WCAG contrast?"
9. "build a color palette from scratch"
10. "diverging color scale for my chart"

## Should NOT trigger (adjacent skills / out of scope)

1. "build a React component for my form"  → frontend-design
2. "fix the layout spacing on this page"  → frontend-design
3. "write CSS grid for this section"  → frontend-design
4. "create a skill for migrations"  → generate-skill
5. "review my code changes"  → code-review
6. "set up my project roadmap"  → track-roadmap
7. "what font pairing should I use?"  → typography, not color
8. "optimize these images"  → not color
9. "animate this button on hover"  → not color
10. "debug this useEffect infinite loop"  → ideal-react-component
