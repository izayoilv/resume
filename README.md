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
./ats-check.sh
```

Verifies extraction of contacts, section headings, and key terms, plus:
single page, no embedded images, embedded fonts, fresh PDF (not stale
relative to `resume.tex`). Also installed as a pre-commit hook, so a
broken or outdated PDF cannot be committed.

---

© 2026 Vincent Yongky Pratama. All rights reserved.
