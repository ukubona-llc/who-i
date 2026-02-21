/**
 * shared.js
 * Handles: Header/Footer Injection, Grid Menu, Theme Toggle, Scroll Progress, Footer Chorus
 */

document.addEventListener('DOMContentLoaded', async () => {
    'use strict';

    // --- PATH RESOLUTION ---
    // Figures out where header.html / footer.html live relative to the current page.
    // Three cases:
    //   /ukhona/html/level1/session1.html  → ../../html/
    //   /ukhona/html/someother.html        → ../html/
    //   /index.html (root)                 → ukhona/html/
    const getPath = (filename) => {
        const path = window.location.pathname;
        if (/\/ukhona\/html\/level\d\//.test(path)) return `../../html/${filename}`;
        if (path.includes('/ukhona/html/'))          return `../html/${filename}`;
        return `ukhona/html/${filename}`;
    };

    const REPO_NAME = '/repos-00';
    const BASE = window.location.pathname.startsWith(REPO_NAME) ? REPO_NAME : '';

    const fixLinks = (container) => {
        if (!container || !BASE) return;
        container.querySelectorAll('a[href^="/"]').forEach(a => {
            const href = a.getAttribute('href');
            if (!href.startsWith(BASE)) a.setAttribute('href', `${BASE}${href}`);
        });
    };

    // --- INJECTION ENGINE ---
    async function inject(id, filename) {
        const placeholder = document.getElementById(id);
        if (!placeholder) { console.error(`[shared] #${id} not found`); return; }
        try {
            const res = await fetch(getPath(filename));
            if (!res.ok) throw new Error(`HTTP ${res.status}`);
            placeholder.innerHTML = await res.text();
            fixLinks(placeholder);

            // Re-run any inline <script> tags injected with the fragment
            placeholder.querySelectorAll('script').forEach(old => {
                const s = document.createElement('script');
                if (old.src) s.src = old.src; else s.textContent = old.textContent;
                old.replaceWith(s);
            });

            console.log(`[shared] ✓ ${filename}`);
        } catch (err) {
            console.error(`[shared] ✗ ${filename}`, err);
            placeholder.innerHTML = `<div style="color:red;padding:1rem;font-family:monospace;font-size:.8rem;">Failed to load ${filename}<br>${err.message}</div>`;
        }
    }

    // --- LOAD PARTIALS ---
    await Promise.all([
        inject('header',             'header.html'),
        inject('footer-placeholder', 'footer.html'),
    ]);

    // --- INIT ---
    initGridMenu();
    initThemeToggle();
    initScrollProgress();
    initFooterChorus();

    // --- GRID MENU ---
    function initGridMenu() {
        const menuBtn  = document.getElementById('menuIcon');
        const menuGrid = document.getElementById('gridMenu');
        if (!menuBtn || !menuGrid) return;

        fixLinks(menuGrid);
        let open = false;

        const toggle = (force) => {
            open = force !== undefined ? force : !open;
            menuGrid.classList.toggle('active', open);
            menuBtn.setAttribute('aria-expanded', String(open));
        };

        menuBtn.addEventListener('click', e => { e.stopPropagation(); toggle(); });
        document.addEventListener('click', e => {
            if (open && !menuGrid.contains(e.target) && !menuBtn.contains(e.target)) toggle(false);
        }, true);
        document.addEventListener('keydown', e => { if (e.key === 'Escape') toggle(false); });
    }

    // --- THEME TOGGLE ---
    function initThemeToggle() {
        const btn  = document.getElementById('toggle-theme');
        const logo = document.getElementById('logo');
        const saved = localStorage.getItem('theme') || 'dark';

        const apply = (theme) => {
            document.documentElement.setAttribute('data-theme', theme);
            localStorage.setItem('theme', theme);
            if (btn)  btn.textContent = theme === 'dark' ? '🌙' : '☀️';
            if (logo) logo.src = theme === 'dark'
                ? logo.getAttribute('data-dark-src')
                : logo.getAttribute('data-light-src');
        };

        apply(saved);
        btn?.addEventListener('click', () => {
            apply(document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark');
        });
    }

    // --- SCROLL PROGRESS ---
    function initScrollProgress() {
        const bar = document.querySelector('.scroll-progress');
        if (!bar) return;
        let ticking = false;
        window.addEventListener('scroll', () => {
            if (ticking) return;
            ticking = true;
            requestAnimationFrame(() => {
                const h = document.documentElement.scrollHeight - document.documentElement.clientHeight;
                bar.style.width = (h > 0 ? (window.scrollY / h) * 100 : 0) + '%';
                ticking = false;
            });
        }, { passive: true });
    }

    // --- FOOTER CHORUS (rotating chips) ---
    function initFooterChorus() {
        const box = document.querySelector('.rotating-chorus');
        if (!box) return;
        const chips = [...box.querySelectorAll('.chip')];
        if (!chips.length) return;

        let idx = 0;
        chips.forEach((c, i) => c.style.display = i === 0 ? 'inline' : 'none');

        clearInterval(window._chorusTimer);
        window._chorusTimer = setInterval(() => {
            chips[idx].style.display = 'none';
            idx = (idx + 1) % chips.length;
            chips[idx].style.display = 'inline';
        }, 5000);
    }
});