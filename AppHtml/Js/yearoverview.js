/* The Year Overview page (YearOverview.vw), in the page itself - no trip to the program:
   - a click on a day in a month, or on a row of the list, marks that date in both places, scrolls the other one
     into view, and shows the day above the list: its name, what it is, its week, and its place among the year's
     working days;
   - a click on a colour in the legend shows only the days of that kind - in the months and in the list - and a
     second click shows them all again.
   The program draws the page again for another country or year (UpdateHtml), so everything is found from the
   click: one listener on the document serves every drawing. */
(function () {
    if (window.yoReady) { return; }
    window.yoReady = true;

    function esc(s) {
        return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }

    // The clicked day, above the list. Its tooltip already reads "Mon 2026-12-28 - Boxing Day - Holiday, day off".
    function showDay(yo, cell) {
        var box = yo.querySelector('.yo-detail');
        if (!box || !cell) { return; }
        var parts = (cell.getAttribute('title') || '').split(' - ');
        var total = parseInt(yo.getAttribute('data-total'), 10) || 0;
        var n = parseInt(cell.getAttribute('data-n'), 10) || 0;
        var worked = cell.getAttribute('data-w') === '1';
        var left = total - n;
        var html = '<div class="yo-dd">' + esc(parts[0] || '') + '</div>';
        // a name may hold " - " itself: everything between the date and the kind is the name
        if (parts.length > 2) { html += '<div class="yo-dn">' + esc(parts.slice(1, -1).join(' - ')) + '</div>'; }
        html += '<div class="yo-dk">' + esc(parts[parts.length - 1] || '') + ' &middot; week ' + esc(cell.getAttribute('data-wk') || '') + '</div>';
        html += '<div class="yo-dw">' + (worked ? 'Working day ' + n + ' of ' + total : 'Not a working day') +
                ' &middot; ' + left + ' working day' + (left === 1 ? '' : 's') + ' left in the year</div>';
        box.innerHTML = html;
    }

    function select(yo, date, scrollTo) {
        yo.querySelectorAll('.yo-sel').forEach(function (e) { e.classList.remove('yo-sel'); });
        var cell = yo.querySelector('td.d[data-d="' + date + '"]');
        var row = yo.querySelector('tr[data-d="' + date + '"]');
        if (cell) { cell.classList.add('yo-sel'); }
        if (row) { row.classList.add('yo-sel'); }
        showDay(yo, cell);
        var target = scrollTo === 'row' ? row : cell;
        if (target) { target.scrollIntoView({ block: 'nearest', behavior: 'smooth' }); }
    }

    // A legend colour: only those days; the same colour again: all of them.
    function filter(yo, kind) {
        var on = yo.getAttribute('data-only') === kind;
        yo.setAttribute('data-only', on ? '' : kind);
        yo.querySelectorAll('.yo-lg').forEach(function (e) {
            e.classList.toggle('on', !on && e.getAttribute('data-kind') === kind);
        });
    }

    document.addEventListener('click', function (ev) {
        var t = ev.target;
        if (!t || !t.closest) { return; }
        var yo = t.closest('.yo');
        if (!yo) { return; }
        // A country, a year or Refresh: the program draws the page again, which takes a moment - the page shows it
        // is busy until the new drawing replaces it (and this class with it).
        if (t.closest('[data-ServerOnClick]')) { yo.classList.add('yo-busy'); return; }
        var lg = t.closest('.yo-lg');
        if (lg) { filter(yo, lg.getAttribute('data-kind')); return; }
        var cell = t.closest('td.d[data-d]');
        if (cell) { select(yo, cell.getAttribute('data-d'), 'row'); return; }
        var row = t.closest('tr[data-d]');
        if (row) { select(yo, row.getAttribute('data-d'), 'cell'); }
    });
})();
