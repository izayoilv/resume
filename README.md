# Resume — Vincent Yongky Pratama

Single-page, ATS-friendly resume in LaTeX (LuaLaTeX, TeX Gyre Heros).
Single column, standard headings, no tables or graphics.

## Build

```bash
latexmk
```

Output: `Vincent_Yongky_Pratama_Resume.pdf`.

## ATS check

```bash
pdftotext Vincent_Yongky_Pratama_Resume.pdf - | head -40
```

Every field must be selectable text, in reading order.

---

© 2026 Vincent Yongky Pratama. All rights reserved.
