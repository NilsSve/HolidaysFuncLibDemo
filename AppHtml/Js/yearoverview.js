/* The Year Overview page (YearOverview.vw), in the page itself - no trip to the program. The months are separate
   HTML boxes on one page (cHolidayMonthCalendar), so everything here is found from the document:
   - a click on a day is RDCFlexTron's (ftcontrols.js): it marks the day and sends "ftcal-select"; here the day's
     row in the list is marked and scrolled to, and the box above the list describes the day - its name, what it
     is, its week, and its place among the year's working days;
   - a click on a row of the list chooses its day the same way (rdcft.ftcalSelect) and brings the day into view;
   - a click on a colour in the legend shows only the days of that kind - in the months and in the list - and a
     second click shows them all again;
   - a click on a country, a year or Refresh dims the page until the program has drawn the year again (the list
     ends with an element yo-ready, which the new drawing brings). */
(function () {
    if (window.yoReady) { return; }
    window.yoReady = true;
    var fromList = false;

    function esc(s) {
        return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }

    // The row to the middle of the list - the list alone: scrollIntoView would scroll the page too.
    function scrollInList(list, row) {
        var r = row.getBoundingClientRect(), l = list.getBoundingClientRect();
        list.scrollTo({ top: list.scrollTop + (r.top - l.top) - (list.clientHeight - r.height) / 2, behavior: 'smooth' });
    }

    // The clicked day, above the list. Its tooltip reads "Sat 2026-07-04 - Independence Day - Holiday on a weekend".
    function showDay(list, cell) {
        var box = list.querySelector('.yo-detail');
        if (!box || !cell) { return; }
        var parts = (cell.getAttribute('title') || '').split(' - ');
        var total = parseInt(list.getAttribute('data-total'), 10) || 0;
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

    // A day was chosen - by a click on it (ftcontrols.js) or on its row (below).
    document.addEventListener('ftcal-select', function (ev) {
        var list = document.querySelector('.yo-list');
        if (!list) { return; }
        list.querySelectorAll('tr.yo-sel').forEach(function (e) { e.classList.remove('yo-sel'); });
        var row = list.querySelector('tr[data-d="' + ev.detail.date + '"]');
        if (row) { row.classList.add('yo-sel'); }
        showDay(list, ev.detail.cell);
        if (row && !fromList) { scrollInList(list, row); }
    });

    // A legend colour: only those days; the same colour again: all of them.
    function filter(kind) {
        var on = document.body.getAttribute('data-only') === kind;
        document.body.setAttribute('data-only', on ? '' : kind);
        document.querySelectorAll('.yo-lg').forEach(function (e) {
            e.classList.toggle('on', !on && e.getAttribute('data-kind') === kind);
        });
    }

    document.addEventListener('click', function (ev) {
        var t = ev.target;
        if (!t || !t.closest) { return; }
        var lg = t.closest('.yo-lg');
        if (lg) { filter(lg.getAttribute('data-kind')); return; }
        if (t.closest('.yo [data-ServerOnClick]')) { document.body.classList.add('yo-busy'); return; }
        var row = t.closest('.yo-l tr[data-d]');
        if (row && window.rdcft && window.rdcft.ftcalSelect) {
            var date = row.getAttribute('data-d');
            var cell = document.querySelector('td.ftcal-d[data-d="' + date + '"]');
            fromList = true;
            try { window.rdcft.ftcalSelect(date, cell); } finally { fromList = false; }
            if (cell) { cell.scrollIntoView({ block: 'nearest', behavior: 'smooth' }); }
        }
    });

    // The year is drawn again: the list's new drawing brings yo-ready - the page is no longer busy. The script is
    // loaded in the page's head, before its body exists: the watch starts once it does.
    function watchBusy() {
    new MutationObserver(function (records) {
        for (var i = 0; i < records.length; i++) {
            for (var j = 0; j < records[i].addedNodes.length; j++) {
                var n = records[i].addedNodes[j];
                if (n.nodeType === 1 && (n.classList.contains('yo-ready') || (n.querySelector && n.querySelector('.yo-ready')))) {
                    document.body.classList.remove('yo-busy');
                    return;
                }
            }
        }
    }).observe(document.body, { childList: true, subtree: true });
    }
    if (document.body) { watchBusy(); } else { document.addEventListener('DOMContentLoaded', watchBusy); }
})();
