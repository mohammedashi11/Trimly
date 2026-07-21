---
name: Trimly
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#393939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1c1b1b'
  surface-container: '#201f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353534'
  on-surface: '#e5e2e1'
  on-surface-variant: '#d0c5af'
  inverse-surface: '#e5e2e1'
  inverse-on-surface: '#313030'
  outline: '#99907c'
  outline-variant: '#4d4635'
  surface-tint: '#e9c349'
  primary: '#f2ca50'
  on-primary: '#3c2f00'
  primary-container: '#d4af37'
  on-primary-container: '#554300'
  inverse-primary: '#735c00'
  secondary: '#c8c6c5'
  on-secondary: '#303030'
  secondary-container: '#474746'
  on-secondary-container: '#b6b5b4'
  tertiary: '#bfcdff'
  on-tertiary: '#082b72'
  tertiary-container: '#97b0ff'
  on-tertiary-container: '#254188'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffe088'
  primary-fixed-dim: '#e9c349'
  on-primary-fixed: '#241a00'
  on-primary-fixed-variant: '#574500'
  secondary-fixed: '#e4e2e1'
  secondary-fixed-dim: '#c8c6c5'
  on-secondary-fixed: '#1b1c1c'
  on-secondary-fixed-variant: '#474746'
  tertiary-fixed: '#dbe1ff'
  tertiary-fixed-dim: '#b4c5ff'
  on-tertiary-fixed: '#00174b'
  on-tertiary-fixed-variant: '#27438a'
  background: '#131313'
  on-background: '#e5e2e1'
  surface-variant: '#353534'
typography:
  display-lg:
    fontFamily: Manrope
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Manrope
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Manrope
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-md:
    fontFamily: Manrope
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Manrope
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  container-max: 1200px
  gutter: 24px
  margin-mobile: 20px
  margin-desktop: 40px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 32px
  section-gap: 64px
---

## Brand & Style
The design system is engineered to evoke the atmosphere of an exclusive, high-end grooming lounge. The brand personality is sophisticated, authoritative, and meticulously curated, targeting a discerning clientele that values precision and a premium experience. 

The visual style employs a **Dark-Mode Minimalism** aesthetic with a **Tactile Modern** edge. By utilizing a deep charcoal foundation paired with metallic accents, the UI feels quiet yet luxurious. High-end editorial influences are present through generous whitespace and a strictly controlled color palette, ensuring the focus remains on the craftsmanship of the service.

## Colors
The palette is rooted in a "Noir Luxe" philosophy. The primary background is a deep, non-pure black (#141414) to maintain softness and depth. 

- **Primary (Warm Gold):** Reserved exclusively for high-priority actions, active states, and brand-defining moments. 
- **Secondary (Obsidian Border):** A subtle, desaturated grey used for structural boundaries and container outlines.
- **Surface (Deep Charcoal):** A slightly lighter variant used to distinguish cards and elevated sections from the base background.
- **Typography (Parchment):** An off-white shade that reduces eye strain and reinforces the high-end, classic feel.

## Typography
This design system utilizes **Manrope** across all levels to achieve a balanced, technical, yet approachable feel. 

Headlines use tighter letter-spacing and heavier weights to command attention against the dark background. Body text maintains a comfortable line height for legibility. Labels and secondary metadata utilize increased letter-spacing and uppercase styling to provide a clear information hierarchy without relying on high-contrast colors.

## Layout & Spacing
The layout follows a **Fluid-Fixed Hybrid** model. On desktop, content is constrained to a 1200px center-aligned container. On mobile, a single-column layout persists with a minimum side margin of 20px.

A strict 8px grid governs all internal component spacing. Generous "breathing room" (section-gap) is mandatory between logical blocks to reinforce the premium, unhurried brand narrative. Negative space is treated as a functional element to guide the user's eye toward the Gold accent calls-to-action.

## Elevation & Depth
Depth is created through **Tonal Layering** and **Low-Contrast Outlines** rather than traditional drop shadows. 

1.  **Base:** The primary background (#141414).
2.  **Surface:** Cards and floating panels use a subtle shift to a slightly lighter tint or a semi-transparent overlay.
3.  **Borders:** All interactive containers are defined by a 1px solid border (#2A2A2A). 
4.  **Interaction:** When an element is focused or active, the border transitions to the Primary Gold color. 

Shadows, if used, are restricted to extremely large "Ambient Blurs" (0px offset, 40px blur, 10% opacity black) to provide a soft lift for modal overlays only.

## Shapes
The shape language is defined by a consistent **16px corner radius (rounded-lg)** for all primary containers, cards, and input fields. This softened geometry offsets the "coldness" of the dark theme, making the interface feel more inviting and modern.

Small utility elements like chips or badges may use a full pill-radius to distinguish them from structural components.

## Components

- **Buttons:** Primary buttons feature a solid Warm Gold background with dark text. Secondary buttons are ghost-style with a #2A2A2A border and off-white text. 
- **Cards:** Used for barber profiles and service listings. They must have a 1px #2A2A2A border and 16px corner radius. No background fill is required if the card sits on the base background.
- **Input Fields:** Minimalist design with only a bottom border or a very subtle outlined box. Active states are highlighted by a Gold border.
- **Chips/Badges:** Used for time slots or service categories. Unselected states use a dark-grey stroke; selected states use a solid Gold background.
- **Lists:** Clean, border-separated rows with 24px vertical padding to maintain the minimalist rhythm.
- **Booking Calendar:** A custom component using a high-contrast grid where the selected date is encased in a Gold circle, while unavailable dates are dimmed to 30% opacity.