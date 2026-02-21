#!/usr/bin/env bash
# build_index.sh — builds index.html + ukhona/html/level{1..3}/session{1..5}.html
# Run from repo root: bash build_index.sh

set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HTML_DIR="$ROOT/ukhona/html"

# ── Helpers (bash 3 compatible — no declare -A) ────────────────────────────────
get_accent() {
  case "$1" in
    1) echo "#4fc3f7" ;;
    2) echo "#69db7c" ;;
    3) echo "#ffd43b" ;;
  esac
}
get_level_name() {
  case "$1" in
    1) echo "Foundations" ;;
    2) echo "Exploration" ;;
    3) echo "Integration" ;;
  esac
}

# ── Session metadata ───────────────────────────────────────────────────────────
# LEVEL|SESSION|EMOJI|TITLE|SUBTITLE|ONE_LINER|BODY_HTML

declare -a SESSIONS=(

# ════════════════════════════════════════════════════════════════════
# LEVEL 1 · Foundations — PowerPoint clarity. One idea per slide.
# ════════════════════════════════════════════════════════════════════

"1|1|🌱|The Existing Process|How Evidence Becomes Policy|What is the current pipeline for literature review at WHO-India?|
<div class='slide'>
  <div class='slide-num'>01</div>
  <h2 class='slide-h'>The Chain</h2>
  <p class='slide-lead'>Geneva sets the goal → SEARO translates it → Country Office assigns it → <em>You</em> review the evidence.</p>
</div>
<div class='slide'>
  <div class='slide-num'>02</div>
  <h2 class='slide-h'>The Standard Steps</h2>
  <ol class='slide-list'>
    <li>Receive mandate</li>
    <li>Search PubMed / WHO IRIS / grey literature</li>
    <li>Screen abstracts</li>
    <li>Extract data from full texts</li>
    <li>Draft the policy brief</li>
    <li>Clear and submit</li>
  </ol>
</div>
<div class='slide slide-callout'>
  <div class='slide-num'>03</div>
  <p class='slide-big'>Every recommendation starts with a <em>search</em>.</p>
</div>"

"1|2|🔬|The Tools Available|What AI Can and Cannot See|Which AI tools exist for literature screening?|
<div class='slide'>
  <div class='slide-num'>01</div>
  <h2 class='slide-h'>AI Tools That Exist Now</h2>
  <ol class='slide-list'>
    <li><strong>Semantic Scholar</strong> — free, citation-aware</li>
    <li><strong>Elicit</strong> — extracts RCT outcomes automatically</li>
    <li><strong>Rayyan</strong> — collaborative abstract screening</li>
    <li><strong>Consensus</strong> — claims synthesis</li>
    <li><strong>Claude / ChatGPT</strong> — drafting &amp; synthesis, not search</li>
  </ol>
</div>
<div class='slide slide-callout'>
  <div class='slide-num'>02</div>
  <p class='slide-big'>AI cannot verify the citations it generates.</p>
</div>
<div class='slide'>
  <div class='slide-num'>03</div>
  <h2 class='slide-h'>Hard Limits</h2>
  <ol class='slide-list'>
    <li>No access to paywalled full texts</li>
    <li>No live search without a plugin</li>
    <li>No substitute for critical appraisal judgement</li>
  </ol>
</div>"

"1|3|🧭|The Framework|PICO and the Logic of Evidence|How do you frame a clinical question for AI?|
<div class='slide slide-callout'>
  <div class='slide-num'>01</div>
  <p class='slide-big'>A precise question gets a precise answer.</p>
</div>
<div class='slide'>
  <div class='slide-num'>02</div>
  <h2 class='slide-h'>PICO</h2>
  <ol class='slide-list'>
    <li><strong>P</strong> — Population: who exactly?</li>
    <li><strong>I</strong> — Intervention: what treatment or programme?</li>
    <li><strong>C</strong> — Comparator: compared to what?</li>
    <li><strong>O</strong> — Outcome: measured how?</li>
  </ol>
</div>
<div class='slide'>
  <div class='slide-num'>03</div>
  <h2 class='slide-h'>PICO → AI Prompt</h2>
  <ol class='slide-list'>
    <li>Name the population precisely — no vague terms</li>
    <li>Use generic <em>and</em> brand names for interventions</li>
    <li>Specify measurable endpoints</li>
    <li>Request study design filters explicitly</li>
  </ol>
</div>"

"1|4|⚗️|The Protocol|From Question to Search String|How do you build a reproducible search strategy?|
<div class='slide'>
  <div class='slide-num'>01</div>
  <h2 class='slide-h'>Boolean Logic</h2>
  <ol class='slide-list'>
    <li><strong>AND</strong> — narrows (both terms required)</li>
    <li><strong>OR</strong> — broadens (either term works)</li>
    <li><strong>NOT</strong> — excludes</li>
    <li><strong>( )</strong> — group before operating</li>
    <li><strong>trunk*</strong> — wildcard catches variants</li>
  </ol>
</div>
<div class='slide slide-callout'>
  <div class='slide-num'>02</div>
  <p class='slide-big'>Aim for 200–500 results. Document every decision.</p>
</div>
<div class='slide'>
  <div class='slide-num'>03</div>
  <h2 class='slide-h'>Build Order</h2>
  <ol class='slide-list'>
    <li>Map each PICO element to MeSH terms</li>
    <li>Join synonyms within each element with OR</li>
    <li>Join elements together with AND</li>
    <li>Test in PubMed</li>
  </ol>
</div>"

"1|5|🎯|The Output|Writing the Evidence Brief|How do you structure a policy brief from a literature review?|
<div class='slide'>
  <div class='slide-num'>01</div>
  <h2 class='slide-h'>Brief Architecture</h2>
  <ol class='slide-list'>
    <li>Executive summary — one paragraph, decision-ready</li>
    <li>Background — why this question, why now</li>
    <li>Methods — search strategy &amp; inclusion criteria</li>
    <li>Findings — tabulated, graded evidence</li>
    <li>Recommendations — tiered by certainty</li>
    <li>Limitations — brief and honest</li>
  </ol>
</div>
<div class='slide slide-callout'>
  <div class='slide-num'>02</div>
  <p class='slide-big'>The summary must work without the rest of the document.</p>
</div>
<div class='slide'>
  <div class='slide-num'>03</div>
  <h2 class='slide-h'>AI-Assisted Drafting</h2>
  <ol class='slide-list'>
    <li>Feed extracted data table to Claude</li>
    <li>Prompt: synthesise findings, flag contradictions</li>
    <li>Human edits for tone, context, WHO house style</li>
    <li>Supervisor clearance before submission</li>
  </ol>
</div>"

# ════════════════════════════════════════════════════════════════════
# LEVEL 2 · Exploration — analytical, denser, introduces nuance
# ════════════════════════════════════════════════════════════════════

"2|1|🌐|Bias in the Machine|When AI Mirrors Our Blindspots|How does training data bias affect AI literature tools?|
<section class='s-section'>
  <h2>Sources of Bias</h2>
  <ul>
    <li>Publication bias — negative trials systematically underrepresented in indexed literature</li>
    <li>Language bias — English-language sources dominate all major AI training corpora</li>
    <li>Geographic bias — LMIC evidence sparse; high-income country trials set the baseline</li>
    <li>Recency bias — older foundational studies deprioritised by citation-velocity algorithms</li>
  </ul>
</section>
<section class='s-section'>
  <h2>Mitigation Strategies</h2>
  <ul>
    <li>Supplement AI search with manual grey literature trawl (WHO IRIS, national registers)</li>
    <li>Explicitly query non-English databases: LILACS, EMBASE, CNKI</li>
    <li>Document and disclose known gaps in the brief's limitations section</li>
    <li>Weight evidence by contextual transferability, not just methodological quality</li>
  </ul>
</section>"

"2|2|👑|Prompt Engineering|The Craft of Asking Machines Well|What makes a good AI prompt for evidence synthesis?|
<section class='s-section'>
  <h2>Anatomy of a Strong Prompt</h2>
  <ul>
    <li><strong>Role</strong> — assign expertise: <em>\"You are a systematic review methodologist with WHO experience\"</em></li>
    <li><strong>Task</strong> — specific deliverable, not a vague request</li>
    <li><strong>Context</strong> — paste the data table; never assume the model has it</li>
    <li><strong>Format</strong> — specify table, bullets, paragraph, word count</li>
    <li><strong>Constraints</strong> — <em>\"do not invent citations\"</em>, <em>\"flag all uncertainty explicitly\"</em></li>
  </ul>
</section>
<section class='s-section'>
  <h2>Iteration Patterns</h2>
  <ul>
    <li>Chain prompts across turns to build complexity incrementally</li>
    <li>Ask the model to critique its own prior output before finalising</li>
    <li>Request alternative framings when one synthesis feels incomplete</li>
    <li>Test on a question you already know the answer to before trusting novel outputs</li>
  </ul>
</section>"

"2|3|🔭|Critical Appraisal|Reading Studies That Read Back|How do you appraise AI-retrieved evidence rigorously?|
<section class='s-section'>
  <h2>GRADE in Brief</h2>
  <ul>
    <li><strong>High</strong> — RCT with low risk of bias; directness and precision adequate</li>
    <li><strong>Moderate</strong> — RCT with important limitations, or observational with strong dose-response</li>
    <li><strong>Low</strong> — Observational studies without special features</li>
    <li><strong>Very low</strong> — Case series, mechanism-based reasoning, expert opinion</li>
  </ul>
</section>
<section class='s-section'>
  <h2>Risk of Bias Checklist</h2>
  <ul>
    <li>Was randomisation adequate and concealed?</li>
    <li>Were participants, personnel, and outcome assessors blinded?</li>
    <li>Was attrition reported, balanced, and handled with appropriate methods?</li>
    <li>Were all pre-specified outcomes reported, without selective reporting?</li>
    <li>Are there other sources of bias specific to this study design?</li>
  </ul>
</section>"

"2|4|🩻|Meta-Analysis Basics|When Numbers Can Be Pooled|When is statistical pooling of evidence appropriate?|
<section class='s-section'>
  <h2>Conditions for Pooling</h2>
  <ul>
    <li>Clinical homogeneity — sufficiently similar populations, interventions, and outcomes</li>
    <li>Methodological homogeneity — comparable designs and risk-of-bias profiles</li>
    <li>Statistical homogeneity — I² below ~50% as a rough threshold for fixed-effects</li>
    <li>Sufficient studies — minimum three to five for a meaningful pooled estimate</li>
  </ul>
</section>
<section class='s-section'>
  <h2>Reading a Forest Plot</h2>
  <ul>
    <li>Each row represents one study; box size reflects statistical weight</li>
    <li>Horizontal whiskers show the 95% confidence interval</li>
    <li>Diamond at the bottom shows the pooled estimate and its CI</li>
    <li>Vertical line of no effect sits at 1.0 (RR/OR) or 0 (mean difference)</li>
    <li>Diamond crossing that line → result not statistically significant at α = 0.05</li>
  </ul>
</section>"

"2|5|👁️|Surveillance Use Cases|AI Watching the Literature|How can AI assist ongoing evidence surveillance between full reviews?|
<section class='s-section'>
  <h2>Living Reviews Infrastructure</h2>
  <ul>
    <li>Automated PubMed email alerts on validated PICO search strings</li>
    <li>Semantic Scholar citation alerts for sentinel papers in the domain</li>
    <li>Quarterly AI-assisted rescreening of new hits against inclusion criteria</li>
    <li>Preprint monitoring via medRxiv and bioRxiv for emerging signals</li>
  </ul>
</section>
<section class='s-section'>
  <h2>Signal vs Noise</h2>
  <ul>
    <li>Volume of output is not a proxy for quality of evidence signal</li>
    <li>Triage by journal impact tier plus citation velocity in the first 90 days</li>
    <li>Flag any result that directly contradicts existing WHO policy positions</li>
    <li>Escalate immediately if a new safety signal emerges — do not wait for the next cycle</li>
  </ul>
</section>"

# ════════════════════════════════════════════════════════════════════
# LEVEL 3 · Integration — scholarly, reference-grade, layered
# ════════════════════════════════════════════════════════════════════

"3|1|🧬|Ethics of AI Evidence|When the Algorithm Decides|What are the ethical limits of AI in evidence-based policy?|
<section class='s-section'>
  <h2>Core Ethical Tensions</h2>
  <ul>
    <li><strong>Efficiency vs Accountability</strong> — AI accelerates synthesis but obscures authorship; who is accountable when a recommendation harms?</li>
    <li><strong>Automation vs Expertise</strong> — Over-reliance on AI tools risks deskilling junior officers in the critical appraisal judgements the tools cannot make</li>
    <li><strong>Equity vs Optimisation</strong> — Tools trained on biased corpora do not passively reflect inequity; they actively reproduce and scale it</li>
    <li><strong>Transparency vs Proprietary Models</strong> — Black-box outputs fed into public health policy cannot be independently audited or challenged</li>
  </ul>
</section>
<section class='s-section'>
  <h2>Institutional Safeguards</h2>
  <ul>
    <li>Human-in-the-loop requirement for all policy-facing recommendations — non-negotiable</li>
    <li>Mandatory disclosure of AI tool names, versions, and prompts in methods sections</li>
    <li>Annual audit: AI-assisted outputs vs gold-standard Cochrane review conclusions in the same domain</li>
    <li>Limitation literacy training for all staff — not just capability training on tool use</li>
  </ul>
</section>"

"3|2|🏛️|Institutional Integration|Making AI Stick|How do you embed AI tools durably into WHO country office workflows?|
<section class='s-section'>
  <h2>Change Management Principles</h2>
  <ul>
    <li>Begin with willing early adopters, not mandates — coerced adoption produces surface compliance and hidden workarounds</li>
    <li>Pilot on low-stakes, time-pressured reviews first, where speed gains are most visible</li>
    <li>Quantify and display time saved per review — evidence of value accelerates institutional buy-in</li>
    <li>Cultivate internal champions at each seniority tier; peer modelling is more powerful than top-down instruction</li>
  </ul>
</section>
<section class='s-section'>
  <h2>Standard Operating Procedure Template</h2>
  <ul>
    <li><strong>Step 1</strong> — Define the question (PICO): human responsibility, non-delegable</li>
    <li><strong>Step 2</strong> — AI-assisted database search and deduplication</li>
    <li><strong>Step 3</strong> — Human verification of the final included-studies list (spot-check minimum 20%)</li>
    <li><strong>Step 4</strong> — AI-assisted data extraction and synthesis first draft</li>
    <li><strong>Step 5</strong> — Human critical appraisal, contextual edit, GRADE rating</li>
    <li><strong>Step 6</strong> — Supervisor clearance before any external dissemination: human, documented</li>
  </ul>
</section>"

"3|3|⚡|Rapid Evidence Reviews|Speed Without Sacrificing Rigour|How fast can a credible evidence review be produced with AI assistance?|
<section class='s-section'>
  <h2>The 48-Hour Workflow</h2>
  <ul>
    <li><strong>Hours 0–2</strong>: PICO definition, search string construction, database selection — human</li>
    <li><strong>Hours 2–6</strong>: AI-assisted search execution, deduplication, import to screening tool</li>
    <li><strong>Hours 6–12</strong>: AI abstract screening; human spot-check of 20% random sample for calibration</li>
    <li><strong>Hours 12–24</strong>: Full-text retrieval and AI-assisted data extraction into structured table</li>
    <li><strong>Hours 24–36</strong>: AI synthesis draft; human critical appraisal, contextual edit, GRADE where feasible</li>
    <li><strong>Hours 36–48</strong>: WHO house-style formatting, supervisor clearance, submission</li>
  </ul>
</section>
<section class='s-section'>
  <h2>What the 48-Hour Format Sacrifices</h2>
  <ul>
    <li>Grey literature depth: registers, reports, and unpublished data are under-searched</li>
    <li>Non-English language sources: routinely excluded by time pressure</li>
    <li>Formal GRADE rating: often truncated to directional certainty language</li>
    <li>Stakeholder consultation: not possible within the timeline</li>
    <li>All omissions must be explicitly disclosed in the limitations section — ethical obligation, not stylistic choice</li>
  </ul>
</section>"

"3|4|🌊|Global Evidence Ecosystems|Navigating International Data Hierarchies|How do LMIC contexts fit into, and challenge, global evidence hierarchies?|
<section class='s-section'>
  <h2>The Evidence Hierarchy Problem</h2>
  <ul>
    <li>RCTs from high-income settings dominate GRADE rankings and Cochrane reviews by sheer volume and methodological visibility</li>
    <li>Contextual validity — the fit between study setting and implementation setting — is rarely assessed systematically in global guidelines</li>
    <li>Implementation and health systems evidence is routinely excluded from Cochrane reviews by design; it is precisely this evidence that country offices need</li>
    <li>Local observational data, even when highly transferable, is dismissed at face value due to study design, not contextual relevance</li>
  </ul>
</section>
<section class='s-section'>
  <h2>LMIC-Sensitive Appraisal Framework</h2>
  <ul>
    <li><strong>Transferability</strong>: Was the trial population comparable in disease burden, health system capacity, and social determinants?</li>
    <li><strong>Health system assumptions</strong>: Does the intervention require infrastructure or human resource density that cannot be assumed?</li>
    <li><strong>Regional supplementation</strong>: Always search LILACS, IndMED, IMSEAR, and African Journals Online alongside global databases</li>
    <li><strong>Explicit local citation</strong>: Cite available local evidence directly in the policy brief, even if it does not meet Cochrane inclusion criteria</li>
  </ul>
</section>"

"3|5|🔥|Future of Evidence|What Comes After the Current Moment|Where is AI-assisted evidence synthesis heading, and what remains irreducibly human?|
<section class='s-section'>
  <h2>Near-Term Technical Developments</h2>
  <ul>
    <li>Real-time living systematic reviews: continuously updated, integrated with preprint servers and trial registries</li>
    <li>Multimodal AI: reading and extracting from figures, tables, supplementary data files, and scanned PDFs</li>
    <li>Automated GRADE rating with structured explainability: outputs that can be audited, challenged, and revised</li>
    <li>Direct integration with WHO GDG platform: from search output to recommendation draft without format conversion</li>
  </ul>
</section>
<section class='s-section'>
  <h2>The Irreducibly Human Role</h2>
  <ul>
    <li><strong>Framing the question</strong>: AI cannot determine what matters to a population — that requires political, ethical, and epidemiological judgement</li>
    <li><strong>Contextual interpretation</strong>: Health systems are not datasets; the distance between evidence and decision requires human translation</li>
    <li><strong>Accountability</strong>: Policy recommendations have named authors who bear responsibility for their consequences</li>
    <li><strong>Equity as a value</strong>: Equity must be actively chosen at every step — it cannot be optimised into existence by any algorithm</li>
  </ul>
</section>"
)

