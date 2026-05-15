---
name: Royal Roast Interface
colors:
  surface: '#fdf9f4'
  surface-dim: '#ddd9d5'
  surface-bright: '#fdf9f4'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f7f3ee'
  surface-container: '#f1ede8'
  surface-container-high: '#ebe8e3'
  surface-container-highest: '#e6e2dd'
  on-surface: '#1c1c19'
  on-surface-variant: '#51443c'
  inverse-surface: '#31302d'
  inverse-on-surface: '#f4f0eb'
  outline: '#83746b'
  outline-variant: '#d5c3b8'
  surface-tint: '#805533'
  primary: '#6f4627'
  on-primary: '#ffffff'
  primary-container: '#8b5e3c'
  on-primary-container: '#ffe3d1'
  inverse-primary: '#f4bb92'
  secondary: '#7d562d'
  on-secondary: '#ffffff'
  secondary-container: '#ffca98'
  on-secondary-container: '#7a532a'
  tertiary: '#604b3e'
  on-tertiary: '#ffffff'
  tertiary-container: '#7a6355'
  on-tertiary-container: '#ffe2d1'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdcc5'
  primary-fixed-dim: '#f4bb92'
  on-primary-fixed: '#301400'
  on-primary-fixed-variant: '#653d1e'
  secondary-fixed: '#ffdcbd'
  secondary-fixed-dim: '#f0bd8b'
  on-secondary-fixed: '#2c1600'
  on-secondary-fixed-variant: '#623f18'
  tertiary-fixed: '#fbddca'
  tertiary-fixed-dim: '#dec1af'
  on-tertiary-fixed: '#28180d'
  on-tertiary-fixed-variant: '#574335'
  background: '#fdf9f4'
  on-background: '#1c1c19'
  surface-variant: '#e6e2dd'
  status-pending: '#D97706'
  status-preparing: '#8B5E3C'
  status-delivering: '#4B5EAA'
  status-completed: '#166534'
  cream-accent: '#FAF9F6'
  espresso-dark: '#261C15'
typography:
  display-lg:
    fontFamily: Libre Caslon Text
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Libre Caslon Text
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Libre Caslon Text
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  headline-md:
    fontFamily: Libre Caslon Text
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
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
  price-display:
    fontFamily: Manrope
    fontSize: 20px
    fontWeight: '700'
    lineHeight: 24px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  container-margin: 24px
  gutter: 16px
  stack-sm: 4px
  stack-md: 12px
  stack-lg: 24px
  section-gap: 48px
---

## Brand & Style

This design system is crafted to evoke the sensory experience of a premium, artisanal coffee house. The brand personality is **sophisticated, warm, and communal**, bridging the gap between a traditional "Old World" café and a modern, tech-enabled specialty roastery. 

The aesthetic style is a blend of **Minimalism** and **Tactile Modernism**. We utilize generous whitespace to signal premium quality, paired with soft, organic shadows and a rich, earthy color palette that mimics the materials of a high-end coffee shop—ceramic, craft paper, and polished wood. The goal is to make the digital ordering process feel as inviting and tactile as a physical interaction with a barista.

Targeting both the daily commuter and the coffee connoisseur, the UI prioritizes clarity in customization (modifiers/variations) while maintaining an elegant, unhurried visual rhythm.

## Colors

The color palette is derived directly from the roasting process and the natural textures of coffee. 

*   **Primary (#8B5E3C):** A robust "Medium Roast" brown used for primary actions, active states, and brand-heavy components.
*   **Secondary (#D4A373):** A warm "Golden Tan" inspired by the crown in the logo, used for accents, highlights, and secondary call-to-outs.
*   **Neutral (#F9F5F0):** A soft, "Steamed Milk" off-white that serves as the primary background color, reducing eye strain and providing a warmer feel than pure white.
*   **Tertiary/Text (#3D2B1F):** A deep "Espresso" used for high-contrast typography to ensure legibility and a sense of grounding.

**Status Colors** are tuned to be harmonious with the earthy palette while remaining functionally distinct for order tracking (e.g., Pending, Preparing, Completed).

## Typography

The typography system uses a classic pairing to balance tradition and utility. 

**Libre Caslon Text** is our headline face. Its elegant serifs and classic proportions provide an authoritative, "Royal" feel suitable for product names and category headers.

**Manrope** is used for all functional text, including descriptions, labels, and system states. Its clean, geometric nature ensures high legibility on mobile devices, especially when users are navigating complex customization menus like "Selected Modifiers" or "Product Variations."

**Price Displays** use a heavier weight of Manrope in the primary brand color to ensure the transaction value is always clear and prominent.

## Layout & Spacing

This design system utilizes a **12-column fluid grid** for desktop and a **4-column grid** for mobile. The layout philosophy is centered on "The Breathable Menu"—using ample margins and section gaps to prevent the UI from feeling cluttered, even when many modifiers are present.

*   **Margins:** A minimum of 24px container margins on mobile to ensure touch targets for product cards aren't cramped.
*   **Rhythm:** An 8px base unit drives all spacing. Elements are grouped using tight stacks (4px-12px) for related metadata (like a product name and its price) and larger gaps (24px-48px) to separate different categories or order sections.
*   **Mobile-First Reflow:** Product cards transition from a multi-column grid on desktop to a single-column stack on mobile, emphasizing large, high-quality product imagery as defined in the data structure.

## Elevation & Depth

To maintain a premium cafe feel, elevation is conveyed through **Tonal Layers** and **Ambient Shadows** rather than harsh borders.

*   **The Canvas:** The base layer is the "Neutral" cream color.
*   **Surface Layers:** Cards and containers use a pure white or a very light cream (#FAF9F6) to subtly lift off the background.
*   **Shadows:** We use low-opacity, diffused shadows with a slight brown tint (`rgba(61, 43, 31, 0.08)`) to make elements feel like they are resting on a surface rather than floating in digital space. 
*   **Interaction:** Upon hover or press, shadows should slightly deepen and the element should scale (1.02x) to provide tactile feedback similar to picking up a menu or a physical cup.

## Shapes

The shape language is **Soft and Organic**. We avoid sharp corners to maintain the friendly, approachable nature of a neighborhood coffee shop. 

A **Rounded (0.5rem)** base is applied to all standard components like input fields, small chips, and checkboxes. **Large (1rem)** roundedness is reserved for product cards and category containers, while **Extra Large (1.5rem)** or full pill-shapes are used for primary buttons and search bars to make them feel comfortable and "hand-held."

## Components

### Buttons
Primary buttons are pill-shaped, using the Primary Brown with white text. Secondary buttons use a "ghost" style with a 1px Primary Brown border. All buttons should have a minimum touch target height of 48px.

### Cards
Product cards feature a top-aligned image with a "Soft" corner radius. Product names (Libre Caslon) and Prices (Manrope Bold) are placed immediately below, with descriptions tucked into a subtle light-gray subtext.

### Chips & Modifiers
For variations (Hot/Iced) and modifiers (Syrups/Milk types), use outlined chips that fill with the Primary color when selected. This provides a clear, tactile "toggle" feeling.

### Input Fields & Forms
Forms (for addresses, landmarks, etc.) use a light-tan background with a bottom-only border or a very subtle soft-rounded outline. This mimics the look of a handwritten ledger or a boutique order form.

### Order Status Tracker
The tracker uses a horizontal step indicator. "Preparing" uses the brand brown, while "Completed" transitions to a deep forest green. Icons should be thin-line and elegant to match the typography.

### Lists & Navigation
Lists (like the Cart or Order History) use subtle dividers (1px cream/tan) and generous vertical padding (16px) to ensure each item feels distinct.
