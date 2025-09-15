<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>AlphaOmen</title>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
<!-- Your custom CSS -->
<link rel="stylesheet" href="assets/css/style.css?v=2">

<style>

/**************************** Calculator *******************************/
#floatingCalc {
    width: 60px; /* collapsed width */
    height: 60px; /* collapsed height */
    border-radius: 50%;
    overflow: hidden;
    transition: all 0.3s ease;
    position: fixed;
    z-index: 2147483647 !important; /* max safe z-index */
}

#floatingCalc.expanded {
    width: 360px; /* full width */
    height: auto;
    border-radius: 12px;
}

#floatingCalc:hover {
    cursor: pointer;
}

.calc-sidebar {
    width: 360px !important;
    background-color: #f9f9f9;
    padding: 15px;
    right: 20px;
    bottom: 10px;
    border-radius: 12px;
    box-shadow: 0 8px 20px rgba(0,0,0,0.25);
    transition: all 0.3s ease;
    position: fixed;
    z-index: inherit;
}

#calcDisplay {
    width: 100%;
    height: 70px;
    font-size: 22px;
    text-align: right;
    padding: 10px;
    margin-top: 20px;
    margin-bottom: 15px;
    border-radius: 8px;
    border: 1px solid #ccc;
    background: #fff;
    box-shadow: inset 0 2px 5px rgba(0,0,0,0.05);
    overflow-x: auto;
}

.calc-buttons {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 8px;
}

.calc-buttons button {
    padding: 12px;
    font-size: 18px;
    border-radius: 8px;
    border: none;
    background-color: #e3e3e3;
    cursor: pointer;
    transition: all 0.2s ease;
    color: #333;
    user-select: none;
}

.calc-buttons button:hover {
    transform: scale(1.05);
    background-color: #d4d4d4;
}

.calc-buttons button.operator {
    background-color: #5c9ded;
    color: white;
}

.calc-buttons button.equals {
    background-color: #3bcf91;
    color: white;
}

.calc-buttons button.clear {
    background-color: #f47575;
    color: white;
}

.calc-buttons button.backspace {
    background-color: #ffb347;
    color: white;
}

.toggle-buttons {
    display: flex;
    margin-bottom: 10px;
    gap: 10px;
}

.toggle-buttons button {
    flex: 1;
    font-size: 16px;
    padding: 10px;
    border-radius: 8px;
    border: none;
    cursor: pointer;
    background-color: #ddd;
    transition: background-color 0.3s ease;
}

.toggle-buttons button.active {
    background-color: #5c9ded;
    color: white;
}

/**************************** Calculator Dark Mode *******************************/
body.dark-mode .calc-sidebar {
    background-color: #2b2b2b;
    color: #f1f1f1;
}

body.dark-mode #calcDisplay {
    background-color: #1e1e1e;
    color: #f1f1f1;
    border-color: #555;
}

body.dark-mode .calc-buttons button {
    background-color: #444;
    color: #f1f1f1;
}

body.dark-mode .calc-buttons button:hover {
    background-color: #555;
}

body.dark-mode .calc-buttons button.operator {
    background-color: #5c9ded;
    color: white;
}

body.dark-mode .calc-buttons button.equals {
    background-color: #3bcf91;
    color: white;
}

body.dark-mode .calc-buttons button.clear {
    background-color: #f47575;
    color: white;
}

body.dark-mode .calc-buttons button.backspace {
    background-color: #ffb347;
    color: white;
}

body.dark-mode .toggle-buttons button {
    background-color: #555;
    color: #f1f1f1;
}

body.dark-mode .toggle-buttons button.active {
    background-color: #5c9ded;
    color: white;
}
/* Calculator Close Button Dark Mode */
body.dark-mode #calcCloseBtn {
    color: #ffffff;       /* White icon */
    background: transparent; /* Keep transparent */
}

/********************************************************************************/
</style>
</head>
<body>

