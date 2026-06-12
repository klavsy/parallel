### Parallel Universe (Creative App)

Explore the lives you didn't live. Enter who you are, what you love, and the big decision you're facing -an AI generates three alternate-universe versions of your life (bold, balanced, cautionary), each with a story,career path, key milestones, an outcome and actionable next steps: real job roles on LinkedIn, travel ideas on Bing Maps, and food to try - all in your native language,narrated aloud by Azure Speech AI.

This transforms decision-making into an engaging, reflective, and imaginative experience - allowing users to explore the question:

“What if I chose differently?”


### Features


🌌 3 AI-generated parallel universes tailored to the user's name, interests, situation, and decision - switchable between Gemma 4 31B (Hugging Face Inference Providers) and Azure AI Foundry (gpt-4o-mini) via one env var.

🌍 36 European languages - full UI translation and AI output in the selected language (incl. Latvian, Maltese, Welsh, Icelandic…)
🔊 Voice narration of every universe with Azure AI Speech neural voices (36 voices mapped).

💼 Tailored job roles per universe → one tap opens live LinkedIn job search results.

✈️🍽️ Travel & food recommendations → deep links to Bing Maps.

📅 Outlook Calendar - turn any universe milestone into a real scheduled goal (deep link, no API key).

📤💾 Shareable image cards - 1080×1350 PNG rendered on canvas, native share sheet (Instagram/Facebook/LinkedIn) on mobile, direct download on desktop.

🎯 Reality-check score per universe - a 0-100 feasibility estimate grounded by Foundry IQ: the backend retrieves facts from an Azure AI Search knowledge base (agentic retrieval) and the model calibrates each score against them; rendered as an animated gradient bar, honestly labeled as an AI estimate.

🗺️ Embedded mini-maps (Azure Maps) - travel destinations geocoded precisely and real restaurants pinpointed near the user's location; tap a map for a detail modal with Bing Maps and menu links.

📊 Microsoft Clarity analytics (heatmaps, session recordings).

📱 Fully responsive: phones → tablets → desktops → 4K TVs; safe-area aware (iPhone notch), prefers-reduced-motion respected.

🎨 Toggleable ambient animated background (preference persisted).

### 🧠 Powered By:


- HTML5
- CSS3
- JavaScript
- Node.js
- Express
- Hugging Face
- Gemma 3
- Bing Maps
- LinkedIn (share button)
- Vercel
- Render
- GitHub
- GitHub Copilot
- Microsoft Clarity (analytics)
- Azure Maps
- Azure AI Speech (text-to-voice narration)
- Azure AI Foundry
- Outlook calendar

### 🔗 Explore the Project

🌐 Website: https://www.parallia.xyz/

🌐 GitHub (frontend): https://github.com/klavsy/parallel/

🌐 GitHub (backend): https://github.com/klavsy/parallel-backend/
