# Deceptive patterns and the persuasion boundary

Load when a request is about conversion, signups, retention, engagement, or pricing presentation — or when reviewing an interface for manipulation. The catalogue is Harry Brignull's (https://www.deceptive.design/), which indexes 60 enforcement actions behind these patterns; the largest single fine to date is $245M.

## When a request implies a deceptive pattern

"Increase signups", "improve conversion", "boost retention", and "get more people onto the annual plan" are all satisfiable by deception. The shortest path to the ask is frequently a catalogued pattern, and shipping it counts as doing what was asked.

When that happens: **name the pattern, offer the honest alternative, let the user choose.** Do not silently pick either one, and do not refuse the task — the request itself is legitimate.

- ✅ "Pre-ticking the newsletter box would lift signups, but that's preselection — 14 enforcement cases. An unticked box with a benefit line next to it converts lower and is defensible. Which do you want?"
- ❌ Shipping the pre-ticked box because it satisfies the metric.
- ❌ Refusing to work on conversion.

The distinction that does the work: a **genuine user preference** is not the same as **exploiting default-acceptance bias**. Most of these patterns are the second thing wearing the first thing's clothes.

## The four an agent produces by default

These four arrive by way of ordinary engineering instincts, not bad intent. They are the ones to recognize in your own output.

| Pattern | Reads to the agent as | Honest alternative |
|---|---|---|
| **Preselection** — 14 enforcement cases | A helpful default: newsletter opt-in, recurring billing, or data sharing pre-ticked | Require an active choice. Nothing consequential is checked on load |
| **Hidden costs** — 10 enforcement cases | Progressive disclosure: shipping, tax, and fees revealed at checkout | Final price on the listing. Itemize fees before the user has invested time |
| **Nagging** — 14 documented cases | Retrying a dismissed prompt, because the answer might change | A dismissal that sticks. "Not now" without a permanent "no" *is* the pattern |
| **Addictive design** — 11+ apps catalogued | Engagement best practice: streaks, infinite scroll, variable rewards, loss-framed notifications | Design an exit. Growth.Design's own Duolingo teardown found a clear stopping point after a daily goal *improved* long-term retention |

That last row is the useful one to hold onto: the honest alternative was also the better-performing one. "Ethical" and "converts worse" are not synonyms, and assuming they are is how the tradeoff gets skipped.

## The full catalogue

The remaining 14, compressed to the shape each takes in an interface:

| Pattern | Shape |
|---|---|
| Confirmshaming | The decline option worded to induce guilt |
| Hard to cancel | Cancellation by phone only, or buried behind redirects, when signup was one click |
| Fake scarcity | Unverifiable stock counters, fabricated "3 left" notices |
| Fake urgency | Countdown timers that reset per device or per visit; a perpetual "24-hour sale" |
| Forced action | An unrelated requirement bolted onto the thing the user came for |
| Hidden subscription | A control that starts a recurring charge without saying so |
| Visual interference | The refusal path given the page's lowest contrast; unsubscribe links matched to the background |
| Trick wording | Double negatives; an opt-out nested where scanning won't catch it |
| Obstruction | Accept is one click, decline is several |
| Sneaking | Items added to a cart the user did not add |
| Disguised ads | An ad shaped like the real download button, or like a system warning |
| Fake social proof | Fabricated purchase notifications with random timestamps |
| Currency confusion | Prices in a bought currency so the real cost needs arithmetic |
| Comparison prevention | Options rendered non-comparable — inconsistent tax treatment, cheaper plans behind extra clicks |

## Where the line is genuinely contested

State this rather than implying a settled rule, because the sources do not agree:

- **Jurisdiction differs.** Countdown timers are prohibited in the EU under the Unfair Commercial Practices Directive and are not uniformly prohibited in the US. "Legal where you ship" is not the same as "legal."
- **Incremental cost disclosure is disputed.** Industry treats drip pricing as disclosure; regulators have treated it as deception and won. The catalogue records the regulatory outcome, not the industry argument.
- **No formal boundary exists for addictive design.** Infinite scroll is standard practice. Loot boxes are flagged; streak systems are not. There is no published threshold separating a habit-forming feature from an exploitative one.
- **Persuasion is not deception.** Making a good option attractive is legitimate design. The tell is whether the pattern works *because* the user misunderstands something — if it stops working once the user sees it clearly, it was deception.

## Anti-patterns

- ❌ Satisfying a conversion request with a catalogued pattern because it was the shortest path
  ✅ Name the pattern, price the honest alternative, let the user decide
- ❌ Treating "it's industry standard" as settling the question
  ✅ Standard practice and defensible practice are different claims — Baymard finds 67% of benchmarked mobile navigation scores mediocre or worse, so the field is not a baseline worth copying
- ❌ A "Not now" button with no permanent decline
  ✅ One dismissal that persists
- ❌ Fees appearing for the first time at checkout
  ✅ Full price where the user first sees the product
- ❌ Refusing an entire conversion or retention task on ethical grounds
  ✅ Do the work; flag the one decision that has an ethical fork in it

## Gotchas

- **Symptom:** A conversion feature ships and later draws a legal complaint. **Cause:** The pattern was legal in the launch market and not in another. **Fix:** Check jurisdiction before treating a persuasion pattern as settled.
- **Symptom:** Users describe the product as manipulative in reviews while metrics look healthy. **Cause:** Short-horizon metrics reward patterns that cost trust over a longer one. **Fix:** Pair engagement metrics with a retention-quality or complaint signal.
- **Symptom:** A stakeholder asks for a pattern by name. **Cause:** They may not know it is catalogued and enforced against. **Fix:** Say which pattern it is and cite the enforcement count; the request often changes on its own.
- **Symptom:** A team believes ethical design costs conversion. **Cause:** The comparison was never run. **Fix:** The exit-design finding above is a counterexample worth having on hand.
