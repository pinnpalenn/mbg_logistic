---
name: NutriTrack Logistics
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#444651'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#757682'
  outline-variant: '#c5c5d3'
  surface-tint: '#4059aa'
  primary: '#00236f'
  on-primary: '#ffffff'
  primary-container: '#1e3a8a'
  on-primary-container: '#90a8ff'
  inverse-primary: '#b6c4ff'
  secondary: '#006c49'
  on-secondary: '#ffffff'
  secondary-container: '#6cf8bb'
  on-secondary-container: '#00714d'
  tertiary: '#3e2400'
  on-tertiary: '#ffffff'
  tertiary-container: '#5c3800'
  on-tertiary-container: '#ef9900'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dce1ff'
  primary-fixed-dim: '#b6c4ff'
  on-primary-fixed: '#00164e'
  on-primary-fixed-variant: '#264191'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#ffddb8'
  tertiary-fixed-dim: '#ffb95f'
  on-tertiary-fixed: '#2a1700'
  on-tertiary-fixed-variant: '#653e00'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
typography:
  h1:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  h2:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  h3:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-md:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '600'
    lineHeight: 18px
    letterSpacing: 0.05em
  data-mono:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: -0.01em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  gutter: 20px
  margin: 24px
---

## Brand & Style

The design system is anchored in the principles of reliability, precision, and public service. For a logistics system dedicated to "Makan Bergizi Gratis" (MBG), the visual language must communicate high trust and operational efficiency to ensure stakeholders—from administrators to drivers—feel confident in the supply chain's integrity.

The chosen style is **Corporate / Modern** with a focus on data density and legibility. It utilizes a structured information hierarchy that prioritizes real-time status updates and spatial data (maps). The interface avoids decorative flourishes, favoring functional aesthetics that reduce cognitive load during high-pressure distribution windows.

## Colors

The palette is designed for high-trust utility. The **Deep Logistics Blue** serves as the foundational primary color, used for navigation, primary actions, and branding to evoke stability. **Efficient Green** is reserved strictly for positive outcomes: successful deliveries, optimized routes, and healthy system statuses. 

**Alert Orange** acts as a critical attention-grabber for pending tasks, delays, or warnings, ensuring they are distinct from standard operations. The background uses a very soft gray to reduce screen glare during long shifts, while surfaces remain pure white to provide clear separation of data modules.

## Typography

The design system utilizes **Inter** exclusively to leverage its exceptional readability at small sizes—crucial for dense manifests and map labels. The typographic scale emphasizes a clear distinction between administrative headers and actionable data. 

Upper-case labels with increased letter spacing are used for secondary metadata and table headers to create a professional, "institutional" feel. For numerical data such as fleet IDs or timestamps, medium-weight Inter is used to maintain a semi-tabular appearance without requiring a separate monospaced font.

## Layout & Spacing

The design system employs a **Fluid Grid** model with a 12-column structure for desktop dashboards. This allows the central map view or data tables to expand and contract based on the user's hardware. 

A strict 4px/8px baseline grid ensures vertical rhythm. Modules within the dashboard (cards) should use a 16px or 24px internal padding (MD or LG) to maintain breathability between data points. Gutters are fixed at 20px to provide clear visual separation between sidebar navigation and the primary content area.

## Elevation & Depth

To maintain a "clean" feel, the design system avoids heavy shadows. Instead, it uses **Ambient Shadows** and **Tonal Layers**. 

- **Level 0 (Base):** The background (#F9FAFB).
- **Level 1 (Cards/Modules):** Pure white surfaces with a 1px border (#E2E8F0) and a very soft, diffused shadow (0px 2px 4px rgba(30, 58, 138, 0.05)).
- **Level 2 (Overlays/Popovers):** Higher elevation with a more pronounced shadow (0px 10px 15px rgba(0, 0, 0, 0.1)) to indicate temporary interaction.

Depth is also communicated through subtle tinting of containers for "active" versus "inactive" states in the sidebar.

## Shapes

The shape language is consistently **Rounded**, using an 8px base radius for standard components like input fields and small cards, and 12px-16px for larger dashboard containers. 

This level of rounding softens the industrial nature of logistics data, making the system feel modern and accessible. Buttons and interactive chips follow the 8px (rounded-md) standard to ensure they are perceived as tactile, clickable elements.

## Components

- **Buttons:** Primary buttons use a solid Deep Logistics Blue background with white text. Secondary buttons use a transparent background with a 1px Blue border.
- **Status Chips:** Small, high-contrast badges. "Delivered" uses a light green background with dark green text; "Pending" uses light orange with dark orange text.
- **Input Fields:** 8px rounded corners with a 1px stroke. Focus state is indicated by a 2px Deep Logistics Blue glow.
- **Cards:** Main dashboard containers use a white background, 12px rounded corners, and a subtle Level 1 shadow. Headers within cards should have a thin bottom border to separate titles from content.
- **Data Tables:** Clean, borderless rows with a subtle hover state (#F1F5F9). Headers must be sticky and use the `label-md` typographic style.
- **Maps:** Integrated map components should use a custom silver/light grayscale base map style to ensure the primary and secondary color markers pop effectively.
- **Icons:** Use a consistent 24px line-art icon set (like Lucide or Phosphor) with a 2px stroke weight to match the Inter typography.