# ── Session page generator ─────────────────────────────────────────────────────
generate_page() {
  local level="$1" session="$2" emoji="$3" title="$4" subtitle="$5" oneliner="$6" body="$7"
  local accent; accent="$(get_accent "$level")"
  local level_name; level_name="$(get_level_name "$level")"

  local prev_link="" next_link=""
  if   (( session > 1 ));  then prev_link="session$(( session - 1 )).html"
  elif (( level   > 1 ));  then prev_link="../level$(( level - 1 ))/session5.html"
  fi
  if   (( session < 5 ));  then next_link="session$(( session + 1 )).html"
  elif (( level   < 3 ));  then next_link="../level$(( level + 1 ))/session1.html"
  fi

  local prev_html="" next_html=""
  [[ -n "$prev_link" ]] && prev_html="<a class='s-nav-btn' href='${prev_link}'>← Previous</a>"
  [[ -n "$next_link" ]] && next_html="<a class='s-nav-btn s-nav-next' href='${next_link}'>Next →</a>"

  local level_css=""
  if [[ "$level" == "1" ]]; then
    level_css='
    .s-page { max-width: 860px; }
    .slide {
      min-height: 320px; display: flex; flex-direction: column; justify-content: center;
      padding: 3rem 3.5rem; margin-bottom: 2rem; border-radius: 16px;
      background: var(--glass); border: 1px solid var(--border);
      position: relative; overflow: hidden; transition: var(--transition);
    }
    .slide::before {
      content: ""; position: absolute; inset: 0; pointer-events: none;
      background: linear-gradient(135deg, color-mix(in srgb, var(--session-accent) 4%, transparent), transparent 60%);
    }
    .slide:hover { border-color: color-mix(in srgb, var(--session-accent) 40%, var(--border)); }
    .slide-callout {
      background: color-mix(in srgb, var(--session-accent) 7%, var(--glass));
      border-color: color-mix(in srgb, var(--session-accent) 35%, transparent);
    }
    .slide-num {
      font-family: "Inter", sans-serif; font-size: .6rem; letter-spacing: .4em;
      font-weight: 700; color: var(--session-accent); opacity: .6; margin-bottom: 1.5rem;
    }
    .slide-h {
      font-family: var(--ff-display); font-size: clamp(1.6rem, 4vw, 2.4rem);
      font-weight: 800; line-height: 1.1; letter-spacing: -.02em;
      color: var(--text); margin-bottom: 1.5rem;
    }
    .slide-lead {
      font-size: clamp(1.05rem, 2.5vw, 1.35rem); line-height: 1.65;
      color: var(--text-secondary); max-width: 600px;
    }
    .slide-lead em { color: var(--session-accent); font-style: italic; font-weight: 600; }
    .slide-big {
      font-family: var(--ff-display); font-size: clamp(1.6rem, 4.5vw, 2.6rem);
      font-weight: 800; line-height: 1.15; color: var(--text);
      letter-spacing: -.02em; max-width: 680px;
    }
    .slide-big em { color: var(--session-accent); font-style: italic; }
    .slide-list {
      list-style: none; padding: 0; margin: 0;
      display: flex; flex-direction: column; gap: .9rem;
      counter-reset: slide-counter;
    }
    .slide-list li {
      counter-increment: slide-counter; display: flex; align-items: flex-start; gap: 1.2rem;
      font-size: clamp(1rem, 2vw, 1.15rem); line-height: 1.5; color: var(--text-secondary);
    }
    .slide-list li::before {
      content: counter(slide-counter, decimal-leading-zero);
      font-family: "Inter", sans-serif; font-size: .65rem; font-weight: 700;
      letter-spacing: .05em; color: var(--session-accent); min-width: 2rem; padding-top: .25em;
    }
    .slide-list li strong { color: var(--text); font-weight: 600; }
    .slide-list li em { color: var(--session-accent); font-style: normal; }
    @media (max-width: 600px) { .slide { padding: 2rem 1.5rem; min-height: 240px; } }'
  else
    level_css='
    .s-section { margin-bottom: 3rem; padding-bottom: 3rem; border-bottom: 1px solid var(--border); }
    .s-section:last-of-type { border-bottom: none; }
    .s-section h2 {
      font-family: var(--ff-display); font-size: 1.3rem; font-weight: 600;
      color: var(--text); margin-bottom: 1.25rem;
      padding-left: 1rem; border-left: 3px solid var(--session-accent);
    }
    .s-section ul { list-style: none; padding: 0; display: flex; flex-direction: column; gap: .6rem; }
    .s-section li {
      padding: .7rem 1rem .7rem 1.25rem; background: var(--glass);
      border: 1px solid var(--border); border-radius: 8px;
      font-size: .95rem; color: var(--text-secondary); line-height: 1.65; transition: var(--transition);
    }
    .s-section li::before { content: "▸"; color: var(--session-accent); margin-right: .6rem; font-size: .75rem; }
    .s-section li:hover {
      background: color-mix(in srgb, var(--session-accent) 5%, var(--glass));
      border-color: var(--session-accent); color: var(--text);
    }
    .s-section li strong { color: var(--text); font-weight: 600; }
    .s-section li em { color: var(--session-accent); font-style: italic; }'
  fi

  cat <<PAGE
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${emoji} ${title} · Level ${level} Session ${session}</title>
  <meta name="description" content="${oneliner}">
  <meta name="color-scheme" content="dark light">
  <link rel="icon" href="https://abikesa.github.io/favicon/assets/favicon-dark.ico" media="(prefers-color-scheme: dark)">
  <link rel="icon" href="https://abikesa.github.io/favicon/assets/favicon-light.ico" media="(prefers-color-scheme: light)">
  <link rel="preload" href="https://abikesa.github.io/logos/assets/ukubona-dark.png" as="image">
  <link rel="preload" href="https://abikesa.github.io/logos/assets/ukubona-light.png" as="image">
  <link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,800;1,400&family=Source+Serif+4:ital,opsz,wght@0,8..60,300;0,8..60,400;1,8..60,300&display=swap" rel="stylesheet">
  <link href="../../css/variables.css?v=1.1" rel="stylesheet">
  <link href="../../css/head.css?v=1.1" rel="stylesheet">
  <link href="../../css/card.css?v=1.1" rel="stylesheet">
  <link href="../../css/footer.css" rel="stylesheet">
  <style>
    :root {
      --session-accent: ${accent};
      --ff-display: 'Playfair Display', Georgia, serif;
      --ff-body:    'Source Serif 4', Georgia, serif;
    }
    body { font-family: var(--ff-body); font-weight: 300; }
    .spine { position: fixed; left: 0; top: 0; width: 3px; height: 0%; background: var(--session-accent); z-index: 200; transition: height .1s linear; }
    .s-page { padding-top: calc(var(--header-h) + 3rem); padding-bottom: 6rem; max-width: 780px; margin: 0 auto; padding-left: 2rem; padding-right: 2rem; }
    .s-crumb { font-family: 'Inter', sans-serif; font-size: .6rem; letter-spacing: .3em; text-transform: uppercase; color: var(--text-secondary); opacity: .5; margin-bottom: 2.5rem; display: flex; gap: .75rem; align-items: center; }
    .s-crumb span { color: var(--session-accent); opacity: 1; }
    .s-hero { margin-bottom: 3.5rem; }
    .s-label { font-family: 'Inter', sans-serif; font-size: .6rem; letter-spacing: .3em; text-transform: uppercase; color: var(--session-accent); margin-bottom: .75rem; font-weight: 600; }
    .s-title { font-family: var(--ff-display); font-size: clamp(2rem, 5vw, 3.2rem); font-weight: 800; line-height: 1.1; letter-spacing: -.02em; color: var(--text); margin-bottom: .5rem; }
    .s-subtitle { font-family: var(--ff-display); font-size: clamp(1rem, 2.5vw, 1.3rem); font-style: italic; font-weight: 400; color: var(--text-secondary); margin-bottom: 1.5rem; }
    .s-oneliner { font-size: .9rem; line-height: 1.7; color: var(--text-secondary); border-left: 3px solid var(--session-accent); padding-left: 1rem; max-width: 540px; }
    .s-badge { display: inline-flex; align-items: center; gap: .5rem; font-family: 'Inter', sans-serif; font-size: .55rem; letter-spacing: .2em; text-transform: uppercase; padding: .3rem .8rem; border-radius: 999px; border: 1px solid var(--session-accent); color: var(--session-accent); background: color-mix(in srgb, var(--session-accent) 8%, transparent); margin-bottom: 1.5rem; }
    .s-nav { display: flex; justify-content: space-between; align-items: center; margin-top: 4rem; padding-top: 2rem; border-top: 1px solid var(--border); gap: 1rem; }
    .s-nav-btn { font-family: 'Inter', sans-serif; font-size: .7rem; letter-spacing: .1em; font-weight: 500; padding: .6rem 1.4rem; border-radius: 8px; border: 1px solid var(--border); background: var(--glass); color: var(--text-secondary); text-decoration: none; transition: var(--transition); }
    .s-nav-btn:hover { border-color: var(--session-accent); color: var(--session-accent); }
    .s-nav-next { margin-left: auto; }
    @media (max-width: 600px) { .s-page { padding-left: 1.25rem; padding-right: 1.25rem; } }
    ${level_css}
  </style>
</head>
<body>
<div class="spine" id="spine"></div>
<div class="scroll-indicator" aria-hidden="true"><div class="scroll-progress"></div></div>
<div class="bg-pattern" aria-hidden="true"></div>
<header class="header" id="header"></header>

<div class="s-page">
  <div class="s-crumb">
    <a href="../../" style="color:inherit;text-decoration:none;">Home</a> · Level ${level} · <span>Session ${session}</span>
  </div>
  <div class="s-hero">
    <div class="s-badge">${emoji} Level ${level} of 3 · Session ${session} of 5</div>
    <p class="s-label">Level ${level} · ${level_name}</p>
    <h1 class="s-title">${title}</h1>
    <p class="s-subtitle">${subtitle}</p>
    <p class="s-oneliner">${oneliner}</p>
  </div>

  ${body}

  <nav class="s-nav" aria-label="Session navigation">
    ${prev_html}
    ${next_html}
  </nav>
</div>

<div id="footer-placeholder"></div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.29.0/feather.min.js"></script>
<script src="../../js/shared.js"></script>
<script>
  const spine = document.getElementById('spine');
  window.addEventListener('scroll', () => {
    const pct = window.scrollY / (document.documentElement.scrollHeight - window.innerHeight) * 100;
    spine.style.height = Math.min(pct, 100) + '%';
  }, { passive: true });
</script>
</body>
</html>
PAGE
}

