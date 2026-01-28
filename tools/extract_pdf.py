import re
from pathlib import Path

import pdfplumber

pdf_path = Path(r"D:\Projects\simpliID\School ID Photo Capture Technical Spec.pdf")

text_parts: list[str] = []
with pdfplumber.open(str(pdf_path)) as pdf:
    for i, page in enumerate(pdf.pages[:15]):
        t = page.extract_text() or ""
        text_parts.append(f"\n\n=== PAGE {i+1} ===\n{t}")

text = "\n".join(text_parts)
print(text[:20000])

lines = [ln.strip() for ln in text.splitlines() if ln.strip()]
candidates: list[str] = []
for ln in lines:
    if "|" in ln and len([p for p in ln.split("|") if p.strip()]) >= 3:
        candidates.append(ln)
    elif re.search(r"\b(Column|Field|Key)\b", ln, re.I):
        candidates.append(ln)
    elif len(re.findall(r"\w+", ln)) >= 6 and re.search(
        r"\b(ID|Name|Class|Section|DOB|Roll|Order|School)\b", ln, re.I
    ):
        candidates.append(ln)

print("\n\n=== CANDIDATES ===")
for c in candidates[:80]:
    print(c)
