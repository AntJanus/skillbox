# Feature catalog

Concrete AI features real products shipped, grouped by app category, retrieved 2026-09-22. Use it in
Phase 3: cross each row's "data it needs" with the app's data-shape sheet. A row whose data the app
does not hold is not a candidate. Names are the products' own; the pattern is what transfers.

Tiers: **embedder** (in-process, no daemon) · **small local** (3 to 9 GB daemon model) · **large
local** (17 GB and up, or an OS-level on-device model) · **vision** (image input) · **hosted** ·
**no model** (a heuristic, a parser, statistics).

## Patterns that recur across every category

These eleven shapes account for most of the rows below. Propose the shape first, then pick the row
that matches the app's data.

| Pattern | Shape | Rows that show it |
|---|---|---|
| Reviewable suggestion | Chips or a checklist the user accepts or dismisses; nothing applied on its own | Todoist break-down, Copilot categorization, Jetpack excerpt, tag suggestions |
| Low confidence shows the alternatives | Below a threshold, the top two guesses render as buttons instead of one silent pick | Copilot Money categorization |
| Rules learned from corrections, no model | A correction becomes a rule so the model is never asked twice | Lunch Money auto-rules |
| Photo or paste becomes a prefilled form | Extraction lands in the app's own edit form; the user saves | Crouton recipe photo, MacroFactor plate photo, Expensify SmartScan, Scanlily inventory |
| Summary with links back | Every sentence or chapter carries a source row or timestamp | Strava activity summary, Snipd chapters, Notion Q&A, Kindle recaps |
| Natural language becomes structure the user can edit | Dates, filters, queries and events are parsed and shown as editable fields | Fantastical, Things, Todoist dates, Honeycomb query assistant |
| Background job with progress | Captioning, transcribing, indexing runs as a job on a jobs screen | Excire keywording, Pocket Casts transcripts, Cloudinary alt text |
| On-device by default, send only on an explicit action | Text leaves the machine only when the user picks the hosted action | Ulysses Writing Tools, Ente magic search, Apple Photos search |
| Provenance is visible | AI-written text is marked and fades as the user rewrites it; AI content is disclosed | iA Writer authorship, Steam disclosure, Copilot's badge |
| Explain after the fact | A verdict the app already computes gets a one-sentence reason on demand | Chess.com coach, Duolingo explain my answer, Wordle Bot |
| Related items pane | A side list of similar records while the user reads or writes | Smart Connections, Plex match score, Immich duplicates |

## Notes and knowledge