# ── index.html ─────────────────────────────────────────────────────────────────
generate_index() {
  cat <<'INDEX'
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Ukubona</title>
  <meta name="description" content="Ukubona LLC — to see, to perceive, to know.">
  <meta name="color-scheme" content="dark light">
  <link rel="icon" href="https://abikesa.github.io/favicon/assets/favicon-dark.ico" media="(prefers-color-scheme: dark)">
  <link rel="icon" href="https://abikesa.github.io/favicon/assets/favicon-light.ico" media="(prefers-color-scheme: light)">
  <link rel="preload" href="https://abikesa.github.io/logos/assets/ukubona-dark.png" as="image">
  <link rel="preload" href="https://abikesa.github.io/logos/assets/ukubona-light.png" as="image">
  <link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link href="ukhona/css/variables.css?v=1.1" rel="stylesheet">
  <link href="ukhona/css/head.css?v=1.1" rel="stylesheet">
  <link href="ukhona/css/card.css?v=1.1" rel="stylesheet">
  <link href="ukhona/css/footer.css" rel="stylesheet">
  <style>
    html { height: 100%; }
    body { min-height: 100%; display: flex; flex-direction: column; }
    .landing-stage {
      position: relative; z-index: 10; flex: 1;
      display: flex; flex-direction: column;
      align-items: center; justify-content: center;
      padding: 2rem; margin-top: var(--header-h); text-align: center; gap: 1rem;
    }
    .topo-layer { position: fixed; inset: 0; z-index: 0; overflow: hidden; pointer-events: none; }
    .topo-layer svg { width: 100%; height: 100%; opacity: .04; }
    @keyframes topoFloat {
      0%, 100% { transform: translate(0, 0); }
      50%       { transform: translate(-12px, 8px); }
    }
    .topo-layer svg g { animation: topoFloat 32s ease-in-out infinite; }
  </style>
</head>
<body>
<div class="topo-layer" aria-hidden="true">
  <svg viewBox="0 0 1000 750" preserveAspectRatio="xMidYMid slice">
    <g fill="none" stroke="currentColor" stroke-width=".8">
      <ellipse cx="500" cy="380" rx="490" ry="340"/>
      <ellipse cx="500" cy="380" rx="430" ry="290"/>
      <ellipse cx="500" cy="380" rx="365" ry="238" stroke-width="1.4"/>
      <ellipse cx="500" cy="380" rx="298" ry="188"/>
      <ellipse cx="500" cy="380" rx="230" ry="140"/>
      <ellipse cx="500" cy="380" rx="164" ry="96" stroke-width="1.4"/>
      <ellipse cx="500" cy="380" rx="100" ry="56"/>
      <ellipse cx="500" cy="380" rx="46" ry="24"/>
      <line x1="0" y1="250" x2="1000" y2="250" stroke-dasharray="2,20"/>
      <line x1="0" y1="500" x2="1000" y2="500" stroke-dasharray="2,20"/>
      <line x1="333" y1="0" x2="333" y2="750" stroke-dasharray="2,20"/>
      <line x1="666" y1="0" x2="666" y2="750" stroke-dasharray="2,20"/>
    </g>
  </svg>
</div>
<div class="scroll-indicator" aria-hidden="true"><div class="scroll-progress"></div></div>
<div class="bg-pattern" aria-hidden="true"></div>
<header class="header" id="header"></header>
<main class="landing-stage" aria-label="Ukubona landing"></main>
<div id="footer-placeholder"></div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.29.0/feather.min.js"></script>
<script src="ukhona/js/shared.js"></script>
</body>
</html>
INDEX
}

# ── Write index.html ───────────────────────────────────────────────────────────
generate_index > "$ROOT/index.html"
echo "✅  $ROOT/index.html"

# ── Write session pages ────────────────────────────────────────────────────────
for entry in "${SESSIONS[@]}"; do
  IFS='|' read -r level session emoji title subtitle oneliner body <<< "$entry"
  dir="$HTML_DIR/level${level}"
  mkdir -p "$dir"
  outfile="$dir/session${session}.html"
  generate_page "$level" "$session" "$emoji" "$title" "$subtitle" "$oneliner" "$body" > "$outfile"
  echo "✅  $outfile"
done

echo ""
echo "Done — index.html + 15 session pages written."
echo ""
echo "  Level 1 — Slide cards  : big type, numbered, callout blocks"
echo "  Level 2 — Analysis cards: dense bullets, hover states"
echo "  Level 3 — Reference cards: full sentences, scholarly register"