// RFramework UI Script

$(function() {
    // Notify Lua that NUI is ready
    $.post('https://rframework/ready', JSON.stringify({}));

    // Listen for messages from Lua
    window.addEventListener('message', function(event) {
        const data = event.data;

        switch(data.action) {
            case 'toggle':
                toggleMenu(data.show);
                break;
            case 'updateHUD':
                updateHUD(data.data);
                break;
        }
    });

    // Close menu on ESC
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeMenu();
        }
    });
});

function toggleMenu(show) {
    if (show) {
        $('#menu').removeClass('hidden');
    } else {
        $('#menu').addClass('hidden');
    }
}

function closeMenu() {
    $.post('https://rframework/close', JSON.stringify({}));
    $('#menu').addClass('hidden');
}

function updateHUD(data) {
    if (data.money !== undefined) {
        $('#money').text('$' + formatNumber(data.money));
    }
    if (data.bank !== undefined) {
        $('#bank').text('$' + formatNumber(data.bank));
    }
    if (data.job !== undefined) {
        $('#job').text(data.job);
    }
    if (data.jobGrade !== undefined) {
        $('#jobGrade').text(data.jobGrade);
    }

    // Show HUD if it's hidden
    if ($('#hud').hasClass('hidden')) {
        $('#hud').removeClass('hidden');
    }
}

function formatNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
