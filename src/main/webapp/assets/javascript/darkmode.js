// In darkmode.js
const darkModeToggle = document.getElementById('darkModeToggle');
const body = document.body;
const darkModeIcon = document.getElementById('darkModeIcon');

// Function to update icon based on mode
function updateIcon() {
    if (body.classList.contains('dark-mode')) {
        darkModeIcon.classList.remove('fa-moon');
        darkModeIcon.classList.add('fa-sun');
    } else {
        darkModeIcon.classList.remove('fa-sun');
        darkModeIcon.classList.add('fa-moon');
    }
}

// Load saved preference on page load
if (localStorage.getItem('darkMode') === 'enabled') {
    body.classList.add('dark-mode');
}
updateIcon();

// Toggle dark mode on button click
darkModeToggle.addEventListener('click', () => {
    body.classList.toggle('dark-mode');

    // Save preference
    localStorage.setItem('darkMode', body.classList.contains('dark-mode') ? 'enabled' : 'disabled');

    // Update icon
    updateIcon();
});