<a href="#" id="calculatorToggle" class="nav-link"><i class="fa-solid fa-calculator"></i> Calculator</a>

	<!-- Hidden Calculator -->
	<div id="floatingCalc" class="calc-sidebar collapsed" style="display:none;">
	<button id="calcCloseBtn" class="btn-close" aria-label="Close"></button>
    <input type="text" id="calcDisplay" readonly>

    <div class="toggle-buttons">
        <button id="btnNormal" class="active">123</button>
        <button id="btnScientific">Fx</button>
    </div>

    <div id="normalCalc" class="calc-buttons">
        <button class="clear">C</button>
        <button>( )</button>
        <button class="operator">%</button>
        <button class="backspace">⌫</button>

        <button>7</button>
        <button>8</button>
        <button>9</button>
        <button class="operator">*</button>

        <button>4</button>
        <button>5</button>
        <button>6</button>
        <button class="operator">-</button>

        <button>1</button>
        <button>2</button>
        <button>3</button>
        <button class="operator">+</button>

        <button>0</button>
        <button>.</button>
        <button class="equals">=</button>
        <button class="operator">/</button>
    </div>

    <div id="scientificCalc" class="calc-buttons" style="display:none;">
        <button class="func-btn">sin(</button>
        <button class="func-btn">cos(</button>
        <button class="func-btn">tan(</button>
        <button class="func-btn">log(</button>

        <button class="func-btn">ln(</button>
        <button class="func-btn">√(</button>
        <button class="func-btn">π</button>
        <button class="func-btn">e</button>
    </div>
</div>

<script>
const calcToggle = document.getElementById('calculatorToggle');
const floatingCalc = document.getElementById('floatingCalc');
const display = document.getElementById('calcDisplay');

const btnNormal = document.getElementById('btnNormal');
const btnScientific = document.getElementById('btnScientific');

const normalCalc = document.getElementById('normalCalc');
const scientificCalc = document.getElementById('scientificCalc');

//Load calculator state from localStorage
if(localStorage.getItem('calcOpen') === 'true') {
    floatingCalc.style.display = 'block';
    floatingCalc.classList.add('expanded');
}

// Toggle calculator display
calcToggle.onclick = (e) => {
	e.preventDefault();
    const style = window.getComputedStyle(floatingCalc);
    if(style.display === 'none') {
        floatingCalc.style.display = 'block';
        floatingCalc.classList.add('expanded');
        localStorage.setItem('calcOpen', 'true');
    } else {
        floatingCalc.style.display = 'none';
        floatingCalc.classList.remove('expanded');
        localStorage.setItem('calcOpen', 'false');
    }
}

//Load saved display value on page load
display.value = localStorage.getItem('calcDisplay') || '';
function saveDisplay() {
    localStorage.setItem('calcDisplay', display.value);
}

calcCloseBtn.onclick = () => {
    floatingCalc.style.display = 'none';
    floatingCalc.classList.remove('expanded');
    localStorage.setItem('calcOpen', 'false');
}

//Expand on hover
floatingCalc.addEventListener('mouseenter', () => floatingCalc.classList.add('expanded'));

// Switch calculator mode
btnNormal.onclick = () => {
    btnNormal.classList.add('active');
    btnScientific.classList.remove('active');
    normalCalc.style.display = 'grid';
    scientificCalc.style.display = 'none';
};

btnScientific.onclick = () => {
    btnScientific.classList.add('active');
    btnNormal.classList.remove('active');
    scientificCalc.style.display = 'grid';
    normalCalc.style.display = 'none';
};

// Calculator logic
document.querySelectorAll('.calc-buttons button').forEach(btn => {
    btn.onclick = () => {
        const val = btn.innerText;
        if (!isNaN(val) || val === '.') display.value += val;
        else if (val === 'C') display.value = '';
        else if (val === '⌫') display.value = display.value.slice(0, -1);
        else if (val === '( )') {
            let openCount = (display.value.match(/\(/g) || []).length;
            let closeCount = (display.value.match(/\)/g) || []).length;
            display.value += openCount > closeCount ? ')' : '(';
        } else if (['+', '-', '*', '/', '^', '%'].includes(val)) display.value += val;
        else if (['sin(', 'cos(', 'tan(', 'log(', 'ln(', '√(', 'π', 'e'].includes(val)) {
            if(val === 'π') display.value += Math.PI.toFixed(8);
            else if(val === 'e') display.value += Math.E.toFixed(8);
            else if(val === '√(') display.value += 'sqrt(';
            else display.value += val;
        } else if (val === '=') {
            if (!display.value) return;
            try {
                let expr = display.value
                		   .replace(/sqrt/g, 'Math.sqrt')
                           .replace(/sin/g, 'Math.sin')
                           .replace(/cos/g, 'Math.cos')
                           .replace(/tan/g, 'Math.tan')
                           .replace(/log/g, 'Math.log10')
                           .replace(/ln/g, 'Math.log')
                           .replace(/\^/g, '**')
                           .replace(/π/g, Math.PI)
                           .replace(/e/g, Math.E)
                           .replace(/(\d+)%/g, '($1/100)');
                display.value = eval(expr);
            } catch(e) { display.value = 'Error'; }
        }
        saveDisplay();
    }
});

// Keyboard support
document.addEventListener('keydown', (e) => {
    const key = e.key;
    if (!isNaN(key) || ['+', '-', '*', '/', '.', '%', '(', ')'].includes(key)) display.value += key;
    else if (key === 'Enter') {
        e.preventDefault();
        if (!display.value) return;
        try {
            let expr = display.value
					   .replace(/sqrt/g, 'Math.sqrt')
                       .replace(/sin/g, 'Math.sin')
                       .replace(/cos/g, 'Math.cos')
                       .replace(/tan/g, 'Math.tan')
                       .replace(/log/g, 'Math.log10')
                       .replace(/ln/g, 'Math.log')
                       .replace(/\^/g, '**')
                       .replace(/π/g, Math.PI)
                       .replace(/e/g, Math.E)
                       .replace(/(\d+)%/g, '($1/100)');
            display.value = eval(expr);
        } catch(err) { display.value = 'Error'; }
    } else if (key === 'p') display.value += Math.PI.toFixed(8);
    else if (key === 'E') display.value += Math.E.toFixed(8);
    else if (key === 'Backspace') display.value = display.value.slice(0, -1);
    else if (key === 'Escape') display.value = '';
    saveDisplay();
});
</script>
</body>
</html>
