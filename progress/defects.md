# 🐛 FEEDWISE — Defects & Improvements Log

> **All bugs found, improvements identified, and technical debt tracked across all phases**
> 
> **Last Updated:** 2026-08-10

---

## 🔴 CRITICAL BUGS (Must fix before submission)

| ID | Phase | Description | File(s) | Status | Assigned To | Fixed Date |
|----|-------|-------------|---------|--------|-------------|------------|
| — | — | No critical bugs yet | — | — | — | — |

---

## 🟡 MEDIUM BUGS (Should fix if time allows)

| ID | Phase | Description | File(s) | Status | Fixed Date |
|----|-------|-------------|---------|--------|------------|
| — | — | No medium bugs yet | — | — | — |

---

## 🟢 LOW BUGS (Nice to fix, not blocking)

| ID | Phase | Description | File(s) | Status | Fixed Date |
|----|-------|-------------|---------|--------|------------|
| — | — | No low bugs yet | — | — | — |

---

## 💡 IMPROVEMENTS (Not bugs, but would make product better)

| Priority | Description | Phase | Effort | Status |
|----------|-------------|-------|--------|--------|
| 🟡 High | Add haptic feedback on decision buttons | 5 | 30min | ⬜ |
| 🟡 High | Add page transition animations (Hero, fade) | 5 | 1h | ⬜ |
| 🟡 High | Add pull-to-refresh on feed | 5 | 30min | ⬜ |
| 🟢 Medium | Add Nepali language support | 9 | 3h | ⬜ |
| 🟢 Medium | Add offline caching with local storage | 8 | 2h | ⬜ |
| 🟢 Medium | Add skeleton loading on every list | 5 | 1h | ⬜ |
| 🟢 Medium | Add confetti animation on badge unlock | 5 | 30min | ⬜ |
| 🟢 Low | Add sound effects on decision | Post-MVP | 1h | ⬜ |
| 🟢 Low | Add push notifications | Post-MVP | 3h | ⬜ |
| 🟢 Low | Add social sharing of MIL score | Post-MVP | 2h | ⬜ |

---

## 📝 TECHNICAL DEBT

| Description | File(s) | Priority | Estimated Fix |
|-------------|---------|----------|---------------|
| Mock data still used as fallback | mock_*.dart | Low | Remove after stable backend |
| AnimatedBuilder should be AnimatedBuilder or custom | components | Medium | Check API compatibility |
| No unit tests written | test/ | Medium | Add after Phase 5 |
| No integration tests | test/ | Low | Add in Phase 9 |
| Supabase keys in dart-define | main.dart | Medium | Use proper key management |

---

## 📊 DEFECT SUMMARY

| Severity | Open | Fixed | Total |
|----------|------|-------|-------|
| 🔴 Critical | 0 | 0 | 0 |
| 🟡 Medium | 0 | 0 | 0 |
| 🟢 Low | 0 | 0 | 0 |
| **Total** | **0** | **0** | **0** |

---

## HOW TO LOG A DEFECT

When you find a bug during any phase:

1. Add it to the appropriate severity section above
2. Assign an ID (format: BUG-001, BUG-002, etc.)
3. Note the phase where it was found
4. Describe the bug clearly
5. List the file(s) affected
6. Set status: `Open` → `In Progress` → `Fixed` → `Verified`
7. Update the Defect Summary counts
8. Update the phase report with a reference to this defect
