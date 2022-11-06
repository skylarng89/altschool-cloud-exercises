let removeElement = function (number, value) {
    let len = number.length;
    let count = 0;
    for (let i = 0; i < len; i++) {
        if (number[i] !== value) number[count++] = number[i];
    }
    return count;
};