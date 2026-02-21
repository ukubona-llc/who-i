#!/usr/bin/env bash
# build_sessions.sh — stamps out ukhona/html/level{1..3}/session{1..5}.html
# Each page is absorbed into the Ukubona cascade:
#   variables.css → head.css → card.css → footer.css + shared.js
# Page-level flavor CSS lives inline per session.
# Run from repo root: bash build_sessions.sh

set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HTML_DIR="$ROOT/ukhona/html"

# ── Level / Session metadata ───────────────────────────────────────────────────
# Format: LEVEL|SESSION|EMOJI|TITLE|SUBTITLE|ONE_LINER|BODY_HTML

declare -a SESSIONS=(

# ── LEVEL 1 · Foundations ─────────────────────────────────────────────────────
"1|1|🌱|The Existing Process|How Evidence Becomes Policy|What is the current process for literature review at WHO-India?|
<section class='s-section'>
  <h2>Chain of Command</h2>
  <ul>
    <li>Geneva sets global targets</li>
    <li>SEARO translates to regional priorities</li>
    <li>Country office tasks the officer</li>
    <li>Officer conducts the review</li>
    <li>Clearance and policy uptake</li>
  </ul>
</section>
<section class='s-section'>
  <h2>The Standard Workflow</h2>
  <ul>
    <li>Receive mandate from supervisor</li>
    <li>Search PubMed / WHO IRIS / grey literature</li>
    <li>Screen abstracts for relevance</li>
    <li>Extract data from full texts</li>
    <li>Synthesize and draft brief</li>
    <li>Submit for clearance</li>
  </ul>
</section>"

"1|2|🔬|The Tools Available|What AI Can and Cannot See|Which AI tools exist for literature screening?|
<section class='s-section'>
  <h2>Existing AI Tools</h2>
  <ul>
    <li>Semantic Scholar — free, citation-aware search</li>
    <li>Elicit — extracts outcomes from RCTs automatically</li>
    <li>Consensus — claims synthesis from abstracts</li>
    <li>Rayyan — collaborative abstract screening</li>
    <li>ChatGPT / Claude — synthesis drafting, not search</li>
  </ul>
</section>
<section class='s-section'>
  <h2>What AI Cannot Do (Yet)</h2>
  <ul>
    <li>Access paywalled full texts</li>
    <li>Verify citations it generates</li>
    <li>Replace critical appraisal judgement</li>
    <li>Guarantee recency without live search</li>
  </ul>
</section>"

"1|3|🧭|The Framework|PICO and the Logic of Evidence|How do you frame a clinical question for AI?|
<section class='s-section'>
  <h2>PICO Structure</h2>
  <ul>
    <li><strong>P</strong> — Population: who are we studying?</li>
    <li><strong>I</strong> — Intervention: what are we testing?</li>
    <li><strong>C</strong> — Comparator: compared to what?</li>
    <li><strong>O</strong> — Outcome: what are we measuring?</li>
  </ul>
</section>
<section class='s-section'>
  <h2>Translating PICO to AI Prompts</h2>
  <ul>
    <li>State the population precisely — no vague terms</li>
    <li>Name the intervention with generic + brand names</li>
    <li>Specify outcomes with measurable endpoints</li>
    <li>Ask for study design filters explicitly</li>
  </ul>
</section>"

"1|4|⚗️|The Protocol|From Question to Search String|How do you build a reproducible search strategy?|
<section class='s-section'>
  <h2>Boolean Logic Basics</h2>
  <ul>
    <li>AND — narrows results (both terms must appear)</li>
    <li>OR — broadens results (either term acceptable)</li>
    <li>NOT — excludes terms</li>
    <li>Parentheses — group terms before operators</li>
    <li>Wildcards — trunk* catches truncate, truncation…</li>
  </ul>
</section>
<section class='s-section'>
  <h2>Building the String</h2>
  <ul>
    <li>Map each PICO element to MeSH terms</li>
    <li>Combine synonyms within each element with OR</li>
    <li>Combine elements with AND</li>
    <li>Test in PubMed — aim for 200–500 results</li>
    <li>Document every decision for reproducibility</li>
  </ul>
</section>"

"1|5|🎯|The Output|Writing the Evidence Brief|How do you structure a policy brief from a literature review?|
<section class='s-section'>
  <h2>Brief Architecture</h2>
  <ul>
    <li>One-paragraph executive summary — decision-ready</li>
    <li>Background — why this question now</li>
    <li>Methods — search strategy, inclusion criteria</li>
    <li>Findings — tabulated, graded evidence</li>
    <li>Recommendations — tiered by certainty</li>
    <li>Limitations — honest, brief</li>
  </ul>
</section>
<section class='s-section'>
  <h2>The AI-Assisted Draft</h2>
  <ul>
    <li>Feed extracted data table to Claude / GPT</li>
    <li>Prompt: synthesize findings, flag contradictions</li>
    <li>Human edits for tone, context, WHO house style</li>
    <li>Supervisor clearance before submission</li>
  </ul>
</section>"

# ── LEVEL 2 · Exploration ──────────────────────────────────────────────────────
"2|1|🌐|Bias in the Machine|When AI Mirrors Our Blindspots|How does training data bias affect AI literature tools?|
<section class='s-section'>
  <h2>Sources of Bias</h2>
  <ul>
    <li>Publication bias — negative trials underrepresented</li>
    <li>Language bias — English-language literature dominates</li>
    <li>Geographic bias — LMIC evidence systematically sparse</li>
    <li>Recency bias — older foundational studies deprioritised</li>
  </ul>
</section>
<section class='s-section'>
  <h2>Mitigation Strategies</h2>
  <ul>
    <li>Supplement AI search with manual grey literature trawl</li>
    <li>Explicitly query non-English databases (LILACS, EMBASE)</li>
    <li>Document and report known gaps in the brief</li>
    <li>Weight evidence by setting relevance, not just quality</li>
  </ul>
</section>"

"2|2|👑|Prompt Engineering|The Craft of Asking Machines Well|What makes a good AI prompt for evidence synthesis?|
<section class='s-section'>
  <h2>Anatomy of a Strong Prompt</h2>
  <ul>
    <li>Role — assign expertise: \"You are a systematic review methodologist\"</li>
    <li>Task — specific deliverable, not vague request</li>
    <li>Context — paste the data; don't assume the AI has it</li>
    <li>Format — specify table, bullet, paragraph, word count</li>
    <li>Constraints — \"do not invent citations\", \"flag uncertainty\"</li>
  </ul>
</section>
<section class='s-section'>
  <h2>Iteration Patterns</h2>
  <ul>
    <li>Chain prompts — build complexity across turns</li>
    <li>Ask for critique of its own output</li>
    <li>Request alternative framings</li>
    <li>Test with known answers before trusting novel ones</li>
  </ul>
</section>"

"2|3|🔭|Critical Appraisal|Reading Studies That Read Back|How do you appraise AI-retrieved evidence?|
<section class='s-section'>
  <h2>GRADE in Brief</h2>
  <ul>
    <li>High — RCT with low risk of bias</li>
    <li>Moderate — RCT with limitations OR observational with strong effect</li>
    <li>Low — observational studies</li>
    <li>Very low — case series, expert opinion</li>
  </ul>
</section>
<section class='s-section'>
  <h2>Risk of Bias Checklist</h2>
  <ul>
    <li>Was randomisation adequate?</li>
    <li>Was allocation concealed?</li>
    <li>Were participants and assessors blinded?</li>
    <li>Was attrition reported and handled?</li>
    <li>Were outcomes pre-specified?</li>
  </ul>
</section>"

"2|4|🩻|Meta-Analysis Basics|When Numbers Can Be Pooled|When is it appropriate to pool evidence statistically?|
<section class='s-section'>
  <h2>Conditions for Pooling</h2>
  <ul>
    <li>Clinical homogeneity — similar populations and interventions</li>
    <li>Methodological homogeneity — comparable designs</li>
    <li>Statistical homogeneity — low I² (&lt; 50% as rough guide)</li>
    <li>Sufficient studies — minimum ~3–5 for meaningful pooling</li>
  </ul>
</section>
<section class='s-section'>
  <h2>Reading a Forest Plot</h2>
  <ul>
    <li>Each row = one study; box size = weight</li>
    <li>Horizontal line = 95% confidence interval</li>
    <li>Diamond = pooled estimate</li>
    <li>Vertical line at 1.0 (RR) or 0 (MD) = line of no effect</li>
    <li>If diamond crosses line → not statistically significant</li>
  </ul>
</section>"

"2|5|👁️|Surveillance Use Cases|AI Watching the Literature|How can AI assist ongoing evidence surveillance?|
<section class='s-section'>
  <h2>Living Reviews</h2>
  <ul>
    <li>Set automated PubMed alerts for key terms</li>
    <li>Use Semantic Scholar citation alerts</li>
    <li>Schedule quarterly AI-assisted rescreening</li>
    <li>Track preprint servers (medRxiv, bioRxiv) for emerging evidence</li>
  </ul>
</section>
<section class='s-section'>
  <h2>Signal vs Noise</h2>
  <ul>
    <li>Volume of output ≠ quality of signal</li>
    <li>Triage by journal quality + citation velocity</li>
    <li>Flag contradictions with existing policy positions</li>
    <li>Escalate immediately if safety signals emerge</li>
  </ul>
</section>"

# ── LEVEL 3 · Integration ──────────────────────────────────────────────────────
"3|1|🧬|Ethics of AI Evidence|When the Algorithm Decides|What are the ethical limits of AI in evidence-based policy?|
<section class='s-section'>
  <h2>Core Ethical Tensions</h2>
  <ul>
    <li>Efficiency vs accountability — who owns an AI-assisted recommendation?</li>
    <li>Automation vs expertise — deskilling risk in junior officers</li>
    <li>Equity vs optimisation — tools built on biased data perpetuate inequity</li>
    <li>Transparency vs proprietary models — black-box outputs in public health</li>
  </ul>
</section>
<section class='s-section'>
  <h2>Institutional Safeguards</h2>
  <ul>
    <li>Human-in-the-loop requirement for all policy recommendations</li>
    <li>Disclosure of AI tool use in methods sections</li>
    <li>Regular audit of AI outputs against gold-standard reviews</li>
    <li>Staff training on limitation literacy, not just tool use</li>
  </ul>
</section>"

"3|2|🏛️|Institutional Integration|Making AI Stick|How do you embed AI tools into existing WHO workflows?|
<section class='s-section'>
  <h2>Change Management Essentials</h2>
  <ul>
    <li>Start with willing early adopters, not mandates</li>
    <li>Pilot on low-stakes reviews first</li>
    <li>Document time saved — make the value visible</li>
    <li>Build internal champions at each seniority level</li>
  </ul>
</section>
<section class='s-section'>
  <h2>SOP Template</h2>
  <ul>
    <li>Step 1: Define question (PICO) — human</li>
    <li>Step 2: AI-assisted search and screening</li>
    <li>Step 3: Human verification of included studies</li>
    <li>Step 4: AI-assisted extraction and synthesis draft</li>
    <li>Step 5: Human critical appraisal and edit</li>
    <li>Step 6: Supervisor clearance — human</li>
  </ul>
</section>"

"3|3|⚡|Rapid Evidence Reviews|Speed Without Sacrificing Rigour|How fast can a credible evidence review be produced with AI?|
<section class='s-section'>
  <h2>The 48-Hour Review</h2>
  <ul>
    <li>Hour 0–2: PICO definition + search string (human)</li>
    <li>Hour 2–6: AI-assisted search + deduplication</li>
    <li>Hour 6–12: AI abstract screening (human spot-check 20%)</li>
    <li>Hour 12–24: Full-text retrieval + AI extraction</li>
    <li>Hour 24–36: AI synthesis draft + human critical edit</li>
    <li>Hour 36–48: Formatting, clearance, submission</li>
  </ul>
</section>
<section class='s-section'>
  <h2>What Gets Sacrificed</h2>
  <ul>
    <li>Grey literature depth</li>
    <li>Non-English sources</li>
    <li>Formal GRADE rating</li>
    <li>Stakeholder consultation</li>
    <li>Must be disclosed in the brief's limitations section</li>
  </ul>
</section>"

"3|4|🌊|Global Evidence Ecosystems|Navigating International Data|How do LMIC contexts fit into global evidence hierarchies?|
<section class='s-section'>
  <h2>The Evidence Hierarchy Problem</h2>
  <ul>
    <li>RCTs from high-income settings dominate GRADE rankings</li>
    <li>Contextual validity often ignored by global guidelines</li>
    <li>Implementation evidence routinely excluded from Cochrane reviews</li>
    <li>Local observational data dismissed despite high relevance</li>
  </ul>
</section>
<section class='s-section'>
  <h2>LMIC-Sensitive Appraisal</h2>
  <ul>
    <li>Weight transferability: was the study population comparable?</li>
    <li>Assess health system capacity assumptions in the evidence</li>
    <li>Supplement global reviews with regional database searches</li>
    <li>Cite local data explicitly in the policy brief</li>
  </ul>
</section>"

"3|5|🔥|Future of Evidence|What Comes After the Current Moment|Where is AI-assisted evidence synthesis heading?|
<section class='s-section'>
  <h2>Near-Term Developments</h2>
  <ul>
    <li>Real-time living systematic reviews — always current</li>
    <li>Multimodal AI — reading figures, tables, supplementary data</li>
    <li>Automated GRADE rating with explainability</li>
    <li>Direct integration with WHO guidelines development platform</li>
  </ul>
</section>
<section class='s-section'>
  <h2>The Enduring Human Role</h2>
  <ul>
    <li>Framing the question — AI cannot define what matters</li>
    <li>Contextual judgement — health systems are not datasets</li>
    <li>Accountability — recommendations have authors</li>
    <li>Ethics — equity must be chosen, not optimised into</li>
  </ul>
</section>"
)

