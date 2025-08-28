<script>
// Helper: count weekdays between two dates
function calculateBusinessDays(fromDate, toDate) {
    let count = 0;
    let curDate = new Date(fromDate);

    while (curDate <= toDate) {
        let day = curDate.getDay(); // 0 = Sun, 6 = Sat
        if (day !== 0 && day !== 6) {
            count++;
        }
        curDate.setDate(curDate.getDate() + 1);
    }
    return count;
}

function updateDays() {
    const fromInput = document.getElementById("ReqDateFrom");
    const toInput = document.getElementById("ReqDateTo");
    const numDaysField = document.getElementById("ReqNumDays");

    const from = fromInput.value;
    const to = toInput.value;

    if (from && to) {
        const fromDate = new Date(from + "T00:00:00"); // ensure proper parse
        const toDate = new Date(to + "T00:00:00");

        if (!isNaN(fromDate) && !isNaN(toDate) && fromDate <= toDate) {
            const days = calculateBusinessDays(fromDate, toDate);
            numDaysField.value = days;
        } else {
            numDaysField.value = 0;
        }
    }
}

// Attach events *after DOM loads*
document.addEventListener("DOMContentLoaded", function() {
    document.getElementById("ReqDateFrom").addEventListener("change", updateDays);
    document.getElementById("ReqDateTo").addEventListener("change", updateDays);
});
</script>