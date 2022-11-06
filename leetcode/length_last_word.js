let lengthOfLastWord = function (s) {
    let str = word.trim();
    let len = str.length;
    let i = len - 1;
    while (i >= 0 && str[i] !== ' ') i--;
    return len - 1 - i;
};