# ── Page template ──────────────────────────────────────────────────────────────
generate_page() {
  local level="$1" session="$2" emoji="$3" title="$4" subtitle="$5" oneliner="$6" body="$7"

  local total_sessions=5
  local prev_session=$(( session - 1 ))
  local next_session=$(( session + 1 ))
  local prev_level=$(( level - 1 ))
  local next_level=$(( level + 1 ))

  # prev/next link logic
  local prev_link="" next_link=""
  if   (( session > 1 ));         then prev_link="session${prev_session}.html"
  elif (( level > 1 ));           then prev_link="../level${prev_level}/session5.html"
  fi
  if   (( session < total_sessions )); then next_link="session${next_session}.html"
  elif (( level < 3 ));                then next_link="../level${next_level}/session1.html"
  fi

  local prev_html="" next_html=""
  [[ -n "$prev_link" ]] && prev_html="<a class='s-nav-btn' href='${prev_link}'>← Previous</a>"
  [[ -n "$next_link" ]] && next_html="<a class='s-nav-btn s-nav-next' href='${next_link}'>Next →</a>"

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
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

  <!-- Ukubona cascade: Variables → Base → Components → Footer -->
  <link href="../../css/variables.css?v=1.1" rel="stylesheet">
  <link href="../../css/head.css?v=1.1" rel="stylesheet">
  <link href="../../css/card.css?v=1.1" rel="stylesheet">
  <link href="../../css/footer.css" rel="stylesheet">

  <!-- Session-level flavor — does not clobber cascade -->
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,600;0,800;1,400&family=Source+Serif+4:ital,opsz,wght@0,8..60,300;0,8..60,400;1,8..60,300&display=swap');

    :root {
      --session-accent: ${ACCENT[$level]};
      --ff-display: 'Playfair Display', Georgia, serif;
      --ff-body:    'Source Serif 4', Georgia, serif;
    }

    body { font-family: var(--ff-body); font-weight: 300; }

    /* scroll progress spine */
    .spine { position: fixed; left: 0; top: 0; width: 3px; height: 0%; background: var(--session-accent); z-index: 200; transition: height .1s linear; }

    /* page wrapper clears fixed header */
    .s-page { padding-top: calc(var(--header-h) + 3rem); padding-bottom: 6rem; max-width: 780px; margin: 0 auto; padding-left: 2rem; padding-right: 2rem; }

    /* breadcrumb */
    .s-crumb {
      font-family: 'Inter', sans-serif;
      font-size: .6rem; letter-spacing: .3em; text-transform: uppercase;
      color: var(--text-secondary); opacity: .5; margin-bottom: 2.5rem;
      display: flex; gap: .75rem; align-items: center;
    }
    .s-crumb span { color: var(--session-accent); opacity: 1; }

    /* hero block */
    .s-hero { margin-bottom: 3.5rem; }
    .s-label {
      font-family: 'Inter', sans-serif;
      font-size: .6rem; letter-spacing: .3em; text-transform: uppercase;
      color: var(--session-accent); margin-bottom: .75rem; font-weight: 600;
    }
    .s-title {
      font-family: var(--ff-display);
      font-size: clamp(2rem, 5vw, 3.2rem);
      font-weight: 800; line-height: 1.1; letter-spacing: -.02em;
      color: var(--text); margin-bottom: .5rem;
    }
    .s-subtitle {
      font-family: var(--ff-display);
      font-size: clamp(1rem, 2.5vw, 1.3rem);
      font-style: italic; font-weight: 400;
      color: var(--text-secondary); margin-bottom: 1.5rem;
    }
    .s-oneliner {
      font-size: .9rem; line-height: 1.7;
      color: var(--text-secondary);
      border-left: 3px solid var(--session-accent);
      padding-left: 1rem;
      max-width: 540px;
    }

    /* session position badge */
    .s-badge {
      display: inline-flex; align-items: center; gap: .5rem;
      font-family: 'Inter', sans-serif;
      font-size: .55rem; letter-spacing: .2em; text-transform: uppercase;
      padding: .3rem .8rem; border-radius: 999px;
      border: 1px solid var(--session-accent);
      color: var(--session-accent);
      background: color-mix(in srgb, var(--session-accent) 8%, transparent);
      margin-bottom: 1.5rem;
    }

    /* content sections */
    .s-section {
      margin-bottom: 3rem;
      padding-bottom: 3rem;
      border-bottom: 1px solid var(--border);
    }
    .s-section:last-of-type { border-bottom: none; }

    .s-section h2 {
      font-family: var(--ff-display);
      font-size: 1.3rem; font-weight: 600;
      color: var(--text); margin-bottom: 1.25rem;
      padding-left: 1rem;
      border-left: 3px solid var(--session-accent);
    }

    .s-section ul {
      list-style: none; padding: 0;
      display: flex; flex-direction: column; gap: .6rem;
    }
    .s-section li {
      padding: .65rem 1rem;
      background: var(--glass);
      border: 1px solid var(--border);
      border-radius: 8px;
      font-size: .95rem;
      color: var(--text-secondary);
      line-height: 1.6;
      transition: var(--transition);
      position: relative;
    }
    .s-section li::before {
      content: '▸';
      color: var(--session-accent);
      margin-right: .6rem;
      font-size: .75rem;
    }
    .s-section li:hover {
      background: color-mix(in srgb, var(--session-accent) 6%, var(--glass));
      border-color: var(--session-accent);
      color: var(--text);
    }
    .s-section li strong { color: var(--text); font-weight: 600; }

    /* prev / next nav */
    .s-nav {
      display: flex; justify-content: space-between; align-items: center;
      margin-top: 4rem; padding-top: 2rem;
      border-top: 1px solid var(--border);
      gap: 1rem;
    }
    .s-nav-btn {
      font-family: 'Inter', sans-serif;
      font-size: .7rem; letter-spacing: .1em; font-weight: 500;
      padding: .6rem 1.4rem; border-radius: 8px;
      border: 1px solid var(--border);
      background: var(--glass); color: var(--text-secondary);
      text-decoration: none; transition: var(--transition);
    }
    .s-nav-btn:hover { border-color: var(--session-accent); color: var(--session-accent); }
    .s-nav-next { margin-left: auto; }

    @media (max-width: 600px) {
      .s-page { padding-left: 1.25rem; padding-right: 1.25rem; }
    }
  </style>
</head>
<body>

<div class="spine" id="spine"></div>
<div class="scroll-indicator" aria-hidden="true"><div class="scroll-progress"></div></div>
<div class="bg-pattern" aria-hidden="true"></div>

<header class="header" id="header"></header>

<div class="s-page">

  <div class="s-crumb">
    <a href="../../" style="color:inherit;text-decoration:none;">Home</a>
    ·
    Level ${level}
    ·
    <span>Session ${session}</span>
  </div>

  <div class="s-hero">
    <div class="s-badge">${emoji} Level ${level} of 3 · Session ${session} of 5</div>
    <p class="s-label">Level ${level} · ${LEVEL_NAME[$level]}</p>
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
  // vertical spine progress bar
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

# ── Accent colors per level ────────────────────────────────────────────────────
declare -A ACCENT=( [1]="#4fc3f7" [2]="#69db7c" [3]="#ffd43b" )
declare -A LEVEL_NAME=( [1]="Foundations" [2]="Exploration" [3]="Integration" )

# ── Stamp out all pages ────────────────────────────────────────────────────────
for entry in "${SESSIONS[@]}"; do
  IFS='|' read -r level session emoji title subtitle oneliner body <<< "$entry"

  dir="$HTML_DIR/level${level}"
  mkdir -p "$dir"
  outfile="$dir/session${session}.html"

  generate_page "$level" "$session" "$emoji" "$title" "$subtitle" "$oneliner" "$body" > "$outfile"
  echo "✅  $outfile"
done

echo ""
echo "Done — 15 session pages written."
echo "CSS paths are relative: ../../css/ and ../../js/ from ukhona/html/level*/"