| Feature | What the user sees | Data it needs | Tier | Shipped by |
|---|---|---|---|---|
| Related notes pane | While writing, a side pane lists semantically related notes and excerpts ranked by similarity | Note bodies chunked to blocks, a local embedding index | embedder | [Smart Connections](https://github.com/brianpetro/obsidian-smart-connections) |
| Vault Q&A | A question answered from the whole collection, with links to the pages it came from | Page bodies, an embedding index, per-user permissions | hosted | [Notion Q&A](https://www.notion.com/help/guides/get-answers-about-content-faster-with-q-and-a) · [Obsidian Copilot](https://github.com/logancyang/obsidian-copilot) |
| Autofill column | A database column fills itself per row (summary, key facts, translation) from that row's body | Row body, the column's prompt | hosted | [Notion Autofill](https://www.notion.com/help/autofill) |
| Meeting notes block | Records, transcribes live, and produces a summary beside the user's own typed notes | Audio, transcript, typed notes | hosted | [Notion Meeting Notes](https://www.notion.com/help/ai-meeting-notes) |
| Recording to transcript to summary | A recording inside a note becomes a searchable transcript with a one-tap summary | Audio, on-device transcript | small local | [Apple Notes](https://support.apple.com/guide/iphone/record-and-transcribe-audio-iphbe11247b5/ios) |
| Inline math | Typing `=` after an expression shows the answer inline; variables and graphs update live | Note text, a symbolic evaluator | no model | [Apple Notes Math](https://support.apple.com/guide/notes/solve-math-apda85974595/mac) |
| Voice memo to typed fields | A spoken memo becomes a node whose typed fields (tasks, decisions) are filled from the transcript | Audio, transcript, the field schema | hosted | [Tana](https://tana.inc/docs/mobile-voice-memos) |
| Audio overview | A generated two-host discussion, or a short single-voice brief, of the user's sources | Source documents, TTS | hosted | [NotebookLM](https://support.google.com/notebooklm/answer/16212820) |
| Mind map of sources | An interactive concept map; clicking a branch drills into it | Source text, extracted hierarchy | hosted | [NotebookLM](https://workspaceupdates.googleblog.com/2025/03/new-features-available-in-notebooklm.html) |

## Photos and video libraries

| Feature | What the user sees | Data it needs | Tier | Shipped by |
|---|---|---|---|---|
| Natural-language photo search | "Maya skateboarding in a tie-dye shirt" returns photos and the moment inside a video | Frame pixels, on-device image embeddings, person names | embedder | [Apple Photos](https://support.apple.com/guide/mac-help/use-apple-intelligence-in-photos-mchl35c53342/15.0/mac/15.0) · [Immich smart search](https://docs.immich.app/features/searching/) · [Ente magic search](https://ente.com/help/photos/features/search-and-discovery/magic-search) |
| Ask your library | A conversational question ("what did I eat in Barcelona?") returns photos plus a written answer | Pixels, EXIF, face and place clusters, a library index | hosted | [Google Photos](https://support.google.com/photos/answer/15318661?hl=en) |
| Review duplicates | Groups of visually similar assets with keep, trash or stack actions | Embeddings from the search index, file size, metadata | embedder | [Immich](https://docs.immich.app/features/duplicates-utility/) |
| Face clustering into people | Unnamed clusters the user names once; all their photos collect under that person | Face crops, face embeddings, clustering | vision | [PhotoPrism](https://docs.photoprism.app/developer-guide/vision/face-recognition/) |
| Automatic keywording | Every imported photo comes back tagged with content keywords that are then searchable | Pixels, a tag vocabulary, keywords written to the catalog | vision | [Excire](https://excire.com/en/photo-keywording/) |
| Best take | Tap a face in a group shot and swap in that person's expression from a nearby frame | Burst frames, face alignment | vision | [Google Photos](https://support.google.com/pixelcamera/answer/9940184) |
| Clean up | Brush over a bystander or a wire and it is erased with the background filled in | Pixels, a brush mask | vision | [Apple Photos](https://support.apple.com/guide/mac-help/use-apple-intelligence-in-photos-mchl35c53342/15.0/mac/15.0) · [Lightroom](https://helpx.adobe.com/lightroom/desktop/using/generative-remove-faq.html) |
| Memory movie from a prompt | Describe the movie you want; get a chaptered video of selected photos and clips with music | Pixels, embeddings, dates, places, faces | hosted | [Apple Photos](https://www.apple.com/newsroom/2024/10/apple-intelligence-is-available-today-on-iphone-ipad-and-mac/) |

## Personal finance and budgeting

| Feature | What the user sees | Data it needs | Tier | Shipped by |
|---|---|---|---|---|
| Auto-categorization with a confidence badge | A transaction arrives categorized with a badge, or shows the top two guesses to tap when confidence is low | Merchant, amount, weekday, card, the user's past corrections (about 30 reviewed rows to start) | embedder | [Copilot Money](https://help.copilot.money/en/articles/8182433-copilot-intelligence-for-spending) |
| Rules from corrections | Recategorizing a transaction silently creates a match rule for that payee | Payee string, chosen category, rule set | no model | [Lunch Money](https://support.lunchmoney.app/setup/categories/auto-categorization) |
| Receipt to expense | Photograph a receipt; merchant, date, total and currency are filled in | Receipt image | vision | [Expensify SmartScan](https://help.expensify.com/articles/new-expensify/reports-and-expenses/Troubleshoot-SmartScan-Issues) · [Wave](https://support.waveapps.com/hc/en-us/articles/360059848112-Scan-and-upload-your-receipts) |
| Receipt attach and line-item split | A receipt attaches to its transaction and one charge splits into groceries, household, electronics | Receipt image, posted transactions, category tree | vision | [Monarch](https://www.monarch.com/blog/winter-release) |
| Receipt audit | Typed amount, merchant or date that disagree with the receipt image get flagged with a question | OCR output, the typed fields | vision | [Expensify Concierge](https://docs.expensify.com/using-expensify-day-to-day/concierge-receipt-audit) |
| Ask about your money | "Why did my net worth change this month?" answered from the user's own accounts | Balances, transactions, categories, net worth history | hosted | [Monarch](https://www.monarch.com/blog/winter-release) |
| Bulk categorizer on a local model | A job fills the category on every uncategorized transaction and proposes new categories | Description, amount, notes, category list | small local | [actual-ai](https://github.com/sakowicz/actual-ai) |
| Subscription agent over text | A text says a subscription is worth cancelling; a plain-English reply cancels or negotiates it | Transactions, recurring-charge detection, bill records | hosted | [Rocket Money Rowan](https://www.rocketcompanies.com/press-release/rocket-moneys-rowan-rewrites-what-ai-can-do-in-personal-finance/) |

## Media and reading trackers

| Feature | What the user sees | Data it needs | Tier | Shipped by |
|---|---|---|---|---|
| Match score | A predicted personal enjoyment score on each title while browsing | Ratings, watch history, watchlist, title metadata | embedder | [Plex](https://www.prnewswire.com/news-releases/plex-introduces-a-social-platform-for-entertainment-discovery-across-streaming-services-302789816.html) |
| Automatic chapters | A chaptered progress bar and named sections on media nobody timestamped | Transcript or audio, topic boundaries | embedder | [YouTube](https://support.google.com/youtube/answer/9884579) |
| Generated transcripts | A searchable transcript for an episode the publisher never transcribed | Episode audio; publisher transcript when present | small local | [Pocket Casts](https://blog.pocketcasts.com/2025/04/29/generated-transcripts-are-here/) |
| Chapters with summaries you can query | Named chapters with per-chapter summaries, and a chat over the summary to pull quotes | Transcript, chapter boundaries, highlight positions | hosted | [Snipd](https://www.snipd.com/blog/ai-podcast-summaries-you-can-chat-with) |
| Series recap | A spoiler-free summary of prior books up to where the reader stopped | Prior volumes' text, the reader's furthest position | hosted | [Kindle Recaps](https://www.aboutamazon.com/news/books-and-authors/kindle-recaps-feature-ebook-series-refreshers) |
| Auto-summary and saved prompts | A saved article arrives carrying a summary; the reader runs their own saved prompt over a document, paragraph or highlight | Full text, highlights, notes, prompt templates | hosted | [Readwise Ghostreader](https://docs.readwise.io/reader/guides/ghostreader/overview) |
| Prompted playlist | A mood, memory or aesthetic in free text becomes a playlist that can refresh weekly | Prompt, listening history, catalog metadata | hosted | [Spotify](https://newsroom.spotify.com/2026-01-22/prompted-playlists-expansion/) |
| Narrated commentary | A synthetic voice introduces each run of songs with why it picked them | Listening history, taste profile, track metadata | hosted | [Spotify DJ](https://newsroom.spotify.com/2026-05-07/dj-expansion-4-new-languages/) |
| Ask about what is playing | A question about the current video answered without leaving playback | Transcript, metadata | hosted | [YouTube Ask](https://techcrunch.com/2026/02/19/youtubes-latest-experiment-brings-its-conversational-ai-tool-to-tvs/) |

## Tasks, habits and calendar

| Feature | What the user sees | Data it needs | Tier | Shipped by |
|---|---|---|---|---|
| Natural-language dates | "every 3rd Tuesday starting Aug 29" highlights inline and becomes a real due date | Input string, locale, timezone, week start | no model | [Todoist](https://www.todoist.com/help/articles/use-task-quick-add-in-todoist-va4Lhpzz) · [Things](https://culturedcode.com/things/support/articles/9780167/) · [TickTick](https://help.ticktick.com/articles/7055782422935240704) |
| Natural-language events | "Lunch with Josh at Joe's 1:30 Monday /Work" becomes an event with location, invitee and calendar | Input string, contacts, calendar names, current date | no model | [Fantastical](https://flexibits.com/fantastical/help/adding-events-and-tasks) |
| Break a task down | A button on a vague task returns a reviewable checklist of sub-tasks to accept or deselect | Task title, project, sibling tasks | hosted | [Todoist Task Assist](https://www.todoist.com/help/articles/use-the-task-assist-extension-with-todoist-ZgldtcPeT) |
| Create, split and file from one instruction | One sentence creates tasks, splits a project into steps, and files them with tags and priority | Lists, tags, projects, the instruction or a voice transcript | hosted | [TickTick AI](https://help.ticktick.com/articles/7475477082185662464) |
| Flexible routines | "Gym 3x a week, mornings" books calendar blocks and moves them when meetings appear | Calendar, working hours, habit window, priority | no model | [Reclaim](https://help.reclaim.ai/en/articles/4129152-overview-how-to-use-reclaim-habits-to-get-time-for-your-routines) · [Motion](https://www.usemotion.com/help/time-management/auto-scheduling) |
| Guided daily planning | A chat walks the user through picking today's tasks and reorders them as asked | Tasks, backlog, calendar, objectives | hosted | [Sunsama](https://help.sunsama.com/docs/usage-guides/sunny/) |
| Propose meeting times into a draft | While replying about meeting up, a button inserts free slots into the reply | Thread text, free/busy for everyone | hosted | [Google Calendar](https://support.google.com/calendar/answer/16865189) |
| Inbox triage as grouped actions | "Organize my inbox" returns grouped one-click actions: archive, label, delete, make a todo | Threads, sender history, labels | hosted | [Shortwave](https://www.shortwave.com/docs/guides/ai-assistant/) |

## Household, health and personal CRM

| Feature | What the user sees | Data it needs | Tier | Shipped by |
|---|---|---|---|---|
| Recipe from a photo | Photograph a cookbook page; a structured recipe with ingredients and steps appears | Page photo | vision | [Crouton](https://apps.apple.com/us/app/crouton-recipe-manager/id1461650987) |
| Recipe from a page or a video link | A URL becomes an editable recipe card; works from cooking-video descriptions too | Page markup or video description | no model | [Paprika](https://www.paprikaapp.com/help/ios/) · [Mela](https://www.macstories.net/reviews/mela-1-6-adds-web-search-engine-and-recipe-import-from-youtube-instagram-and-tiktok-videos/) |
| Rewrite a recipe for a diet | One tap converts a saved recipe to vegan or another style, rewriting ingredients and steps | Recipe body, dietary preferences | hosted | [Samsung Food](https://news.samsung.com/uk/samsung-announces-global-launch-of-samsung-food-an-ai-powered-personalised-food-and-recipe-service) |
| Inventory item from a photo | Photograph an item; description, fields and a category are drafted | Item photo, the field schema | vision | [Scanlily](https://www.scanlily.com/en/features/AI_Image_Recognition) |
| Plate photo to food log | Photograph a plate, add "only ate half", land in an editable log entry | Meal photo, optional text, the food database | vision | [MacroFactor](https://help.macrofactorapp.com/en/articles/258-ai-food-logging) |
| Activity summary | Right after a workout, a plain-language summary of the effort against recent training | Activity streams, recent history | hosted | [Strava](https://support.strava.com/hc/en-us/articles/26786795557005-Athlete-Intelligence-on-Strava) |
| Live coaching voice | Mid-run, a generated voice reads pace, splits and milestones like "your fastest mile this week" | Live metrics, fitness history | small local | [Apple Watch Workout Buddy](https://support.apple.com/guide/watch/use-workout-buddy-apd65c7938e6/watchos) |
| Coach grounded in your numbers | "How should I train today?" answered from recovery, sleep and strain history, remembering prior chats | Biometrics history, goals, journal, prior conversations | hosted | [WHOOP](https://www.whoop.com/us/en/thelocker/whoop-unveils-the-new-whoop-coach-powered-by-openai/) · [Oura Advisor](https://ouraring.com/blog/oura-advisor/) |
| Network navigator | A question about your contacts returns reasons to reconnect, intro suggestions and outreach drafts | Contacts, interaction recency, bios | hosted | [Clay](https://library.me.sh/2026/01/12/introducing-nexus-4-0-and-an-exclusive-invitation/) |

## Writing, blogs and CMS

| Feature | What the user sees | Data it needs | Tier | Shipped by |
|---|---|---|---|---|
| Excerpt generation | A button fills the excerpt field from the draft, with length, tone and language controls | Post body | hosted | [Jetpack AI](https://jetpack.com/support/create-better-content-with-jetpack-ai/) |
| Alt text and captions | Select an image and get alt text and a caption written in the context of the surrounding post | Image, surrounding text | vision | [Jetpack AI](https://jetpack.com/support/create-better-content-with-jetpack-ai/) · [Cloudinary](https://cloudinary.com/documentation/mediaflows_multilingual_alt_text_powerflow) · [Firefox PDF](https://support.mozilla.org/en-US/kb/pdf-alt-text) |
| Rewrite in place | Select a paragraph, pick "make longer", "change tone" or a language; the block is replaced | Selected text, chosen transform | hosted | [Jetpack AI block](https://jetpack.com/support/jetpack-blocks/jetpack-ai-assistant-block/) |
| Proofread, rewrite, summarize on device | Highlight a passage; text leaves the device only on that explicit action | Selected text | large local | [Ulysses](https://help.ulysses.app/en_US/dive-into-editing/writing-tools) · [Apple Writing Tools](https://support.apple.com/guide/iphone/use-writing-tools-iphd0f3a9494/ios) |
| Tone indicator | A panel names the perceived tone of the draft as the user types | Draft text | small local | [Grammarly tone](https://www.grammarly.com/tone) |
| Fix this sentence | A flagged wordy sentence gets a rewrite with before-and-after reading grade and "another suggestion" | The sentence, readability scores | hosted | [Hemingway Plus](https://hemingwayapp.com/help/docs/rewriting-text-with-ai-tools) |
| Authorship marking | Pasted AI text renders with a gradient that fades as the user rewrites it in their own words | Clipboard provenance, per-range authorship metadata | no model | [iA Writer](https://ia.net/writer/support/editor/authorship) |
| Product description draft | A short prompt with features and tone drafts a full description into the field | Title, features, tone | hosted | [Shopify Magic](https://help.shopify.com/en/manual/products/details/product-descriptions/shopify-magic) |

## OS-level and browser, on device

| Feature | What the user sees | Data it needs | Tier | Shipped by |
|---|---|---|---|---|
| Mail summaries, priority and smart reply | One-line summaries replace preview text, urgent mail pins to the top, tappable replies answer the questions found in the message | Message bodies, thread history | large local | [Apple Mail](https://www.macrumors.com/guide/apple-intelligence-smart-replies-summaries/) |
| Live translation | Messages arrive translated; calls get a running translated transcript, all on device | Audio or text, language pair | large local | [Apple](https://support.apple.com/en-us/123720) · [Windows Live Captions](https://support.microsoft.com/en-us/accessibility/windows/use-live-captions-to-better-understand-audio) |
| Search your past screens | A natural-language description finds a past screenshot of activity; opt-in after a privacy backlash and a delayed relaunch | Periodic screenshots, OCR, window titles, a local index | embedder | [Windows Recall](https://support.microsoft.com/en-us/windows/ai/ai-features/retrace-your-steps-with-recall) |
| Tab groups and history in plain words | "Organize similar tabs" names and groups them; "that fancy restaurant I looked at last week" finds the page | Tab titles, history, page content | embedder | [Chrome](https://blog.google/products-and-platforms/products/chrome/google-chrome-ai-features-august-2024-update/) |
| In-browser summarizer API | A page calls a browser API and shows a key-points summary with nothing sent to a server | Page text; the model downloads on first use | small local | [Chrome Summarizer API](https://developer.chrome.com/docs/ai/summarizer-api) |
| Link preview and tidy tabs | Hover a link for a short summary of the destination; a broom groups the day's tabs. Two sibling features were later removed | Target page, tab titles | hosted | [Arc Max](https://resources.arc.net/hc/en-us/articles/19335160678679-Arc-Max-Boost-Your-Browsing-with-AI) |
| Call notes | After a call, a transcript and a short summary of what was agreed, announced to both parties | Call audio, contact | large local | [Pixel](https://support.google.com/phoneapp/answer/15257579) |
| Camera and mic effects | Auto-framing, eye contact, background blur and voice focus applied to every app's call | Live frames and audio | vision | [Windows Studio Effects](https://support.microsoft.com/en-US/Windows/ai/ai-features/windows-studio-effects) |

## Developer, CLI and terminal tools

| Feature | What the user sees | Data it needs | Tier | Shipped by |
|---|---|---|---|---|
| Suggest and explain a command | Ask for a command in English and get a runnable one; paste a cryptic command and get each flag explained | The question or command, shell type | hosted | [gh copilot](https://github.com/github/gh-copilot) · [Amazon Q translate](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-conversation.html) |
| Search across history, saved commands and past sessions | One fuzzy-search panel with source filters | Local history, saved workflows, transcripts | embedder | [Warp](https://docs.warp.dev/terminal/entry/command-search/) |
| Goal instead of a command | A plain-English goal runs a multi-step plan, reads output, retries after its own errors | Session context, output, exit codes, help text | hosted | [Warp Agent Mode](https://docs.warp.dev/agents/local-agents/interacting-with-agents/terminal-and-agent-modes/) |
| Saved prompts over any selection | Select text anywhere and fire a saved prompt; the rewrite lands in place | Selection, prompt template | hosted | [Raycast AI Commands](https://manual.raycast.com/ai/ai-commands) |
| Local next-edit prediction | A greyed multi-line diff of the likely next edit; tab accepts, tab again jumps to the next site | Buffer, recent edits, diagnostics | small local | [Zed](https://zed.dev/docs/ai/edit-prediction) · [JetBrains full line](https://www.jetbrains.com/help/idea/full-line-code-completion.html) |
| Commit message from the staged diff | A drafted message, editable before committing, following house conventions | Staged diff, custom instructions | hosted | [GitLens](https://help.gitkraken.com/gitlens/gl-gk-ai/) |
| Root cause from a crash | A walkthrough of the likely cause on an issue, with a PR offered | Stack trace, traces, logs, source | hosted | [Sentry Seer](https://docs.sentry.io/product/ai-in-sentry/seer/root-cause-analysis/) |
| Query assistant | "Slowest endpoints for customer X yesterday" becomes a real, editable query in the builder | Dataset schema, recent queries | hosted | [Honeycomb](https://www.honeycomb.io/blog/introducing-query-assistant) |

## Games and hobby apps

| Feature | What the user sees | Data it needs | Tier | Shipped by |
|---|---|---|---|---|
| Move classification | Every move labelled brilliant to blunder, with per-phase grades | Game record, engine evaluation | no model | [Chess.com Game Review](https://support.chess.com/en/articles/8584089-how-does-game-review-work) |
| Coach explanation on demand | Click a flagged move and read one sentence on why, with arrows drawn as you hover | Position, engine lines, the classification | hosted | [Chess.com Coach](https://www.chess.com/news/view/chesscom-launches-game-review-v2) |
| Learn from your mistakes | Replay only the positions you got wrong and find the better move yourself | Moves, evaluations, a masters database to suppress false positives | no model | [Lichess](https://lichess.org/@/lichess/blog/learn-from-your-mistakes/WFvLpiQA) |
| Explain my answer | After a wrong answer, a chat explains the rule | The exercise, the correct and submitted answers | hosted | [Duolingo](https://www.duolingo.com/help/what-is-duolingo-max) |
| Post-puzzle bot | Each guess scored against optimal play with how many candidates it eliminated | The answer, the candidate list, the guess sequence | no model | [NYT Wordle Bot](https://play.google.com/store/apps/details?id=com.nytimes.crossword) |
| Usage-based team builder | Add a unit to a slot and see the most-used moves, items and partners with speed tiers | Aggregated ladder and tournament data | no model | [Pikalytics](https://www.pikalytics.com/team) |
| NPCs that decide | Townspeople make their own decisions and react in character to nearby events | Personality traits, goals, world state | small local | [inZOI Smart Zoi](https://www.nvidia.com/en-us/geforce/news/nvidia-ace-naraka-bladepoint-inzoi-launch-this-month/) |
| Free-form persuasion | Talk (speech or text) an NPC into something with no dialogue tree | Speech-to-text, persona, disposition, history | hosted | [Suck Up!](https://themagicrain.com/2024/04/suck-up-is-a-vampire-game-that-uses-a-i-to-interact-with-its-players/) |
| Mesh from a prompt | "A rusty mailbox" returns a usable 3D mesh in seconds | The prompt | vision | [Roblox Cube](https://devforum.roblox.com/t/beta-cube-3d-generation-tools-and-apis-for-creators/3558947) |
| AI content disclosure | A labelled block on the store page states whether the game contains generated content | Developer survey, per-asset tags | no model | [Steam](https://www.gamedeveloper.com/business/valve-tweaks-and-clarifies-ai-disclosure-rules-for-steam) |

## Small features users praise

Low-risk, narrow, and repeatedly singled out in reviews as the AI that fixed a chore rather than
adding a chat box.

| Feature | Why it lands | Shipped by |
|---|---|---|
| Rename downloaded files from their contents, with one-click undo | Fixes `document(3).pdf` without being asked; undo makes a wrong rename free | [Arc Max Tidy Downloads](https://resources.arc.net/hc/en-us/articles/19335160678679-Arc-Max-Boost-Your-Browsing-with-AI) (later removed when the browser went into maintenance) |
| Alt text drafted where the omission happens | Sits in the image block or the PDF editor, editable before save, on device in Firefox's case | [Jetpack AI](https://jetpack.com/support/generate-alt-text-and-captions-with-ai-in-the-editor/) · [Firefox](https://hacks.mozilla.org/2024/05/experimenting-with-local-alt-text-generation-in-firefox-nightly/) |
| Transcript under every recording, automatically | The feature voice memos always lacked; searchable, on device, free | [Apple Notes and Voice Memos](https://www.macrumors.com/how-to/ios-record-audio-transcribe-notes-app/) |
| Speaker labels on a recording | Turns a wall of transcript into a readable conversation; the user names each speaker once | [Pixel Recorder](https://www.androidauthority.com/google-pixel-recorder-speaker-labels-tech-3251520/) |
| A few bullets for any recording length | On-device; the vendor reported a 24% engagement lift in the app after shipping it | [Pixel Recorder summaries](https://android-developers.googleblog.com/2024/08/recorder-app-on-pixel-sees-boost-in-engagement-with-gemini-nano.html) |
| Screenshots indexed and searchable | Title, summary, prices and addresses extracted from every screenshot; a reviewer loaded 1,800 and recall held up | [Pixel Screenshots](https://www.androidauthority.com/pixel-screenshots-review-3476772/) |
| User-authored prompts with document variables | Defaults (summarize, define, translate) plus the user's own templates; the community shares a prompt library | [Readwise Ghostreader](https://docs.readwise.io/reader/guides/ghostreader/custom-prompts) |
| Save the last 30 seconds by tapping a headphone | A physical gesture becomes a summarized highlight exported to the user's notes | [Snipd](https://www.tapsmart.com/apps/review-snipd/) |
| Anything on screen becomes selectable and actionable | Hold a key, click, then summarize or rewrite via the local model | [Windows Click to Do](https://www.pcworld.com/article/2910874/what-is-click-to-do-meet-microsofts-next-ai-headliner-for-windows-pcs.html) |
| Remove an unwanted object with a tap | Likely distractions are highlighted first; hands-on comparisons rated it above the competition on clean backgrounds | [Apple Photos Clean Up](https://www.androidpolice.com/clean-up-ios-18-vs-magic-eraser/) |
| Ask from the launcher bar | No separate window; the least-friction way to reach a model on a desktop | [Raycast Quick AI](https://www.raycast.com/pro) |

## Features users pushed back on, and the rule each one teaches

| What shipped | What happened | Rule for the skill |
|---|---|---|
| [Windows Recall](https://www.theregister.com/2024/06/07/microsoft_recall_changes): constant screenshots into a user-readable database with passwords unredacted | Made opt-in, encrypted, pulled from preview, delayed repeatedly | Anything that indexes everything is opt-in, encrypted at rest, and excludes secrets by default |
| [Apple notification summaries](https://9to5mac.com/2025/01/16/ios-18-3-temporarily-disables-apple-intelligence-notification-summaries-for-select-apps-more/): fabricated headlines attributed to a news outlet | Disabled for news apps; summaries italicised to mark them as AI; per-app off switch | Summaries of other people's words carry a visible AI mark and a per-source off switch |
| [Google AI Overviews](https://www.forbes.com/sites/roberthart/2024/05/31/google-restricts-ai-search-tool-after-nonsensical-answers-told-people-to-eat-rocks-and-put-glue-on-pizza/): glue on pizza, a rock a day, from joke sources | Scaled back for some query classes | A generated answer over retrieved text shows its sources beside each claim, and low-quality sources are excluded before generation |
| [Meta AI in the search bar](https://www.nbcnews.com/tech/tech-news/meta-putting-ai-front-center-apps-users-are-annoyed-rcna148857/) and the [WhatsApp blue circle](https://www.forbes.com/sites/kateoflahertyuk/2025/04/01/whatsapps-new-blue-circle-what-it-is-and-why-you-cant-turn-it-off/): no way to turn it off, generated text in front of search | Sustained complaints; the assistant gave wrong instructions for disabling itself | Never front a working feature with AI, and every AI surface has an off switch in settings |
| [LinkedIn AI post enhancement](https://techcrunch.com/2026/07/30/linkedin-adds-a-button-to-report-ai-generated-slop/): a flood of generated posts and comments | Feature removed; a "seems like AI slop" report button shipped and flagged content lost about 40% of views | Generation that publishes under the user's name is generate-then-edit with provenance, never one-click post |
| [Slack](https://techcrunch.com/2024/05/17/slack-under-attack-over-sneaky-ai-training-policy/) and [Adobe](https://blog.adobe.com/en/publish/2024/06/10/updating-adobes-terms-of-use): terms read as consent to train on customer content | Public clarifications and rewritten terms | State in the settings screen where data goes and whether it is retained; local by default for personal records |
| [Microsoft 365 Copilot bundling](https://www.theregister.com/software/2026/07/29/microsoft_faces_competition_probe_over_copilot_subscription_price_hike/5280474): price rise with the opt-out plan hidden behind cancellation | Regulator investigation and a lawsuit | A hosted feature's cost is visible before it runs, with a cap the user sets |
| [Spotify AI DJ](https://community.spotify.com/t5/Live-Ideas/Remove-the-DJ-AI-or-at-least-give-the-option-to-turn-it-off/idi-p/7328994): spoken commentary users cannot silence | The most-requested removal on the community forum | A voice or narration layer is separable from the feature it decorates |
| [Firefox AI sidebar](https://support.mozilla.org/en-US/kb/firefox-ai-controls): additions read as undercutting the product's simplicity | A single "block AI enhancements" toggle that also suppresses promotional prompts | One global switch that also silences upsell for the feature |
| [Audible AI narration](https://techcrunch.com/2025/05/13/audible-is-expanding-its-ai-narrated-audiobook-library/): synthetic narrators replacing performers | Objections from narrators and a writers' guild; listener willingness fell | Generated media is labelled as such where it is consumed |
